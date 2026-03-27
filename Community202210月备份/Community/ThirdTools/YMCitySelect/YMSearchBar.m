//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMSearchBar.m
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMSearchBar.h"
#import "UIView+ym_extension.h"

@implementation YMSearchBar

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.searchTextField.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.searchTextField.font = [UIFont systemFontOfSize:15];
    self.searchTextField.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
}

@end
