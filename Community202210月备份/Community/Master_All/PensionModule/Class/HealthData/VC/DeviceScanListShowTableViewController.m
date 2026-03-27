//
//  DeviceListTableViewController.m
//
//
//  Created by 余莹 on 2021/11/4.
//
//
#import "FBKVOController.h"
#import "NSObject+FBKVOController.h"
//
#import "DeviceScanListShowTableViewController.h"
#import "HealthBaseDataManager.h"
#import "DevGetNowUsersDevInfoModel.h"

#import "DeviceScanListShowVcHeaderView.h"
#import "DeviceScanListShowVcFooterView.h"

#import "DeviceScanListShowTableViewCell.h"
#define  DeviceScanListShowTableViewCell_Identifier       @"DeviceScanListShowTableViewCell"

#import "DeviceMatchingRemoveGuideVC.h"


@interface DeviceScanListShowTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
//
{
    FBKVOController *fbKVO;
}
//
@property (nonatomic,strong) DeviceScanListShowVcHeaderView *headerView;
@property (nonatomic,strong) DeviceScanListShowVcFooterView *footerView;
@property (nonatomic,assign) BOOL touchDevConnectedYesChangeBool;//点击过本页的连接yes
@end

@implementation DeviceScanListShowTableViewController
- (DeviceScanListShowVcHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DeviceScanListShowVcHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    }
    return _headerView;
}
- (DeviceScanListShowVcFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[DeviceScanListShowVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 150)];
        [_footerView.footerShowBtn addTarget:self action:@selector(footerShowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerShowBtnAction{
    [self upSearchDevListData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //本页刷新 可做searchDeviceInfoWithBlock 搜索操作
    self.title = @"智能设备管理";
    [self initView];
    [self addKvo];
    [self addRefresh];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self notHiddenNavigationBar];
}
- (void)initView{
    self.tableView.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self emptyInfoInit];

    
}
- (void)initData{
    if ([TrusangBlueToothSdkDataManager share].scanDevsSaveArr.count>0) {
        self.dataSourceArr = [TrusangBlueToothSdkDataManager share].scanDevsSaveArr;
        [self.tableView reloadData];
    }else{
        [self upSearchDevListData];
    }
}
- (void)addKvo{
    WEAKSELF
    [TrusangBlueToothSdkDataManager share].conectOneDevNotHaveMacBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DeviceMatchingRemoveGuideVC  *vc = [[DeviceMatchingRemoveGuideVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf pushVc:vc];
        });
    }; 
    
    fbKVO = [FBKVOController controllerWithObserver:self];
    //蓝牙设备信息相关监听
    [fbKVO observe:[TrusangBlueToothSdkDataManager share] keyPath:@"nowDevState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change){
        NSLog(@"DeviceScanListShowTableViewController nowDevState有变化   %ld",[TrusangBlueToothSdkDataManager share].nowDevState);
        if (([[change objectForKey:@"new"] intValue] == DeviceStateConnected ) &&  [[change objectForKey:@"new"] intValue] != [[change objectForKey:@"old"] intValue]) {
            [self successGetNewLianJie];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    NSArray *devKeyArr = @[@"connected",
                           @"isConnected"];
    [fbKVO observe:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave  keyPaths:devKeyArr options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        NSLog(@"  change=%@ object=%@ observer%@  |||||keyPath=%@ ",change,object,observer,keyPath);//切换家人时 本isConnected 才会改变
        if (([[change objectForKey:@"new"] boolValue] == YES ) && [[change objectForKey:@"new"] intValue] != [[change objectForKey:@"old"] intValue]) {
            [self successGetNewLianJie];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    [fbKVO observe:[TrusangBlueToothSdkDataManager share]  keyPath:@"scanDevsSaveArr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        NSLog(@"  change=%@ object=%@ observer%@  |||||keyPath=%@ ",change,object,observer,keyPath);//切换家人时 本isConnected 才会改变
       //新数据更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
- (void)successGetNewLianJie{
    //发送震动
    [[TrusangBlueToothSdkDataManager share]findDeviceAction];
    [[TrusangBlueToothSdkDataManager share]sendVibrateAction];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        Y_SVP_SHOW_SUCCESS_MES_5Delay(@"正在读取手环设备数据，请等待");
        Y_SVP_SHOW_MES_10Delay(@"正在读取手环设备数据,请等待"); 
    });
 
    
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upSearchDevListData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)upSearchDevListData{
    WEAKSELF
    [[TrusangBlueToothSdkDataManager share]backgroundKeepsBlueDevScanningWhenNowDevStateNotCare];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
    });
    /**
     [[TrusangBlueToothSdkDataManager share]searchDeviceInfoWithBlock:^(NSArray<ZHJBTDevice *> * _Nullable arr, BOOL success) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.tableView.mj_header endRefreshing];
         });
         if (success) {
             NSLog(@"%@",arr);
             [self.dataSourceArr addObjectsFromArray:arr];
  
             NSLog(@"本次总搜索后 累加结果 ");
            // NSMutableArray *resultArr = [NSMutableArray arrayWithArray:self.dataSourceArr];
             for (int i = 0; i < self.dataSourceArr.count; i++) {
                 for (int j = i+1; j < self.dataSourceArr.count; j++) {
                     ZHJBTDevice *devOne = self.dataSourceArr[i];
                     ZHJBTDevice *devOther = self.dataSourceArr[j];
                     if ([devOne.mac isEqualToString:devOther.mac]) {
                         [self.dataSourceArr removeObjectAtIndex:j];
                         j-=1;//删除本个j，角标上移 重复本个j
                         NSLog(@"已经有过 重复的 dev == %@", devOne.name );
                     }
                 }
             }
             NSLog(@"本次总搜索后 累加结果 end");
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.tableView reloadData];
             });
         }
       
     }];
     */
    
}
#pragma mark - Table view data source

#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceScanListShowTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:DeviceScanListShowTableViewCell_Identifier];
    if (!cell) {
        cell = [[DeviceScanListShowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DeviceScanListShowTableViewCell_Identifier];
    }
    
    ZHJBTDevice *devic = self.dataSourceArr[indexPath.row];
    [cell fillDataWithDev:devic];
    cell.saveOldDevState = self.saveOldDevState;
    cell.touchDevConnectedYesChangeBool = self.touchDevConnectedYesChangeBool;
    cell.clickBtnBlock = ^(ZHJBTDevice * _Nonnull dev) {
        if (isNotNil(dev)) {
            [self touchCellRightBtnWithDev:dev];
        }
    };
//    if ( [devic.uuid isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.uuid] ) {
//        switch ([TrusangBlueToothSdkDataManager share].nowDevState) {
//            case DeviceStateConnected:
//                cell.detailTextLabel.backgroundColor = [UIColor greenColor];
//                break;
//            case DeviceStateDefault:
//                cell.detailTextLabel.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];
//                break;
//            case DeviceStateDisconnected:
//                cell.detailTextLabel.backgroundColor = [UIColor orangeColor];
//                break;
//            default:
//                cell.detailTextLabel.backgroundColor = [UIColor orangeColor];
//                break;
//        }
//
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHJBTDevice *devic = self.dataSourceArr[indexPath.row];
    
    NSString *nameStr = [NSString stringWithFormat:@"设备名: %@",devic.name];
    NSString *macStr = [NSString stringWithFormat:@"设备mac: %@",devic.mac];
    UIAlertController *showDevAlertC = [UIAlertController alertControllerWithTitle:nameStr message:macStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [showDevAlertC addAction:cancleAction];
    [self presentViewController:showDevAlertC animated:YES completion:nil];
}
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}

 
#pragma mark ==
//重连或者点击连接
- (void)touchCellRightBtnWithDev:(ZHJBTDevice *)dev{
    if (!self.isOwnBool) {
        Y_SVP_SHOW_INFO_MES_5Delay(@"不允许连接。\n 不能更换他人所绑定连接的设备。\n 仅能处理自己的绑定连接设备");
        return;
    }
    NSString *titleStr =  [@"确认连接设备:" stringByAppendingString:[TextShowWithModelStr textShowWithModelStr:dev.name]];
    AlertManager *alert = [[AlertManager shareManager] creatAlertWithTitle:titleStr message:@"" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitleArr:@[@"连接"].mutableCopy];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == AlertManagerCancelIndex) {
            NSLog(@"取消按钮");
        }else{
            self.touchDevConnectedYesChangeBool = YES;//
            [self chooseNewDevToConnectWithDev:dev];
        }
    }];
    
}
- (void)chooseNewDevToConnectWithDev:(ZHJBTDevice *)dev{
    /**
     dev数据mac来判断是否为同一个？ mac空 问题 更换为 name
     用name
     */

    if ([dev.name isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name] ) {
        //重连
        switch ([TrusangBlueToothSdkDataManager share].nowDevState) {//"连接失败！"重新连接"
            case DeviceStateDisconnected:
            {
                //主动重连 开始旋转 (成功失败后的回调)
                /**
                 [[TrusangBlueToothSdkDataManager share]reConNowDev];
                 [self.headerView.rightIndicatorView startAnimating];
                 */
                //缺回调 则用主动连接处理 不使用重连
                [self gotoConDev:dev];
            }
                break;
            case DeviceStateConnected:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerView showWithEndConnectBool:YES];
                });
              
                
            }
                break;
            default:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.headerView showWithEndConnectBool:NO];
                });
            }
               
                break;
        }
        
    }else{
        if (!self.isOwnBool) {
            Y_SVP_SHOW_INFO_MES_5Delay(@"不允许连接。\n 不能更换他人所绑定连接的设备。\n 仅能处理自己的绑定连接设备");
            return;
        }
        if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
            Y_SVP_SHOW_INFO_MES_5Delay(@"请去设备主页 主动断开连接");
            return;
        }
        //一个账号下可以多个dev绑定 1129不做解绑 做数据上传(不必须)  传完旧设备数据后 断开旧设备 再绑定新设备 做设备切换
        //非同一个dev号 先离线+解绑 再连接新号新号自带判断绑定操作
        if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
            [[ZHJBLEManagerProvider shared] disconnectDeviceWithDisconnect:^(CBPeripheral * _Nonnull info) {
                DLog(@"3断开设备 %@",info);
                [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected = NO;
                [TrusangBlueToothSdkDataManager share].nowDevState = DeviceStateDisconnected;
                [self gotoConDev:dev];
                
            }];
        
       
            
            /**
             [[TrusangBlueToothSdkDataManager share] disConnectDev];
             [[HealthBaseDataManager share]removebindIngDevWithUserId:self.nowUserId withDevAddress:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
                 if (success) {
                     [self gotoConDev:dev];
                 }else{
                     Y_SVP_SHOW_ERR_MES(@"解绑旧设备失败，无法为新设备做绑定，仅能连接新设备。");
                 }
             }];
             */
        }else{
            [self gotoConDev:dev];
        }
      
    }
}
- (void)gotoConDev:(ZHJBTDevice *)dev{
    [[TrusangBlueToothSdkDataManager share] stopScanDev];//停止搜索
    [self changeOtherDevToCleaningOldData];//情况数据
    //主动去连接
    [TrusangBlueToothSdkDataManager share].nowDevState = DeviceStateConnecting;
    [self.headerView showWithEndConnectBool:NO];//header
    [self.tableView reloadData];//cell
    [[TrusangBlueToothSdkDataManager share]connectDevice:dev withConnetStatuBlock:^(ConnectDev_State devState) {
        [TrusangBlueToothSdkDataManager share].nowDevState = devState;
        [self.headerView showWithEndConnectBool:YES];
     
         switch (devState) {
             case ConnectDev_State_Success:
             {
                 Y_SVP_SHOW_SUCCESS_MES(@"设备连接成功！");
                 
                  //判断新连接设备 和当前userid 所对应的绑定设备信息是否一样 一样就不做绑定 不一样则需绑定(不做userid的共同判断 只做当前设备的判断即可 本列表 mac空的数据已经被去重了)
//                 NSString *managerDevAddress = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic[@"mdeviceAddress"]];
                 NSString *managerDevAddress = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress];//常用的 被新绑定后才会替换掉 可用

                 //[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserId 不变 旧的健康数据可以沿用旧设备数据， 更改绑定的设备数据即可
                 NSString *dName = [NSString stringWithFormat:@"%@",dev.name];
                 __block NSString *dAddress = [NSString stringWithFormat:@"%@",dev.mac];
//                 if (dAddress.length<=0) {
//                     [[TrusangBlueToothSdkDataManager share]getDevWhenIsOneLineWithThisDevInfoWithDev:^(BOOL success, ZHJBTDevice * _Nonnull nowContentedDevSelfInfo) {
//                         if (success) {
//                             dAddress = nowContentedDevSelfInfo.mac;
//                         }
//                     }];
//                 }
                 if (dAddress.length<=0 || isNil(dAddress)) {
                     dAddress = [[TrusangBlueToothSdkDataManager share]getDevMacStrOfNowSaveBlueScanArrWithOneDevUseNameStr:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave];
                 }
                
                 NSString *dVersion = [NSString stringWithFormat:@"%@",dev.version].length>0 ? [NSString stringWithFormat:@"%@",dev.version] :@"1.0";
                 //familyMemberId 不变
                 [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = dName;
                 [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = dAddress;
                 [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceVersion = dVersion;
                 //familyMemberId 不变
                 [[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic setValue:dName  forKey:@"mdeviceName"];
                 [[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic setValue:dAddress  forKey:@"mdeviceAddress"];
                 [[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic setValue:dVersion forKey:@"mdeviceVersion"];
                 NSLog(@" managerDevAddress = %@ , dAddress = %@",managerDevAddress,dAddress);
                 if (isNotNil(self.oneDevicConnectedOkBlock)) {
                     self.oneDevicConnectedOkBlock(dev);//通知主页连了一个设备（无论是否绑定 都要做切换连接 ，旧的changeOtherDevToCleaningOldData掉了 所以a切换a也做）
                 }
                 if ( ![managerDevAddress isEqualToString: dAddress]) {

                     if (dAddress.length<=0) {
                         NSLog(@"新设备 旧userid 需要提交绑定数据 但mac空 不做处理");
                     }else{
                         //每次设备上线 会触发主页对于绑定的相关判断和绑定调用 本处无需
//                         [[HealthBaseDataManager share]bindIngDevWithUserId:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserId withDevName:dName withDevAddress:dAddress withDevVersionStr:dVersion];

                     }
                 }else{
                     NSLog(@"已经绑定过了 是旧的已绑定的设备数据 不需要绑定");
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];//cell
                 });
             }
                 break;
             case ConnectDev_State_Fail:
             {
                 Y_SVP_SHOW_ERR_MES(@"设备连接失败！");
             }
                 break;
             case ConnectDev_State_OutTime:
             {
                 Y_SVP_SHOW_ERR_MES(@"设备连接超时！");
             }
                 break;
                 
             default:
                 break;
         }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];//cell
        });
       
          
    }];
    
}

#pragma mark ==

- (void)changeOtherDevToCleaningOldData{
    //更设备 不切换人
 
    /**
     //扫描的蓝牙设备arr不能删除  需要使用
     */
    [TrusangBlueToothSdkDataManager share].showModel.histroy_TempArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_HeartRateArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr= [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave = [[ZHJBTDevice alloc]init];
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac = @"";
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name = @"";
    [TrusangBlueToothSdkDataManager share].nowDevState = DeviceStateDefault;
    NSLog(@"设备清空 %@｜  扫描的蓝牙设备arr不能删除  需要使用 %@", [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave,[TrusangBlueToothSdkDataManager share].scanDevsSaveArr);

    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @"";
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
}


#pragma mark ==  无数据占位 协议
- (void)emptyInfoInit{
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}
#pragma mark - 文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"暂未发现任何设备\n请检查蓝牙是否打开或在连接范围内";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0x6E727D)
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
#pragma mark - 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"yl_sheb_nothing"];//Nomal_ZeroWidthIcon
}
#pragma mark - 中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.tableView.tableHeaderView.height * 0.5;
}
// 是否允许滚动 ｜有数据能正常下拉刷新 空数据时 无法下拉动作 设置yes即可正常
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark -  无数据占位 end
@end
