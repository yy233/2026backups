//
//  ZYMessageTopCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import "ZYMessageTopCollectionViewCell.h"

@implementation ZYMessageTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)fillData:(NSMutableDictionary *)dic{
    if (isNotNil(dic)) {
        if ([dic isKindOfClass:[NSDictionary class]] || [dic isKindOfClass:[NSMutableDictionary class]]) {
            ChatFriendModel *model = [ChatFriendModel mj_objectWithKeyValues:dic];
            //旧
            /**
             [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.avatarMediaId]]]];
             self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemarks].length>0 ? [TextShowWithModelStr textShowWithModelStr:model.friendRemarks] : [TextShowWithModelStr textShowWithModelStr:model.userNickname];//备注名
             //            self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.userNickname];//昵称
             */
            //0906新
            [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgSmallUrl]]]];
            self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr:model.friendRemark] : [TextShowWithModelStr textShowWithModelStr:model.nickName];//备注名 昵称
        }
    }
}
@end
