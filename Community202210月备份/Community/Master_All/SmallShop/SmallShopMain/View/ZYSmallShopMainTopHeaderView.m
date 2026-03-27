//
//  ZYSmallShopMainTopHeaderView.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainTopHeaderView.h"

@interface ZYSmallShopMainTopHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIButton *personButton;

@end

@implementation ZYSmallShopMainTopHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.text = [ShareUserInfo sharedUserInfo].commuityInfo.name;
    [self.messageButton addTarget:self action:@selector(messageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.personButton addTarget:self action:@selector(personButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 消息
- (void)messageButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageButtonEvent)]) {
        [self.delegate messageButtonEvent];
    }
}

// 个人中心
- (void)personButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personButtonEvent)]) {
        [self.delegate personButtonEvent];
    }
}

@end
