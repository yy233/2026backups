//
//  MedicalShopRelatedData.m
//  Community
//
//  Created by 余莹 on 2021/12/9.
//

#import "MedicalShopRelatedData.h"

#define  MedicalShopRelatedData_Longitude  (106.4534211)
#define  MedicalShopRelatedData_Latitude  (29.3541211)

#define  URL_NearTheServiceList             @"shop/goods/goods/NearTheService"    //附近的服务
#define  URL_HotShopList                    @"shop/shop/hotGoods/getHot"          //热门推荐
#define  URL_MedicalShopList                @"shop/shop/newShop/getShopAllList"   //根据分类展示店铺列表 /医疗类型
#define  URL_SOS_MedicalShopList            @"shop/shop/newShop/getMedicalShop"   //医疗救助机构


@implementation MedicalShopRelatedData
//all
+ (void)getShopListWithURL:(NSString *)url andAllParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{
   
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSArray *arr = ( [[dataDic allKeys] containsObject:@"records"] && isNotNil([dataDic objectForKey:@"records"]) ) ? [dataDic objectForKey:@"records"] : [NSMutableArray array];
                block(arr,YES);
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

//查询附近的服务
//主页少量几条
+ (void)getMedicalNearTheServiceMinNumCountWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_NearTheServiceList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE_3) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
}
    
+ (void)getMedicalNearTheServiceFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_NearTheServiceList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
}

+ (void)getMedicalNearTheServiceWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_NearTheServiceList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
}



//根据分类展示店铺列表 /医疗类型
//主页少量几条
+ (void)getMedicalShopOnlyMinNumCountWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_MedicalShopList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE_3) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [parms setValue:@(6) forKey:@"treeId"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
    
}
+ (void)getMedicalShopFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_MedicalShopList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [parms setValue:@(6) forKey:@"treeId"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
    
}
+ (void)getMedicalShopWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_MedicalShopList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    [parms setValue:@(6) forKey:@"treeId"];//医疗类型
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
}



#pragma mark ===SOS 养老 紧急通讯录 机构部分
/**
 医疗，查询商铺接口
 经纬度现在写死
 "longitude": "106.4534211",
 "latitude": "29.3541211"
 */
+ (void)getMedicalShopOfSOSAgencyFirstPageNumWithSearchShopNameStr:(NSString *)shopName WithBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    if (shopName.length>0) {
        [parms setValue:shopName forKey:@"shopName"];
    }
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [self getMedicalShopOfSOSAgencyWithAllParms:parms withBlock:block];
}
+ (void)getMedicalShopOfSOSAgencyWithSearchShopNameStr:(NSString *)shopName andPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(MedicalShopRelatedData_Longitude) forKey:@"longitude"];
    [parms setValue:@(MedicalShopRelatedData_Latitude) forKey:@"latitude"];
    if (shopName.length>0) {
        [parms setValue:shopName forKey:@"shopName"];
    }
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
     [self getMedicalShopOfSOSAgencyWithAllParms:parms withBlock:block];
}

+ (void)getMedicalShopOfSOSAgencyWithAllParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{

    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_SOS_MedicalShopList];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
 
 
}



#pragma mark ==
//热门推荐
+ (void)getHotShopFirstPageNumWithBlock:(BaseListArrAndSuccessBoolBlock)block{

    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_HotShopList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
    
}
+ (void)getHotShopWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL_Shop_medical,URL_HotShopList];
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"rows"];
    [self getShopListWithURL:url andAllParms:parms withBlock:block];
}

@end
