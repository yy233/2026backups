//
//  IssueHistroyListVcViewModel.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHistroyListVcViewModel.h"

@implementation IssueHistroyListVcViewModel
+ (void)issueHistroyListWithHouseWithParm:(NSMutableDictionary *)parm withListBloclk:(BaseListArrAndSuccessBoolBlock)listBlock{
    [parm setValue:@"0" forKey:@"type"];//房屋
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Rent_Look_History_list withParams:parm finished:^(id responsObject, NSError *error) {
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
+ (void)issueHistroyListWithBuniessShopWithParm:(NSMutableDictionary *)parm withListBloclk:(BaseListArrAndSuccessBoolBlock)listBlock{
    [parm setValue:@"1" forKey:@"type"];//商铺
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Rent_Look_History_list withParams:parm finished:^(id responsObject, NSError *error) {
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
@end
