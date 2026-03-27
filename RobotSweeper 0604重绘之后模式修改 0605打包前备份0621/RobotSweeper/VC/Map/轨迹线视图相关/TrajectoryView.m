//
//  TrajectoryView.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/16.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "TrajectoryView.h"

@implementation TrajectoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewOfLine];
    }
    return self;
}
- (void)initViewOfLine{
    self.backgroundColor = [UIColor clearColor];//初始颜色能用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNoticeOfTrajectoryView:) name:kTrajectNoticeStr object:nil];
}

- (void)getNoticeOfTrajectoryView:(NSNotification *)notice{
     [self upTrajectoryView];
}

- (void)upTraViewOfScrollViewZooming{
    [self upTrajectoryView];
}
#pragma mark -----------------------------------------更新前的数据处理--------
- (void)upTrajectoryView{
    NSMutableArray* arrOfPointSource = [DataManager shareDataManager].trajectorySourceArr;//xmpp源数据存的点
    //得到新数据
    CGPoint zuoTopP = CGPointMake([DataManager shareDataManager].mapLeftEnd, [DataManager shareDataManager].mapTopEnd);//左上角点坐标
    
    NSMutableArray *arrOfNewTrajectPoint = [NSMutableArray array];
    /**在绘画时处理成新数据 当前只保留得到的xmpp对应值？ 因为x y 00 原点会变化
     */
    
    for (int i = 0; i < arrOfPointSource.count; i++) {//偶数x 奇数y 在x==偶数时处理数据
        //计算出x=x-left  y=-(y-top)   原点00坐标更换左上角为00坐标
        CGFloat  x = [arrOfPointSource[i] CGPointValue].x   - zuoTopP.x ;
        CGFloat  y = -([arrOfPointSource[i] CGPointValue].y - zuoTopP.y);
        [arrOfNewTrajectPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    _pointsArr = [NSMutableArray arrayWithArray:arrOfNewTrajectPoint];//图上所用值
    
    //    [self setNeedsDisplay];
    [self  upViewWithCAShaperLayer];
//    NSLog(@"%@ %ld",kTrajectNoticeStr,_pointsArr.count);

}
#pragma mark -----------------------------------------view绘画更新部分都可以用 内存不一样--------
/////这种耗费内存
//- (void)drawRect:(CGRect)rect{
//    //1.获取画布(上下文)
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    //2.画笔大小（宽度）
////    CGContextSetLineWidth( context, 1/_mapScale);
//    CGContextSetLineWidth( context, 1);
//    //3.画笔颜色
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);//强转为CGColor
//    //遍历点
//    if (_pointsArr!=nil) {
//        for (int j = 0; j < _pointsArr.count - 1; j ++) {
//            //当前点
//            CGPoint currentPoint = [_pointsArr[j] CGPointValue];
//            //下一个点
//            CGPoint nextPoint = [_pointsArr[j + 1] CGPointValue];
//
//            //起点终点
//            CGContextMoveToPoint(context, currentPoint.x*_mapScale, currentPoint.y*_mapScale);
//            CGContextAddLineToPoint(context, nextPoint.x*_mapScale, nextPoint.y*_mapScale);
//
//        }
//    }
//
//    //连线
//    CGContextStrokePath(context);
//
//}

- (void)upViewWithCAShaperLayer{
    
//    NSLog(@"得到更新轨迹信号");
    if (self.layer) {
        while (self.layer.sublayers.count) {
//            NSLog(@"self.layer %@",self.layer.sublayers);
            [self.layer.sublayers.firstObject removeFromSuperlayer];
        }
    }
   

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;

    //遍历点
    if (_pointsArr!=nil && _pointsArr.count>0) {
        for (int j = 0; j < _pointsArr.count - 1; j ++) {
            //当前点
            CGPoint currentPoint = [_pointsArr[j] CGPointValue];
            CGPoint movePoint = CGPointMake(currentPoint.x*_mapScale, currentPoint.y*_mapScale);
            if (j == 0) {
                [path moveToPoint:movePoint];//第一个点
            }else{
                [path addLineToPoint:movePoint];//下一个点
                
            }
        }
    }
//    [path closePath];// 结束划线
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor colorWithRed:153.0/255 green:161.0/255 blue:231.0/255 alpha:255.0/255].CGColor;
    maskLayer.lineWidth = 1;
 
    // 在图层上添加图层
    [self.layer addSublayer:maskLayer];
    
//    NSLog(@"upViewWithCAShaperLayer");
    

}

@end
