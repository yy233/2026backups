//
//  ZYCommunityFairIssueTopView.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueTopView.h"

@interface ZYCommunityFairIssueTopView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *previewButton;

@end

@implementation ZYCommunityFairIssueTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    [self.backButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"sj_back_icon"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.previewButton addTarget:self action:@selector(previewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)previewButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewButtonEvent)]) {
        [self.delegate previewButtonEvent];
    }
}

@end
