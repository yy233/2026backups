//
//  ZYAddGroupFriendCell.m
//  Community
//
//  Created by ZY on 2021/4/24.
//

#import "ZYAddGroupFriendCell.h"

@implementation ZYAddGroupFriendCell
- (void)leftSelectedImgTypeIsSelected:(BOOL)isSelected{
    if (!isSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"addf_normal"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"addf_selected"];
    }

    
}
- (void)fillCellWithDic:(NSDictionary *)dic{
    DLog(@"%@",dic);
    ChatFriendModel *model = [ChatFriendModel mj_objectWithKeyValues:dic];
//    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.otherAccount];
//    self.telLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemark];
        self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.nickName];
        self.telLabel.text = [TextShowWithModelStr textShowWithModelStr:model.friendRemark];
    NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    
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
