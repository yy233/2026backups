//
//  ZYReportAboutRepairApplyBottomView.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyBottomView.h"

@interface ZYReportAboutRepairApplyBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation ZYReportAboutRepairApplyBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加按钮按下事件
    [self.voiceButton addTarget:self action:@selector(voiceButtonTouchDownClicked) forControlEvents:UIControlEventTouchDown];
    // 添加按钮松开事件
    [self.voiceButton addTarget:self action:@selector(voiceButtonTouchUpClicked) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside)];
}

#pragma mark - 处理点击事件
- (void)voiceButtonTouchDownClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonTouchDownEvent)]) {
        [self.delegate voiceButtonTouchDownEvent];
    }
}

- (void)voiceButtonTouchUpClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonTouchUpEvent)]) {
        [self.delegate voiceButtonTouchUpEvent];
    }
}

@end
