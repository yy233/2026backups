//
//  ZYSearchFriendsCell.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYSearchFriendsCell.h"

@implementation ZYSearchFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addView.layer.borderWidth = 0.5;
    self.addView.layer.borderColor = Y_RGBA(59, 143, 253, 1).CGColor;
    self.addView.layer.cornerRadius = 12.5;
    self.addView.layer.masksToBounds = YES;
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithDic:(NSMutableDictionary *)dic{
    ChatUserModel *model = [ChatUserModel mj_objectWithKeyValues:dic];
    NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl];
    NSURL *getImgUrl = [UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.nickName];
        self.telLabel.text = [TextShowWithModelStr textShowWithModelStr:model.otherAccount];
        [self.iconImageView sd_setImageWithURL:getImgUrl  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    });


}
@end
