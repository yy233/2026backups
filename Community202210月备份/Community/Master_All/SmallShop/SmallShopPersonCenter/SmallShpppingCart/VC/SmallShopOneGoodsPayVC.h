//
//  SmallShopOneGoodsPayVC.h
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "SmallShopCartDetailPayVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SmallShopOneGoodsPayVC_Type_Goods   = 1,
    SmallShopOneGoodsPayVC_Type_Service = 2,
    SmallShopOneGoodsPayVC_Type_Box     = 3,
    SmallShopOneGoodsPayVC_Type_SpellGroupActivities   = 4, //拼团活动 拼团｜只有商品类型 
} SmallShopOneGoodsPayVC_Type;

@interface SmallShopOneGoodsPayVC : SmallShopCartDetailPayVC
@property (nonatomic,strong) NSMutableDictionary *detailVcUseModelDic;
@property (nonatomic,assign) SmallShopOneGoodsPayVC_Type nowGoodsSeviceBoxType;

@end

NS_ASSUME_NONNULL_END
