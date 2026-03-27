//
//  ActivityOtherData.m
//  Community
//
//  Created by 余莹 on 2022/6/15.
//

#import "ActivityOtherData.h"

static NSString *kurl_Activity_Detail = @"proprietor/activity/selectOne";
static NSString *kurl_Activity_Cancel = @"proprietor/activity/cancel";
static NSString *kurl_Activity_InputInfo = @"proprietor/activity/apply";
 
 
@implementation ActivityOtherData

//活动详情
+ (void)getDetailOfIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_BASEURL(kurl_Activity_Detail)  withParams:@{@"id":idStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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

//活动报名
+ (void)activityInputInfo:(NSMutableDictionary *)inputDic withBlock:(BaseDicAndSuccessBoolBlock)block{
  
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:Y_BASEURL(kurl_Activity_InputInfo) withBody:inputDic finished:^(id responsObject, NSError *error) {
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


//取消报名
+ (void)cancelActivityOfIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestDeleteALLURL:Y_BASEURL(kurl_Activity_Cancel) withParams:@{@"id":idStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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
