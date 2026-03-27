//
//  PopViewBuniessShopAndHouseChoosePayWayViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import "PopViewBuniessShopAndHouseChoosePayWayViewModel.h"

@implementation PopViewBuniessShopAndHouseChoosePayWayViewModel
 + (void)getPayWayViewArr:(BaseListArrAndSuccessBoolBlock)listBlock{
//@"lease/const"//房屋常量查询
     NSArray *body = [NSArray arrayWithObject:@(1)];
     [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
         BaseListArrAndSuccessBoolBlock block  = listBlock;
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                 NSArray *arr = [[reDic allKeys] containsObject:@"1"] ? [NSArray arrayWithArray:reDic[@"1"]] : [[NSArray alloc]init];
                 if (arr.count>0) {
                     block(arr,YES);
                 }else{
                     block(@[],NO);
                     Y_SVP_SHOW_ERR_MES(@"没有押付方式!");
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
