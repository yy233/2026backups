//
//  IssueHouseAppointmentManagerVcViewModel.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import "IssueHouseAppointmentManagerVcViewModel.h"
/**
 reserveStatus:预约状态: 
 requestType:请求类型,1我预约的(租客),2预约我的(房东)
 */
@implementation IssueHouseAppointmentManagerVcViewModel
#pragma mark == list data
//租户身份
+ (void)getIsZuHuTypeAppointmentListWithParms:(NSMutableDictionary *)parms withListBlocl:(BaseListArrAndSuccessBoolBlock)listBlock{
    [parms setValue:@(1) forKey:@"requestType"];
    [self getHouseAppointmentManagerListWithParms:parms withListBlocl:listBlock];
}
//房东身份
+ (void)getIsFangDongTypeAppointmentListWithParms:(NSMutableDictionary *)parms withListBlocl:(BaseListArrAndSuccessBoolBlock)listBlock{
    [parms setValue:@(2) forKey:@"requestType"];
    [self getHouseAppointmentManagerListWithParms:parms withListBlocl:listBlock];
}

+ (void)getHouseAppointmentManagerListWithParms:(NSMutableDictionary *)parms withListBlocl:(BaseListArrAndSuccessBoolBlock)listBlock{
    
    NSMutableDictionary *allParms = [[NSMutableDictionary alloc]init];
    [allParms setValue:@(1) forKey:@"page"];
    [allParms setValue:@(9999) forKey:@"size"];
    //____暂不做刷新数据
    [allParms setValue:parms forKey:@"query"];
    //
    NSString *url = @"lease/house/reserve/whole";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:allParms finished:^(id responsObject, NSError *error) {
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
#pragma mark == action
//租客：___完成
+ (void)finishOkHouseAppintmentZuKeTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/reserve/completeChecking";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"id":@(appintmentId)}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
//租客：___取消
+ (void)cancelHouseAppintmentZuKeTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"requestType"];
    [parms setValue:@(appintmentId) forKey:@"id"];
    [self cancelHouseAppintmentWtihParms:parms withDicBlock:dicBlock];
}


//房东:___接受 取消
+ (void)acceptHouseAppintmentFangDongTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/reserve/confirm";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"id":@(appintmentId)}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
//房东:___取消
+ (void)cancelHouseAppintmentFangDongTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(2) forKey:@"requestType"];
    [parms setValue:@(appintmentId) forKey:@"id"];
    [self cancelHouseAppintmentWtihParms:parms withDicBlock:dicBlock];
}

//
+ (void)cancelHouseAppintmentWtihParms:(NSMutableDictionary *)parms withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"lease/house/reserve/cancel";
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWithBodyNotParms:url withBody:parms finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
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
