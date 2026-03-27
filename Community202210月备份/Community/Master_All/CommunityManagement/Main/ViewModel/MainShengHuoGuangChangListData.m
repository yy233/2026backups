//
//  MainShengHuoGuangChangListData.m
//  Community
//
//  Created by 余莹 on 2021/8/24.
//

#import "MainShengHuoGuangChangListData.h"

@implementation MainShengHuoGuangChangListData
/**
二手已经发布商品  集市列表
 */
+ (void)initErShouListWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"page"];
    [self erShouReqWithParms:parms withBlock:block];
    
}
+ (void)updataErShouListWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(pageNum) forKey:@"page"];
    [self erShouReqWithParms:parms withBlock:block];
}
+ (void)erShouReqWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block{
    [parms setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    NSString *url = @"proprietor/market/selectMarketAllPage";
  
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;//list
                NSArray *arr =   [[dic allKeys] containsObject:@"list"] ? [NSArray arrayWithArray:[dic objectForKey:@"list"]] :[NSMutableArray array];
                block(arr,YES);
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
 
 */

@end
