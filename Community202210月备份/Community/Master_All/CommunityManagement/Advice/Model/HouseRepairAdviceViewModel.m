//
//  HouseRepairAdviceViewModel.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "HouseRepairAdviceViewModel.h"

@implementation HouseRepairAdviceViewModel
+ (void)houseAdviceSendImgWithOneFileArr:(NSMutableArray *)file withblock:(DataStrBlock)dataStrBlock{
    [[ToolOfNetWork sharedTools]YrequestPostHouseRepairOneImageWithURL:URL_Post_House_Repari_adviceImg withParams:@{}.mutableCopy fileData:file finished:^(id responsObject, NSError *error) {
        MessageBlock block = dataStrBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSString *urlStr = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]];
                block(urlStr,YES);
            }else{
                block(@"",NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@"",NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

+ (void)houseAdviceSendParams:(NSMutableDictionary *)parms  withblock:(MessageBlock)messageBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Post_House_Repari_advice withParams:parms finished:^(id responsObject, NSError *error) {
        MessageBlock block = messageBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(@"操作成功",YES);
            }else{
                block(@"",NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@"",NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
         
    }];
}
@end
