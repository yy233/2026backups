//
//  IssueHouseAppointmentManagerVcViewModel.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//  预约 多type列表 数据接口

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseAppointmentManagerVcViewModel : NSObject
//租户身份
+ (void)getIsZuHuTypeAppointmentListWithParms:(NSMutableDictionary *)parms withListBlocl:(BaseListArrAndSuccessBoolBlock)listBlock;
//房东身份
+ (void)getIsFangDongTypeAppointmentListWithParms:(NSMutableDictionary *)parms withListBlocl:(BaseListArrAndSuccessBoolBlock)listBlock;

//______
// myIdentityType; //身份类型 租客｜房东
//zuke：取消 完成
+ (void)cancelHouseAppintmentZuKeTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)finishOkHouseAppintmentZuKeTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//房东:接受 取消
+ (void)acceptHouseAppintmentFangDongTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)cancelHouseAppintmentFangDongTypeWithThisAppintmentId:(NSInteger)appintmentId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;




@end

NS_ASSUME_NONNULL_END
