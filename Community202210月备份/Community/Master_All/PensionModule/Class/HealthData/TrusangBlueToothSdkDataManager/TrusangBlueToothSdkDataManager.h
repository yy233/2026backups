//
//  TrusangBlueToothSdkDataManager.h
//  Community
//
//  Created by 余莹 on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "TrusangBlueToothUseShowModel.h"
//#import <TrusangBluetooth/TrusangBluetooth.h>
//#import <TrusangBluetooth/TrusangBluetooth-Swift.h>
//#import "TrusangBluetooth.framework/Headers/TrusangBluetooth.h"
//#import "TrusangBluetooth.framework/Headers/TrusangBluetooth-Swift.h"
//#import "TrusangBluetooth.framework/Headers/ZHJBLETools.h"
//key
static NSString * _Nullable kvoKsaveNowDevName = @"saveNowDevName";
static NSString * _Nullable kvoKsaveNowDevMac = @"saveNowDevMac";


static NSString * _Nullable kvoKpowerIntVale = @"powerIntVale";
static NSString * _Nullable kvoKtemperature = @"temperature";
static NSString * _Nullable kvoKbp_bp = @"bp_bp";
static NSString * _Nullable kvoKbp_sp = @"bp_sp";
static NSString * _Nullable kvoKbo = @"bo";
static NSString * _Nullable kvoKheartReat = @"heartRete";
static NSString * _Nullable kvoKsleep = @"sleep";
//

static NSString * _Nullable kvoK_History_temperature = @"histroy_TempArr";       // @"History_temperature";//histroy_TempArr
static NSString * _Nullable kvoK_History_bpsp = @"histroy_BpSpArr";               //@"History_bpsp";
static NSString * _Nullable kvoK_History_heartReat = @"histroy_HeartRateArr";    // @"History_heartReat";
static NSString * _Nullable kvoK_History_bo = @"histroy_BoArr";                  // @"History_bo";
static NSString * _Nullable kvoK_History_sleep = @"histroy_SleepArr";            //@"History_sleep";
 
 
/**
 
 //历史记录
 @property (nonatomic,strong) NSMutableArray <ZHJTemperature *>   *histroy_TempArr;
 @property (nonatomic,strong) NSMutableArray <ZHJSleep *>         *histroy_SleepArr;
 @property (nonatomic,strong) NSMutableArray <ZHJHeartRate *>     *histroy_HeartRateArr;
 @property (nonatomic,strong) NSMutableArray <ZHJBloodPressure *> *histroy_BpSpArr;
 @property (nonatomic,strong) NSMutableArray <ZHJBloodOxygen *>   *histroy_BoArr;
  
 //健康数据警告区间相关
 @property (nonatomic,assign) double temperatureAlarmLimit_Max;
 @property (nonatomic,assign) double temperatureAlarmLimit_Min;
 @property (nonatomic,assign) double heartReteAlarmLimit_Min;
 @property (nonatomic,assign) double heartReteAlarmLimit_Max;
 */



typedef enum : NSUInteger {
    ConnectDev_State_Success,
    ConnectDev_State_Fail,
    ConnectDev_State_OutTime,
} ConnectDev_State;
//
typedef void(^MyPhoneDevIsOpenBlueToothBlock)(BOOL);
typedef void(^ArrAndSuccesBoolBlock)(NSArray <ZHJBTDevice *>* _Nullable,BOOL);
typedef void(^ConnectStateBlock)(ConnectDev_State);
typedef void(^ContConectDevWithDevNotHaveMacBlock)(void);//主动连接某设备 某设备mac空 预计mac被他人连上或本机系统连上了的回调 做跳转引导。
//各类型历史信息 完全获取后 通知上传 主页展示需要
typedef void(^DevHistoryGetEnd_HeartInfoTypeBlock)(BOOL isGetDevHistroyEnd);
typedef void(^DevHistoryGetEnd_SleepInfoTypeBlock)(BOOL isGetDevHistroyEnd);
typedef void(^DevHistoryGetEnd_tempInfoTypeBlock) (BOOL isGetDevHistroyEnd);

//
NS_ASSUME_NONNULL_BEGIN

@interface TrusangBlueToothSdkDataManager : NSObject
{
    ZHJBTDevice * saveNowDev;
};
@property (nonatomic,strong) NSMutableArray *scanDevsSaveArr;//保留的扫描出来的设备数据arr
@property (nonatomic,strong) ZHJBTDevice *nowBlueToothDevSave;
@property (nonatomic,assign) DeviceState nowDevState;
@property (nonatomic,strong) TrusangBlueToothUseShowModel *showModel;
@property (nonatomic,strong) ContConectDevWithDevNotHaveMacBlock  conectOneDevNotHaveMacBlock;

@property (nonatomic,copy) DevHistoryGetEnd_HeartInfoTypeBlock devHistoryGetEnd_HeartInfoTypeBlock;
@property (nonatomic,copy) DevHistoryGetEnd_SleepInfoTypeBlock devHistoryGetEnd_SleepInfoTypeBlock;
@property (nonatomic,copy) DevHistoryGetEnd_tempInfoTypeBlock  devHistoryGetEnd_tempInfoTypeBlock;
 

singleton_interface(share);


//基础搜索和连接
- (void)getMyPhoneDevceStateWithOpenBoolWithBlock:(MyPhoneDevIsOpenBlueToothBlock)block;
- (void)backgroundKeepsBlueDevScanning;
- (void)backgroundKeepsBlueDevScanningWhenNowDevStateNotCare;
- (void)searchDeviceInfoWithBlock:(ArrAndSuccesBoolBlock)block;
- (void)stopScanDev;
- (void)connectDevice:(ZHJBTDevice *)trusangBluedev withConnetStatuBlock:(ConnectStateBlock)stateBlock;
- (void)disConnectDev;
//mac空时 返回蓝牙存储设备列表中 能够匹配的mac
- (NSString *)getDevMacStrOfNowSaveBlueScanArrWithOneDevUseNameStr:(ZHJBTDevice *)trusangBluedev;
#pragma mark == 重连
- (void)reConNowDev;

//当前已经连接的设备 设备信息 获取 (没连接 或没查到 做No nil)
- (void)getDevWhenIsOneLineWithThisDevInfoWithDev:( void (^) (BOOL success,ZHJBTDevice *nowContentedDevSelfInfo) )nowDevSelfInfoBlock;//

//信息获取（基础信息+延时后也要拿到历史信息）
- (void)getOneBlueDevHealthInfoWithNowConnectedOkDevice;

//历史信息等主动获取
- (void)getHistoryInfoWithDevice;

//寻找设备 发送查找指令到设备，设备会震动
//- (void)findDevice:(ZHJBTDevice *)oneDev;
- (void)findDeviceAction;
//发送震动指令
- (void)sendVibrateAction;
@end

NS_ASSUME_NONNULL_END
