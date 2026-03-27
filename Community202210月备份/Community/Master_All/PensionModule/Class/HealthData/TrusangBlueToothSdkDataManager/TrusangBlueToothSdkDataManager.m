//
//  TrusangBlueToothSdkDataManager.m
//  Community
//
//  Created by 余莹 on 2021/11/10.
//

#import "TrusangBlueToothSdkDataManager.h"
#import <CoreBluetooth/CBPeripheral.h>
@interface TrusangBlueToothSdkDataManager()
//@property (nonatomic,strong) NSTimer *notConnectSuccessTimerr;
//@property (nonatomic,assign) NSInteger notConnectSuccessTimeNum;//间隔时间
@end

@implementation TrusangBlueToothSdkDataManager
singleton_implementation(share)

//
- (void)getMyPhoneDevceStateWithOpenBoolWithBlock:(MyPhoneDevIsOpenBlueToothBlock)block{
 
    [[ZHJBLEManagerProvider shared]bluetoothProviderManagerStateDidUpdateWithState:^(enum ZHJBTManagerState staus) {
 
        if (staus==ZHJBTManagerStatePoweredOn) {
            NSLog(@"0设备状态=on   getStaus = %ld",(long)staus);
            block(YES);
        }else{
          
            NSLog(@"0设备状态 ！on  getStaus = %ld",(long)staus);
            block(NO);
        }
        

    }];

}
#pragma mark === 搜索
//后台一直搜
- (void)backgroundKeepsBlueDevScanningWhenNowDevStateNotCare{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [[ZHJBLEManagerProvider shared]scanWithDiscover:^(NSArray<ZHJBTDevice *> * _Nonnull arr) {
       
            [self.scanDevsSaveArr addObjectsFromArray:arr];
            for (int i = 0; i < self.scanDevsSaveArr.count; i++) {
                for (int j = i+1; j < self.scanDevsSaveArr.count; j++) {
                    ZHJBTDevice *devOne = self.scanDevsSaveArr[i];
                    ZHJBTDevice *devOther = self.scanDevsSaveArr[j];
                    if ([devOne.mac isEqualToString:devOther.mac]) {
                       // NSLog(@"已经有过 重复的 dev 删除 \n i=%d dev == %@ \n j=%d dev == %@ ",i, devOne.name,j, devOther.name);
                        [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                        j-=1;//删除本个j，角标上移 重复本个j
                    }else if (devOne.mac.length>0 && devOther.mac.length==0){
                        NSLog(@" 0去重循环内mac有空数据 \n i=%d dev == %@  mac=%@ , \n j=%d dev == %@  mac=%@",i, devOne.name,devOne.mac,j, devOther.name,devOther.mac);
                        if ([devOne.name isEqualToString:devOther.name]) {
                            [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                            j-=1;//删除本个j，角标上移 重复本个j
                        }
                   }
                }
            }
            
        }];
    });
}

