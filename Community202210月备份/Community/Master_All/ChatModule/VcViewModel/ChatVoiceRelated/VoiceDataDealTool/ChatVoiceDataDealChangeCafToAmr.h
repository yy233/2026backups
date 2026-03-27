//
//  ChatVoiceDataDealChangeCafToAmr.h
//  Community
//
//  Created by 余莹 on 2021/6/26.
//

#import <Foundation/Foundation.h>

typedef void(^CafToAmrBlock)(NSString *newPathStr, BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface ChatVoiceDataDealChangeCafToAmr : NSObject

+ (void)changeCafToAmrWithCafPath:(NSString *)cafPath withCafToAmrBlock:(CafToAmrBlock)block;

@end

NS_ASSUME_NONNULL_END
