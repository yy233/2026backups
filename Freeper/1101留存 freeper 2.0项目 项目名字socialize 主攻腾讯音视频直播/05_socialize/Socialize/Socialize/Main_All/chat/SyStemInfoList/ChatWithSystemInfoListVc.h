//
//  ChatWithSystemInfoListVc.h
//  Socialize
//
//  Created by 余莹 on 2023/8/11.
//

#import <UIKit/UIKit.h>
#import "IMBase.h"
#import "TUIConversationCellData.h"
#import "VoiceRoomChuanZhiModel.h"
NS_ASSUME_NONNULL_BEGIN

//普通列表 服务通知
@interface ChatWithSystemInfoListVc : Y_BaseViewController
@property (nonatomic,strong) TUIConversationCellData *conversation;
- (void)creatVoiceRoomUseSwiftVcWithInfo:(VoiceRoomChuanZhiModel *)vChuanZhiModel;//VoiceRoomChuanZhiModel

@end

NS_ASSUME_NONNULL_END
