//
//  IssueHouseOkSendInfoViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/2.
//

#import "IssueHouseOkSendInfoViewModel.h"

@implementation IssueHouseOkSendInfoViewModel
//整租
+ (void)issueHouseSendZhengZuWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/wholeLease";
    [parms removeObjectForKey:@"id"];
    [self sendUrlStr:url withParm:parms withBlock:dicBlock];
}

//单间
+ (void)issueHouseSendDanJianWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/singleRoom";
    [parms removeObjectForKey:@"id"];
    [self sendUrlStr:url withParm:parms withBlock:dicBlock];
}
//合租
+ (void)issueHouseSendHeZuWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/combineLease";
    [parms removeObjectForKey:@"id"];
    [self sendUrlStr:url withParm:parms withBlock:dicBlock];
}

+ (void)sendUrlStr:(NSString *)urlStr withParm:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
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

//———————————— 修改 put
//整租
+ (void)issueHouseSendZhengZuChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/wholeLease";
    [self sendChangeUrlStr:url withParm:parms withBlock:dicBlock];
}

//单间
+ (void)issueHouseSendDanJianChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/singleRoom";
    [self sendChangeUrlStr:url withParm:parms withBlock:dicBlock];
}
//合租
+ (void)issueHouseSendHeZuWithChangeParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/combineLease";
    [self sendChangeUrlStr:url withParm:parms withBlock:dicBlock];
}

+ (void)sendChangeUrlStr:(NSString *)urlStr withParm:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
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
