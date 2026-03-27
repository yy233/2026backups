//
//  HealthBaseDataManager.m
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#import "HealthBaseDataManager.h"
#import "BaseHealthHeader.h"


// 家人档案列表
#define URL_GetFamilyList                      @"zhsj/yiliao/myself/family/list"

#define URL_GetUserBingInfoList                @"userDeviceInfo/currentLoginUserDeviceInfoList"
#define URL_GetUserBingInfo                    @"userDeviceInfo/deviceInfo"      //获取用户绑定设备信息
#define URL_GetUserHealthInfo                  @"healthData/realTimeHealthData"  //用户实时健康数据（心率体温睡眠.
#define URL_BindDevice                         @"userDeviceInfo/userBindDevice"   //绑定设备
#define URL_UnbindDevice                       @"userDeviceInfo/userUnbindDevice" //解绑

#define URL_UpInfoHeartRate                    @"heartRate/monitorHeartRate" //监测用户实时心率以及历史心率并保存（历史心率需筛选）
#define URL_UpInfoTemperature                  @"temperature/monitorTemperature" //检测用户体温并保存
#define URL_UpInfoSleep                        @"sleep/monitorSleep" //监控用户睡眠并保存

//睡眠
#define URL_GetSleepOneDay                     @"healthData/sleepChart" //查询最近一天的睡眠数据
#define URL_GetSleepOneWeak                    @"healthData/sleepChart" //查询最近一周的睡眠数据
//按日、周、月查询用户体温列表
#define URL_GetTemp                           @"healthData/tempChart"
//按日、周、月查询用户体温异常列表
#define URL_GetTempAbnormal                   @"healthData/abnormalTempRecord"
//心率
#define URL_GetHeart                          @"healthData/heartRateChart"
#define URL_GetHeartAbnormal                  @"healthData/abnormalHeartRateRecord"


@interface HealthBaseDataManager ()
@property (nonatomic,assign) NSInteger bangDingDelayTimeCount;
@end

@implementation HealthBaseDataManager
singleton_implementation(share);

#pragma mark ===
- (HealthBaseDataSaveNowUseModel *)nowUserInfoAndHealthSaveModel{
    if (!_nowUserInfoAndHealthSaveModel) {
        _nowUserInfoAndHealthSaveModel = [[HealthBaseDataSaveNowUseModel alloc]init];
        _nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _nowUserInfoAndHealthSaveModel.nowUserHealthInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
        _nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
        _nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
        _nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @"";
    }
    return _nowUserInfoAndHealthSaveModel;
}

