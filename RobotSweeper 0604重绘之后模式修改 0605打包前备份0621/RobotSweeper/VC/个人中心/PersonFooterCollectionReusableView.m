//
//  PersonFooterCollectionReusableView.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PersonFooterCollectionReusableView.h"

@implementation PersonFooterCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logOutBtn];
    }
    return self;
}
- (UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.frame = CGRectMake(100, 20, Y_mainW-200, 40);
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutBtn setBackgroundColor:[UIColor blueColor]];
    }
    return _logOutBtn;
}
@end
