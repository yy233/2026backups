//
//  issBuniessShopTagsViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/20.
//

#import "IssBuniessShopTagsViewModel.h"

@implementation IssBuniessShopTagsViewModel

+ (void)getIssueBuniessShopTagsWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_BuniessShop_Tags withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
