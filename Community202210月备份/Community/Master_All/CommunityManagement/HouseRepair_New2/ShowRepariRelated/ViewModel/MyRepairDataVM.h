//
//  MyRepairData.h
//  Community
//
//  Created by 余莹 on 2022/4/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyRepairDataVM : NSObject

//工单详情
+ (void)myRepairOneDetailInfoWithIdInfo:(NSInteger)idNum
                             withBlock:(BaseDicAndSuccessBoolBlock)block;
//取消报事报修
+ (void)myRepairOneDetailWithCancelThisRepairWithIdInfo:(NSInteger)idNum
                                              withBlock:(BaseDicAndSuccessBoolBlock)block;

//提交评价
+ (void)myRepairEndWithUpEvaluationInfoDic:(NSMutableDictionary *)evaluationInfoDic
                                 withBlock:(BaseDicAndSuccessBoolBlock)block;
 
//保存草稿
+ (void)myRepairEndWithSaveTheDraftEvaluationInfoDic:(NSMutableDictionary *)evaluationInfoDic
                                 withBlock:(BaseDicAndSuccessBoolBlock)block;
 @end

NS_ASSUME_NONNULL_END
