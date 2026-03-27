//
//  IssHouseOfHouseConstViewModel.m
//  Community
//
//  Created by 余莹 on 2021/2/27.
// 第二页 非蓝色圆的 常量查询

#import "IssHouseOfHouseConstViewModel.h"

@implementation IssHouseOfHouseConstViewModel
/**
 body==10
 "houseLeasetypeId———房屋出租类型id        1不限(默认) 2普通住宅 4别墅 8公寓
 */
+ (void)getIssueHouseLeaseTypeWithList:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSMutableArray *body = [NSMutableArray arrayWithObject:@(10)];
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listBlock;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr10 = [[reDic allKeys] containsObject:@"10"] ? [NSArray arrayWithArray:reDic[@"10"]] : [[NSArray alloc]init];
                block(arr10,YES);
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
