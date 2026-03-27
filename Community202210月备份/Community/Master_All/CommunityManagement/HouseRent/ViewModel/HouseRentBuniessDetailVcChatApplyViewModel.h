//
//  HouseRentBuniessDetailVcChatApplyViewModel.h
//  Community
//
//  Created by 余莹 on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentBuniessDetailVcChatApplyViewModel : NSObject
+ (void)HouseRentBuniessDetailVcChatApplyWithImIdStr:(NSString *)imidStr withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)webViewShopBuniessDetailVcChatApplyWithImIdStr:(NSString *)imidStr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
