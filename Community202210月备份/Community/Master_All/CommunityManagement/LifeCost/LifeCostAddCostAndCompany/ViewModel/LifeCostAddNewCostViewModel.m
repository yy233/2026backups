//
//  LifeCostAddNewCostViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import "LifeCostAddNewCostViewModel.h"

@implementation LifeCostAddNewCostViewModel 

//
//+ (void)initAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId with:(BaseListArrAndSuccessBoolBlock)listBlock {
//    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
//    [parms setValue:@(1) forKey:@"page"];
//    [parms setValue:@(PAGE_SIZE) forKey:@"size"];
//    NSDictionary *qdic = [NSDictionary dictionaryWithObjects:@[@(typeId),@(cityId)] forKeys:@[@"type",@"cityId"]];
//    [parms setValue:qdic forKey:@"query"];
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_Companys_List withParams:parms finished:^(id responsObject, NSError *error) {
//        BaseListArrAndSuccessBoolBlock block = listBlock;
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                block(Y_ResponsObject_dataArr,YES);
//            }else{
//                block(@[],NO);
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            block(@[],NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
//+ (void)moreAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId WithPageNum:(NSInteger)pageNum with:(BaseListArrAndSuccessBoolBlock)listBlock {
//    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
//    [parms setValue:@(pageNum) forKey:@"page"];
//    [parms setValue:@(PAGE_SIZE) forKey:@"size"];
//    NSDictionary *qdic = [NSDictionary dictionaryWithObjects:@[@(typeId),@(cityId)] forKeys:@[@"type",@"cityId"]];
//    [parms setValue:qdic forKey:@"query"];
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_Companys_List withParams:parms finished:^(id responsObject, NSError *error) {
//        BaseListArrAndSuccessBoolBlock block = listBlock;
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                block(Y_ResponsObject_dataArr,YES);
//            }else{
//                block(@[],NO);
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            block(@[],NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}

+ (void)getAddNewCostCompanyArrWithTypeId:(NSInteger)typeId withCityId:(NSInteger)cityId withSearchStr:(NSString *)searchStr with:(BaseListArrAndSuccessBoolBlock)listBlock {
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    if (searchStr==nil || searchStr.length == 0) {
        parms = [NSMutableDictionary dictionaryWithObjects:@[@(typeId),@(cityId),@""] forKeys:@[@"typeId",@"cityId",@"companyName"]];
    }else{
        parms = [NSMutableDictionary dictionaryWithObjects:@[@(typeId),@(cityId),searchStr] forKeys:@[@"typeId",@"cityId",@"companyName"]];
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_Companys_List withParams:parms finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLStrWithAllURLNoParmsNotMainQueue:URL_Life_Companys_List withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
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

/**
 新增缴费 ===  假账单接口
 */
+ (void)addNewLifeCostPayWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLStrWithAllURLNoParmsNotMainQueue:URL_Life_addNewLifeCostPay withParams:parms finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_addNewLifeCostPay withParams:parms finished:^(id responsObject, NSError *error) {
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
@end