- (void)backgroundKeepsBlueDevScanning{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[ZHJBLEManagerProvider shared]scanWithDiscover:^(NSArray<ZHJBTDevice *> * _Nonnull arr) {
       
            [self.scanDevsSaveArr addObjectsFromArray:arr];
            for (int i = 0; i < self.scanDevsSaveArr.count; i++) {
                for (int j = i+1; j < self.scanDevsSaveArr.count; j++) {
                    ZHJBTDevice *devOne = self.scanDevsSaveArr[i];
                    ZHJBTDevice *devOther = self.scanDevsSaveArr[j];
                    if ([devOne.mac isEqualToString:devOther.mac]) {
                       // NSLog(@"已经有过 重复的 dev 删除 \n i=%d dev == %@ \n j=%d dev == %@ ",i, devOne.name,j, devOther.name);
                        [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                        j-=1;//删除本个j，角标上移 重复本个j
                    }else if (devOne.mac.length>0 && devOther.mac.length==0){
                        NSLog(@" 0去重循环内mac有空数据 \n i=%d dev == %@  mac=%@ , \n j=%d dev == %@  mac=%@",i, devOne.name,devOne.mac,j, devOther.name,devOther.mac);
                        if ([devOne.name isEqualToString:devOther.name]) {
                            [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                            j-=1;//删除本个j，角标上移 重复本个j
                        }
                   }
                }
            }
            /**
             for (ZHJBTDevice *scanOkDev in self.scanDevsSaveArr) {
                 NSLog(@"后台总搜索 结果 去重————————%ld dev == %@",self.scanDevsSaveArr.count, scanOkDev.name);
             }
             */
            if (self.nowDevState == DeviceStateConnected) {//当前设备连接状态 则可停止
                [self stopScanDev];
            }
            
        }];
    });
   
}
//搜索动作搜
- (void)searchDeviceInfoWithBlock:(ArrAndSuccesBoolBlock)block{
//    if (self.nowDevState == DeviceStateConnected ) {
//        self.nowDevState = DeviceStateConnected;//在线状态 无论搜多少次都是在线
//    }else if (self.nowDevState == DeviceStateDisconnected) {
//        self.nowDevState = DeviceStateDisconnected;//离线状态
//  //  }else if (self.nowDevState != DeviceStateDisconnected && self.nowDevState != DeviceStateConnected && self.nowDevState != DeviceStateConnecting) {
//    }else{
//        self.nowDevState = DeviceStateSearching;
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[ZHJBLEManagerProvider shared]scanWithSeconds:(60*60*10) discover:^(NSArray<ZHJBTDevice *> * _Nonnull arr) {
            NSLog(@"1设备基础信息获取 定时回调信息  searchDeviceInfo%@",arr);
            [self stopScanDev];//停止搜索 调一次搜一次
           
            if (self.nowDevState == DeviceStateConnected ) {
                self.nowDevState = DeviceStateConnected;//在线状态 无论搜多少次都是在线
            }else if (self.nowDevState != DeviceStateDisconnected && self.nowDevState != DeviceStateConnected  && self.nowDevState != DeviceStateConnecting) {
                self.nowDevState = DeviceStateDefault;//搜索完成后 不确定当前是否在线 设置为无状态
            }
            if (arr.count>0) {
                
                //混合所有搜索的数据 去重后返回
                [self.scanDevsSaveArr addObjectsFromArray:arr];
                for (int i = 0; i < self.scanDevsSaveArr.count; i++) {
                    for (int j = i+1; j < self.scanDevsSaveArr.count; j++) {
                        ZHJBTDevice *devOne = self.scanDevsSaveArr[i];
                        ZHJBTDevice *devOther = self.scanDevsSaveArr[j];
                        if ([devOne.mac isEqualToString:devOther.mac]) {
                           // NSLog(@"已经有过 重复的 dev 删除 \n i=%d dev == %@  mac=%@ , \n j=%d dev == %@  mac=%@",i, devOne.name,j, devOther.name);
                            [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                            j-=1;//删除本个j，角标上移 重复本个j
                            
                        //在线状态时mac空了的情况 用name 做去重
                        }else if (devOne.mac.length>0 && devOther.mac.length==0){
                            NSLog(@" 0去重循环内mac有空数据 \n i=%d dev == %@  mac=%@ , \n j=%d dev == %@  mac=%@",i, devOne.name,devOne.mac,j, devOther.name,devOther.mac);
                            if ([devOne.name isEqualToString:devOther.name]) {
                                [self.scanDevsSaveArr removeObjectAtIndex:j];//      不用removeObject:devOther];//乱序了
                                j-=1;//删除本个j，角标上移 重复本个j
                            }
                       }
                    }
                }
                
            
                block(self.scanDevsSaveArr,YES);
           
            }
        }];
    });
   
}