#pragma mark ===  获取家属列表 （本接口的baseurl 在ZYPensionUrlHeader_h内 暂时不同于蓝牙数据存储相关接口base）
- (void)getFamileWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {

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
#pragma mark ===

- (void)getUserDevHistoryListWithBlock:(BaseListArrAndSuccessBoolBlock)getDevDicHistoryListBlock{
    NSLog(@"1当前手环设备的连接状态 isConnected= %d nowDevState=%ld ",[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected,[TrusangBlueToothSdkDataManager share].nowDevState);
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetUserBingInfoList);
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
       
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                getDevDicHistoryListBlock(Y_ResponsObject_dataArr,YES);
            }else{
                getDevDicHistoryListBlock(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            getDevDicHistoryListBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ===
- (void)getUserDevInfoWithGetDevDicInfoBlock:(BaseDicAndSuccessBoolBlock)getDevDicBlockBlock withOneUserId:(NSString *)userId{
  
    /** 都可以拿到数据
     [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:url withBody:@{@"familyMemberId":userId}.mutableCopy finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 NSDictionary *dic = Y_ResponsObject_dataDic;
                 NSLog(@"获取用户绑定设备信息 body=%@",dic);
             }else{
                 Y_SVP_SHOW_ERR_MESSAGE
             }
         }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
     }];
     */
    WEAKSELF
    self.nowUserInfoAndHealthSaveModel.nowUserId = userId;
    NSLog(@" nowUserInfoAndHealthSaveModel =%@ %@ ", weakSelf.nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress,weakSelf.nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName);
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetUserBingInfo);
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:@{@"familyMemberId":userId}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSLog(@"获取用户绑定设备信息 parms=%@",dic);
                if (isNotNil(getDevDicBlockBlock)) {
                    getDevDicBlockBlock(dic,YES);
                }
            }else{
                if (isNotNil(getDevDicBlockBlock)) {
                    getDevDicBlockBlock(@{}, NO);
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            if (isNotNil(getDevDicBlockBlock)) {
                getDevDicBlockBlock(@{}, NO);
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//初始状态 和 上传历史完成状态 都要调用健康数据 用于主界面数据信息
- (void)getUserRecentHealthWithInfoWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSLog(@"查询他人健康数据");
        WEAKSELF
        NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetUserHealthInfo);
        [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:@{@"familyMemberId":userId}.mutableCopy finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *dic = Y_ResponsObject_dataDic;
                    NSLog(@"获取用户健康数据 parms=%@",dic);
//                   DevGetRecentHealthModel
                    weakSelf.nowUserInfoAndHealthSaveModel.nowUserHealthInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    weakSelf.nowUserInfoAndHealthSaveModel.nowRecentHealthModel = [DevGetRecentHealthModel mj_objectWithKeyValues:dic];
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
- (void)bindIngDevWithUserId:(NSString *)userId withDevName:(NSString *)devNameStr withDevAddress:(NSString *)devAddress withDevVersionStr:(NSString *)devVersionStr{
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    //1129不穿入ID，只能自己绑定自己的设备 后台默认token用户
    //[parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:devNameStr forKey:@"deviceName"];
    [parms setValue:devAddress forKey:@"deviceAddress"];
    if (devVersionStr.length==0 || [devVersionStr isEqualToString:@"0"]) {
        devVersionStr = @"1.0";
    }
    if (userId.length<=0 || devNameStr.length<=0 || devAddress.length<=0) {//数据不完整
        return;
    }
    [parms setValue:devVersionStr forKey:@"deviceVersion"];
    
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_BindDevice);
    if (self.bangDingDelayTimeCount>0) {
        NSLog(@"绑定结果回复之前的时间内 不做绑定请求");//设备状态更新kvo 多次调用问题
        return;
    }
    self.bangDingDelayTimeCount = 5;
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        self.bangDingDelayTimeCount = 0;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSLog(@"新增绑定设备 parms=%@",dic);
                DevGetNowUsersDevInfoModel *bingOkDev = [[DevGetNowUsersDevInfoModel alloc]init];
                bingOkDev.mdeviceName = devNameStr;
                bingOkDev.mdeviceAddress = devAddress;
                bingOkDev.mdeviceVersion = devVersionStr;
                self.nowUserInfoAndHealthSaveModel.nowUserId = userId;
                self.nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = bingOkDev;
                self.nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                //[self getUserDevInfoWithGetDevDicInfoBlock:nil withOneUserId:userId];//这里不需要block信息的回调 本处为连接成功后更新当前user ID的绑定设备数据 本行数据拿到的数据不是新绑定的数据
            }else if ([[responsObject objectForKey:@"code"] intValue]==30003){
                self.nowUserInfoAndHealthSaveModel.nowUserId = userId;
                DevGetNowUsersDevInfoModel *bingOkDev = [[DevGetNowUsersDevInfoModel alloc]init];
                bingOkDev.mdeviceName = devNameStr;
                bingOkDev.mdeviceAddress = devAddress;
                bingOkDev.mdeviceVersion = devVersionStr;
                self.nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = bingOkDev;
                self.nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [bingOkDev mj_keyValues];
                //[self getUserDevInfoWithGetDevDicInfoBlock:nil withOneUserId:userId];//这里不需要block信息的回调 本处为连接成功后更新当前user ID的绑定设备数据 本行数据拿到的数据不是新绑定的数据

                /** 
                 code = 30003;
                 data = "<null>";
                 message = "已绑定该设备";*/
                //Y_SVP_SHOW_SUCCESS_MES(@"已绑定该设备。");
                //[self getUserDevInfoWithGetDevDicInfoBlock:nil withOneUserId:userId];//这里不需要block信息的回调 本处为连接成功后更新当前user ID的绑定设备数据 这里不做id切换 打印看看获取用户绑定设备信息
                
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
 
}
- (void)removebindIngDevWCanNotSendUserid:(NSString *)userId withDevAddress:(NSString *)devAddress withBlock:(BaseDicAndSuccessBoolBlock)blcok{
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    //1129不穿入ID，只能自己解绑自己的设备 后台默认token用户
    //[parms setValue:userId forKey:@"familyMemberId"];
     [parms setValue:devAddress forKey:@"deviceAddress"];
 
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_UnbindDevice);//解绑
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSLog(@"解绑绑定设备 parms=%@",dic);
                blcok(@{},YES);
            }else{
                //Y_SVP_SHOW_ERR_MESSAGE
                blcok(@{},NO);
            }
        }else{
            blcok(@{},NO);
            //Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==================================== 上传数据 （1129 上传数据里面不传familyMemberId）
#pragma mark === 心率血压 总上传
//当前 ｜心率 压强
- (void)updataWithUserId:(NSString *)userId withNowHeartReatInfo:(ZHJHeartRateDetail *)nowHRInfoDetailModel withNowBpInfo:(ZHJBloodPressureDetail *)nowBpInfoDetailModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableArray *devInfoUpArr = [[NSMutableArray alloc]init];
        ZHJHeartRateDetail *detailHrObj =  nowHRInfoDetailModel;//某时刻的hr
        DevUpDataHeartRateModel *objModel = [self dealHrAndBpInfoDicWithUserId:userId withNowHeartReatInfo:detailHrObj withNowBpInfo:nil];
        if (isNotNil(objModel)) {
            [devInfoUpArr addObject: [[NSMutableDictionary alloc]initWithDictionary:[objModel mj_keyValues]]];
        }
        
        //上传实时数据
        if (devInfoUpArr.count>0) {
            [self upHrAndBpInfoWithAllUpArr:devInfoUpArr];
        }
    });

}
 
