/********************************************************************
 文件名称 : UIView+Category.h 文件
 作   者 : ChaoX
 创建时间 : 15/2/12
 文件描述 : UIView扩展类
 *********************************************************************/


#import <UIKit/UIKit.h>

@interface UIView (Utils)

/**
 *origin
 */
@property (nonatomic,assign) CGPoint origin;

/**
 *origin.x
 */
@property (nonatomic,assign) CGFloat originX;

/**
 *origin.y
 */
@property (nonatomic,assign) CGFloat originY;

/**
 *size
 */
@property (nonatomic,assign) CGSize  size;

/**
 *size.width
 */
@property (nonatomic,assign) CGFloat width;

/**
 *size.height
 */
@property (nonatomic,assign) CGFloat height;

/**
 *更新View 的单个约束.
 */
- (void)updateConstraint:(NSLayoutAttribute )attribute constantValue:(CGFloat )value;
- (UIImage *)screenshot;
@end
