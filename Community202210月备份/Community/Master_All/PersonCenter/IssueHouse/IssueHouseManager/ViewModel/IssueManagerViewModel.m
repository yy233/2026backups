//
//  IssueManagerBottomListViewModel.m
//  Community
//
//  Created by 余莹 on 2021/4/2.
// 租房管理列表()

#import "IssueManagerViewModel.h"

@implementation IssueManagerViewModel
//租房管理 房东 已发的 house 列表数据
+ (void)managerVcBottomFangDongTypeWithListBlock:(BaseListArrAndSuccessBoolBlock)blockList{
    NSString *url = @"lease/house/ownerLeaseHouse";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(9999) forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = blockList;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//租房管理 房东 已发的 buniesShop 列表数据  ___子类已有 (弃用本条)？0710 使用这个接口
+ (void)managerVcBottomBuniessShopTypeWithListBlock:(BaseListArrAndSuccessBoolBlock)blockList{
    NSString *url = @"lease/shop/listShop"; //URL_Get_BuniessShop_UserSendList
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(9999) forKey:@"size"];
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_Get_BuniessShop_UserSendList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {

        BaseListArrAndSuccessBoolBlock block = blockList;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//下架发布的房屋
+ (void)deletDownHouseWithId:(NSInteger)houseId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house";
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObject:@(houseId) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
            BaseDicAndSuccessBoolBlock block = dicBlock;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataDic,YES);
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
//下架发布的商铺
+ (void)deletDownBuniessShopWithId:(NSInteger)shopId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/shop/cancelShop";
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObject:@(shopId) forKey:@"shopId"];
        [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
            BaseDicAndSuccessBoolBlock block = dicBlock;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    block(Y_ResponsObject_dataDic,YES);
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

//0903签约
/**
 身份类型;1:房东;2:租客
 资产类型;1:商铺;2:房屋
 */
//房屋
+ (void)qianYueHouseListWithFangDongOrZuKe:(NSInteger)identityType initWithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(identityType) forKey:@"identityType"];
    [parms setValue:@(2) forKey:@"assetType"];
    [self qianyueListWithParms:parms withBlock:block];
    
}
//商铺
+ (void)qianYueBuniessListWithFangDongOrZuKe:(NSInteger)identityType initWithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(identityType) forKey:@"identityType"];
    [parms setValue:@(1) forKey:@"assetType"];
    [self qianyueListWithParms:parms withBlock:block];
}

+ (void)qianyueListWithParms:(NSMutableDictionary *)parms  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"lease/house/v2/contractList";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataDic,YES);//notContracted 等类型
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
