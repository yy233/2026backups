//
//  ShippingAddressData.m
//  Community
//
//  Created by 余莹 on 2021/4/9.
//

#import "ShippingAddressData.h"
#import "ConnectUrl.h"
@implementation ShippingAddressData
/**
 购物 用户地址列表
 */
+ (void)getUserAddressListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueueWtihBuniessShopTypeUrl:URL_BuniessService_GetUserAddressList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
 详情
 */
+ (void)getUserAddressDetailWithUUID:(NSString *)uuid withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BuniessService_GetUserAddressDetailWithUUID,uuid];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueueWtihBuniessShopTypeUrl:url withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
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
/**
 删除
 */
+ (void)deletUserAddressWithUUID:(NSString *)uuid withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BuniessService_DeletUserAddressWithUUID,uuid];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWtihBuniessShopTypeUrl:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
 
         BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(@{},YES);
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
/**
 新增
 */
+ (void)addUserAddressWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:URL_BuniessService_PostUserAddAddress withParams:parms finished:^(id responsObject, NSError *error) {

        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
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
/**
 修改
 */
+ (void)editUserAddressWithParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:URL_BuniessService_PostUserEditAddress withParams:parms finished:^(id responsObject, NSError *error) {
         
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
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

@implementation ShippingAddressModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else{
            
            return @"";
            
        }
        
    }
    
    return oldValue;
    
}

//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *car_id;
//在Model 类中的.m 文件中替换 Key
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//
//    return @{@"car_id":@"id"};
//
//}
@end
