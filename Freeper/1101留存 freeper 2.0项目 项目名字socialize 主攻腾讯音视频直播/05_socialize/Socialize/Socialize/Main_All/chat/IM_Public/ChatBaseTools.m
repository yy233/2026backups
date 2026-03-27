//
//  ChatBaseTools.m
//  Socialize
//
//  Created by 余莹 on 2023/7/8.
//

#import "ChatBaseTools.h"

#define  chatAddSystemGroup_Url  @"/chatGroup/auth/joinOfficialGroup"

#define  chatMemberOfGroup_Url  @"/chatGroup/officialAccount"

@implementation ChatBaseTools

+ (void)chatAddSystemGroupWithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *allUrl = Y_AllURL_Main(chatAddSystemGroup_Url);
    
    [[Y_NetWorkBaseTool sharedTool]YrequestPUTALLURLNoMainQueue:allUrl
                                                     withParams:@{}.mutableCopy
                                                       finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                if ([[responsObject objectForKey:@"data"]  isKindOfClass:[NSString class]]) {
                    block(@{@"channelId":responsObject},YES);
                }else{
                    NSDictionary *dataDic = Y_ResponsObject_dataDic;
                    block(dataDic,YES);
                }
                

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
//    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl
//                                                       withParams:@{}.mutableCopy
//                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull  error) {
//        if (isNotNil(responsObject)) {
//            if (Y_status_IS_Success) {
//                NSDictionary *dataDic = Y_ResponsObject_dataDic;
//                block(dataDic,YES);
//
//            }else{
//                block(@{},NO);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    Y_SVP_SHOW_ERR_MESSAGE
//                });
//            }
//        }else{
//            block(@{},NO);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                Y_SVP_SHOW_ERR_DESCRIPTION
//            });
//        }
//
//    }];
    
}
+ (void)chatGetGroupSystemManagerWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *allUrl = Y_AllURL_Main(chatAddSystemGroup_Url);
    
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl
                                                       withParams:@{}.mutableCopy
                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull  error) {
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSMutableArray *arrr = Y_ResponsObject_dataArr;
                block(arrr ,YES);

            }else{
                block(@[],NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@[],NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
            
    }];
    
}



//全部管理员的获取
+ (void)getGroupAdmainManagerWithBlock:(BaseListArrAndSuccessBoolBlock)block{

    NSString *allUrl = Y_AllURL_Main(chatMemberOfGroup_Url);
    
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl
                                                       withParams:@{}.mutableCopy
                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull  error) {
        if (isNotNil(responsObject)) {
            if (Y_status_IS_Success) {
                NSMutableArray *arrr = Y_ResponsObject_dataArr;
                block(arrr ,YES);

            }else{
                block(@[],NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@[],NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
            
    }];
    
}

@end
