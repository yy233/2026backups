//
//  PostDatasTool.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef  void(^BlockWithSuccBoolAndDic)(BOOL succ,NSDictionary *dataDic);

@interface PostDatasTool : NSObject
singleton_interface(share)

#pragma mark ***************** *****************  品牌相关
#pragma mark ====  添加品牌
- (void)insertBrandWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;
#pragma mark ====  添加应品牌子型号
- (void)insertBrandTypeWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;


#pragma mark ***************** *****************  位置相关
#pragma mark ==== 仓库
- (void)insertPalseWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;//库
- (void)insertCabinetWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;//柜子
- (void)insertLevelWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;//层

#pragma mark ***************** *****************  订单/出入库
//出库一条数据
//- (void)orderExportWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;
//数组多数据出库
- (void)orderListExportWithInfoArr:(NSMutableArray *)infoArr withBlock:(BlockWithSuccBoolAndDic)block;
//入库 一条数据
- (void)orderImportWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;
//移动库存
- (void)moveStockWithInfo:(NSDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block;

@end

NS_ASSUME_NONNULL_END