- (void)stopScanDev{
    [[ZHJBLEManagerProvider shared]stopScan];
}
//mac空时 返回蓝牙存储设备列表中 能够匹配的mac
- (NSString *)getDevMacStrOfNowSaveBlueScanArrWithOneDevUseNameStr:(ZHJBTDevice *)trusangBluedev{
    NSString *getMacStr = @"";
    for (ZHJBTDevice *scanDevObj in self.scanDevsSaveArr) {
        NSLog(@"   ****** |存储的搜索数据  %@ %@, mac长度 = %ld,  peripheral =%@" ,scanDevObj.name, scanDevObj.mac,scanDevObj.mac.length,scanDevObj.peripheral.identifier);
        
        
        if ([scanDevObj.mac isEqualToString:trusangBluedev.mac]) {
            trusangBluedev = scanDevObj;//替换成搜索arr里同个dev的数据 再做连接
            NSLog(@"  ****** |直接匹配mac  %@ %@ %@ %@" ,scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac);
            getMacStr = scanDevObj.mac;
        }else if (trusangBluedev.mac.length==0 && scanDevObj.mac.length>0 && [scanDevObj.name isEqualToString:trusangBluedev.name]){
            NSLog(@"  ****** |给的dev空时 匹配name  %@ %@ %@ %@" ,scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac);
            getMacStr = scanDevObj.mac;
        }else if (trusangBluedev.mac.length>0 && scanDevObj.mac.length==0 && [scanDevObj.name isEqualToString:trusangBluedev.name]){
            NSLog(@"  ****** |存储的dev空时 匹配name  %@ %@ %@ %@" ,scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac);
            getMacStr = trusangBluedev.mac;
        }else {
            NSLog(@"  ****** |存储的搜索数据 没有匹配设备 空mac返回");
        }
        
    }
    return getMacStr;
}
#pragma mark === 连接
- (void)connectDevice:(ZHJBTDevice *)trusangBluedev withConnetStatuBlock:(ConnectStateBlock)stateBlock{
    [self stopScanDev];
    NSLog(@" ****** 连接 connectDevice ******   %@ %@ %@ %@ %@ %@ %ld %d %d sn=%@",trusangBluedev.name,trusangBluedev.mac,trusangBluedev.rssi,trusangBluedev.version,trusangBluedev.peripheral,trusangBluedev.model,trusangBluedev.power,trusangBluedev.isConnected,trusangBluedev.isANCSAuthorized,trusangBluedev.sn);// ****** 连接 connectDevice ******   S50-7856 A4:C1:38:6B:78:56 0 0 (null) (null) 0 0 0 sn=
    for (ZHJBTDevice *scanDevObj in self.scanDevsSaveArr) {
        NSLog(@" ****** 连接 connectDevice ****** |存储的搜索数据  %@ %@, mac长度 = %ld,  peripheral =%@" ,scanDevObj.name, scanDevObj.mac,scanDevObj.mac.length,scanDevObj.peripheral.identifier);
        if ([scanDevObj.mac isEqualToString:trusangBluedev.mac]) {
            trusangBluedev = scanDevObj;//替换成搜索arr里同个dev的数据 再做连接
            NSLog(@" ****** 连接 connectDevice ****** |*匹配  %@ %@ %@ %@" ,scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac);
        }else {
            if (scanDevObj.mac.length<=0 && [scanDevObj.name isEqualToString: trusangBluedev.name]) {
                NSLog(@" ****** 连接 connectDevice ****** |*mac空数据问题  %@ %@ %@ %@ mac长度=%ld", scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac,scanDevObj.mac.length);
                NSString *showInfoStr = [NSString stringWithFormat:@"%@无法匹配\n请检查%@是否处于被蓝牙连接的状态!\n可尝试关闭%@之前所连接过的手机蓝牙,从而更换连接。",trusangBluedev.name,trusangBluedev.name,trusangBluedev.name];
                Y_SVP_SHOW_INFO_MES_5Delay(showInfoStr);
//#import "DeviceMatchingRemoveGuideVC.h"
                self.conectOneDevNotHaveMacBlock(); 
            }else{
                //其他设备连接状态
//                NSLog(@" ****** 连接 connectDevice ****** |不匹配  %@ %@ %@ %@", scanDevObj.name, scanDevObj.mac ,trusangBluedev.name,trusangBluedev.mac);
            }
           
        }
    }
    
    self.showModel.saveNowDevName = [NSString stringWithFormat:@"%@",trusangBluedev.name];
    self.showModel.saveNowDevMac = [NSString stringWithFormat:@"%@",trusangBluedev.mac];//此处的mac有值
    if (self.nowDevState == DeviceStateConnected) {
    }else{
        self.nowDevState = DeviceStateConnecting;

    }
    [[ZHJBLEManagerProvider shared]connectDeviceWithDevice:trusangBluedev  success:^(CBPeripheral * _Nonnull successInfo) {
        NSLog(@"2设备连接 成功 %@",successInfo);
//        self.showModel.saveNowDevName  //        successInfo.name
        self->saveNowDev = trusangBluedev;//保存dev ,成员变量不用self.
        [self connectedWithInitReadAndWriteWithConnetStatuBlock:stateBlock];//读写通道打开

    } fail:^(CBPeripheral * _Nonnull failInfo, NSError * _Nullable err) {
        NSLog(@"2设备连接 失败 %@ \n  %@ ",failInfo ,err);
        stateBlock(ConnectDev_State_Fail);
        self.nowBlueToothDevSave.isConnected = NO;
        self.nowDevState = DeviceStateDisconnected;
        
    } timeout:^{
        NSLog(@"2设备连接 超时");
        stateBlock(ConnectDev_State_OutTime);
        self.nowBlueToothDevSave.isConnected =  NO;
        self.nowDevState = DeviceStateDisconnected;
    }];
}
- (void)disConnectDev{
    NSLog(@"主动断开设备");
    [[ZHJBLEManagerProvider shared] disconnectDeviceWithDisconnect:^(CBPeripheral * _Nonnull info) {
        NSLog(@"3断开设备 %@",info);
        /**
         [self anObjChangeSetKvoWith_nowDevState:DeviceStateDisconnected];
         [self anObjChangeSetKvoWith_nowBlueToothDevSaveisConnected:NO];
     
         */
        self.nowBlueToothDevSave.isConnected = NO;
        self.nowDevState = DeviceStateDisconnected;
        
    }];
}
////本类调用 不被kvo识别问题
//- (void)anObjChangeSetKvoWith_nowDevState:(DeviceState)obj{
//    [self willChangeValueForKey:@"nowDevState"];
//     self.nowDevState = obj;
//    [self didChangeValueForKey:@"nowDevState"];
//}
//- (void)anObjChangeSetKvoWith_nowBlueToothDevSaveisConnected:(BOOL)obj{
//    [self willChangeValueForKey:@"nowBlueToothDevSave"];
//    self.nowBlueToothDevSave.isConnected = obj;
//    [self didChangeValueForKey:@"nowBlueToothDevSave"];
//}
 
 

