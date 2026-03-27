//
//  ZYSmallShopGoodsSpellGroupSharedModel.h
//  Community
//
//  Created by ZY on 2022/3/25.
//

#import <Foundation/Foundation.h>

@class ZYSmallShopGoodsSpellGroupSharedDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopGoodsSpellGroupSharedModel : NSObject

@property (nonatomic, copy) NSString *action;

@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupSharedDataModel *data;

@end


@interface ZYSmallShopGoodsSpellGroupSharedDataModel : NSObject

@property (nonatomic, copy) NSString *communityId;

@property (nonatomic, copy) NSString *spellId;

@end

NS_ASSUME_NONNULL_END
