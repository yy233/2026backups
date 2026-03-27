//
//  IssBuniessShopQuYuViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssBuniessShopQuYuAndAddressViewModel : NSObject
+ (void)getIssueBuniessShopQuYuWithCityId:(NSInteger)cityId getQuYuArr:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getIssueBuniessShopCommunityAddressWithQuYuId:(NSInteger)quYuId getCommunityAddressArr:(BaseListArrAndSuccessBoolBlock)listBlock;

@end

NS_ASSUME_NONNULL_END
