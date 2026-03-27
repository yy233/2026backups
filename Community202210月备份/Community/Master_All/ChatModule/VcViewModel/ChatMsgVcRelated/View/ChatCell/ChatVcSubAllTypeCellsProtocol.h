//
//  ChatVcSubAllTypeCellsProtocol.h
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * _Nullable kAddStr = @"addr_str";
static NSString * _Nullable kLat = @"latitude";
static NSString * _Nullable kLong = @"longitude";

@protocol ChatVcSubAllTypeCellsProtocol <NSObject>

//图片cell大图展示
- (void)cellDelegateWithTouchImgWithAllUrlStr:(NSString *)imgAllUrlStr;
//地址信息跳转等
- (void)cellDelegateWithTouchOpenLocateActionWithAddressStr:(NSString *)addressStr withLatFloat:(CGFloat)lat withLongFloat:(CGFloat)longi andWithFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle;

//播放语音
- (void)cellDelegateWithTouchVoicePlayActionFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle;
//播放mp4
- (void)cellDelegateWithTouchMp4OpenOrCloseActionwithFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel
                                                             orGroupModel:(nullable ChatGroupMessageModel *)gmodle
                                                   withTouchIsOpenMp4Bool:(BOOL)isOpenMp4;


////撤回删除
//- (void)cellDelegateWithTouchUndoFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel orGroupModel:(nullable ChatGroupMessageModel *)gmodle;
//- (void)cellDelegateWithTouchDeletFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle;
@end

NS_ASSUME_NONNULL_END
