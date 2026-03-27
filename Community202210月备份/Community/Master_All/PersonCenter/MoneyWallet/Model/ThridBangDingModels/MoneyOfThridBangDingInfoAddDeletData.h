//
//  MoneyOfThridBangDingAddDeletViewModel.h
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyOfThridBangDingInfoAddDeletData : NSObject
+ (void)getThridAuthorizationBangDingInfoWithBlock:(BaseListArrAndSuccessBoolBlock)block;
//微信
+ (void)weixinBangDingWithCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)weixinJieBangWithAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block;

//支付宝
//+ (void)zhifubaoBangDingWithAccountStr:(NSString *)accountStr realNameStr:(NSString *)nameStr withBlock:(BaseDicAndSuccessBoolBlock)block;//弃用
+ (void)zhifubaoBangDingWithCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)zhifubaoJieBangWithAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block;
#pragma mark == ios
+ (void)iosJieBangWithNotUseAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
