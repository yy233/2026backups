//
//  XQQDayView.m
//  LineDemo
//
//  Created by xuqinqiang on 2017/7/10.
//  Copyright © 2017年 CamelotChina.com. All rights reserved.
//

#import "XQQDayView.h"
#import "SubDayView.h"
#import "XQQWeatherModel.h"
#import "CAShapeLayer+XQQExtension.h"
#import "XQQDayViewTool.h"

#import "UIView+KDS_FrameHelper.h"
#import "UIColor+KDS_HexToUIColor.h"


@interface XQQDayView ()

/** 底部滚动视图 */
@property (nonatomic, strong)  UIScrollView  *  backScrollView;

@end


@implementation XQQDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.backScrollView];
        
    }
    return self;
}

#pragma mark - set

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    //创建小view 并赋值
    CGFloat width = Screen_W / 6;
    
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        
        SubDayView * view = [[SubDayView alloc]initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        
        view.model = self.dataArr[i];
        
        [self.backScrollView addSubview:view];
    }
    //划线
    
    //划线
    UIBezierPath * minPath = [UIBezierPath bezierPath];
    
    UIBezierPath * maxPath = [UIBezierPath bezierPath];
    
    
    //取到第一个点
    XQQWeatherModel * FirstModel = dataArr.firstObject;
    
    CGPoint minFirstPoint = FirstModel.minPoint;
    
    CGPoint maxFirstPoint = FirstModel.maxPoint;
    
    [minPath moveToPoint:minFirstPoint];
    
    [maxPath moveToPoint:maxFirstPoint];
    
    
    if (dataArr.count < 2) return;//此处先不连线
    
    for (NSInteger i = 1; i < dataArr.count; i ++) {
        
        XQQWeatherModel * model = dataArr[i];
        
        //因为model对应的是每一个小的view 所以得到的 每一个点 的X 是固定的 这里需要变一下
        CGPoint minPoint = model.minPoint;
        minPoint.x = minPoint.x + i * width;
        
        CGPoint maxPoint = model.maxPoint;
        maxPoint.x = maxPoint.x + i * width;
        
        //思路 : 先找 第二个点 和第一个点 的中心点  然后 根据 得到的中心点 找 中心点 与第一个点的中点 和 中心点与第二个点的中心点
        CGPoint minMidPoint = [XQQDayViewTool getMindPointWithSubViewWidth:width
                                                                FirstModel:FirstModel
                                                               SecondModel:model
                                                                     isMax:NO];
        
        CGPoint maxMidPoint = [XQQDayViewTool getMindPointWithSubViewWidth:width
                                                                FirstModel:FirstModel
                                                               SecondModel:model
                                                                     isMax:YES];
        
        [maxPath addQuadCurveToPoint:maxMidPoint controlPoint:[XQQDayViewTool getControlPointWithFirstPoint:maxMidPoint SecondPoint:maxFirstPoint]];
        
        [maxPath addQuadCurveToPoint:maxPoint controlPoint:[XQQDayViewTool getControlPointWithFirstPoint:maxMidPoint SecondPoint:maxPoint]];
        
        [minPath addQuadCurveToPoint:minMidPoint controlPoint:[XQQDayViewTool getControlPointWithFirstPoint:minMidPoint SecondPoint:minFirstPoint]];
        
        [minPath addQuadCurveToPoint:minPoint controlPoint:[XQQDayViewTool getControlPointWithFirstPoint:minMidPoint SecondPoint:minPoint]];
        
        FirstModel = model;
        
        minFirstPoint = minPoint;
        
        maxFirstPoint = maxPoint;
        
        [maxPath addLineToPoint:CGPointMake(maxPoint.x, maxPoint.y)];
        
        [minPath addLineToPoint:CGPointMake(minPoint.x, minPoint.y)];
        
    }
    
    CAShapeLayer * maxLayer = [CAShapeLayer getLineLayerWithColor:[Tool getColorWithHexString:@"#FFC90E"] LineWidth:1.5 Path:maxPath];
    
    [self.backScrollView.layer addSublayer:maxLayer];
    
    
    CAShapeLayer * minLayer = [CAShapeLayer getLineLayerWithColor:[Tool getColorWithHexString:@"#3699FF"] LineWidth:1.5 Path:minPath];
    
    [self.backScrollView.layer addSublayer:minLayer];
    
    self.backScrollView.contentSize = CGSizeMake(Screen_W / 6 * self.dataArr.count, 0);
}

#pragma mark - get
- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.width,self.height)];
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.bounces = NO;
    }
    return _backScrollView;
}


@end
