//
//  MoneyOfThridBangDingModel.h
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MoneyBindDingGetCodeStrBlock)(NSString *);
@interface WeiXinAuthorizationManager : NSObject
singleton_interface(share)
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)weiXinMoneyBangDingActionWithWeixinCodeStrBlock:(MoneyBindDingGetCodeStrBlock)codeStrBlock;
@end

NS_ASSUME_NONNULL_END
