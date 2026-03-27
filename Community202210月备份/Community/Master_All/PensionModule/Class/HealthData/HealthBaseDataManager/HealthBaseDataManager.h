//
//  HealthBaseDataManager.h
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#import <Foundation/Foundation.h>
#import "HealthBaseDataSaveNowUseModel.h"

static NSString * _Nullable kvoK_GetInfo_mdeviceAddress = @"mdeviceAddress";
static NSString * _Nullable kvoK_GetInfo_mdeviceName = @"mdeviceName";
static NSString * _Nullable kvoK_GetInfo_nowUserInfoChangeBool = @"nowUserInfoChangeBool";

typedef void(^SendHistorySuccessBlock)(NSInteger sendHistorySuccessCount);

NS_ASSUME_NONNULL_BEGIN

@interface HealthBaseDataManager : NSObject

singleton_interface(share);
@property (nonatomic,assign) NSInteger sendHistorySuccessSaveCount;
@property (nonatomic,copy) SendHistorySuccessBlock sendHistorySuccessBlock;

@property (nonatomic,strong)HealthBaseDataSaveNowUseModel *nowUserInfoAndHealthSaveModel;
//绑定相关数据 实时数据 获取
- (void)getUserDevHistoryListWithBlock:(BaseListArrAndSuccessBoolBlock)getDevDicHistoryListBlock;
- (void)getUserDevInfoWithGetDevDicInfoBlock:(BaseDicAndSuccessBoolBlock)getDevDicBlockBlock withOneUserId:(NSString *)userId;
- (void)getUserRecentHealthWithInfoWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block;
- (void)bindIngDevWithUserId:(NSString *)userId withDevName:(NSString *)devNameStr withDevAddress:(NSString *)devAddress withDevVersionStr:(NSString *)devVersionStr;
- (void)removebindIngDevWCanNotSendUserid:(NSString *)userId withDevAddress:(NSString *)devAddress withBlock:(BaseDicAndSuccessBoolBlock)blcok;
//获取家属列表
- (void)getFamileWithBlock:(BaseListArrAndSuccessBoolBlock)block;

//健康数据 上传类
//心率血压
- (void)updataWithUserId:(NSString *)userId withNowHeartReatInfo:(ZHJHeartRateDetail *)nowHRInfoDetailModel withNowBpInfo:(ZHJBloodPressureDetail *)nowBpInfoDetailModel ;//当前
- (void)updataWithUserId:(NSString *)userId withHeartReatInfoArr:(NSMutableArray *)heartReatInfoArr withDBPandSBPInfoArr:(NSMutableArray *)dbInfoArr;
//睡眠
- (void)updataWithUserId:(NSString *)userId withHistorySleepInfoArr:(NSMutableArray *)sleepInfoArr;
//体温
- (void)updataWithUserId:(NSString *)userId withNowTempInfo:(ZHJTemperatureDetail *)nowTempInfoDetailModel;//当前
- (void)updataWithUserId:(NSString *)userId withHistoryTempInfoArr:(NSMutableArray *)tempInfoArr;//历史列表

//获取实时 获取历史
#pragma mark ==== 睡眠
//====== 睡眠数据
//一天的睡眠数据
- (void)getUserSleepOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block;  
//一周的睡眠数据
- (void)getUserSleepOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark ==== 体温
//====== 体温数据
//一天的体温数据
- (void)getUserTempOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block;
//一周的体温数据
- (void)getUserTempOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block;
//一月的体温数据
- (void)getUserTempOneMonthDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block;

//====== 体温异常数据
//一天
- (void)getUserTempOneDayAbnormalDataWithUserId:(NSString *)userId withBlock:(BaseListArrAndSuccessBoolBlock)block;
//一周
- (void)getUserTempOneWeakAbnormalDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block;
//一月
- (void)getUserTempOneMonthAbnormalDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block;

#pragma mark ==== 心率
//====== 心率数据
//一天的心率数据
- (void)getUserHeartOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block;
//一周的心率数据
- (void)getUserHeartOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block;
//一月的心率数据
- (void)getUserHeartOneMonthDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block;

//====== 心率异常数据
//一天
- (void)getUserHeartOneDayAbnormalDataWithUserId:(NSString *)userId withBlock:(BaseListArrAndSuccessBoolBlock)block;
//一周
- (void)getUserHeartOneWeakAbnormalDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block;
//一月
- (void)getUserHeartOneMonthAbnormalDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
