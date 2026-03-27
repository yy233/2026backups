//
//  ZYChatUserInfoTopCell.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYChatUserInfoTopCell.h"

@implementation ZYChatUserInfoTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillMyInfoDataWithModel:(ChatUserModel *)model{//自己
    self.nicknameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.nickName];
    self.signatureLabel.text = [TextShowWithModelStr textShowWithModelStr: model.autograph];
    self.registrationNumLabel.text = [TextShowWithModelStr textShowWithModelStr: model.imId];//登记label
    
    NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
}
//他人
- (void)fillOtherUserInfoWithModel:(ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel *)model{
    if (model.allowToAdd) {//非好友
        self.nicknameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.nickName];
    }else{
        self.nicknameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr: model.friendRemark] : [TextShowWithModelStr textShowWithModelStr:model.nickName];
    }
    self.signatureLabel.text = @"";//如果是自己 则显示个性签名 他人 无其他可显示数据
    self.registrationNumLabel.text = [TextShowWithModelStr textShowWithModelStr: model.imId];//登记label
    //
    NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
}
 @end