- (void)updataWithUserId:(NSString *)userId withHeartReatInfoArr:(NSMutableArray *)heartReatInfoArr withDBPandSBPInfoArr:(NSMutableArray *)dbInfoArr{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableArray *devInfoUpArr = [[NSMutableArray alloc]init];
        NSInteger minCount = heartReatInfoArr.count;
        for (int i = 0; i < minCount; i++) {
            ZHJHeartRate *hrObj = heartReatInfoArr[i];//某天的hr
            NSInteger  detailsMinCount = hrObj.details.count;
             for (int j = 0; j < detailsMinCount; j++) {
                 ZHJHeartRateDetail *detailHrObj = hrObj.details[j];
                 DevUpDataHeartRateModel *objModel = [self dealHrAndBpInfoDicWithUserId:userId withNowHeartReatInfo:detailHrObj withNowBpInfo:nil];
                 if (isNotNil(objModel)) {
                     [devInfoUpArr addObject: [[NSMutableDictionary alloc]initWithDictionary:[objModel mj_keyValues]]];
                 }
             }
     
        }
        if (devInfoUpArr.count>0) {
            NSLog(@"上传历史心率血压列表");
            [self upHrAndBpInfoWithAllUpArr:devInfoUpArr];
        }else{
            NSLog(@"上传历史心率血压列表 空数据 不上传");
        }
    });
   
}
- (DevUpDataHeartRateModel *)dealHrAndBpInfoDicWithUserId:(NSString *)userId withNowHeartReatInfo:(ZHJHeartRateDetail *)hrDetailModel withNowBpInfo:(ZHJBloodPressureDetail *)bpDetailModel{
     DevUpDataHeartRateModel *hrAndBpModel  = [[DevUpDataHeartRateModel alloc]init];

    NSInteger hrNum = isNotNil(hrDetailModel)  ? hrDetailModel.HR : 0;
    NSInteger dbpNum = isNotNil(bpDetailModel)  ?  bpDetailModel.DBP : 0;
    NSInteger sbpNum = isNotNil(bpDetailModel)  ? bpDetailModel.SBP : 0;
//    if (hrNum>0 || dbpNum>0 || sbpNum >0) {
    if (hrNum>0) {//暂时只做心跳数据
        //time
        NSString *dateStr = hrDetailModel.dateTime;
       
        if (isNil(dateStr) || dateStr.length == 0) {
            hrAndBpModel.createTime = [ToolOfTimeChangeFormat  currentTimeStr];
           // NSLog(@"心率数据 silentHeart = %ld  ｜ dateStr = %@  空空空。使用当前时间戳 %@",hrNum,dateStr,hrAndBpModel.createTime);
        }else{
            hrAndBpModel.createTime =  [ToolOfTimeChangeFormat getTimeStrWithShortYearMonthDayHouseMinString:dateStr];
           // NSLog(@"心率数据 silentHeart = %ld  ｜ dateStr = %@ 非空   使用转换后的时间戳  %@",hrNum,dateStr,hrAndBpModel.createTime);
        }
     
       // hrAndBpModel.familyMemberId = userId;//1129不传familyMemberId
        hrAndBpModel.silentHeart = hrNum;
        hrAndBpModel.diastolicPressure = dbpNum;
        hrAndBpModel.systolicPressure = sbpNum;
        
  
       
        return  hrAndBpModel;
    }else{
       // NSLog(@"心率数据 silentHeart = %ld 空 省略 ",hrNum);
        return nil;
    }
    
}
//上传
- (void)upHrAndBpInfoWithAllUpArr:(NSMutableArray *)devInfoUpArr{
   // NSLog(@"心率上传 devInfoUpArr=%@",devInfoUpArr);
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_UpInfoHeartRate);
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:url withBody:devInfoUpArr finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSLog(@"心率上传 成功=%@",responsObject);
                NSDictionary *dic = Y_ResponsObject_dataDic;
                self.sendHistorySuccessSaveCount += 1;
                if (isNotNil(self.sendHistorySuccessBlock)) {
                    self.sendHistorySuccessBlock(self.sendHistorySuccessSaveCount);
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark == 睡眠 上传
- (void)updataWithUserId:(NSString *)userId withHistorySleepInfoArr:(NSMutableArray *)sleepInfoArr{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableArray *devInfoUpArr = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < [TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr.count; i++) {
            ZHJSleep *sleepObj = [TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr[i];
           //NSLog(@"查看 [历史记录] ———————————— [睡眠类] 本天日期开始时间=%@ ｜ 本天 记录睡眠条数=%ld ｜ 入睡睡眠时长=%ld 浅睡时长=%ld 深睡时长=%ld 清醒时长=%ld 快速眼动时长=%ld",sleepObj.details.firstObject.dateTime,sleepObj.details.count, (long)sleepObj.beginDuration,(long)sleepObj.lightDuration,(long)sleepObj.deepDuration,(long)sleepObj.awakeDuration,sleepObj.awakeDuration);
            for (int j = 0 ; j < sleepObj.details.count; j ++) {
                ZHJSleepDetail *sleepDetailOneObj = sleepObj.details[j];
                if (isNil(sleepDetailOneObj) || isNil(sleepDetailOneObj.dateTime) || sleepDetailOneObj.type == 0 || sleepDetailOneObj.duration == 0 ) {//type睡眠状态（1 开始入睡 2 浅睡 3 深睡 4 清醒 5 快速眼动）
                   // NSLog(@"查看 [历史记录] ———————————— [睡眠类] 空");
                    return;
                }else{
                    DevUpDataSleepModel *objModel = [[DevUpDataSleepModel alloc]init];
                    //objModel.familyMemberId = userId;//1129不传familyMemberId
                    objModel.createTime = [ToolOfTimeChangeFormat getTimeStrWithShortYearMonthDayHouseMinString:sleepDetailOneObj.dateTime];
                    objModel.sleepStatus = sleepDetailOneObj.type;
                    objModel.stepCount = 0;//步数
                    if (isNotNil(objModel)) {
                        [devInfoUpArr addObject: [[NSMutableDictionary alloc]initWithDictionary:[objModel mj_keyValues]]];
                    }
                }
                //NSLog(@"查看 [历史记录] ———————————— [睡眠类] 本天日期=%@ ｜ 类型 %ld | 时长=%ld分钟",sleepDetailOneObj.dateTime,sleepDetailOneObj.type,sleepDetailOneObj.duration);
            }
            if (devInfoUpArr.count>0) {
                [self upSleepInfoWithAllUpArr:devInfoUpArr];
            }

        }
    });

    
}
- (void)upSleepInfoWithAllUpArr:(NSMutableArray *)devInfoUpArr{
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_UpInfoSleep);
   // NSLog(@"睡眠 记录上传 devInfoUpArr == \n %@",devInfoUpArr);
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:url withBody:devInfoUpArr finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSLog(@"睡眠 记录上传成功=%@",dic);
                self.sendHistorySuccessSaveCount += 1;
                if (isNotNil(self.sendHistorySuccessBlock)) {
                    self.sendHistorySuccessBlock(self.sendHistorySuccessSaveCount);
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==  体温 总上传
//实时
- (void)updataWithUserId:(NSString *)userId withNowTempInfo:(ZHJTemperatureDetail *)nowTempInfoDetailModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableArray *devInfoUpArr = [[NSMutableArray alloc]init];
        DevUpDataTemperatureModel *objModel  = [self dealTempUpObjWithUserId:userId withZHJTemperatureDetail:nowTempInfoDetailModel];
        if (isNotNil(objModel)) {
            NSLog(@"上传实时温度");
            [devInfoUpArr addObject: [[NSMutableDictionary alloc]initWithDictionary:[objModel mj_keyValues]]];
            [self upTempInfoWithAllUpArr:devInfoUpArr];
        }else{
            NSLog(@"上传实时温度 空数据 不上传");
        }
      
    });
  
}
//历史
- (void)updataWithUserId:(NSString *)userId withHistoryTempInfoArr:(NSMutableArray *)tempInfoArr{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableArray *devInfoUpArr = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < tempInfoArr.count; i++) {
            ZHJTemperature *tempObj = tempInfoArr[i];
           // NSLog(@"查看 [历史记录] ———————————— [体温类] 平均=%ld 中位数=%ld 最大=%ld 最小=%ld ",(long)tempObj.avg,(long)tempObj.mid,(long)tempObj.max,(long)tempObj.min);
            for (int j = 0 ; j < tempObj.details.count; j ++) {
                ZHJTemperatureDetail *tempDetailOneObj = tempObj.details[j];
                DevUpDataTemperatureModel *objModel  = [self dealTempUpObjWithUserId:userId withZHJTemperatureDetail:tempDetailOneObj];
                if (isNotNil(objModel)) {
                    [devInfoUpArr addObject: [[NSMutableDictionary alloc]initWithDictionary:[objModel mj_keyValues]]];
                }
            }
        }
        if (devInfoUpArr.count>0) {
            NSLog(@"上传历史温度列表");
            [self upTempInfoWithAllUpArr:devInfoUpArr];
        }else{
            NSLog(@"上传历史温度列表 空数据 不上传");
        }
    });
   

}
//体温数据格式处理
- (DevUpDataTemperatureModel *)dealTempUpObjWithUserId:(NSString *)userId withZHJTemperatureDetail:(ZHJTemperatureDetail *)tempDetailOneObj{
    

    NSInteger wristTemp = tempDetailOneObj.wristTemperature;//手腕体温
    NSInteger headTemp = tempDetailOneObj.headTemperature;//额头体温
    //
    double vaildTemperature_WT = (double)(wristTemp/100.0);
    double vaildTemperature_HT = (double)(headTemp/100.0);
    
    if ((vaildTemperature_WT<44.0 || vaildTemperature_HT<44.0) && (vaildTemperature_WT>34.0 || vaildTemperature_HT>34.0)) {
        DevUpDataTemperatureModel *objModel  = [[DevUpDataTemperatureModel alloc]init];
        //objModel.familyMemberId = userId;//1129不传familyMemberId
        objModel.tmpHandler = vaildTemperature_WT;
        objModel.tmpForehead = vaildTemperature_HT;
        //time
        NSString *dateStr = tempDetailOneObj.dateTime;
        if (isNil(dateStr) || dateStr.length == 0 ) {
            objModel.createTime = [ToolOfTimeChangeFormat  currentTimeStr];
        }else{
            objModel.createTime =  [ToolOfTimeChangeFormat getTimeStrWithShortYearMonthDayHouseMinString:dateStr];
        }
     
        //NSLog(@" ———————————— [体温类] %@ %f  %f,=== 时间串%@ 时间戳 %@",dateStr,vaildTemperature_WT,vaildTemperature_HT,dateStr,objModel.createTime);
        return objModel;
    }else{
        return nil;//有数据 且 没有越界数据才做model
    }
    
}
//体温上传
- (void)upTempInfoWithAllUpArr:(NSMutableArray *)devInfoUpArr{
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_UpInfoTemperature);
   // NSLog(@"体温 记录上传 devInfoUpArr == \n %@",devInfoUpArr);
    [[ToolOfNetWork sharedTools]YrequestPostALLURLNoMainQueueWithBodyNotParms:url withBody:devInfoUpArr finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSLog(@"体温 记录上传成功=%@",dic);
                self.sendHistorySuccessSaveCount += 1;
                if (isNotNil(self.sendHistorySuccessBlock)) {
                    self.sendHistorySuccessBlock(self.sendHistorySuccessSaveCount);
                }
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 

//获取睡眠 timeStatus1最近一天 timeStatus2为周数据
//一天的睡眠数据
- (void)getUserSleepOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetSleepOneDay);
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:@{@"familyMemberId":userId,@"timeStatus":@(1)}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSDictionary *oneDaySleepDic = [[dic allKeys]containsObject: @"list"] ? [NSArray arrayWithArray:[dic objectForKey:@"list"]].firstObject : nil;
                if (isNil(oneDaySleepDic)) {
                    block(@{},NO);
                }else{
                    NSLog(@"获取用户最近一天的睡眠统计数据 parms=%@",oneDaySleepDic);
                    block(oneDaySleepDic,YES);
                }
              
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
//一周的睡眠数据
- (void)getUserSleepOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetSleepOneWeak);// URL_GetSleepOneDay 接口同一个只参数不一样
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:@{@"familyMemberId":userId,@"timeStatus":@(2),@"pageTurnStatus":@(weakPageTurnIndex)}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                if (isNil(dic)) {
                    block(@{},NO);
                }else{
                    NSLog(@"获取用户最近一周的睡眠统计数据 parms=%@",dic);
                    block(dic,YES);
                }
              
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

