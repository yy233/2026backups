//
//  VoiceDownAndSavePlayManage.h
//  Community
//
//  Created by 余莹 on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceDownAndSavePlayManage : NSObject
singleton_interface(share);
//- (void)chatVoiceDownSavePlayWithFileIdStr:(NSString *)voiceFileIdStr;
- (void)chatVoiceDownSavePlayWithMsgId:(NSString *)msgIdStr withFileSecret:(NSString *)fileSecretStr withUrlStr:(NSString *)voiceFileIdStr;

@end

NS_ASSUME_NONNULL_END
