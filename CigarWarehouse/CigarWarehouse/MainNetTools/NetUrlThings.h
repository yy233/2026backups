//
//  NetUrlThings.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/16.
// 网络

#import <Foundation/Foundation.h>


#pragma mark ================================================================================
#define  type_urlset_now                  (type_url_prod) //正式
//#define  type_urlset_now                  (type_url_test) //测试
#define  type_url_prod  (0)
#define  type_url_test  (1)


#if (type_urlset_now == type_url_prod)
//https://www.52dou.net:8000/

#define URL_Main_URL_Prefix                       @"http://114.55.177.167:8000"
#elif (type_urlset_now == type_url_test)
#define URL_Main_URL_Prefix                       @"http://113.249.229.41:8000"
#else
#define URL_Main_URL_Prefix                       @"http://113.248.177.74:8000"
#endif


#define Y_AllURL_Main(_URL)                       [NSString stringWithFormat:@"%@%@", URL_Main_URL_Prefix, _URL]


#pragma mark ================================================================================

#pragma mark === 品牌
#define stock_allBrands          @"/stock/allBrands"//获取所有品牌
#define stock_allBrandTypes      @"/stock/allBrandTypes"//获取某品牌对应型号
#define stock_getStockByBrand    @"/stock/getStockByBrand"//根据品牌查库存
#define stock_getStockByProductCode   @"/stock/getStockByCode"//据某产品码code查库存 /stock/getStockByCode

#pragma mark === 位置
#define stock_allPlace           @"/stock/allPlace"//获取所有仓库
#define stock_allCabinet         @"/stock/allCabinet"//获取柜子列表
#define stock_allLevel           @"/stock/allLevel"//获取柜子对应的位置
#pragma mark === 品牌
#define stock_insertBrand         @"/stock/insertBrand" //添加品牌
#define stock_insertBrandType     @"/stock/insertBrandType" //添加应品牌所有型号
#pragma mark === 位置
#define stock_insertPlace         @"/stock/insertPlace" //添加仓库位置
#define stock_insertCabinet       @"/stock/insertCabinet" //添加柜子
#define stock_insertLevel         @"/stock/insertLevel"//添加柜子内具体位置
#pragma mark === 出入库
#define stock_insertStock         @"/stock/insertStock" //添加库存==入库/stock/insertStock
#define stock_createOrders        @"/stock/createOrders" //创建订单==出库
#define stock_moverstockPos       @"/stock/moveStock" //移动库存/stock/moveStock
#pragma mark ===
 
 


#pragma mark ================================================================================

#define Response_Check_Status_OK                ([[responsObject allKeys]containsObject:@"status"]  && ([[responsObject objectForKey:@"status"]isEqual:@"ok"] || [[responsObject objectForKey:@"status"]isEqual:@"200"]))
#define Response_Check_DataArr_Type             ([[responsObject allKeys]containsObject:@"data"] && [[responsObject objectForKey:@"data"] isKindOfClass:[NSArray class]])
#define Response_Check_DataDic_Type             ([[responsObject allKeys]containsObject:@"data"] && [[responsObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
#define Response_Check_DataStr_Type             ([[responsObject allKeys]containsObject:@"data"] && [[responsObject objectForKey:@"data"] isKindOfClass:[NSString class]])
#define Response_DataArr                        ([[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : @[]
#define Response_DataDic                        ([[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : @{}
#define Response_DataStr                        ([[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : @""
#define Response_responsObject                   responsObject
#define Response_Check_HaveKey_All               [[responsObject allKeys]containsObject:@"all"]
#define Response_Data_AllKey_Arr                   ([[responsObject allKeys] containsObject:@"all"] && isNotNil([responsObject objectForKey:@"all"]) ) ? [responsObject objectForKey:@"all"] : @[]


NS_ASSUME_NONNULL_BEGIN

@interface NetUrlThings : NSObject

@end

NS_ASSUME_NONNULL_END
