//
//  PostDatasTool.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/17.
//

#import "PostDatasTool.h"

@implementation PostDatasTool
singleton_implementation(share)

#pragma mark ***************** *****************  品牌相关

#pragma mark ====  添加品牌
- (void)insertBrandWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{

    NSString *u = Y_AllURL_Main(stock_insertBrand);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
    
}

#pragma mark ====  添加应品牌子型号
- (void)insertBrandTypeWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{

    NSString *u = Y_AllURL_Main(stock_insertBrandType);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
    
}


 
#pragma mark ***************** *****************  位置相关
#pragma mark ==== 仓库

/**
 #pragma mark === 位置
 #define stock_insertPlace         @"/stock/insertPlace" //添加仓库位置
 #define stock_insertCabinet       @"/stock/insertCabinet" //添加柜子
 #define stock_insertLevel         @"/stock/insertLevel"//添加柜子内具体位置*/
- (void)insertPalseWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{

    NSString *u = Y_AllURL_Main(stock_insertPlace);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
    
}
- (void)insertCabinetWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{

    NSString *u = Y_AllURL_Main(stock_insertCabinet);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
    
}

- (void)insertLevelWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{

    NSString *u = Y_AllURL_Main(stock_insertLevel);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
    
}





#pragma mark ***************** *****************  订单/出入库
/*
 #define stock_insertStock         @"/stock/insertBrand" //添加库存==入库
 #define stock_createOrders        @"/stock/createOrders" //创建订单==出库
 **/
//出库
- (void)orderExportWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{
 
    NSString *u = Y_AllURL_Main(stock_createOrders);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
}
//数组多数据出库
- (void)orderListExportWithInfoArr:(NSMutableArray *)infoArr withBlock:(BlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(stock_createOrders);
    [[NetWorkSwiftTool share]baseNetPostBodyMethodWithUrl:u
                                                 parm:infoArr
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
}


//入库
- (void)orderImportWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(stock_insertStock);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
}
//移动库存
- (void)moveStockWithInfo:(NSDictionary *)infoDic withBlock:(BlockWithSuccBoolAndDic)block{
    NSString *u = Y_AllURL_Main(stock_moverstockPos);
    [[NetWorkSwiftTool share]baseNetPostMethodWithUrl:u
                                                   parm:infoDic
                                                 header:nil
                                                   succ:^(NSDictionary * _Nonnull responsObject) {
        
        if (Response_Check_Status_OK) {
            if (Response_Check_DataArr_Type) {
                block(YES,Response_DataArr);
                
            }else if(Response_Check_DataDic_Type){
                block(YES,Response_DataDic);
                
            }else{
                block(YES,responsObject);
            }
        }else{
          
        }
        
    } fail:^(NSError * _Nonnull err) {
        Y_SVP_SHOW_err_domain
    }];
}
@end
