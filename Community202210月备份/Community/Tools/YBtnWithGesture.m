//
//  YBtnWithGesture.m
//  Community
//
//  Created by 余莹 on 2021/5/14.
//

#import "YBtnWithGesture.h"

@implementation YBtnWithGesture


-(id)init
{
   self = [super init];
   if (self)
    {
        [self loadGesture];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self){
        [self loadGesture];
    }
    return self;
}
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
 self = [super initWithCoder:aDecoder];

    
    if (self)
  
    {
        [self loadGesture];
    }
  return self;
}

//重写该方法可以去除长按按钮时出现的高亮效果
//- (void)setHighlighted:(BOOL)highlighted
//{
//
//}
/**
 *  加载手势方法
 */
- (void)loadGesture
{

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
 
    //长按
    longPress.numberOfTouchesRequired = 1;
    //
    longPress.minimumPressDuration = 0.5;
    longPress.allowableMovement = 20;//长按手指能移动的最大距离
    [self addGestureRecognizer:longPress];

}
- (void)choose:(UILongPressGestureRecognizer *)longPress{
    //背景图设置
    if (longPress.state==UIGestureRecognizerStateBegan || longPress.state==UIGestureRecognizerStateChanged) {//
        [self setHighlighted:YES];
    }else if (longPress.state==UIGestureRecognizerStateEnded || longPress.state==UIGestureRecognizerStateCancelled) {
        [self setHighlighted:NO];
    }else{
        NSLog(@"___其他状态——");
        [self setHighlighted:YES];
    }
    //传值
    _longPressBlock(longPress);
}
 

@end
