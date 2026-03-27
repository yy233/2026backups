//
//  ChatVoiceDataDealTool.h
//  Community
//
//  Created by 余莹 on 2021/5/21.
/**
    开始录音 给名字
    结束录音。存储音频  做路径 ，拿数据 处理数据 转码， 发送 音频数据/
    回调后发送dic
 */
/**
     得到URL 下载文件 存储文件 转码 播放音频
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VoiceFileSendOkGetDicBlock)(NSDictionary *);
@interface ChatVoiceDataDealTool : NSObject
singleton_interface(share)

/**
 录音
 */
- (void)voiceStartRecordWithChatSessionId:(NSString *)chatSessionIdStr;
- (void)voiceEndRecordWithIsSendInfoBool:(BOOL)isSendInfoBool;



#pragma mark ===
@property (nonatomic,copy) VoiceFileSendOkGetDicBlock voiceGetWillSendDicBlock;
 
@end

NS_ASSUME_NONNULL_END
