//
//  ZYAddFriendsTopCell.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYAddFriendsTopCell.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

@implementation ZYAddFriendsTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.uidLabel.text =  [NSString stringWithFormat:@"我的ID:%@",[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken];//展示imid不展示token
    [self addSubview:self.scanTouchBtn];
    [_scanTouchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_qcodeImageView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIButton *)scanTouchBtn{
    if (!_scanTouchBtn) {
        _scanTouchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _scanTouchBtn;
}
@end
