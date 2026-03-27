//
//  ZYGroupChatCell.m
//  Community
//
//  Created by ZY on 2021/4/29.
//

#import "ZYGroupChatCell.h"

@interface ZYGroupChatCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *notiNumLabel;

@end

@implementation ZYGroupChatCell


- (void)fillCellWithDic:(NSDictionary *)dic{
    ChatGroupModel *model = [ChatGroupModel mj_objectWithKeyValues:dic];
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.groupName];
    self.contentLabel.text = [TextShowWithModelStr textShowWithModelStr:model.groupUuid];
    NSString *getImgStr = [TextShowWithModelStr textShowWithModelStr: model.avatarMediaId];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,getImgStr]]];
    
    //群聊列表cell 群头像名字ID创建者ID 无这些
    self.dateLabel.hidden = YES;
    self.notiNumLabel.hidden = YES;
    self.notiNumLabel.superview.hidden = YES;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:10 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
