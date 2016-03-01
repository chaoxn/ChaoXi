//
//  WeatherViewModel.m
//  chaoxi
//
//  Created by fizz on 16/2/26.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import "WeatherViewModel.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherViewModel()<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currLocation;
@property (nonatomic, retain) CLPlacemark *placemark;

@end

@implementation WeatherViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self startSystemLocation];
       
    }
    return self;
}

- (void)initBind
{
 
}

// 定位
- (void)startSystemLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = 10;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestAlwaysAuthorization];
    
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSLog(@"%d", enable);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currLocation = [locations lastObject];
    NSLog(@"经度 = %f 纬度 = %f", self.currLocation.coordinate.latitude, self.currLocation.coordinate.longitude);
    // 位置反编码
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0) {
            
            NSLog(@"你的地址没找到");
        }else {
            
            self.placemark = [placemarks firstObject];
            NSLog(@"市   %@",self.placemark.locality);
            
            self.requestCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                
                NSString *str = [self.placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
                return [[CXAPIManage getWhetherData:str] map:^id(RACTuple *x) {
                    
                    return x.first;
                }];
                
            }];
            
            [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                
                self.dataDic = x;
            }];
            
            
            self.cityStr = self.placemark.locality;
            
            self.locSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
                [subscriber sendNext:self.placemark.locality];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
            }];
            
//            [self initBind];
            
            [self.locationManager stopUpdatingLocation];
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

@end
