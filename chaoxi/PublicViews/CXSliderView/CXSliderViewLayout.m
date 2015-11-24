//
//  CXSliderViewLayout.m
//  CXSilderViewDemo
//
//  Created by fizz on 15/11/16.
//  Copyright © 2015年 chaox. All rights reserved.
//

#import "CXSliderViewLayout.h"
#import "CXSliderViewCell.h"

@implementation CXSliderViewLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ScreenWidth, CELL_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

-(void)setCount:(NSUInteger)count
{
    _count = count;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    return attr;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT+DRAG_INTERVAL*self.count+([UIScreen mainScreen].bounds.size.height-DRAG_INTERVAL));
}

-(void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray *)deepCopyWithArray:(NSArray *)array
{
    NSMutableArray *copys = [NSMutableArray arrayWithCapacity:array.count];
    
    for (UICollectionViewLayoutAttributes *attris in array) {
        [copys addObject:[attris copy]];
    }
    return copys;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    float screen_y = self.collectionView.contentOffset.y;
    float current_floor = floorf((screen_y-HEADER_HEIGHT)/DRAG_INTERVAL)+1;
    float current_mod = fmodf((screen_y-HEADER_HEIGHT), DRAG_INTERVAL);
    float percent = current_mod/DRAG_INTERVAL;
    
    //计算当前应该显示在屏幕上的CELL在默认状态下应该处于的RECT范围，范围左右范围进行扩展，避免出现BUG
    //之前的方法采用所有ITEM进行布局计算，当ITEM太多后，会严重影响性能体验，所有采用这种方法
    CGRect correctRect;
    if(current_floor == 0 || current_floor == 1){
        //因为导航栏和当前CELL的高度特殊，所有做特殊处理
        correctRect = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, RECT_RANGE);
    }else{
        correctRect = CGRectMake(0, HEADER_HEIGHT+HEADER_HEIGHT+CELL_HEIGHT*(current_floor-2), CELL_WIDTH, RECT_RANGE);
    }
    
    NSArray* array = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:correctRect]];
    
     //当前ITEM Y坐标提高的量
    CGFloat riseOfCurrentItem = CELL_CURRHEIGHT-DRAG_INTERVAL;
    //当前ITEM增加的高度
    CGFloat incrementalHeightOfCurrentItem = CELL_CURRHEIGHT-CELL_HEIGHT;
    //当前ITEM以下的ITEM需要向下移动的位移
    CGFloat offsetOfNextItem = incrementalHeightOfCurrentItem - riseOfCurrentItem;
    
    if(screen_y >= HEADER_HEIGHT){
        
        for(UICollectionViewLayoutAttributes *attributes in array){
            NSInteger row = attributes.indexPath.row;
            if(row < current_floor){
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor){
                attributes.zIndex = 1;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor+1){
                attributes.zIndex = 2;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem-riseOfCurrentItem*percent, CELL_WIDTH, CELL_HEIGHT+(CELL_CURRHEIGHT-CELL_HEIGHT)*percent);
                [self setEffectViewAlpha:percent forIndexPath:attributes.indexPath];
            }else{
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem+offsetOfNextItem*percent, CELL_WIDTH, CELL_HEIGHT);
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/568*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
        }
    }else{
        
        for(UICollectionViewLayoutAttributes *attributes in array){
            
            if(attributes.indexPath.row > 1){
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/568*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
            
        }
    }
    
//    if ([self.delegate respondsToSelector:@selector(setEffectOfHead:)]) [self.delegate setEffectOfHead:screen_y];
    
    return [self deepCopyWithArray:array];
}

/**
 *  设置CELL里imageView的位置偏移动画
 *
 *  @param distance
 *  @param indexpath
 */
-(void)setImageViewOfItem:(CGFloat)distance withIndexPath:(NSIndexPath *)indexpath
{
    CXSliderViewCell *cell = (CXSliderViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
    cell.cxImageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y+distance, CELL_WIDTH, cell.cxImageView.frame.size.height);
}

-(void)setEffectViewAlpha:(CGFloat)percent forIndexPath:(NSIndexPath *)indexPath
{
    CXSliderViewCell *cell = (CXSliderViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.coverView.alpha = MAX((1-percent)*0.6, 0.2);
    cell.desLabel.frame = CGRectMake(10, 85+percent*60, cell.desLabel.frame.size.width, cell.desLabel.frame.size.height);
    cell.desLabel.alpha = percent*0.85;
    cell.title.layer.transform = CATransform3DMakeScale(0.5+0.5*percent, 0.5+0.5*percent, 1);
    cell.title.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, CELL_HEIGHT/2+(CELL_CURRHEIGHT-CELL_HEIGHT)/2*percent);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint destination;
    CGFloat positionY;
    CGFloat screen_y = self.collectionView.contentOffset.y;
    CGFloat cc;
    CGFloat count;
    if (screen_y < 0) {
        return proposedContentOffset;
    }

    if(velocity.y == 0){
        count = roundf(((proposedContentOffset.y-HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        if(count == 0){
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }else{
        if(velocity.y>1){
            cc = 1;
        }else if(velocity.y < -1){
            cc = -1;
        }else{
            cc = velocity.y;
        }
        if (velocity.y > 0) {
            count = ceilf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }else{
            count = floorf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }
        if(count == 0){
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }
    
    if(positionY < 0){
        positionY = 0;
    }
    if(positionY > self.collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height){
        positionY = self.collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height;
    }
    destination = CGPointMake(0, positionY);
    self.collectionView.decelerationRate = .8;
    return destination;
}
@end
