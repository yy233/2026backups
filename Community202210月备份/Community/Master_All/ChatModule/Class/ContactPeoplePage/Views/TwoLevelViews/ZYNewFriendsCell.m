//
//  ZYNewFriendsCell.m
//  Community
//
//  Created by ZY on 2021/4/27.
//

#import "ZYNewFriendsCell.h"
#import "ChatFriendReqModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
@implementation ZYNewFriendsCell
- (void)fillUserInfo:(NSDictionary *)dic{
    ChatFriendReqModel *model = [ChatFriendReqModel mj_objectWithKeyValues:dic];
//    if ([model.nickName isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.nickName]) {//from自己 to他人
//        self.nameLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.toName].length >0 ? [TextShowWithModelStr textShowWithModelStr:model.toName] : @"";
//    }else{//to自己 from他人
//        self.nameLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.fromName].length >0 ? [TextShowWithModelStr textShowWithModelStr:model.fromName] : @"";
//    }
//    //verifmessage自带名字
//    self.remarkLabel.text = [TextShowWithModelStr textShowWithModelStr:model.remark.message];
//    if ([model.fromAvatar isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl]) {//from自己 to他人
//        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.toAvatar]]]];
//    }else{//to自己 from他人
//        [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]]];
//    }
    //0909
//    self.nameLabel.text  = [TextShowWithModelStr textShowWithModelStr:model.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr:model.friendRemark] : [TextShowWithModelStr textShowWithModelStr:model.nickName];
    self.nameLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.nickName];// 本好友通知消息界面不使用备注 只用昵称
    self.remarkLabel.text = [TextShowWithModelStr textShowWithModelStr:model.remark.message];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    [self customAgreeView:model.verifyFlag];
}

/**
 verifyFlag
 验证状态；好友验证状态：1已添加，2已同意对方为好友，3已拒绝对方，4对方已同意，5对方已拒绝，6等待我方操作 同意、拒绝
 */
- (void)customAgreeView:(NSInteger)status {

 
    BOOL isGetOnlyShowTextStatus = (status == 6) ? NO : YES;
    if (isGetOnlyShowTextStatus) {
        self.agreeView.userInteractionEnabled = NO;
        self.agreeView.backgroundColor = [UIColor clearColor];
        self.agreeLabel.textColor = Y_RGBA(153, 153, 153, 1);
        switch (status) {
            case 1:
            {
                self.agreeLabel.text = @"已添加";
            }
                break;
            case 2:
            {
                self.agreeLabel.text = @"已同意";
            }
                break;
            case 3:
            {
                self.agreeLabel.text = @"已拒绝";
            }
                break;
            case 4:
            {
                self.agreeLabel.text = @"已被同意";
            }
                break;
            case 5:
            {
                self.agreeLabel.text = @"已被拒绝";
            }
                break;
            case 6:
            {
                self.agreeLabel.text = @"同意";//6等待我方操作 同意、拒绝
            }
                break;
            default:
                self.agreeLabel.text = @"其他";
                break;
        }
        
    }else{
        switch (status) {//6等待我方操作 同意、拒绝 显示同意右滑动拒绝
            case 6:
            {
                self.agreeView.userInteractionEnabled = YES;
                self.agreeView.layer.cornerRadius = 14;
                self.agreeView.layer.masksToBounds = YES;
                self.agreeView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(55, 28) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
                self.agreeLabel.text = @"同意";
                self.agreeLabel.textColor = [UIColor whiteColor];
            }
                break;
            default:
                self.agreeLabel.text = @"其他";
                break;
        }
    }
}

// 定制同意视图
//- (void)customAgreeView:(NSInteger)status {
//
//
//    BOOL isGetOnlyShowTextStatus = (status<=3 || status>4) ? YES : NO;
//    if (isGetOnlyShowTextStatus) {
//        self.agreeView.userInteractionEnabled = NO;
//        self.agreeView.backgroundColor = [UIColor clearColor];
//        self.agreeLabel.textColor = Y_RGBA(153, 153, 153, 1);
//        switch (status) {
//            case 1:
//            {
//                 self.agreeLabel.text = @"等待同意";//自己加
//            }
//                break;
//            case 2:
//            {
//                self.agreeLabel.text = @"已被同意";
//             }
//                break;
//            case 3:
//            {
//                self.agreeLabel.text = @"已被拒绝";
//            }
//                break;
//            case 5:
//            {
//                self.agreeLabel.text = @"已同意";
//             }
//                break;
//            case 6:
//            {
//                self.agreeLabel.text = @"已拒绝";
//            }
//                break;
//            default:
//                self.agreeLabel.text = @"其他";
//                break;
//        }
//
//    }else{
//        switch (status) {
//            case 4:
//            {
//                self.agreeView.userInteractionEnabled = YES;
//                self.agreeView.layer.cornerRadius = 14;
//                self.agreeView.layer.masksToBounds = YES;
//                self.agreeView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(55, 28) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
//                self.agreeLabel.text = @"同意";
//                self.agreeLabel.textColor = [UIColor whiteColor];
//            }
//                break;
//            default:
//                self.agreeLabel.text = @"其他";
//                break;
//        }
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.agreeView.layer.cornerRadius = 14;
    self.agreeView.layer.masksToBounds = YES;
    self.agreeView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(55, 28) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
