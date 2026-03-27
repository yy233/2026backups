//
//  GetDatasTool.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/16.
//

#import "GetDatasTool.h"




@implementation GetDatasTool
singleton_implementation(share)

#pragma mark ***************** ***************** ***************** ***************** 品牌相关查询

#pragma mark ====  获取所有品牌
- (void)getAllBrandsListWithBlock:(BlockWithSuccBoolAndArr)block{
    
    NSString *u = Y_AllURL_Main(stock_allBrands);
    NSDictionary *p = @{};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
}


#pragma mark ====  获取某品牌所有型号
- (void)getBrandTypesOfOneBrandId:(NSInteger)brandId withTypesListWithBlock:(BlockWithSuccBoolAndArr)block{
    
    NSString *u = Y_AllURL_Main(stock_allBrandTypes);
    NSDictionary *p = @{@"brandId":@(brandId)};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {//Alamofire.AFError.responseSerializationFailed(reason: Alamofire.AFError.ResponseSerializationFailureReason.inputDataNilOrZeroLength)
    }];
}

#pragma mark ====  根据品牌查库存
- (void)getBrandStockNumOfOneBrandId:(NSInteger)brandId
                    withOtherInfoDic:(NSMutableDictionary *)pdic
              withTypesListWithBlock:(BlockWithSuccBoolAndArr)block{
    
    NSString *u = Y_AllURL_Main(stock_getStockByBrand);
    if (pdic.count==0 || isNil(pdic)) {
        pdic = @{@"page":@(0),
                 @"count":@(999)}.mutableCopy;
    }
    [pdic setValue:@(brandId) forKey:@"brand_id"];
    NSDictionary *p = [NSDictionary dictionaryWithDictionary:pdic];
    
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
       //NSLog(@"根据品牌查库存 responsObject %@",responsObject);
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            Y_SVP_SHOW_ERR_MES(@"根据品牌查库存失败！");
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_DESCRIPTION;
        DLog(@"根据品牌查库存失败");
    }];
}

#pragma mark ====  根据某产品码code查库存
- (void)getProductInfoWithProductCodeId:(NSString *)ProductCodeId withTypesListWithBlock:(BlockWithSuccBoolAndArr)block{
    NSString *u = Y_AllURL_Main(stock_getStockByProductCode);
    NSDictionary *p =   @{@"stock_code":ProductCodeId};
    
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
       //NSLog(@"根据品牌查库存 responsObject %@",responsObject);
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            Y_SVP_SHOW_ERR_MES(@"根据某产品码code查库存失败！");
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_DESCRIPTION;
    }];
}
#pragma mark ***************** ***************** ***************** *****************  位置相关查询

#pragma mark ====  获取所有仓库
- (void)getAllPlaceListWithBlock:(BlockWithSuccBoolAndArr)block{

    NSString *u = Y_AllURL_Main(stock_allPlace);
    NSDictionary *p = @{};
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                    parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
       
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
}


 
#pragma mark ====  获取柜子列表
- (void)getOnePlaceSubCabinetListWithPlaceId:(NSInteger)placeId withCabinetListWithBlock:(BlockWithSuccBoolAndArr)block{
 
    NSString *u = Y_AllURL_Main(stock_allCabinet);
    NSDictionary *p = @{@"pid":@(placeId)};//仓库id
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
}

#pragma mark ====  获取柜子对应的位置
- (void)getOneCabinetSubLevelListWithCabinetId:(NSInteger)cabinetId withLevelListWithBlock:(BlockWithSuccBoolAndArr)block{

    NSString *u = Y_AllURL_Main(stock_allLevel);
    NSDictionary *p = @{@"cid":@(cabinetId)};//柜子id
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                   parm:p
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
            }else{
                block(YES,Response_DataDic);
            }
        }else if(Response_Check_HaveKey_All){
            block(YES,Response_Data_AllKey_Arr);
            
        }else{
            
        }
        
    } fail:^(NSError * _Nonnull err) {
    }];
    
}

 

@end
