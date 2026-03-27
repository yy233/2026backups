//
//  ZYCarInviteBottomView.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInviteBottomView.h"

@interface ZYCarInviteBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@end

@implementation ZYCarInviteBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.inviteButton addTarget:self action:@selector(inviteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)inviteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteButtonEvent)]) {
        [self.delegate inviteButtonEvent];
    }
}

@end
