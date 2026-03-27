//
//  ZhiBoNetTool.m
//  Socialize
//
//  Created by 余莹 on 2023/8/16.
//

#import "ZhiBoNetTool.h"
static NSString *const kZhiBoDetailData_sub_Url = @"/activity/getActivity";

@implementation ZhiBoNetTool


singleton_implementation(share);


- (void)getOneZhiBoDetailInfoWithActivityID:(NSString *)actId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [parms setValue:actId                                       forKey:@"activityId"];
    [parms setValue:[ShareUserInfo share].userInfo.address      forKey:@"account"];
    NSString * kZhiBoData_AllUrl = Y_AllURL_Main(kZhiBoDetailData_sub_Url);
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:kZhiBoData_AllUrl withParams:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {

        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(dataDic,YES);
                });
                
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
    
}


@end
