//
//  IssueShopBuniessOkSendInfoViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/4.
//

#import "IssueShopBuniessOkSendInfoViewModel.h"

@implementation IssueShopBuniessOkSendInfoViewModel
//商铺
+ (void)issueShopBuniessOkSendInfoWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/shop/addShop";
    [parms removeObjectForKey:@"shopId"];
    [self sendUrlStr:url withParm:parms withBlock:dicBlock];
}

+ (void)sendUrlStr:(NSString *)urlStr withParm:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:urlStr withBody:parms finished:^(id responsObject, NSError *error) {

//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                dicBlock(dic,YES);
            }else{
                dicBlock(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//-------- 更新数据
//商铺
+ (void)issueShopBuniessOkSendInfoChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/shop/updateShop";
    [self sendBunessShopInfoChangeUrlStr:url withParm:parms withBlock:dicBlock];
}

+ (void)sendBunessShopInfoChangeUrlStr:(NSString *)urlStr withParm:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                dicBlock(dic,YES);
            }else{
                dicBlock(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
@end