/**
 连接成功后 本方法会被调用 // 发现设备读写特征值
 理论上设备连接后，要确认此方法回调后，才可以进行数据读取，但是一般的取得写入通道后，这个通道也会很快取得，可忽略
 发现了读写通道才可以进行功能参数数据的读取和设置
 */
- (void)connectedWithInitReadAndWriteWithConnetStatuBlock:(ConnectStateBlock)stateBlock{
    self.nowBlueToothDevSave = saveNowDev;
    NSLog(@"connectedWithInitReadAndWriteWithConnetStatuBlock 连接设备 为 %@ %@ ",saveNowDev.name,saveNowDev.mac);
    self.nowBlueToothDevSave.isConnected = YES;
    self.nowDevState = DeviceStateConnected;
    __block int okIndex = 0;
    [[ZHJBLEManagerProvider shared]discoverReadCharacteristicWithRead:^(CBCharacteristic * _Nonnull chic) {
        NSLog(@" 发现设备读写特征值 Read  ==%@",chic);
        okIndex += 1;
        if (okIndex >= 2) {
            if ( isNotNil(stateBlock) ) {
                stateBlock(ConnectDev_State_Success);
                [self getDevWhenIsOneLineWithThisDevInfoWithDev:^(BOOL success, ZHJBTDevice * _Nonnull nowContentedDevSelfInfo) {
                }];
            }
            [self writePhoneTimeToDev];
            [self lookNowDevStateNotice];
        }
      
    }];
    [[ZHJBLEManagerProvider shared]discoverWriteCharacteristicWithWrite:^(CBCharacteristic * _Nonnull chic) {
        NSLog(@" 发现设备读写特征值 Write  ==%@",chic);
        okIndex += 1;
        if (okIndex >= 2) {
            if ( isNotNil(stateBlock) ) {
                stateBlock(ConnectDev_State_Success);
                [self getDevWhenIsOneLineWithThisDevInfoWithDev:^(BOOL success, ZHJBTDevice * _Nonnull nowContentedDevSelfInfo) {
                }];
            }
            [self writePhoneTimeToDev];
            [self lookNowDevStateNotice];
        }
    }];
}
#pragma mark == 监控设备的状态改变
- (void)lookNowDevStateNotice{
    NSLog(@"lookNowDevStateNotice 监控设备的状态改变");
    [[ZHJBLEManagerProvider shared] deviceStateDidUpdatedWithStateUpdate:^(enum DeviceState state) {
        NSLog(@"lookNowDevStateNotice 此方法是设备的状态回调，可以监控设备的状态改变 %ld",(long)state);
        /**
         /// 没有任何动作
           DeviceStateDefault = 0,
         /// 搜索中
           DeviceStateSearching = 1,
         /// 连接中
           DeviceStateConnecting = 2,
         /// 已连接
           DeviceStateConnected = 3,
         /// 断开连接
           DeviceStateDisconnected = 4,
         };

         */
        self.nowDevState = state;
        switch (state) {
            case DeviceStateDisconnected:
                //有切换，不要在本状态做重连 仅仅更新当前设备状态
               // [self reConNowDev];
                self.nowBlueToothDevSave.isConnected = NO;
                self.nowDevState = DeviceStateDisconnected;
           
                break;
            case DeviceStateConnected:
            {
                
                    self.nowBlueToothDevSave.isConnected = YES;
                    self.nowDevState = DeviceStateConnected;
                WEAKSELF
                [self getDevWhenIsOneLineWithThisDevInfoWithDev:^(BOOL success, ZHJBTDevice * _Nonnull nowContentedDevSelfInfo) {
                    if (success) {
                        NSLog(@"当前连接的设备 自己的设备信息 == %@ %@ %@",nowContentedDevSelfInfo.name,nowContentedDevSelfInfo.mac,nowContentedDevSelfInfo.version);
                        if (![nowContentedDevSelfInfo.name isEqualToString:@"unKnow"] && ![nowContentedDevSelfInfo.name isEqualToString:@""]) {
                            weakSelf.showModel.saveNowDevName = nowContentedDevSelfInfo.name;//某些设备查询名字为这个 不能用于赋值
                        }
                        if (![nowContentedDevSelfInfo.mac isEqualToString:@"unKnow"] && ![nowContentedDevSelfInfo.mac isEqualToString:@""]) {
                            weakSelf.showModel.saveNowDevMac = nowContentedDevSelfInfo.mac;
                        }
                        weakSelf.showModel.saveNowDevVersion = nowContentedDevSelfInfo.version;
                    }
                }];
            }
                break;
            default:
                self.nowBlueToothDevSave.isConnected = NO;
                NSLog(@"离线上线之外的其他状态，搜索状态 正在连接状态 暂时不给设备赋值");
                break;
        }
    }];
}
#pragma mark == 重连scan
- (void)reConNowDev{
//    saveNowDev
    NSLog(@"*** 重连 ***");
    [[ZHJBLEManagerProvider shared] autoReconnectWithSuccess:^(CBPeripheral * _Nonnull successInfo) {
        [self connectedWithInitReadAndWriteWithConnetStatuBlock:nil];//读写通道打开
    } fail:^(CBPeripheral * _Nonnull failInfo, NSError * _Nullable err) {
        //重连失败
    }];
    
}
#pragma mark ==
//当前已经连接的设备 设备信息 获取 (没连接 或没查到 做No nil)
- (void)getDevWhenIsOneLineWithThisDevInfoWithDev:( void (^) (BOOL success,ZHJBTDevice *nowContentedDevSelfInfo) )nowDevSelfInfoBlock{
    if (!self.nowBlueToothDevSave.isConnected) {
        if (isNotNil(nowDevSelfInfoBlock)) {
            nowDevSelfInfoBlock(NO,nil);
        }
        return;
    }
    [[ZHJDeviceInfoProcessor shared]readDeviceInfoWithDeviceInfoHandle:^(ZHJBTDevice * _Nonnull dev) {
        NSLog(@"查询到当前手环等设备信息 = %@ 。 %@  . %d",dev.name,dev.mac,(bool)dev.isConnected);
        if (isNil(dev)) {
            if ( isNotNil(nowDevSelfInfoBlock))  {
                nowDevSelfInfoBlock(NO,nil);
            }
        
        }else{
            if ( isNotNil(nowDevSelfInfoBlock))  {
                nowDevSelfInfoBlock(YES,dev);
            }
          
        }
    }];
}
#pragma mark ==============
//查找设备指令
- (void)findDeviceAction{
    [[ZHJDeviceControlProcessor shared]findDeviceWithWriteHandle:^(enum ZHJBLEError err) {
        NSLog(@"发送了查找设备指令 %ld",(long)err);
    }];
}
//发送震动指令
- (void)sendVibrateAction{
    [[ZHJMessageProcessor shared]sendVibrate];
}
#pragma mark ==============


