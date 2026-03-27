//
//  LifeCostGroupViewModel.m
//  Community
//
//  Created by 余莹 on 2021/3/23.
//

#import "LifeCostGroupViewModel.h"

@implementation LifeCostGroupViewModel
/**
 户号管理
 */
+ (void)getHuHaoManageWithGroupList:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Life_selectGroupAll withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [[Y_ResponsObject_dataDic allKeys] containsObject: @"map"]? [NSDictionary dictionaryWithDictionary:[Y_ResponsObject_dataDic objectForKey:@"map"]] :@{};
                block(reDic,YES);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 /**
  查询全部户号  在缴费记录top筛选处使用了
  */
+ (void)getHuHaoGetAllList:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Life_selectFamilyId withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
           //////////////////
                dispatch_async( dispatch_get_main_queue(), ^{
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

/**
 新增自定义分组
 */
+ (void)addGroupWithParms:(NSMutableDictionary *)parms withblock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLStrWithAllURLNoParmsNotMainQueue:URL_Life_addGroupName withParams:parms finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_addGroupName withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
         
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataDic,YES);
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
