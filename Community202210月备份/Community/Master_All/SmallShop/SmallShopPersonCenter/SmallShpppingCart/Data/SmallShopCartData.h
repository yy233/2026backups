//
//  SmallShopCartData.h
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartData : NSObject

//删除
+ (void)myCartDelInfoWithIdArrs:(NSMutableArray *)idArrs withBlock:(BaseDicAndSuccessBoolBlock)block;
//更改数量
+ (void)myCartchangeOneGoodsCountNumWithId:(NSString *)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block;
//拿到某商品在某数量时的价格等信息
+ (void)myCartChangeCountOfGetMoneyInfoWithOneGoodsID:(NSString *)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block;
////拿到某商品在某数量时的价格等信息 （结算页更改—— 都是钱的数据 不在car加数量）
//+ (void)myCartDetailOrOneGoodsPayVcGetMoneyInfoWithOneGoodsID:(NSInteger)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block;
#pragma mark === 订单生成部分
//单种 商品/服务/货柜/订单 -> 生成订单
+ (void)oneGoodSeiviceBoxCreatOrderWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
//购物车单种多种货物 -> 生成订单
+ (void)cartCreatOrderWithCartDetailInfoDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block;

//超时处理或订单删除接口
+ (void)deletOrderWithOrderStr:(NSString *)orderStr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
