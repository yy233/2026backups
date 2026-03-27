//
//  LdleGoodsData.m
//  Community
//
//  Created by 余莹 on 2022/6/21.
//

#import "LdleGoodsData.h"

static NSString *url_Ldle_DeletOneGoods = @"proprietor/market/deleteMarket";
static NSString *url_Ldle_ChangeOneGoodsType = @"proprietor/market/updateState";
static NSString *url_Ldle_JuBaoOneGoodsWeiGui = @"proprietor/market/updateType";
static NSString *url_Ldle_GetOneGoodsInfo = @"proprietor/market/selectOne";

 
@implementation LdleGoodsData
//删除用户发布的商品
+ (void)deletThisLdleGoodsWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestDeleteALLURL:Y_BASEURL(url_Ldle_DeletOneGoods) withParams:@{@"id":idStr}.mutableCopy finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *dic = Y_ResponsObject_dataDic;
                    block(dic,YES);
                }else{
                    block(@{},NO);
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
    }];
}

//修改商品的上下架状态
+ (void)changeTypeThisLdleGoodsWithIdStr:(NSString *)idStr withisWillUpThisGoodsBool:(BOOL)isWillUpThisGoodsBool withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:idStr forKey:@"id"];
    [parms setValue:[NSNumber numberWithBool:isWillUpThisGoodsBool]  forKey:@"state"];
    
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_BASEURL(url_Ldle_ChangeOneGoodsType) withParams:parms finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *dic = Y_ResponsObject_dataDic;
                    block(dic,YES);
                }else{
                    block(@{},NO);
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
    }];
}


//举报违规 带违规状态
+ (void)juBaoThisLdleGoodsWithIdStr:(NSString *)idStr withWeiGuiType:(NSInteger)weiGuiType withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:idStr forKey:@"id"];
    [parms setValue:[NSNumber numberWithBool:weiGuiType]  forKey:@"type"];
    
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_BASEURL(url_Ldle_JuBaoOneGoodsWeiGui) withParams:parms finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *dic = Y_ResponsObject_dataDic;
                    block(dic,YES);
                }else{
                    block(@{},NO);
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
    }];
}

//获取某闲置商品详情
+ (void)getLdleOneGoodsDetailInfoWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_BASEURL(url_Ldle_GetOneGoodsInfo) withParams:@{@"id":idStr}.mutableCopy  finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *dic = Y_ResponsObject_dataDic;
                    block(dic,YES);
                }else{
                    block(@{},NO);
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
    }];
}
@end
