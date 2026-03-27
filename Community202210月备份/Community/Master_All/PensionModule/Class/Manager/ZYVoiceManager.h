//
//  ZYVoiceManager.h
//  Community
//
//  Created by ZY on 2021/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYVoiceManager : NSObject
singleton_interface(share)

- (void)voiceDownLoadWithFileUrlStr:(NSString *)fileUrlStr AndIsPlay:(BOOL)isPlay;

@end

NS_ASSUME_NONNULL_END