#pragma mark == 体温
/**
 查询时间状态（1：按天，2：按周，3：按月）
 */
 //一天的体温数据
- (void)getUserTempOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(1) forKey:@"timeStatus"];
    [ self getUserTempWithDic:parms withBlock:block];
}
 //一周的体温数据
- (void)getUserTempOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(2) forKey:@"timeStatus"];
    [parms setValue:@(weakPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserTempWithDic:parms withBlock:block];
}
 //一月的体温数据
- (void)getUserTempOneMonthDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(3) forKey:@"timeStatus"];
    [parms setValue:@(monthPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserTempWithDic:parms withBlock:block];
}
- (void)getUserTempWithDic:(NSMutableDictionary*)parms  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetTemp);

    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                if (isNil(dic)) {
                    block(@{},NO);
                }else{
                    NSLog(@"获取用户体温的统计数据 parms=%@",dic);
                    block(dic,YES);
                }
              
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
#pragma mark == 体温异常数据
//一天
- (void)getUserTempOneDayAbnormalDataWithUserId:(NSString *)userId withBlock:(BaseListArrAndSuccessBoolBlock)block{
   NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
   [parms setValue:userId forKey:@"familyMemberId"];
   [parms setValue:@(1) forKey:@"timeStatus"];
   [ self getUserTempAbnormalWithDic:parms withBlock:block];
}
//一周
- (void)getUserTempOneWeakAbnormalDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block{
   NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
   [parms setValue:userId forKey:@"familyMemberId"];
   [parms setValue:@(2) forKey:@"timeStatus"];
   [parms setValue:@(weakPageTurnIndex) forKey:@"pageTurnStatus"];
   [ self getUserTempAbnormalWithDic:parms withBlock:block];
}
//一月
- (void)getUserTempOneMonthAbnormalDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block{
   NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
   [parms setValue:userId forKey:@"familyMemberId"];
   [parms setValue:@(3) forKey:@"timeStatus"];
   [parms setValue:@(monthPageTurnIndex) forKey:@"pageTurnStatus"];
   [ self getUserTempAbnormalWithDic:parms withBlock:block];
}
- (void)getUserTempAbnormalWithDic:(NSMutableDictionary*)parms  withBlock:(BaseListArrAndSuccessBoolBlock)block{
   NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetTempAbnormal);

   [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
       if (isNotNil(responsObject)) {
           if (Y_IS_Success) {
               NSArray *arr = Y_ResponsObject_dataArr;
               if (isNil(arr)) {//空列表数据
                   block(@[],NO);
               }else{
                   NSLog(@"获取用户体温的统计数据 parms=%@",arr);
                   block(arr,YES);
               }
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

#pragma mark ==== 心率
//====== 心率数据
//一天的心率数据
- (void)getUserHeartOneDayDataWithUserId:(NSString *)userId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(1) forKey:@"timeStatus"];
    [ self getUserHeartWithDic:parms withBlock:block];
}
//一周的心率数据
- (void)getUserHeartOneWeakDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(2) forKey:@"timeStatus"];
    [parms setValue:@(weakPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserHeartWithDic:parms withBlock:block];
}
//一月的心率数据
- (void)getUserHeartOneMonthDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(3) forKey:@"timeStatus"];
    [parms setValue:@(monthPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserHeartWithDic:parms withBlock:block];
}
- (void)getUserHeartWithDic:(NSMutableDictionary *)parm  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetHeart);

    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parm finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                if (isNil(dic)) {
                    block(@{},NO);
                }else{
                    NSLog(@"获取用户心率的统计数据 parms=%@",dic);
                    block(dic,YES);
                }
              
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