#pragma mark == 写入数据
- (void)writeDataToDev{
    [self writePhoneTimeToDev];
}
//同步时间
- (void)writePhoneTimeToDev{
    ZHJSyncTime *nowPhoneTime = [[ZHJSyncTime alloc]init: [NSDate date]];
//    nowPhoneTime.year =
    [[ZHJSyncTimeProcessor shared]writeTime:nowPhoneTime setHandle:^(enum ZHJBLEError err) {
        if (err == ZHJBLEErrorCorrect) {
            //成功
            NSLog(@"同步时间 成功");
        }else{
            //失败
            NSLog(@"同步时间 失败");
        }
    }];
}

#pragma mark ============== 当前数据
#pragma mark == 得到数据

//当前数据
- (void)getOneBlueDevHealthInfoWithNowConnectedOkDevice{
    //_______ 间隔执行 蓝牙数据慢
    if (saveNowDev.name.length>0 && self.nowDevState == DeviceStateConnected) {//有设备｜已经连接可通信  才查询
        NSLog(@"*** 开始查询设备实时相关数据 ***");
    }else{
        //无设备或设备没连接时都不做查询
        NSLog(@"** 无设备或设备没连接时都不做查询 **");
        return;
    }
 
    
    __block NSInteger time = 6; //总倒计时时间
    double dlayTimeInv = 2.0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局并行
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),dlayTimeInv*NSEC_PER_SEC, 0); //每2秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            if (self.nowBlueToothDevSave.isConnected) {
                [self getHistoryInfoWithDevice];//去历史记录板块获取数据
            }else{
                return;
            }
        
            dispatch_source_cancel(_timer);
            
        }else{
            //获取基础展示数据    | 获取告警数据区域
            switch (time) {
             
                case 1:
                {
                    [self  getHealthWaringNumWithTemp];
                }
                    break;
                case 2:
                {
                    [self  getHealthWaringNumWithHrBpBo];
                }
                    break;
               
                case 3:
                {
//
                    [self  getHeartRateBpBo];//心率
                }
                    break;
                case 4:
                {
                    //[self  getSleepList];//睡眠
                }
                    break;
                case 5:
                {
                    [self  getTemperature];//体温
                }
                    break;
                case 6:
                {
                    [self getDevSendHealData];//
                  // [self  getPower];
                }
                    break;
                    
                   
                default:
                    NSLog(@"***普通类型 倒计时=%ld 当前线程 %@ ***",time,[NSThread currentThread]);
                    break;
            }
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (void)getPower{
    //电量数据
    [[ZHJBatteryProcessor shared]readBatteryPowerWithBatteryHandle:^(NSInteger power) {
        NSLog(@"5 得到数据  电量 %ld",(long)power);
        self.showModel.powerIntVale = power; 
    }];
}

- (void)getTemperature{
    //体温
    [[ZHJTemperatureProcessor shared]readCurrentTemperatureWithCurrentDataHandle:^(ZHJTemperatureDetail * _Nonnull temperature) {
        double vaildTemperature = (temperature.wristTemperature > 0 ? (double)(temperature.wristTemperature/100.0) : (double)(temperature.headTemperature/100.0) );
        NSLog(@"  读取当前体温 %f",vaildTemperature);
        //先后顺序 响应的是temperature 没做now_TempDetailkvo 则在temperature改变所响应的方法中 调用时 需要已经赋值过的now_Temp
        self.showModel.now_TempDetail = temperature;
        self.showModel.temperature = vaildTemperature;
    }];
}
 
- (void)getHeartRateBpBo{
    //心率 血压 血氧
    [[ZHJHR_BP_BOProcessor shared]readCurrentHR_BP_BOWithCurrentDataHandle:^(ZHJHeartRateDetail * _Nonnull heartRate, ZHJBloodPressureDetail * _Nonnull bp, ZHJBloodOxygenDetail * _Nonnull bo) {
       // NSLog(@"当前心率(Heart rate) %ld  \n 舒张压bp/=%ld \n 收缩压(systolic blood pressure ，SBP)=%ld \n 血氧值bo=%ld",(long)heartRate.HR,bp.DBP,bp.SBP,bo.BO);//舒张压(diastolic blood pressure，DBP).....
        
        //先后顺序 响应的是temperature 没做now_TempDetailkvo 则在temperature改变所响应的方法中 调用时 需要已经赋值过的now_Temp
        //
        self.showModel.now_HeartRateDetail = heartRate;
        self.showModel.now_BpDetail = bp;
        self.showModel.now_BoDetail = bo;
        //
        self.showModel.heartRete = heartRate.HR;
        self.showModel.bp_bp = bp.DBP;
        self.showModel.bp_sp = bp.SBP;
        self.showModel.bo = bo.BO;
        //
        NSLog(@"读取当前 心率 %ld",(long)heartRate.HR);
    }];
}

- (void)getSleepList{
    [[ZHJAutoSleepTimeProcessor shared]readAutoSleepTimeWithAutoSleepTimeHandle:^(NSArray<ZHJAutoSleepTime *> * _Nonnull arr) {
        for ( int i = 0; i < arr.count; i++) {
//            ZHJAutoSleepTime *sleepT = arr.firstObject;
           // NSLog(@"[睡眠] arr_i == %d \n 开始睡眠时间=%ld:%ld \n结束睡眠时间 %ld:%ld \n 睡眠周期arr=%@",i,sleepT.beginHour,sleepT.beginMinute,sleepT.endHour,sleepT.endMinute,sleepT.cycle);
        }
    
    }];
}
#pragma mark ==============
#pragma mark == 心率 警告｜获取设备心率、血压、血氧告警设置 特定设备支持
- (void)getHealthWaringNumWithHrBpBo{//当前测试数据 无法获取不被调用
    /** 高值  max  低值  min;*/
    NSLog(@" ============== 心率、血压、血氧 告警数据");
    self.showModel.heartReteAlarmLimit_Min = 60;
    self.showModel.heartReteAlarmLimit_Max = 100;
    [[ZHJHR_BP_BOProcessor shared]readHR_BP_BOAlarmSettingWithAlarmHandle:^(ZHJHRAlarm_t * _Nonnull hrA, ZHJBPAlarm_t * _Nonnull bpA, ZHJBOAlarm_t * _Nonnull boA) {
        NSLog(@" ============== 心率、血压、血氧 告警数据 %@。%@ 。%@ \n 心率 %ld_%ld \n 血压dbp %ld_%ld  血压sbp %ld_%ld \n 血氧 只有低没有高==%ld",hrA,bpA,boA ,hrA.max,hrA.min ,bpA.maxDBP,bpA.minDBP,bpA.maxSBP,bpA.minSBP ,boA.min );
        self.showModel.heartReteAlarmLimit_Min = hrA.min;
        self.showModel.heartReteAlarmLimit_Max = hrA.max;
        NSLog(@" ============== 心率 警告｜%f %f ",  self.showModel.heartReteAlarmLimit_Min ,  self.showModel.heartReteAlarmLimit_Max);
    }];
}
#pragma mark == 获取设备 体温 告警设置
- (void)getHealthWaringNumWithTemp{
    //初始体温告警设置个值
     self.showModel.temperatureAlarmLimit_Max = 37.0;
     self.showModel.temperatureAlarmLimit_Min = 36.0;   //没有低温告警  假设一个值
    [[ZHJTemperatureProcessor shared]readTemperatureAlarmSettingWithTemperatureAlarmHandle:^(ZHJTemperatureAlarm_t * _Nonnull tempA) {
        self.showModel.temperatureAlarmLimit_Max = (double)(tempA.max/100.0);
        //NSLog(@" ============== 体温 告警数据 获取高温警告=%f 低温假设一个值%f", self.showModel.temperatureAlarmLimit_Max, self.showModel.heartReteAlarmLimit_Min);//告警数据有误 不可用
    }];
}
#pragma mark ====================================  历史数据

- (void)getHistoryInfoWithDevice{
    NSLog(@"历史记录 日期从今日开始往前 的记录查寻");
    NSString *nowDateStr = [ToolOfTimeChangeFormat shortStrOfnowTimeWithYearAndMonthAndDay];
    NSLog(@"开始查询日期== %@",nowDateStr);
    __block NSInteger time = 5; //总倒计时时间
    double delaytime = 3.0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局并行
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),delaytime*NSEC_PER_SEC, 0); //每3秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
        }else{
 
            switch (time) {
                case 5:
                {
                    NSLog(@"开始历史记录获取—— 睡眠 计步");
                    [self.showModel.histroy_SleepArr removeAllObjects];
                    [self  getHistory_Sleep:nowDateStr];
                }
                    break;
               case 4:
                {
                    NSLog(@"开始历史记录获取—— 心率血压血氧");
                    [self.showModel.histroy_HeartRateArr removeAllObjects];
                    [self.showModel.histroy_BpSpArr removeAllObjects];
                    [self.showModel.histroy_BoArr removeAllObjects];
                    [self  getHistory_HR_BP_BO:nowDateStr];
                }
                    break;
                case 3:
                 {
                     NSLog(@"开始历史记录获取—— 体温");
                     [self.showModel.histroy_TempArr removeAllObjects];
                     [self  getHistory_Temperature:nowDateStr];
                 }
                     break;
                default:
                    NSLog(@"*** 历史类型 倒计时=%ld ***",time);
                    break;
            }
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (void)getHistory_Sleep:(NSString *)checkDateStr{
    WEAKSELF
    __block BOOL isHaveLastData = YES;
    [[ZHJStepAndSleepProcessor shared]readStepAndSleepHistoryRecordWithDate:checkDateStr historyDataHandle:^(ZHJStep * _Nonnull step, ZHJSleep * _Nonnull sleep) {
        //        NSLog(@"日期 =%@  \n [睡眠] = %@ \n 计步= %@",checkDateStr,sleep.details,step.details);
       // NSLog(@"日期 =%@  \n __________*********_________[睡眠] = %@ \n ",checkDateStr,sleep.details);
        [self.showModel.histroy_SleepArr addObject:sleep];
       // NSLog(@"｜成功后直接调前一 ｜有更多旧数据  睡眠 计步组  history 继续 ");
        NSString *lastDateStr = [ToolOfTimeChangeFormat getOneDayToLastOneDayStrWithXDayStr_YearMonthDay:checkDateStr];//前一天
        [self getHistory_Sleep:lastDateStr];
    } historyDoneHandle:^(id _Nonnull obj) {
        
        if (isNotNil(obj)) {
            isHaveLastData = NO;
            NSLog(@"没有更多旧数据  睡眠 计步组  history end");
            if (isNotNil(weakSelf.devHistoryGetEnd_SleepInfoTypeBlock)) {
                weakSelf.devHistoryGetEnd_SleepInfoTypeBlock(YES);
            }
        }
        
    }];
    
}
- (void)getHistory_Temperature:(NSString *)checkDateStr{
    WEAKSELF
    __block BOOL isHaveLastData = YES;
    [[ZHJTemperatureProcessor shared]readTemperatureHistoryRecord:checkDateStr historyDataHandle:^(ZHJTemperature * _Nonnull temp) {
       // NSLog(@"日期 =%@  \n 体温组 =%@",checkDateStr,temp.details);
        [self.showModel.histroy_TempArr addObject:temp];
        if (isHaveLastData) {
            //NSLog(@"｜成功后直接调前一天体温")
            NSString *lastDateStr = [ToolOfTimeChangeFormat getOneDayToLastOneDayStrWithXDayStr_YearMonthDay:checkDateStr];//前一天
            [self getHistory_Temperature:lastDateStr];
        }
        
    } historyDoneHandle:^(id _Nonnull obj) {
        if (isNotNil(obj)) {
            isHaveLastData = NO;
            NSLog(@"没有更多旧数据   体温组  history end");
            if (isNotNil(weakSelf.devHistoryGetEnd_tempInfoTypeBlock)) {
                weakSelf.devHistoryGetEnd_tempInfoTypeBlock(YES);
            }
        }
        
    }];
    
    
}
- (void)getHistory_HR_BP_BO:(NSString *)checkDateStr{
    __block BOOL isHaveLastData = YES;
    WEAKSELF
    [[ZHJHR_BP_BOProcessor shared]readHR_BP_BOHistoryRecord:checkDateStr historyDataHandle:^(ZHJHeartRate * _Nonnull hr, ZHJBloodPressure * _Nonnull bp, ZHJBloodOxygen * _Nonnull bo) {
        //    NSLog(@"时间=%@ 心率=%ld %ld \n 血压%ld %ld 血氧%ld %ld",checkDateStr,hr.max,hr.min,bp.max,bp.min,bo.min,bo.max);
     //   NSLog(@"日期 =%@  \n心率组=%@ \n 血压组%@ 血氧组%@",checkDateStr,hr.details,bp.details, bo.details);
        [weakSelf.showModel.histroy_HeartRateArr addObject:hr];
        [weakSelf.showModel.histroy_BpSpArr addObject:bp];
        [weakSelf.showModel.histroy_BoArr addObject:bo];
        //NSLog(@"｜成功后直接调前一天 HR_BP_BO")
        NSString *lastDateStr = [ToolOfTimeChangeFormat getOneDayToLastOneDayStrWithXDayStr_YearMonthDay:checkDateStr];//前一天
        [weakSelf getHistory_HR_BP_BO:lastDateStr];
        
    } historyDoneHandle:^(id _Nonnull obj) {
        
        if (isNotNil(obj)) {
            isHaveLastData = NO;
            NSLog(@"没有更多旧数据   心率组  history end  数量%ld，数据 %@",weakSelf.showModel.histroy_HeartRateArr.count,weakSelf.showModel.histroy_HeartRateArr);
            if (isNotNil(weakSelf.devHistoryGetEnd_HeartInfoTypeBlock)) {
                weakSelf.devHistoryGetEnd_HeartInfoTypeBlock(YES);
            }
        }
        
    }];
    
}
#pragma mark == 设备主动发送的健康数据
 
- (void)getDevSendHealData{
    [[ZHJRealTimeHealthDataProcessor shared]readRealTimeHealthDataWithReadHealthDataHandle:^(ZHJHeartRateDetail * _Nonnull heartRate, ZHJBloodPressureDetail * _Nonnull bp, ZHJBloodOxygenDetail * _Nonnull bo, ZHJStepDetail * _Nonnull step , ZHJTemperatureDetail * _Nonnull temperature) {
        //先后顺序 响应的是temperature 没做now_TempDetailkvo 则在temperature改变所响应的方法中 调用时 需要已经赋值过的now_Temp
        //
        self.showModel.now_HeartRateDetail = heartRate;
        self.showModel.now_BpDetail = bp;
        self.showModel.now_BoDetail = bo;
        //
        self.showModel.heartRete = heartRate.HR;
        self.showModel.bp_bp = bp.DBP;
        self.showModel.bp_sp = bp.SBP;
        self.showModel.bo = bo.BO;
        double vaildTemperature = (temperature.wristTemperature > 0 ? (double)(temperature.wristTemperature/100.0) : (double)(temperature.headTemperature/100.0) );

        //先后顺序 响应的是temperature 没做now_TempDetailkvo 则在temperature改变所响应的方法中 调用时 需要已经赋值过的now_Temp
        self.showModel.now_TempDetail = temperature;
        self.showModel.temperature = vaildTemperature;
        NSLog(@"设备主动发送的健康数据  心率%@ 读取当前体温 %f",heartRate,vaildTemperature);

    }];
}


#pragma mark ===
- (TrusangBlueToothUseShowModel *)showModel{
    if (!_showModel) {
        _showModel = [[TrusangBlueToothUseShowModel alloc]init];
        _showModel.histroy_TempArr = [[NSMutableArray alloc]init];
        _showModel.histroy_HeartRateArr = [[NSMutableArray alloc]init];
        _showModel.histroy_BpSpArr= [[NSMutableArray alloc]init];
        _showModel.histroy_BoArr = [[NSMutableArray alloc]init];
        _showModel.histroy_SleepArr = [[NSMutableArray alloc]init];
    }
    return _showModel;
}
- (NSMutableArray *)scanDevsSaveArr{
    if (!_scanDevsSaveArr) {
        _scanDevsSaveArr = [[NSMutableArray array]init];
    }
    return _scanDevsSaveArr;
}
@end
