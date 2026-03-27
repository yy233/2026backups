//
//  IssBuniessShopPublishTypeViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import "IssBuniessShopPublishTypeViewModel.h"

@implementation IssBuniessShopPublishTypeViewModel

+ (void)getIssueBuniessShopType:(BuniessShopOrHousePublish_Type)type withArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_BuniessShop_Type withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = Y_ResponsObject_dataDic;
                //business type
                if (type == BuniessShopOrHousePublish_Type_type) {
                    if ([[reDic allKeys]containsObject:@"type"]) {
                        block([[NSArray alloc]initWithArray:reDic[@"type"]],YES);
                    }else{
                        Y_SVP_SHOW_ERR_MES(@"没有类型数据！");
                        block(@[],NO);
                    }
                }
                if (type == BuniessShopOrHousePublish_Type_business) {
                    if ([[reDic allKeys]containsObject:@"business"]) {
                        block([[NSArray alloc]initWithArray:reDic[@"business"]],YES);
                    }else{
                        Y_SVP_SHOW_ERR_MES(@"没有行业数据！");
                        block(@[],NO);
                    }
                }
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
@end
