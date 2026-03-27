//
//  BaseDrawView.h
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import <UIKit/UIKit.h>

@protocol BaseDrawViewDelegate <NSObject>

- (void)baseDrawViewDrawRect;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BaseDrawView : UIView

/**
 *  画布
 */
{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
//    NSMutableArray *_pathArray;
//    CGFloat _lineWidth;
//    UIColor *_color;
}

@property (nonatomic,assign)CGFloat lineWidth;/**< 线宽 */

@property (nonatomic,strong)UIColor *color;/**< 线的颜色 */

@property (nonatomic,strong)NSMutableArray *pathArray;

@property (nonatomic, weak) id<BaseDrawViewDelegate> delegate;

/**
 获取绘制的图片

 @return 绘制的图片
 */
-(UIImage*)getDrawingImg;

/**
 撤销
 */
-(void)undo;

/**
 清空
 */
-(void)clear;

///
- (void)changColor:(UIColor *)color;
- (void)changFontWidth:(NSInteger)fontW;
@end

NS_ASSUME_NONNULL_END
