//
//  ZYContactPeopleCell.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYContactPeopleCell.h"

@implementation ZYContactPeopleCell


- (void)fillDataWithFriendModel:(ChatFriendModel *)model{
//    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.avatarMediaId]]]];
//    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemarks].length>0 ? [TextShowWithModelStr textShowWithModelStr:model.friendRemarks] : [TextShowWithModelStr textShowWithModelStr:model.userNickname];//备注名
//            self.remarkLabel.text = [TextShowWithModelStr textShowWithModelStr:model.autograph];//个性签名
    //0906新
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgSmallUrl]]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
 
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr:model.friendRemark] : [TextShowWithModelStr textShowWithModelStr:model.nickName];//备注名 昵称friendRemarks friendRemark新
    self.remarkLabel.text = [TextShowWithModelStr textShowWithModelStr:model.autograph];//个性签名
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.iconImageView.image = nil;
    self.nameLabel.text = @"";
    
}

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

@end
