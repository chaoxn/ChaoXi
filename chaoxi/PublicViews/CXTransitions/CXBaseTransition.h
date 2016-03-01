//
//  CXBaseTransition.h
//  chaoxi
//
//  Created by fizz on 16/3/1.
//  Copyright © 2016年 chaox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CXBaseTransition : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite, assign, getter = isPresenting) BOOL presenting;

@end
