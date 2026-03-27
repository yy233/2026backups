//
//  LdleGoodsData.h
//  Community
//
//  Created by 余莹 on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LdleGoodsData : NSObject
//删除用户发布的商品
+ (void)deletThisLdleGoodsWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;

//修改商品的上下架状态
+ (void)changeTypeThisLdleGoodsWithIdStr:(NSString *)idStr withisWillUpThisGoodsBool:(BOOL)isWillUpThisGoodsBool withBlock:(BaseDicAndSuccessBoolBlock)block;

//举报违规 带违规状态
+ (void)juBaoThisLdleGoodsWithIdStr:(NSString *)idStr withWeiGuiType:(NSInteger)weiGuiType withBlock:(BaseDicAndSuccessBoolBlock)block;

//获取某闲置商品详情
+ (void)getLdleOneGoodsDetailInfoWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
