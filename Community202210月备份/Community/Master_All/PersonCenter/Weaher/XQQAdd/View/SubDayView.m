//
//  SubDayView.m
//  LineDemo
//
//  Created by xuqinqiang on 2017/7/7.
//  Copyright © 2017年 CamelotChina.com. All rights reserved.
//

#import "SubDayView.h"
#import "XQQWeatherModel.h"
#import "CAShapeLayer+XQQExtension.h"

#import "UIView+KDS_FrameHelper.h"
#import "UIColor+KDS_HexToUIColor.h"

#define board 10

@interface SubDayView ()
/** 日期label */
@property (nonatomic, strong)  UILabel  *  dayLabel;
/** 时间 */
@property (nonatomic, strong)  UILabel  *  dateLabel;
/** 天气label */
@property (nonatomic, strong)  UILabel  *  weatherLabel;
/** 天气图片 */
@property (nonatomic, strong)  UIImageView  *  weatherImageView;
/** 顶部天气图片 */
@property (nonatomic, strong)  UIImageView  *  bottomImageView;
/** 底部天气图片 */
@property (nonatomic, strong)  UILabel  *  bottomWeatherLabel;
/** 底部风力label */
@property (nonatomic, strong)  UILabel  *  windLabel;
/** 底部风向label */
@property (nonatomic, strong)  UILabel  *  windDirectionLabel;

@property(nonatomic, strong) UILabel *maxL;

@property(nonatomic, strong) UILabel *minL;

@property(nonatomic, strong) UILabel *airL;


/** 最高温度 */
@property (nonatomic, assign)  CGFloat   max;
/** 最低温度 */
@property (nonatomic, assign)  CGFloat   min;


@end


@implementation SubDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, board, self.width, 20)];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:16];
        _dayLabel.textColor = [Tool getColorWithHexString:@"#000000"];
        _dayLabel.text = @"今天";
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _dayLabel.bottom, self.width, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textColor = [Tool getColorWithHexString:@"#999999"];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"7/23";
        
        _weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _dateLabel.bottom, self.width, 20)];
        
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.font = [UIFont systemFontOfSize:16];
        _weatherLabel.textColor = [Tool getColorWithHexString:@"#000000"];
        _weatherLabel.text = @"多云";
        
        _weatherImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 44)*0.5, _weatherLabel.bottom + 10, 44, 44)];
        _weatherImageView.image = [UIImage imageNamed:@"Weather_Now"];
        
        
        //底部
//        _airL = [[UILabel alloc]initWithFrame:CGRectMake((self.width - 30)*0.5, self.bottom - board - 14, 30, 14)];
        _airL = [[UILabel alloc]initWithFrame:CGRectMake((self.width - 30)*0.5, self.bottom - board - 6, 30, 1)];
        _airL.font = [UIFont systemFontOfSize:10];
        _airL.textAlignment = NSTextAlignmentCenter;
