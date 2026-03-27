//
//  MyRepairDataVM.m
//  Community
//
//  Created by 余莹 on 2022/4/13.
//

#import "MyRepairDataVM.h"

#define URL_Repair_Detail                     @"proprietor/repair/getRepairById"

#define URL_Repair_appraiseRepair             @"proprietor/repair/appraiseRepair" //提交评价

#define URL_Repair_saveCommentDraft           @"proprietor/repair/saveCommentDraft" //保存草稿


#define ReqData_SubListKeyStr      @"records"
//评价类型 1非常不满意 2不满意 3一般 4满意 5很满意

@implementation MyRepairDataVM

//工单详情
+ (void)myRepairOneDetailInfoWithIdInfo:(NSInteger )idNum withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSDictionary *parms = @{
        @"id":@(idNum),
    };
    
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Repair_Detail withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        
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

//取消报事报修 旧版接口 没变
+ (void)myRepairOneDetailWithCancelThisRepairWithIdInfo:(NSInteger)idNum
                                              withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSLog(@"取消上报 报事报修");
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Post_House_Repari_cancelRepair withParams:@{@"id":@(idNum)}.mutableCopy finished:^(id responsObject, NSError *error) {
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


//提交评价
+ (void)myRepairEndWithUpEvaluationInfoDic:(NSMutableDictionary *)evaluationInfoDic
                                 withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Repair_appraiseRepair withBody:evaluationInfoDic finished:^(id responsObject, NSError *error) {
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


//保存草稿
+ (void)myRepairEndWithSaveTheDraftEvaluationInfoDic:(NSMutableDictionary *)evaluationInfoDic
                                           withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Repair_saveCommentDraft withBody:evaluationInfoDic finished:^(id responsObject, NSError *error) {
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
