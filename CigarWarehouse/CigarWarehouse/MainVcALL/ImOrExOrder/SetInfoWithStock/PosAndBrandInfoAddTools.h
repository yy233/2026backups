//
//  PosAndBrandInfoAddTools.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddNetEndUseBlock)(BOOL succ,NSDictionary *okDic);

@interface PosAndBrandInfoAddTools : NSObject

singleton_interface(share)
#pragma mark ===  添加品牌
- (void)addBrandWithBrandNameStr:(NSString *)brandName
                     withEngName:(NSString *)en_brandName
                     withIconUrl:(NSString *)iconStr
                  withIsCubaBool:(BOOL)isCubaBool
                       withBlock:(AddNetEndUseBlock)block;

#pragma mark ===  添加品牌子型号
- (void)addBrandTypeWithBrandTypeNameStr:(NSString *)brandTypeName
                         withEngTypeName:(NSString *)en_brandTypeName
                           withBasePrice:(NSString *)base_price
                          withIsCubaBool:(BOOL)isCubaBool
                   withThisTypeOfBarnsId:(NSInteger)barnsId
                               withBlock:(AddNetEndUseBlock)block;

#pragma mark ===  添加 库/柜子/层

- (void)addPlaceNameStr:(NSString *)PlaceName   withBlock:(AddNetEndUseBlock)block;
- (void)addCabinetNameStr:(NSString *)CibName withPlaceId:(NSInteger)placeId   withBlock:(AddNetEndUseBlock)block;
- (void)addLevelNameStr:(NSString *)LevelName withCabinetId:(NSInteger)cid   withBlock:(AddNetEndUseBlock)block;

#pragma mark === 出入库
//- (void)orderExportWithInfoPricestr:(NSString *)priceStr withstock_id:(NSInteger)stock_id withorderCode:(NSString *)orderCode withbuyer:(NSString *)buyer withBlock:(AddNetEndUseBlock)block;
- (void)orderListExportWithInfoArr:(NSMutableArray *)infoArr withBlock:(AddNetEndUseBlock)block;
- (void)orderImportWithInfoDic:(NSMutableDictionary *)exDic withBlock:(AddNetEndUseBlock)block;
- (void)moveStockPosWithThisProductCode:(NSString *)ProductCode withPosStr:(NSString *)posStr withBlock:(AddNetEndUseBlock)block;
@end

NS_ASSUME_NONNULL_END
