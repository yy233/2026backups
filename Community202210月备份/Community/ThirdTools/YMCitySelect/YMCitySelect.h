//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySelect.h
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    City_Select_Type_Weather, //天气
    City_Select_Type_LifeCost, //生活缴费
} City_Select_Type;

@protocol YMCitySelectDelegate <NSObject>

- (void)ym_ymCitySelectCityName:(NSString *)cityName;

@end

@interface YMCitySelect : UIViewController

- (instancetype)initWithDelegate:(id)targe;

@property (nonatomic,weak) id<YMCitySelectDelegate> ymDelegate;

@property (nonatomic, assign) City_Select_Type type;

@end
