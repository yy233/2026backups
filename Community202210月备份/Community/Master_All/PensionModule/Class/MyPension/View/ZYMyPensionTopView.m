//
//  ZYMyPensionTopView.m
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import "ZYMyPensionTopView.h"

@interface ZYMyPensionTopView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation ZYMyPensionTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.redPointView.layer.cornerRadius = self.redPointView.bounds.size.width / 2.0;
    self.redPointView.layer.masksToBounds = YES;
    self.messageButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self.messageButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.iconImageView zy_cornerRadiusAdvance:36 rectCornerType:UIRectCornerAllCorners];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"yl_placeholder_head"]];
    self.nameLabel.text = [ShareUserInfo sharedUserInfo].userInfo.nickname;
    self.telLabel.text = [ShareUserInfo sharedUserInfo].userInfo.mobile;
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)messageButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageButtonEvent)]) {
        [self.delegate messageButtonEvent];
    }
}

@end
