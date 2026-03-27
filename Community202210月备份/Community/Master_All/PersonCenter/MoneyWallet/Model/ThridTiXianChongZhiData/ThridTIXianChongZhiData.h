//
//  ThridTIXianChongZhiData.h
//  Community
//
//  Created by 余莹 on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThridTIXianChongZhiData : NSObject
#pragma mark - 加载用户余额提现至微信数据
+ (void)tiXianToWechatWithMoneyAmount:(NSString *)amountStr withPatPassword:(NSString *)payPasswordStr withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)tiXianToZFBWithMoneyAmount:(NSString *)amountStr withPatPassword:(NSString *)payPasswordStr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
