//
//  IssBuniessShopPublishTypeViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssBuniessShopPublishTypeViewModel : NSObject
+ (void)getIssueBuniessShopType:(BuniessShopOrHousePublish_Type)type withArr:(BaseListArrAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