//====== 心率异常数据
//一天
- (void)getUserHeartOneDayAbnormalDataWithUserId:(NSString *)userId withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(1) forKey:@"timeStatus"];
    [ self getUserHeartAbnormalWithDic:parms withBlock:block];
}
//一周
- (void)getUserHeartOneWeakAbnormalDataWithUserId:(NSString *)userId withWeakPageTurnIndexNum:(NSInteger)weakPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(2) forKey:@"timeStatus"];
    [parms setValue:@(weakPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserHeartAbnormalWithDic:parms withBlock:block];
}
//一月
- (void)getUserHeartOneMonthAbnormalDataWithUserId:(NSString *)userId withMonthPageTurnIndexNum:(NSInteger)monthPageTurnIndex withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:userId forKey:@"familyMemberId"];
    [parms setValue:@(3) forKey:@"timeStatus"];
    [parms setValue:@(monthPageTurnIndex) forKey:@"pageTurnStatus"];
    [ self getUserHeartAbnormalWithDic:parms withBlock:block];
}

- (void)getUserHeartAbnormalWithDic:(NSMutableDictionary*)parms  withBlock:(BaseListArrAndSuccessBoolBlock)block{
   NSString *url = BASE_TrusangBlueToothData_BaseUrl_URL(URL_GetHeartAbnormal);
   [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
       if (isNotNil(responsObject)) {
           if (Y_IS_Success) {
               NSArray *arr = Y_ResponsObject_dataArr;
               if (isNil(arr)) {//空列表数据
                   block(@[],NO);
               }else{
                   NSLog(@"获取用户心率的统计数据 parms=%@",arr);
                   block(arr,YES);
               }
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
@end
