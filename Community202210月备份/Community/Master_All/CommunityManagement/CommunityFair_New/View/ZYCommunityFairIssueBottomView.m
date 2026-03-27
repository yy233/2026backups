//
//  ZYCommunityFairIssueBottomView.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueBottomView.h"

@interface ZYCommunityFairIssueBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *issueButton;

@end

@implementation ZYCommunityFairIssueBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.issueButton addTarget:self action:@selector(issueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)issueButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(issueButtonEvent)]) {
        [self.delegate issueButtonEvent];
    }
}

@end
