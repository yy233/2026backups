//
//  LifeCosHistorytlListViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/14.
//

#import "LifeCosHistorytlListViewModel.h"

@implementation LifeCosHistorytlListViewModel
+ (void)getHistoryListWithParms:(NSMutableDictionary *)parms withlistBlock:(BaseDicAndSuccessBoolBlock)listBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Life_DetaiHistorytlList withParams:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = listBlock;
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