//        _airL.text = @"良";
//        _airL.textColor = [Tool getColorWithHexString:@"#FFCA14"];
//        _airL.layer.borderWidth = 0.5;
//        _airL.layer.borderColor = [Tool getColorWithHexString:@"#FFCA14"].CGColor;
//        _airL.layer.cornerRadius = 2.5;
//        _airL.clipsToBounds = YES;
        
        _windLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _airL.y - _airL.height - 10, self.width, _dayLabel.height)];
        _windLabel.font = [UIFont systemFontOfSize:12];
        _windLabel.textAlignment = NSTextAlignmentCenter;
        _windLabel.textColor = [Tool getColorWithHexString:@"#202020"];
        _windLabel.text = @"8级";
        
        _windDirectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _windLabel.y - _dateLabel.height, self.width, _dayLabel.height)];
        _windDirectionLabel.font = [UIFont systemFontOfSize:12];
        _windDirectionLabel.textColor = [Tool getColorWithHexString:@"#202020"];
        _windDirectionLabel.textAlignment = NSTextAlignmentCenter;
        _windDirectionLabel.text = @"东风";
        
        _bottomWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _windDirectionLabel.y - _dayLabel.height, self.width, _dayLabel.height)];
        
        _bottomWeatherLabel.textAlignment = NSTextAlignmentCenter;
        _bottomWeatherLabel.font = [UIFont systemFontOfSize:16];
        _bottomWeatherLabel.text = @"多云";
        
        _bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_weatherImageView.x, _bottomWeatherLabel.y - _weatherImageView.height - 10 , _weatherImageView.width, _weatherImageView.height)];
        _bottomImageView.image = [UIImage imageNamed:@"Weather_Now"];
        
        _maxL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _maxL.textAlignment = NSTextAlignmentCenter;
        
        _maxL.textColor = [Tool getColorWithHexString:@"#333333"];
        _maxL.font = [UIFont systemFontOfSize:15];
        
        _minL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _minL.textAlignment = NSTextAlignmentCenter;
        
        _minL.textColor = [Tool getColorWithHexString:@"#333333"];
        _minL.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:_dayLabel];
        [self addSubview:_dateLabel];
        [self addSubview:_weatherLabel];
        [self addSubview:_weatherImageView];
        [self addSubview:_airL];
        [self addSubview:_windLabel];
        [self addSubview:_windDirectionLabel];
        [self addSubview:_bottomWeatherLabel];
        [self addSubview:_bottomImageView];
        
        [self addSubview:_maxL];
        [self addSubview:_minL];
    }
    return self;
}

- (void)setModel:(XQQWeatherModel *)model{
    _model = model;
    
    //天气图片距离 最大 最小值 点的间距
    CGFloat boardss = 10;
    
    //思路 固定最小值 在离底部图片往上 boardss 间距的位置
    //最大值在顶部图片底部往下 boardss  的位置
    //剩下的距离 以 1 长度  为单位 等分
    
    
    //最大值减最小值
    CGFloat differenceValue = [model.max floatValue] - [model.min floatValue];
    
    //间距
    CGFloat space = (_bottomImageView.y - boardss) - (_weatherImageView.bottom + boardss);
    
    
    //每一段间距
    CGFloat accumulated = space / differenceValue;
    
    //画最大值点
    CGFloat maxPointY = _bottomImageView.y - boardss - (([model.currentMax floatValue] - [model.min floatValue]) * accumulated);
    
    model.maxPoint = CGPointMake(_bottomImageView.centerX, maxPointY);
    
    [self.layer addSublayer:[CAShapeLayer CricleLayerWithPoint:CGPointMake(_bottomImageView.centerX, maxPointY) Board:6 FillColor:[Tool getColorWithHexString:@"#FFC90E"]]];
    
    //画最小值
    CGFloat minPointY = _bottomImageView.y - boardss - (([model.currentMin floatValue] - [model.min floatValue]) * accumulated);
    
    model.minPoint = CGPointMake(_bottomImageView.centerX, minPointY);
    
    [self.layer addSublayer:[CAShapeLayer CricleLayerWithPoint:CGPointMake(_bottomImageView.centerX, minPointY) Board:6 FillColor:[Tool getColorWithHexString:@"#3699FF"]]];
    
    _maxL.y = model.maxPoint.y - 30;
    
    _minL.y = model.minPoint.y;
    
    
    //赋值
    _dateLabel.text = model.dateStr;
    
    _dayLabel.text = model.weekStr;
    
    _weatherLabel.text = model.weatherStr;
    
    _bottomWeatherLabel.text = model.weatherNightStr;
    
    [_weatherImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrlDay] placeholderImage:[UIImage imageNamed:@"Weather_Now"]];
    
    [_bottomImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrlNight] placeholderImage:[UIImage imageNamed:@"Weather_Now"]];
    
    
    _maxL.text = [NSString stringWithFormat:@"%@°",model.currentMax];
    
    _minL.text = [NSString stringWithFormat:@"%@°",model.currentMin];
    
    _windDirectionLabel.text = model.windDirection;
    
    _windLabel.text = model.windPower;
    
//    _airL.text = @"优";
}

@end
