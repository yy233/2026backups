//
//  IntelligentInquirySearchData.m
//  Community
//
//  Created by 余莹 on 2021/12/14.
//

#import "IntelligentInquirySearchData.h"

#define a   (0)
#define URL_GetSearchShopService         @"shop/shop/newShop/getShopService"  //AI搜索列表URL

@implementation IntelligentInquirySearchData

+ (void)getIntelligentInquiryListWithSearchText:(NSString *)getSearchText withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:@(29.3541211) forKey:@"latitude"];
    [parms setValue:@(106.4534211) forKey:@"longitude"];
    [parms setValue:getSearchText forKey:@"shopName"];
    
    NSString *allUrl = [BASE_URL_Shop_medical  stringByAppendingString:URL_GetSearchShopService];
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:allUrl withParams:parms finished:^(id responsObject, NSError *error) {
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
