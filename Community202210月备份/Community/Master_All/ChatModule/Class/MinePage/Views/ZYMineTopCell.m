//
//  ZYMineTopCell.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYMineTopCell.h"

@implementation ZYMineTopCell

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
- (void)fillUserInfo:(NSMutableDictionary *)userInfoDic{
    ChatUserModel *model = [ChatUserModel mj_objectWithKeyValues:userInfoDic];
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.nickName];
    self.dateLabel.text = [TextShowWithModelStr textShowWithModelStr: model.imId];
    if([[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl] rangeOfString:@"http"].location !=NSNotFound){
        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }else{
        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
    
}
@end
