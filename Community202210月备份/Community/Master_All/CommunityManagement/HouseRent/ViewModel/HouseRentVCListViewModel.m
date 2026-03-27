//
//  HouseRentVCListViewModel.m
//  Community
//
//  Created by 余莹 on 2020/12/30.
//  筛选

#import "HouseRentVCListViewModel.h"

@implementation HouseRentVCListViewModel
+ (void)getRentVcHouseListArrWithParm:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{//YrequestPostURLNotMainQueue 非get
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Get_Rent_House_List withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock houseArrBlock = block;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                houseArrBlock(Y_ResponsObject_dataArr,YES);
            }else{
                houseArrBlock(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            houseArrBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
+ (void)getRentVcBuniessShopListArrWithParm:(NSMutableDictionary *)parms WithBlock:(BaseListArrAndSuccessBoolBlock)block{
  //URL_Get_Rent_BuniessShop_List URL_Get_Rent_BuniessShop_List_WithDic
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Get_Rent_BuniessShop_List_WithDic withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock buniessShopArrBlock = block;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *redic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                if ([[redic allKeys] containsObject:@"records"]) {
                    if ([[redic objectForKey:@"records"] isKindOfClass:[NSArray class]]) {
                        NSArray *arr = [NSArray arrayWithArray:[redic objectForKey:@"records"]];
                        buniessShopArrBlock(arr,YES);
                    }else{
                        buniessShopArrBlock(@[],NO);
                        Y_SVP_SHOW_ERR_MES(@"数据错误");
                    }
                }else{
                    buniessShopArrBlock(@[],NO);
                    Y_SVP_SHOW_ERR_MES(@"数据格式错误");
                }
            }else{
                buniessShopArrBlock(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            buniessShopArrBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark == 主页用的房屋租赁数据
+ (void)initRentVcHouseListArrToMainVcWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Get_Rent_House_List withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock houseArrBlock = block;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                houseArrBlock(Y_ResponsObject_dataArr,YES);
            }else{
                houseArrBlock(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            houseArrBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
} 
+ (void)upDataRentVcHouseListArrToMainVcWithPageNum:(NSInteger)pageNum WithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Get_Rent_House_List withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock houseArrBlock = block;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                houseArrBlock(Y_ResponsObject_dataArr,YES);
            }else{
                houseArrBlock(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            houseArrBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 
@end
