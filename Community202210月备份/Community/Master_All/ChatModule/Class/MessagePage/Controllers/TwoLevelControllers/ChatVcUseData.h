//
//  ChatVcUseData.h
//  Community
//
//  Created by 余莹 on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatVcUseData : NSObject

singleton_interface(share)
- (void)chatMsgSetReadedTypeWithHistoryInfoMsgIdStrArr:(NSMutableArray *)msgIdArr withToUser:(NSString *)toUser withFromUser:(NSString *)fromUser withSessionId:(NSString *)sessionId;
- (void)chatMsgSetReadedTypeWithMsgId:(NSString *)msgIdStr withToUser:(NSString *)toUser withFromUser:(NSString *)fromUser withSessionId:(NSString *)sessionId;
@end

NS_ASSUME_NONNULL_END
