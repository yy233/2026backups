//
//  ZYCommunityFairMyIssueEmptyView.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairMyIssueEmptyView.h"

@interface ZYCommunityFairMyIssueEmptyView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYCommunityFairMyIssueEmptyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.bottomView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_L2672f9;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
