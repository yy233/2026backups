//
//  ChatVcSubImgTypeTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import "ChatVcSubImgTypeTableViewCell.h"

@interface ChatVcSubImgTypeTableViewCell ()

@property (nonatomic,strong) NSString *saveImgAllUrlStr; 

@end

@implementation ChatVcSubImgTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel{
    
    if (friendGroupSystemType == ChatVcSessionType_FriendGroupSystemOtehr_Friend || friendGroupSystemType ==ChatVcSessionType_FriendGroupSystemOtehr_Group) {
        ChatFriendMessageModel *model = ( ChatFriendMessageModel *)msgModel;
        //1025新版数据
        NSDictionary *imgDic = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];//新版
        NSString *onlyUrl = [[imgDic allKeys]containsObject:@"url"] ? imgDic[@"url"] :@"";
        NSString *secretStr = [[imgDic allKeys]containsObject:@"secret"] ? imgDic[@"secret"] :@"";
        NSString *urlHaveSecret = [NSString stringWithFormat:@"%@&secret=%@",onlyUrl,secretStr];
        if([urlHaveSecret rangeOfString:@"http"].location != NSNotFound){
            self.saveImgAllUrlStr =  [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,urlHaveSecret]; //BASE_Chat_Img_Default_URL 旧有值 新为@“”
        }else{
            self.saveImgAllUrlStr =  [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,urlHaveSecret];
        }
        [self.contentView_New sd_setImageWithURL: [UrlWithString getURLWithStr: self.saveImgAllUrlStr ]];

    }
 

}

//图片点击
- (void)imgViewTap{
    if (isNil(self.chatVcSubCellsDeletage)) {
        return;
    }
    if ( [self.chatVcSubCellsDeletage  respondsToSelector:@selector(cellDelegateWithTouchImgWithAllUrlStr:)] ) {
        [self.chatVcSubCellsDeletage cellDelegateWithTouchImgWithAllUrlStr:self.saveImgAllUrlStr];
    }
}
@end
