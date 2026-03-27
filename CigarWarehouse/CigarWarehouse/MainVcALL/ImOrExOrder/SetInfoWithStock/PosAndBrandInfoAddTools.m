//
//  PosAndBrandInfoAddTools.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/17.
//

#import "PosAndBrandInfoAddTools.h"

@implementation PosAndBrandInfoAddTools
 

singleton_implementation(share)

#pragma mark ===  添加品牌类型
- (void)addBrandWithBrandNameStr:(NSString *)brandName 
                     withEngName:(NSString *)en_brandName
                     withIconUrl:(NSString *)iconStr
                  withIsCubaBool:(BOOL)isCubaBool
                       withBlock:(AddNetEndUseBlock)block{

    InsertBrandModel *model = [[InsertBrandModel alloc]init];
    model.brand = brandName;
    model.eng_name = en_brandName;
    model.is_cuba = isCubaBool;
    model.icon = iconStr;
    NSMutableDictionary *p = [model mj_keyValues];
    
    [[PostDatasTool share]insertBrandWithInfoDic:p withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
             DLog(@"insertBrandWithInfoDic  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
}

#pragma mark ===  添加品牌子型号
- (void)addBrandTypeWithBrandTypeNameStr:(NSString *)brandTypeName
                         withEngTypeName:(NSString *)en_brandTypeName
                           withBasePrice:(NSString *)base_price
                          withIsCubaBool:(BOOL)isCubaBool
                   withThisTypeOfBarnsId:(NSInteger)barnsId
                               withBlock:(AddNetEndUseBlock)block{
    
    
    InsertBrandTypeModel *model = [[InsertBrandTypeModel alloc]init];
    model.name = brandTypeName;
    model.eng_name = en_brandTypeName;
    model.brand_id = barnsId;
    model.base_price = [[NSDecimalNumber alloc]initWithString:base_price]; 
    model.pos = 0;
    NSMutableDictionary *p = [model mj_keyValues];
    
    [[PostDatasTool share] insertBrandTypeWithInfoDic:p withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"addBrandTypeWith  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}

#pragma mark ===  添加 库/柜子/层 
//库
- (void)addPlaceNameStr:(NSString *)PlaceName   withBlock:(AddNetEndUseBlock)block{
    
//    PlaceModel *model = [[PlaceModel alloc]init];
//    model.Place = PlaceName;
//    NSMutableDictionary *p = [model mj_keyValues];
    NSMutableDictionary *p = @{@"place":PlaceName}.mutableCopy;
    [[PostDatasTool share] insertPalseWithInfoDic:p withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"insertBrandWithInfoDic  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}
- (void)addCabinetNameStr:(NSString *)CibName withPlaceId:(NSInteger)placeId   withBlock:(AddNetEndUseBlock)block{
    
    CabinetModel *model = [[CabinetModel alloc]init];//增加柜子
    model.Cabinet = CibName;
    model.Pid = placeId;
    NSMutableDictionary *p = [model mj_keyValuesWithIgnoredKeys:@[@"Id"]];//忽略柜子ID键值
    [[PostDatasTool share] insertCabinetWithInfoDic:p withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"insertBrandWithInfoDic  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}

- (void)addLevelNameStr:(NSString *)LevelName withCabinetId:(NSInteger)cid   withBlock:(AddNetEndUseBlock)block{
    
    NSMutableDictionary *p = @{@"cid":@(cid),
                               @"level":LevelName}.mutableCopy;
    [[PostDatasTool share] insertLevelWithInfoDic:p withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"insertBrandWithInfoDic  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}




#pragma mark ===  出入库
//- (void)orderExportWithInfoPricestr:(NSString *)priceStr withstock_id:(NSInteger)stock_id withorderCode:(NSString *)orderCode withbuyer:(NSString *)buyer withBlock:(AddNetEndUseBlock)block{
//    CreateOrdersModel *model;
//    [[PostDatasTool share]orderExportWithInfoDic:[model mj_keyValues] withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
//        if (succ) {
//            DLog(@"orderExportWithInfoPricestr  --- %@",dataDic);
//            block(succ,dataDic);
//        }
//    }];
//    
//}
//出库列表
- (void)orderListExportWithInfoArr:(NSMutableArray *)infoArr withBlock:(AddNetEndUseBlock)block{
   
    [[PostDatasTool share]orderListExportWithInfoArr:infoArr withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"orderExportWithInfoPricestr  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}


- (void)orderImportWithInfoDic:(NSMutableDictionary *)exDic withBlock:(AddNetEndUseBlock)block{
 
    [[PostDatasTool share]orderImportWithInfoDic:exDic withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"orderImportWithInfoDic  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
    
}
- (void)moveStockPosWithThisProductCode:(NSString *)ProductCode withPosStr:(NSString *)posStr withBlock:(AddNetEndUseBlock)block{
    
    [[PostDatasTool share]moveStockWithInfo:@{@"code":ProductCode,
                                              @"pos":posStr}
                                  withBlock:^(BOOL succ, NSDictionary * _Nonnull dataDic) {
        if (succ) {
            DLog(@"moveStockPosWithThisProductCode  --- %@",dataDic);
            block(succ,dataDic);
        }
    }];
}
/**
 
 @property (nonatomic,copy)   NSString     *buyer;
 @property (nonatomic,copy)   NSString     *orderCode;
 @property (nonatomic,assign) double       price;//价格
 @property (nonatomic,assign) NSInteger    quantity;
 @property (nonatomic,assign) NSInteger    stock_id;
 @end


 @interface InsertStockModel : NSObject
 @property (nonatomic,assign) NSInteger    brand_id;
 @property (nonatomic,assign) NSInteger    brand_type_id;
 @property (nonatomic,copy)   NSString     *buy_from;
 @property (nonatomic,assign) double       buy_price;//价格
 @property (nonatomic,assign) double       cigar_piece;//价格
 @property (nonatomic,copy)   NSString     *code;
 @property (nonatomic,copy)   NSString     *owner;
 @property (nonatomic,copy)   NSString     *pack;
 @property (nonatomic,copy)   NSString     *pos;
 @property (nonatomic,copy)   NSString     *produce_from;
 @end*/

@end
