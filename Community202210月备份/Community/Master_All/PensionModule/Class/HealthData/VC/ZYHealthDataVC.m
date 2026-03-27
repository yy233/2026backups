//
//  ZYHealthDataVC.m
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import "ZYHealthDataVC.h"
#import "ZYHealthDataTopView.h"
#import "ZYHealthDataContentHeaderView.h"
#import "ZYHealthDataContentFooterView.h"
#import "ZYHealthDataContentCell.h"
#import "ZYHealthDataDeviceHeaderView.h"
#import "ZYHealthDataDeviceFooterView.h"
#import "ZYHealthDataDeviceCell.h"
#import "ZYHealthDataEmptyDeviceCell.h"
#import "PopViewWithHealthMainVcBottomChangeFamily.h"
#import "DeviceScanListShowTableViewController.h"

#import "HealthBaseDataManager.h"
#import "HealthBaseDataSaveNowUseModel.h"

#import "DeviceMatchingRemoveGuideVC.h"

#import "MedicalWebViewVc.h"


static NSString * const healthDataContentCellID = @"ZYHealthDataContentCell";
static NSString * const healthDataDeviceCellID = @"ZYHealthDataDeviceCell";
static NSString * const healthDataEmptyDeviceCellID = @"ZYHealthDataEmptyDeviceCell";
#define kHealthDataTopViewHeight status_height+140
#define kHealthDataContentHeaderViewHeight 80
#define kHealthDataContentFooterViewHeight 65
#define kHealthDataContentFooterViewEmptyHeight 15
#define kHealthDataContentCellHeight 108
#define kHealthDataDeviceHeaderViewHeight 55
#define kHealthDataDeviceFooterViewHeight 130
#define kHealthDataDeviceCellHeight 90
#define kHealthDataEmptyDeviceCellHeight 75

#define Row_Num_Headerate    0
#define Row_Num_Sleep        1
#define Row_Num_Tempe        2

@interface ZYHealthDataVC () <UITableViewDataSource, UITableViewDelegate, ZYHealthDataTopViewDelegate, ZYHealthDataContentHeaderViewDetegate, ZYHealthDataContentFooterViewDelegate, ZYHealthDataDeviceHeaderViewDelegate, ZYHealthDataDeviceFooterViewDelegate, ZYHealthDataEmptyDeviceCellDelegate, BasePopTableViewChooseDelegate>
//
{
    FBKVOController *fbKVO;
}
//
@property (nonatomic, strong) ZYHealthDataTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYHealthDataContentHeaderView *contentHeaderView;

@property (nonatomic, strong) ZYHealthDataContentFooterView *contentFooterView;

@property (nonatomic, strong) ZYHealthDataDeviceHeaderView *deviceHeaderView;

@property (nonatomic, strong) ZYHealthDataDeviceFooterView *deviceFooterView;

@property (nonatomic, strong) PopViewWithHealthMainVcBottomChangeFamily *popViewChangeFamily;
@property (nonatomic, strong) NSMutableArray *saveFamilysArr;
@property (nonatomic, strong) ZYFamilyArchiveModel *saveNowUserModel;
// 健康数据数组
@property (nonatomic, strong) NSMutableArray *healthDataArray;//默认初始化数据时
// 主三个数据 仅显示用的数据值存储
@property (nonatomic, strong) NSMutableArray *healthDataOnlyMainNumArray;//心率次数，睡眠小时，体温度数三个数据；
// 主三个数据 健康状态记录值
@property (nonatomic, strong) NSMutableArray *healthStatusSaveArray;//本数据给cell做颜色处理使用

@property (nonatomic,strong) NSString *thisViewUseUserId;

@property (nonatomic,assign) BOOL isGetDeletConnedDevNoticeType;//历史列表删除了在线设备时使用的UI更新判断键
@end

@implementation ZYHealthDataVC

- (NSMutableArray *)saveFamilysArr{
    if (!_saveFamilysArr) {
        _saveFamilysArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveFamilysArr;
}
- (PopViewWithHealthMainVcBottomChangeFamily *)popViewChangeFamily{
    _popViewChangeFamily = [[PopViewWithHealthMainVcBottomChangeFamily alloc]init];
    _popViewChangeFamily.delegate = self;
    return _popViewChangeFamily;
}
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"切换家人回调数据");
    /**
     
     //test 对着切换
     NSString *mainUserId = @"118830550621491200";
     NSString *newChooseUserId = @"117839044238512128";
     
     if ([self.thisViewUseUserId  isEqualToString:mainUserId]) {
         [self changeNewId:newChooseUserId];
     }else if([self.thisViewUseUserId  isEqualToString:newChooseUserId]){
         [self changeNewId:mainUserId];
     }
     */
    ZYFamilyArchiveModel *model =  self.saveFamilysArr[indexPath.row];
    //NSString *newChooseUserId = model.ID;//uid
    NSString *newChooseUserId = model.uid;//uid
    if ([newChooseUserId isEqualToString:self.thisViewUseUserId]) {//同一个人不做处理
        return;
    }else{ //有数据的时候刷新 或 切换家人后有别的ID时 匹配对应id的数据
        self.saveNowUserModel = model;
        [self changeNewId:newChooseUserId];
        //更新topUI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.topView setNowShowUserModel:self.saveNowUserModel];
        });
      
    }
    
}
- (void)changeNewId:(NSString *)newId{
    NSLog(@"切换家人 新id= %@",newId);
    Y_SVP_SHOW_INFO_MES(@"*** 切换中  ***");
    NSLog(@"*** 设备主动 断开连接 ***");
    [[TrusangBlueToothSdkDataManager share]disConnectDev];
    self.thisViewUseUserId = newId;
 
    //换一个id做连接
    [self initData];
 
  
}
- (NSString *)thisViewUseUserId{
    if (!_thisViewUseUserId) {
//        _thisViewUseUserId  = [ShareUserInfo sharedUserInfo].userInfo.uid;
        _thisViewUseUserId = @"";//用家属列表中 oneself=1 的对应数据ID
    }
    return _thisViewUseUserId;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ( ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected ) {//不在线
        [[TrusangBlueToothSdkDataManager share]backgroundKeepsBlueDevScanning];//后台扫蓝牙设备
    }
   
    
    self.view.backgroundColor = Y_RGBA(240, 241, 246, 1);
    [self setUI];
    [self customTableView];
    //
    [self addKvo];
    [self addNoitice];//删除了在线设备时 做相关清空 主initdata
    //
    [self initData];
    [self addRefresh];

}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshBlueToothDevInfo)];
    self.tableView.mj_header = headeerRefresh;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];//搜索界面 改变了设备 回来后组二的数据更新等
    [self reRefrehFamilesArr];//
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kHealthDataTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYHealthDataTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYHealthDataTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
        [_topView setTopViewStatusWithRefreshDataTimeStr:@"" andHealthShowType:HealthShow_Type_Good];
    }
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (ZYHealthDataContentHeaderView *)contentHeaderView {
    if (!_contentHeaderView) {
        _contentHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYHealthDataContentHeaderView" owner:nil options:nil].lastObject;
        _contentHeaderView.delegate = self;
    }
    
    return _contentHeaderView;
}

- (ZYHealthDataContentFooterView *)contentFooterView {
    if (!_contentFooterView) {
        _contentFooterView = [[NSBundle mainBundle] loadNibNamed:@"ZYHealthDataContentFooterView" owner:nil options:nil].lastObject;
        _contentFooterView.delegate = self;
    }
    
    return _contentFooterView;
}

- (NSMutableArray *)healthDataArray {
    if (!_healthDataArray) {
        _healthDataArray = [NSMutableArray array];
    }
    
    return _healthDataArray;
}
- (NSMutableArray *)healthStatusSaveArray{
    if (!_healthStatusSaveArray) {
        _healthStatusSaveArray = [NSMutableArray array];
    }
    return _healthStatusSaveArray;
}
- (NSMutableArray *)healthDataOnlyMainNumArray{
    if (!_healthDataOnlyMainNumArray) {
        _healthDataOnlyMainNumArray = [NSMutableArray array];
    }
    return _healthDataOnlyMainNumArray;;
}

- (ZYHealthDataDeviceHeaderView *)deviceHeaderView {
    if (!_deviceHeaderView) {
        _deviceHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYHealthDataDeviceHeaderView" owner:nil options:nil].lastObject;
        _deviceHeaderView.delegate = self;
    }
    
    return _deviceHeaderView;
}

- (ZYHealthDataDeviceFooterView *)deviceFooterView {
    if (!_deviceFooterView) {
        _deviceFooterView = [[NSBundle mainBundle] loadNibNamed:@"ZYHealthDataDeviceFooterView" owner:nil options:nil].lastObject;
        _deviceFooterView.delegate = self;
    }
    
    return _deviceFooterView;
}

#pragma mark - 加载数据
//非初始 有旧数据 未知是否有家人数据更新做 家人列表数据请求 替换掉原本家人数据
- (void)reRefrehFamilesArr{
    if (self.saveFamilysArr.count <= 0) {
        return;
    }
    WEAKSELF
    [[HealthBaseDataManager share] getFamileWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        if (success) {
            if (arr.count>0) {//有数据 做整个家人list数据量替换
                weakSelf.saveFamilysArr = [NSArray yy_modelArrayWithClass:[ZYFamilyArchiveModel class] json: arr].mutableCopy;
                     if (weakSelf.saveFamilysArr.count>0) {//有数据
                      //已经有的数据更新 主（头像昵称）
                        for (int i = 0; i < weakSelf.saveFamilysArr.count ; i++) {
                            ZYFamilyArchiveModel *model =   weakSelf.saveFamilysArr[i];
                            if ([model.uid isEqualToString:weakSelf.thisViewUseUserId]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [weakSelf.topView setNowShowUserModel:model];
                                });
                             
                            }
                        }
                      
                    }
            }
        }
    }];
}
- (void)initData {
    NSArray *iconImageNameArray = @[@"yl_heart", @"yl_sleep", @"yl_temper"];
    NSArray *titleArray = @[@"心率", @"睡眠", @"体温"];
    NSArray *subTitleArray = @[@"检测心率，呵护您的健康。", @"健康睡眠质量，科学睡眠。", @"健康体温，保护您的健康。"];
    self.healthStatusSaveArray = @[@(0),@(0),@(0)].mutableCopy;//未知状态0 123优良差
    self.healthDataOnlyMainNumArray =  @[@(0),@(0),@(0)].mutableCopy;
    self.healthDataArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < iconImageNameArray.count; i++) {
        ZYHealthDataContentModel *model = [[ZYHealthDataContentModel alloc] init];
        model.iconImageName = iconImageNameArray[i];
        model.title = titleArray[i];
        model.subTitle = subTitleArray[i];
        [self.healthDataArray addObject:model];
    }
    [self.tableView reloadData];

    //
    if (self.saveFamilysArr.count<=0) {//初始状态 无数据 需要自己的id走初始数据
        WEAKSELF
        [[HealthBaseDataManager share] getFamileWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
            if (success) {
                 weakSelf.saveFamilysArr = [NSArray yy_modelArrayWithClass:[ZYFamilyArchiveModel class] json: arr].mutableCopy;
                 if (weakSelf.saveFamilysArr.count>0) {//有数据
                  
                    for (int i = 0; i < weakSelf.saveFamilysArr.count ; i++) {
                        ZYFamilyArchiveModel *model =   weakSelf.saveFamilysArr[i];

                            //第一次加载本数据时 没有当前ID 使用self的数据
                             if (model.oneself) {//自己
                                 weakSelf.saveNowUserModel = model;
                                 weakSelf.thisViewUseUserId =  weakSelf.saveNowUserModel.uid;
                                 [weakSelf initSubData];
                             }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.topView setNowShowUserModel:weakSelf.saveNowUserModel];
                        });
                        
                       
                    }
                  
                }
            }
        }];
    }else{//已经有过数据
        [self initSubData];
    }
  
   
   
}
- (void)initSubData{
    NSLog(@"initSubData 当前用户ID = %@",self.thisViewUseUserId);
    [self initDevAllData];
    [self initNetAllData];
    
}
- (void)initDevAllData{
    if (self.saveNowUserModel.oneself) {
        if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
            //连接状态
            [self initGetUserNetBindDevData];
            [self initGetDevBaseInfo];
         
        }else{
            //没有连接
            [self initGetUserNetBindDevData];
        }
    }else{
        //清空当前Dev相关数据（切换时已经清空)
        //不允许连接他人设备 即 不允许自己数据的上传到他人表里面 （断连接）
        [[TrusangBlueToothSdkDataManager share] disConnectDev];
        [self initGetUserNetBindDevData];
        
        NSLog(@"切换到家人状态，不做设备相关连接传输 ，只做网络数据处理");
    }
    
}
- (void)initNetAllData{
    if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
        //连接状态
        [self initUserHealthData];
    }else{
        //没有连接
        [self initUserHealthData];
    }
   
}
- (void)initGetUserNetBindDevData{
    NSLog(@"网络加载用户信息 initUserSaveDevData");
    WEAKSELF
    [[HealthBaseDataManager share]getUserDevInfoWithGetDevDicInfoBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            NSLog(@" initUserSaveDevData == %@",dic);
            if ([dic allKeys].count==0) {//空数据状态 做初始值 （防止旧值在本manager处占位）
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @"";
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceVersion = @"";
                
            }else{
                //得到改变后 则做连接 这个 蓝牙设备
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [DevGetNowUsersDevInfoModel  mj_objectWithKeyValues:  [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic];
            }
            NSLog(@"initUserSaveDevData 改变后 nowUserInfoAndHealthSaveModel =%@ %@ ", [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress,[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName);
            if (self.saveNowUserModel.oneself==YES) {//自己
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserInfoChangeBool = YES;//响应不响应问题
            }else{//家人
                //不做连接（初始刷新数据后会有重连调用） 只做加数据
                [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserInfoChangeBool = NO;
            }
           
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
      
    }  withOneUserId: self.thisViewUseUserId];
  
}
- (void)initUserHealthData{
    WEAKSELF
    //获取最近的健康信息 success则已经保存过展示信息  处理完成后刷新即可
    [[HealthBaseDataManager share] getUserRecentHealthWithInfoWithUserId:self.thisViewUseUserId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if ([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.silentHeart>0) {
                [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Headerate withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.silentHeart)];//心率
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.silentHeartHealthStatus)];//状态
                
            }
            if ([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.sleepTime>0) {
                //睡眠 Row_Num_Sleep 时间格式待定
                [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Sleep withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.sleepTime)];
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Sleep withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.sleepHealthStatus)];
            }
           /**
            手腕体温
            额头体温
            使用温度高的做本页数据显示*/
            if (([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpHandler > 0) || ([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpForehead > 0)) {
                BOOL isUseHeaderTmpe = NO;
                if ([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpHandler < [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpForehead) {
                   isUseHeaderTmpe = YES;
                }
                if (isUseHeaderTmpe) {
                    [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Tempe withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpForehead)];
                    [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpForeheadHealthStatus)];
                }else{
                    [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Tempe withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpHandler)];
                    [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@([HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.tmpHandlerHealthStatus)];
                }
            }

            NSString *refteshDataTimeStr = [TextShowWithModelStr textShowWithNotNullStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.refreshDataTime];
            NSInteger userTotalHealthStatus = [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.userTotalHealthStatus;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                //根据网络数据更新主状态
                [weakSelf.topView setTopViewStatusWithRefreshDataTimeStr:refteshDataTimeStr andHealthShowType: userTotalHealthStatus];
//                //根据本地数据更新主要状态
//                [weakSelf upTopViewStatus];
            });
        }
    }];
}
- (void)refreshBlueToothDevInfo{
    if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length <= 0) {//没设备 新用户没绑定设备｜没取到设备信息
        [self initData];
        [self.tableView.mj_header endRefreshing];
        return;
    }else{//有设备 有用户 当前网络信息+做连接 请求设备实时等信息
        [self initUserHealthData];
        [self refreshDevInfoWithSelfDevStatus];
    }
}
- (void)refreshDevInfoWithSelfDevStatus{
    if (self.saveNowUserModel.oneself==NO) {//家人数据 不可做连接
        return;
    }
    if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDisconnected ){
        //有数据离线不在线
        //有切换 离线后不要直接做重连 要判断是否才切换家人后的数据 （对应设备是否一个 是同一个设备离线 才能调用重连）
       
        //Y_SVP_SHOW_MES_5Delay(@"重连ing")
        if ([[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress isEqualToString:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac]) {
            NSLog(@"（对应设备是否一个 是同一个设备离线 才能调用重连）");
            [[TrusangBlueToothSdkDataManager share]reConNowDev];//重连
        }else{
            NSLog(@"（对应设备不一个设备 离线 不能调用重连 需要主动连接 ");
            if (  [TrusangBlueToothSdkDataManager share].scanDevsSaveArr.count <=0 ) {
                 //开启1s/次的扫描蓝牙
                [self scanDevAndDontGoToScanListVc];
            }else{
                 //开启1s/次的扫描蓝牙
                [self scanDevAndDontGoToScanListVc];
            }
            ZHJBTDevice *getDev = [[ZHJBTDevice alloc]init];
            getDev.name = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName];
            getDev.mac = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress];
            getDev.version = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceVersion];
            if (getDev.name.length>0 && getDev.mac.length>0) {
                [self haveChooseDevToConnectWithDev:getDev];
                NSLog(@"连接新设备 %@ %@ ",getDev.name,getDev.mac);
            }else{
                NSLog(@"新设备 数据空 不做连接");
            }
       
        }
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDefault && [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected ){
        
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDefault && ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected ){
        //初始化状态 搜索完成后设置的DeviceStateDefault的状态
        DLog(@"初始化状态 搜索完成后设置的DeviceStateDefault的状态 不做处理");
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnected && [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected){
        //在线 加载刷新数据
        Y_SVP_SHOW_MES_5Delay(@"加载数据ing")
        [self initGetDevBaseInfo];
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnected && ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected){
        // 没在线
        Y_SVP_SHOW_MES_5Delay(@"加载数据ing")
        ZHJBTDevice *getDev = [[ZHJBTDevice alloc]init];
        getDev.name = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName];
        getDev.mac = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress];
        getDev.version = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceVersion];
        if (getDev.name.length>0 && getDev.mac.length>0) {
            [self haveChooseDevToConnectWithDev:getDev];
            NSLog(@"连接新设备 %@ %@ ",getDev.name,getDev.mac);
        }else{
            NSLog(@"新设备 数据空 不做连接");
        }
        [self initGetDevBaseInfo];
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateSearching){
        NSString *showStr = [NSString stringWithFormat:@"搜索中 %@",[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName];
        Y_SVP_SHOW_MES_5Delay(showStr);
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnecting){
        NSString *showStr = [NSString stringWithFormat:@"连接中 %@",[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName];
        Y_SVP_SHOW_MES_5Delay(showStr);
        if (  [TrusangBlueToothSdkDataManager share].scanDevsSaveArr.count <=0 ) {//开启1s/次的扫描蓝牙
            [self scanDevAndDontGoToScanListVc];
        }
        [self initData];//连接
    }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length == 0){
        NSLog(@"name 长度0 不符合重连所需 不做重连");
    }else{
        Y_SVP_SHOW_ERR_MES(@"不符合重连所需 不做重连");
        NSLog(@"不符合重连所需 不做重连");
      
    }
    [self.tableView.mj_header endRefreshing];
 
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:healthDataContentCellID bundle:nil] forCellReuseIdentifier:healthDataContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:healthDataDeviceCellID bundle:nil] forCellReuseIdentifier:healthDataDeviceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:healthDataEmptyDeviceCellID bundle:nil] forCellReuseIdentifier:healthDataEmptyDeviceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.healthDataArray.count;
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYHealthDataContentCell *cell = [tableView dequeueReusableCellWithIdentifier:healthDataContentCellID forIndexPath:indexPath];
        ZYHealthDataContentModel *model = self.healthDataArray[indexPath.row];
        cell.model = model;
        //健康状态颜色
        [cell changeCellHealthStatusWithType:[self.healthStatusSaveArray[indexPath.row] integerValue]];
        [cell setCellShowNum:self.healthDataOnlyMainNumArray[indexPath.row]];
        
        return cell;
    }else {
        NSString *healthGetDevMacStr = [TextShowWithModelStr textShowWithNotNullStr: [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName ];
        NSString *devNameStr = [TextShowWithModelStr textShowWithNotNullStr: [TrusangBlueToothSdkDataManager share].showModel.saveNowDevName ];
        NSLog(@"cell section_dev healthGetDevMacStr=%@ devNameStr=%@",healthGetDevMacStr,devNameStr);
        if ( healthGetDevMacStr.length >0 || devNameStr.length > 0) {
            //已经绑定有设备情况
            WEAKSELF
            ZYHealthDataDeviceCell *cell =  [tableView dequeueReusableCellWithIdentifier:healthDataDeviceCellID forIndexPath:indexPath];
            NSString *netSaveDevNameStr =  healthGetDevMacStr;
            //
            if ([netSaveDevNameStr isEqualToString:@"(null)"]) {
                netSaveDevNameStr = @"";
            }
            if ([devNameStr isEqualToString:@"(null)"]) {
                devNameStr = @"";
            }
            if ([devNameStr isEqualToString:netSaveDevNameStr]) {
                [cell nowDevNameSet:devNameStr];
                
            }else if(netSaveDevNameStr.length>0 && (devNameStr.length<=0 || [devNameStr isEqualToString:@""] || [devNameStr isEqualToString:@"(null)"])){//当前没在线设备  初始状态连接中 （绑定设备有数据 当前设备空 使用绑定设备数据）|(null)后台数据存储问题
                [cell nowDevNameSet:netSaveDevNameStr];
            }else{
                if (self.saveNowUserModel.oneself == NO) {
                    [cell nowDevNameSet:netSaveDevNameStr];//（用网络的接口拿到的设备名字 家人设备不会去主动连接 不能用蓝牙管理中的名字）
                }else{
                    if (self.isGetDeletConnedDevNoticeType) {//历史列表删除断开的是当前连接的那个设备 在新数据未连接前 本键yes 一直为网络名字
                        [cell nowDevNameSet:netSaveDevNameStr];
                    }else{
                        [cell nowDevNameSet:devNameStr];//（切换设备前后时 使用当前设备名 （绑定设备旧数据会被置为空 12中旬后不会滞空了，家人设备不去替换 ）自己设备保留在蓝牙管理中 ）
                    }
                   
                }
              
            }
           
            cell.disConBtn.hidden = ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected;
            cell.disConActionBlock = ^{
                [weakSelf cellTouchDisConDevWithCleaningOldData];
            };
            return cell;
        }else{ 
            //未绑定
            ZYHealthDataEmptyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:healthDataEmptyDeviceCellID forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }

    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
     
        return kHealthDataContentCellHeight;
    }else {
        
        return kHealthDataEmptyDeviceCellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
     
        return self.contentHeaderView;
    }else {
        if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {//离线状态做显示 才能点列表 做设备切换
            [self.deviceHeaderView devSectonHeaderViewShowThisRightBtnBool:NO];
        }else{
            [self.deviceHeaderView devSectonHeaderViewShowThisRightBtnBool:YES];
        }
        return self.deviceHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
     
        return kHealthDataContentHeaderViewHeight;
    }else {
        
        return kHealthDataDeviceHeaderViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        //        /连接 或 连接后断开才有的设备数据
        NSString *healthGetDevMacStr = [TextShowWithModelStr textShowWithNotNullStr:  [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress ];
        if ( healthGetDevMacStr.length >0) {
            //已经绑定有设备情况
            return [UIView new];
        }else{
            return self.contentFooterView;
        }
    
    }else {
        
        return self.deviceFooterView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
     
        if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0) {
            return kHealthDataContentFooterViewHeight;
        }else{
            return kHealthDataContentFooterViewHeight;
        }
     
    }else {
        
        return kHealthDataDeviceFooterViewHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //查看历史记录+ 上传历史记录
        switch (indexPath.row) {
            case Row_Num_Headerate:
            {
                [self sendHistory_HeartRate];
                //[self lookHistory_Bp];//暂时不传这个数据
                //[self lookHistory_Bo];
                HealthHeartTotalVc *vc = [[HealthHeartTotalVc alloc]init];
                vc.nowUserId = self.thisViewUseUserId;
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
                
            }
                break;
            case Row_Num_Sleep:
            {
                [self sendHistory_sleep];
                HealthSleepTotalVc *vc = [[HealthSleepTotalVc alloc]init];
                vc.nowUserId = self.thisViewUseUserId;
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Row_Num_Tempe:
            {
          
                
                [self sendHistory_Temp];
                HealthTemperatureTotalVc *vc = [[HealthTemperatureTotalVc alloc]init];
                vc.nowUserId = self.thisViewUseUserId;
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
                
            default:
                break;
        }
        
        ZYHealthDataContentModel *model = self.healthDataArray[indexPath.row];
        NSLog(@"didSelectRowAtIndexPath == %@", model.title);
//        if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
//        }
    }else {
        NSLog(@"设备");
        //断开
        if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDisconnected ){
            //有数据离线不在线
            NSLog(@"返回 __（ 设备不在线 或 无设备 ）***  不断开  ***");
        }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDefault && [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected){
            //已经连接 但做过搜索 不需要改任何数据
//            [[TrusangBlueToothSdkDataManager share]disConnectDev];
//            NSLog(@"初始化状态 搜索完成后设置的DeviceStateDefault的状态 ｜｜｜ *** 设备主动 断开连接 ***");
            
        }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateDefault && (![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) ){
            // 搜索完成后设置的DeviceStateDefault的状态 不在线
            //重连操作
            [[TrusangBlueToothSdkDataManager share] reConNowDev];
        
        }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnected ){//在线状态
            //发送震动
            [[TrusangBlueToothSdkDataManager share]findDeviceAction];
            [[TrusangBlueToothSdkDataManager share]sendVibrateAction];
           
        }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateSearching){
            NSString *showStr = [NSString stringWithFormat:@"搜索中 %@",[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName];
            Y_SVP_SHOW_MES_5Delay(showStr);
        }else  if ([TrusangBlueToothSdkDataManager share].showModel.saveNowDevName.length>0  && [TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnecting){
            NSString *showStr = [NSString stringWithFormat:@"连接中 %@",[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName];
            Y_SVP_SHOW_MES_5Delay(showStr);
        }else{
            //Y_SVP_SHOW_ERR_MES_5Delay(@"*** 其他状态 不做断开连接  ***");
            NSLog(@"*** 其他状态 不做断开连接  ***");
        }
        
    }
}

- (void)upTopViewStatus{
    //topview健康状态更新
    /**
     根据子数据直接赋予
     */
    /**
     NSInteger userTotalHealthStatus = [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.userTotalHealthStatus;
     */
    NSString *refteshDataTimeStr = [TextShowWithModelStr textShowWithNotNullStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowRecentHealthModel.refreshDataTime];//网络数据
    NSString *statusRefreshDataTime = [ToolOfTimeChangeFormat longStrOfnowTimeWithYearMonthDayHhMmInfo];//硬件数据
    

    if ([self.healthStatusSaveArray containsObject:@(HealthShow_Type_Bad)]) {
        [self.topView setTopViewStatusWithRefreshDataTimeStr: statusRefreshDataTime andHealthShowType:HealthShow_Type_Bad];
    } else if([self.healthStatusSaveArray containsObject:@(HealthShow_Type_Warning)]){
        [self.topView setTopViewStatusWithRefreshDataTimeStr: statusRefreshDataTime andHealthShowType:HealthShow_Type_Warning];
    } else {
        [self.topView setTopViewStatusWithRefreshDataTimeStr: statusRefreshDataTime andHealthShowType:HealthShow_Type_Good];
    }
    /**
     根据网络数据直接赋予
     */
//    [self.topView setTopViewStatusWithHealthShowType:self.model];
}
#pragma mark - ZYHealthDataTopViewDelegate
- (void)backButtonEvent {
    NSLog(@"返回");
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ZYHealthDataTopViewDelegate
// 切换
- (void)switchButtonEvent {
    /**
     解除配对test
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        DeviceMatchingRemoveGuideVC  *vc = [[DeviceMatchingRemoveGuideVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    });
    return;
     */
    
    [self.popViewChangeFamily showInView:self.view thePopViewTableViewHeight:0 WithArray:self.saveFamilysArr];
   // [self.testPopTableV showInView:self.view thePopViewTableViewHeight:0 WithArray:@[].mutableCopy];

  
}

#pragma mark - ZYHealthDataContentHeaderViewDetegate
// 刷新
- (void)refreshButtonEvent {
    
    NSLog(@"点击刷新新数据");
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ZYHealthDataContentFooterViewDelegate

// 绑定设备
- (void)bindButtonEvent {
  
    [self scanDevArrWithInitSearchBeginAction];
    
}

#pragma mark - ZYHealthDataDeviceHeaderViewDelegate
// 设备管理
- (void)deviceManagerButtonEvent {
//    [self scanDevArr];
    [self scanDevArrWithInitSearchBeginAction];
    //test
    //[self initGetDevBaseInfo];
    NSLog(@"智能设备管理");

    

    
  
    
}

#pragma mark - ZYHealthDataDeviceFooterViewDelegate
// 购买
- (void)buyButtonEvent {
    
    NSLog(@"去购买");
    //
    NSLog(@"推荐产品");
    MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
    vc.selfInitType = MedicalWebViewVc_ShowInitType_MallGoods;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark - ZYHealthDataEmptyDeviceCellDelegate
// 添加健康档案
- (void)goButtonEvent {
    
    NSLog(@"添加健康档案，免费找专家");
    MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
    vc.selfInitType = MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark ====== 主动断开连接（也许是更换设备）
- (void)cellTouchDisConDevWithCleaningOldData{
    [[TrusangBlueToothSdkDataManager share]disConnectDev];
    [self ifChangeOtherDevToCleaningOldData];
}
- (void)ifChangeOtherDevToCleaningOldData{
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
    NSLog(@"当前连接的设备清空 %@｜  扫描的蓝牙设备arr不能删除  需要使用 %@", [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave,[TrusangBlueToothSdkDataManager share].scanDevsSaveArr);
//绑定的数据不清空 （也许是更换设备）（也许是不换设备））
//    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
//    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
//    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @"";
//    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
}
#pragma mark ====== //更换人
- (void)changeOtherUserIdToCleaningOldData{
    //更换人 本页数据+网络信息和设备信息等都要清除
    self.healthStatusSaveArray = @[@(0),@(0),@(0)].mutableCopy;//未知状态0 123优良差
    self.healthDataOnlyMainNumArray =  @[@(0),@(0),@(0)].mutableCopy;
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
        [weakSelf.topView setTopViewStatusWithRefreshDataTimeStr:@"" andHealthShowType:HealthShow_Type_Good];
    });
    /**
    （在切换人员时） //扫描的蓝牙设备arr不能删除  需要使用
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
    NSLog(@"设备清空 %@｜（在切换人员时） 扫描的蓝牙设备arr不能删除  需要使用 %@", [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave,[TrusangBlueToothSdkDataManager share].scanDevsSaveArr);
    //[TrusangBlueToothSdkDataManager share].scanDevsSaveArr = [NSMutableArray arrayWithCapacity:0];//需要保留 用于切换之后 比对后台拿到的dev 用来做连接
    //
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel = [[HealthBaseDataSaveNowUseModel alloc]init];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserHealthInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @"";
    NSLog(@"清空changeOtherUserIdToCleaningOldData ｜ 附带历史列表删除后的清空设备");
}
//历史列表通知删除在线设备时 清空的数据
- (void)historyListDeletConnectDevWithCleaningOldData{
    [TrusangBlueToothSdkDataManager share].showModel = [[TrusangBlueToothUseShowModel alloc]init];//所有旧的dev显示相关数据清空
    [self changeOtherUserIdToCleaningOldData];
    
}
#pragma mark =========== 手环连接和数据相关

- (void)haveChooseDevToConnectWithDev:(ZHJBTDevice *)dev{
    [[TrusangBlueToothSdkDataManager share]connectDevice:dev withConnetStatuBlock:^(ConnectDev_State conState) {
        switch (conState) {
            case ConnectDev_State_Success:
            {
                NSLog(@"haveChooseDevToConnectWithDev  %@  %@",dev.name,dev.mac);
                Y_SVP_SHOW_SUCCESS_MES(@"手环/手表设备连接成功");
                [self initGetDevBaseInfo];
            }
                break;
            case ConnectDev_State_Fail:
            {
                Y_SVP_SHOW_ERR_MES(@"手环/手表设备连接失败");
            }
                break;
            case ConnectDev_State_OutTime:
            {
                Y_SVP_SHOW_ERR_MES(@"手环/手表设备连接超时");
            }
                break;
                
                
            default:
                break;
        }
    }];
    
}
//只搜索 不跳转设备扫描搜索页
- (void)scanDevAndDontGoToScanListVc{
    WEAKSELF
    [[TrusangBlueToothSdkDataManager share]getMyPhoneDevceStateWithOpenBoolWithBlock:^(BOOL isOpen) {
        if (isOpen) {
        }else{
            Y_SVP_SHOW_INFO_MES(@"请打开蓝牙,以供设备搜索连接。");
        }
    }];
    //
    [[TrusangBlueToothSdkDataManager share] backgroundKeepsBlueDevScanning];
    
}

- (void)scanDevArrWithInitSearchBeginAction{
    //Y_SVP_SHOW_INFO_MES(@"请打开蓝牙,以供设备搜索连接。");
    WEAKSELF
    [[TrusangBlueToothSdkDataManager share]getMyPhoneDevceStateWithOpenBoolWithBlock:^(BOOL isOpen) {
        if (isOpen) {
        }else{
            Y_SVP_SHOW_INFO_MES(@"请打开蓝牙,以供设备搜索连接。");
        }
    }];
    //
    [[TrusangBlueToothSdkDataManager share] backgroundKeepsBlueDevScanning];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        DeviceScanListShowTableViewController *vc = [[DeviceScanListShowTableViewController alloc]init];
        vc.nowUserId = weakSelf.thisViewUseUserId;
        vc.isOwnBool = weakSelf.saveNowUserModel.oneself;
        vc.saveOldDevState = [TrusangBlueToothSdkDataManager share].nowDevState;
        vc.oneDevicConnectedOkBlock = ^(ZHJBTDevice * _Nonnull chooseDev) {
            [weakSelf haveChooseDevToConnectWithDev:chooseDev];//主动连接//列表页连接成功后 没有做主页相关设备数据接口调用
            [weakSelf refreshDevInfoWithSelfDevStatus];//不做连接 只做状态刷新
            [weakSelf initGetDevBaseInfo];//连接状态下 设备内健康数据
            NSLog(@"haveChooseDevToConnectWithDev == %@ %@ %@ %@ %@ %@ %ld %d %d sn=%@",chooseDev.name,chooseDev.mac,chooseDev.rssi,chooseDev.version,chooseDev.peripheral,chooseDev.model,chooseDev.power,chooseDev.isConnected,chooseDev.isANCSAuthorized,chooseDev.sn);
        };

        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    });
 
}
- (void)scanDevArr{//scanDevArrWithInitSearchBeginAction 替换 防止空时无法跳转
   
    WEAKSELF
    [[TrusangBlueToothSdkDataManager share]searchDeviceInfoWithBlock:^(NSArray<ZHJBTDevice *> * _Nullable arr, BOOL success) {
        if (success) {
            NSLog(@"%@",arr);
            dispatch_async(dispatch_get_main_queue(), ^{
                DeviceScanListShowTableViewController *vc = [[DeviceScanListShowTableViewController alloc]init];
                vc.nowUserId = weakSelf.thisViewUseUserId;
                vc.isOwnBool = weakSelf.saveNowUserModel.oneself;
                vc.dataSourceArr = arr.mutableCopy;
                vc.saveOldDevState = [TrusangBlueToothSdkDataManager share].nowDevState;
                vc.oneDevicConnectedOkBlock = ^(ZHJBTDevice * _Nonnull chooseDev) {
                    [weakSelf haveChooseDevToConnectWithDev:chooseDev];//主动连接//列表页连接成功后 没有做主页相关设备数据接口调用
                    [weakSelf refreshDevInfoWithSelfDevStatus];//不做连接 只做状态刷新
                    [weakSelf initGetDevBaseInfo];//连接状态下 设备内健康数据
                    NSLog(@"haveChooseDevToConnectWithDev == %@ %@ %@ %@ %@ %@ %ld %d %d sn=%@",chooseDev.name,chooseDev.mac,chooseDev.rssi,chooseDev.version,chooseDev.peripheral,chooseDev.model,chooseDev.power,chooseDev.isConnected,chooseDev.isANCSAuthorized,chooseDev.sn);
                };

                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf pushVc:vc];
            });
        }
    }];
   
}
- (void)initGetDevBaseInfo{
    [[TrusangBlueToothSdkDataManager share] getOneBlueDevHealthInfoWithNowConnectedOkDevice];
}
#pragma mark==== kvo

- (void)dealloc{
    //新
    //[fbKVO unobserveAll];
    Y_NSNotificationCenter_RemoveNotice_Name(HistoryDeletConnectDevNoticeName);
}

- (void)addNoitice{
    Y_NSNotificationCenter_Creat_NameAction(HistoryDeletConnectDevNoticeName, historyDeletConnectDevAction);
}
- (void)historyDeletConnectDevAction{
    self.isGetDeletConnedDevNoticeType = YES;// （删除在线就要做yes处理 等新设备连接成功时再换成no）
    [self historyListDeletConnectDevWithCleaningOldData];//清空全部数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //新数据
    [self initData];//重新刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

}
- (void)addKvo{
    WEAKSELF
    
    //历史数据 fkvo 在内改变arr 不被响应 此处另加各个历史数据完成的block 以供通知上传action
    [TrusangBlueToothSdkDataManager share].devHistoryGetEnd_HeartInfoTypeBlock = ^(BOOL isGetDevHistroyEnd) {
        if (isGetDevHistroyEnd) {
            NSLog(@"history 监听 1");
            [self getChangeWithNowBlueTouchShowModelWithKeyPath:kvoK_History_heartReat];
        }
    };
    [TrusangBlueToothSdkDataManager share].devHistoryGetEnd_SleepInfoTypeBlock = ^(BOOL isGetDevHistroyEnd) {
        if (isGetDevHistroyEnd) {
            NSLog(@"history 监听 2");
            [self getChangeWithNowBlueTouchShowModelWithKeyPath:kvoK_History_sleep];
        }
    };
    [TrusangBlueToothSdkDataManager share].devHistoryGetEnd_tempInfoTypeBlock = ^(BOOL isGetDevHistroyEnd) {
        if (isGetDevHistroyEnd) {
            NSLog(@"history 监听 3");
            [self getChangeWithNowBlueTouchShowModelWithKeyPath:kvoK_History_temperature];
        }
    };
    
    //1221 不做实时数据的更新 只做历史数据 且在历史上传完后 做后台主页健康数据展示数据信息的请求 用于更新界面
    [HealthBaseDataManager share].sendHistorySuccessBlock = ^(NSInteger sendHistorySuccessCount) {
        if (sendHistorySuccessCount) {
            [weakSelf initUserHealthData];
        }
    };
    
    //设备连接没有mac
   [TrusangBlueToothSdkDataManager share].conectOneDevNotHaveMacBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DeviceMatchingRemoveGuideVC  *vc = [[DeviceMatchingRemoveGuideVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf pushVc:vc];
        });
   };
 //
    
    fbKVO = [FBKVOController controllerWithObserver:self];
    
    //当前userID更换监听
    [fbKVO observe:self  keyPath:@"thisViewUseUserId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"  change=%@ object=%@ observer%@ 更换人",change,object,observer);
        //更换人
        NSString *oldUserId = [NSString stringWithString:[change objectForKey:@"old"]];
        NSString *newUserId = [NSString stringWithString:[change objectForKey:@"new"]];
        if (isNil(oldUserId) || oldUserId.length==0 || [oldUserId isEqualToString:newUserId]) {
            //旧空数据|新旧一样没变 则不做切换（不做清空）
        }else{
            //旧非空数据 则做切换 需要清空数据
            [self changeOtherUserIdToCleaningOldData];
        }
  
    }];
    
    //后台数据获取监听
    /**
     static NSString * _Nullable kvoK_GetInfo_mdeviceAddress = @"mdeviceAddress";
     static NSString * _Nullable kvoK_GetInfo_mdeviceName = @"mdeviceName";
     static NSString * _Nullable kvoK_GetInfo_nowUserInfoChangeBool = @"nowUserInfoChangeBool";
     */
    NSArray *bindDevInfoChangeKeyArr = @[kvoK_GetInfo_mdeviceAddress,
                                         kvoK_GetInfo_mdeviceName,
                                         kvoK_GetInfo_nowUserInfoChangeBool];
    
   // [fbKVO observe:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel  keyPath:kvoK_GetInfo_nowUserInfoChangeBool options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
    [fbKVO observe:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel  keyPaths:bindDevInfoChangeKeyArr options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        NSLog(@" HealthBaseDataManager 有变化 change=%@ object=%@ observer%@ |||||keyPath=%@ ",change,object,observer,keyPath);
        [self getChangekvoK_GetInfo_nowUserInfoChangeBool];
    }];
  
    //showModel
    //蓝牙设备信息相关监听
    [fbKVO observe:[TrusangBlueToothSdkDataManager share] keyPath:@"nowDevState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change){
        NSLog(@"nowDevState有变化   %ld",[TrusangBlueToothSdkDataManager share].nowDevState);
//        if ([TrusangBlueToothSdkDataManager share].nowDevState == DeviceStateConnecting) {//做定时 超时跳引导页
////            NSTimer dontConnectSuccessTimer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {//timerOfIsConning
////
////            }];
//        }
        NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        if ([[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {//相同改变数据多次kvo内有绑定接口不可多次调用
            return;
        }
        [self getNewChangeOfSaveDevWithKeyPath:keyPath change:change];
        
    }];
 
     NSArray *devKeyArr = @[@"name",
                            @"connected",
                            @"isConnected",
                            @"mac"];
     [fbKVO observe:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave  keyPaths:devKeyArr options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
         NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
         NSLog(@"nowBlueToothDevSave有变化  change=%@ object=%@ observer%@  |||||keyPath=%@ ",change,object,observer,keyPath);//切换家人时 本isConnected 才会改变
         if ([[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {//相同改变数据多次kvo内有绑定接口不可多次调用
             return;
         }
         [self getNewChangeOfSaveDevWithKeyPath:keyPath change:change];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
         
     }];
     //1221 不做实时数据的更新 只做历史数据 且在历史上传完后 做后台主页健康数据展示数据信息的请求 用于更新界面
    //1221 历史信息无法更新
//     NSArray *showModelkeyPathsArr = @[kvoKsaveNowDevName,
//                                       kvoKsaveNowDevMac,
////                                       kvoKpowerIntVale,
////                                       kvoKtemperature,
////                                       kvoKbp_bp,
////                                       kvoKbp_sp,
////                                       kvoKbo,
////                                       kvoKheartReat,
//                                       kvoK_History_temperature,
//                                       kvoK_History_heartReat,//histroy_HeartRateArr
//                                       kvoK_History_bpsp,
//                                       kvoK_History_bo,
//                                       kvoK_History_sleep];
    NSArray *showModelkeyPathsArr = @[kvoKsaveNowDevName,
                                      kvoKsaveNowDevMac,
                                      kvoKheartReat,
                                      kvoKtemperature,
                                      kvoK_History_temperature,
                                      kvoK_History_heartReat,
                                      kvoK_History_bpsp,
                                      kvoK_History_bo,
                                      kvoK_History_sleep];
    NSLog(@"showModelkeyPathsArr %@",showModelkeyPathsArr);
     
     [fbKVO observe:[TrusangBlueToothSdkDataManager share].showModel  keyPaths:showModelkeyPathsArr options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
         NSString *keyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
         NSLog(@"蓝牙设备健康数据变化  change=%@ object=%@ observer%@  |||||keyPath=%@ ",change,object,observer,keyPath);
         if ([keyPath isEqualToString:kvoKsaveNowDevName] || [keyPath isEqualToString:kvoKsaveNowDevMac]) {
             //test
             if ([keyPath isEqualToString:kvoKsaveNowDevMac]) {
                 if (isNil([change objectForKey:@"new"])) {
                     NSLog(@"新值空 kvoKsaveNowDevMac new mac = %@",[change objectForKey:@"new"]);
                     NSLog(@"新值空 kvoKsaveNowDevMac old mac = %@",[change objectForKey:@"old"]);
                 }else{
                     NSLog(@"kvoKsaveNowDevMac new mac = %@",[change objectForKey:@"new"]);
                     NSLog(@"kvoKsaveNowDevMac old mac = %@",[change objectForKey:@"old"]);
                 }
             }

             [self initUserHealthData];//自己更换设备/切换家人 重刷新当前健康数据     //更换设备时的旧健康数据获取
         }else{
             NSLog(@"history 监听");
             [self getChangeWithNowBlueTouchShowModelWithKeyPath:keyPath];
         }
     }];

}
//- (void)timerOfIsConning{
//    //长时间未连接成功做引导页的跳转
//    WEAKSELF
//    dispatch_async(dispatch_get_main_queue(), ^{
//        DeviceMatchingRemoveGuideVC  *vc = [[DeviceMatchingRemoveGuideVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [weakSelf pushVc:vc];
//    });
//}
#pragma mark ===
- (void)getChangekvoK_GetInfo_nowUserInfoChangeBool{
    //拿到当前userid对应的设备信息
     ZHJBTDevice *getDev = [[ZHJBTDevice alloc]init];
     getDev.name = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName];
     getDev.mac = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress];
     getDev.version = [TextShowWithModelStr textShowWithModelStr:[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceVersion];
     NSLog(@"获取设备名字 = %@ mac=%@, 需要做连接, 旧设备已经被清理掉== %@",  getDev.name ,getDev.mac , [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name);
     if (  [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserInfoChangeBool == YES) {
         if ([[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac isEqualToString:getDev.mac ] &&  ![TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {//离线状态下 新旧数据一样 则直接重连
             [[TrusangBlueToothSdkDataManager share]reConNowDev];//主动重连接 成功后 会调用读写开启 设备信息获取等
         }
         if (![[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac isEqualToString:getDev.mac ] && [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
             //断开旧设备
             [[TrusangBlueToothSdkDataManager share]disConnectDev];//isNotNil( [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac ) 切换时旧设备已经被清理掉
         }
         //空数据时 也要可做连接
         if (![[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac isEqualToString:getDev.mac ]) {
             //连接新设备
             NSLog(@"haveChooseDevToConnectWithDev 连接新设备 getDev = %@  name = %@  mac= %@",getDev,getDev.name,getDev.mac);

             [self haveChooseDevToConnectWithDev:getDev];
         }
         if (isNotNil( [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac ) && [[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac isEqualToString:getDev.mac ]) {//同一个设备 不做连接（初始刷新数据后会有重连调用） 只做加数据
             [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserInfoChangeBool = NO;
             [self initGetDevBaseInfo];
           
         }
     }
 
}
#pragma mark == 保存的设备 nowDevState isConnected 连接状态 变化监听

- (void)getNewChangeOfSaveDevWithKeyPath:(NSString *)keyPath  change:(NSDictionary *)change {

    NSLog(@"||**** 保存的设备 连接状态 变化监听**** \n keyPath=%@ \n change=%@",keyPath,change);
    
//    if (([keyPath containsString: @"connect"] || [keyPath containsString:@"isConnected"]) && [[change objectForKey:@"new"] boolValue] == ConnectDev_State_Success) {//是否已经连接
    if ((([keyPath containsString: @"connect"] || [keyPath containsString:@"isConnected"]) && [[change objectForKey:@"new"] boolValue] == YES) || ([keyPath containsString: @"nowDevState"] && [[change objectForKey:@"new"] intValue] == DeviceStateConnected )) {//是否已经连接
        self.isGetDeletConnedDevNoticeType = NO; //新设备连接成功时 no
        NSString *userId = self.thisViewUseUserId;
        NSString *dName =  [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name;
        NSString *dAddress =  [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac;
        NSString *dVersion =  [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.version;
        if (dAddress.length<=0 || isNil(dAddress)) {
            dAddress = [[TrusangBlueToothSdkDataManager share]getDevMacStrOfNowSaveBlueScanArrWithOneDevUseNameStr:[TrusangBlueToothSdkDataManager share].nowBlueToothDevSave];
        }
        //判断新连接设备 和当前userid 所对应的绑定设备信息是否一样 一样就不做绑定 不一样则需绑定
//        NSString *managerUerId = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic[@"familyMemberId"]];
        NSString *managerUerId = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserId];
        //NSString *managerDevAddress = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic[@"mdeviceAddress"]];//被清空了
        NSString *managerDevAddress = [NSString stringWithFormat:@"%@",[HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress];//常用的 被新绑定后才会替换掉 可用
         

        NSLog(@"绑定  后台获取的设备数据%@ %@  蓝牙当前信息%@ %@",managerUerId,managerDevAddress,userId,dAddress);
        //连接状态时 设备mac会无法获取 是空的
     
        if ([managerUerId isEqualToString:self.thisViewUseUserId] &&  [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected &&   (dAddress.length==0 || isNil(dAddress)) ) {
            NSLog(@"绑定  后台存的蓝牙和当前蓝牙数据 在线mac空 名字一样 不需要绑定");
        }else if ([managerUerId isEqualToString:self.thisViewUseUserId] && [managerDevAddress isEqualToString: dAddress]) {
            NSLog(@"绑定  后台存的蓝牙和当前蓝牙数据 一样 不需要绑定");
        }else{
            NSLog(@"绑定  后台存的蓝牙和当前蓝牙数据 不一样 需要绑定");
            if (dAddress.length==0 || isNil(dAddress)) {
                NSLog(@"本次已经在线数据mac无法拿到 下次数据变化时绑定"); //isConnected 变化先后时间差导致 no状态 ，也需要不做绑定上传数据 ｜ 或则 循环搜索列表中的蓝牙name去对应拿到mac做绑定
            }else{
                NSLog(@"绑定");
                [[HealthBaseDataManager share]bindIngDevWithUserId:userId withDevName:dName withDevAddress:dAddress  withDevVersionStr:dVersion];
            }
        }
    }
     //状态改变 二组的cell改变 DeviceStateConnect其他多种状态
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark === showModel
- (void)getChangeWithNowBlueTouchShowModelWithKeyPath:keyPath{
    NSLog(@" getChangeWithNowBlueTouchShowModelWithKeyPath %@",keyPath);
    if ([keyPath containsString:@"Histroy"] || [keyPath containsString:@"histroy"]) {
        [self getNewChangeOfHealthHistoryInfoWithKeyPath:keyPath ];
    }else{
        [self getNewChangeOfNewHealthInfoWithKeyPath:keyPath];
    }
}
#pragma mark == 实时本页使用的展示数据变化监听
- (void)getNewChangeOfNewHealthInfoWithKeyPath:(NSString *)keyPath {

    if ([keyPath isEqualToString:kvoKsaveNowDevName]) {
        NSLog(@"| saveNowDevName == %@",[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName);
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];//更换绑定状态 //UI处理
        return;
        
    }else if ([keyPath isEqualToString:kvoKpowerIntVale]){
        NSLog(@"| powerIntVale == %ld",[TrusangBlueToothSdkDataManager share].showModel.powerIntVale);
    }else if ([keyPath isEqualToString:kvoKheartReat]){//实时心率
        [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Headerate withObject:@([TrusangBlueToothSdkDataManager share].showModel.heartRete)];//心率
        [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@(1)];
        if ([TrusangBlueToothSdkDataManager share].showModel.heartRete <= 0) {
            [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@(HealthShow_Type_NoStaus)];//无数据状态
        }else{
            if ([TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Min == 0 || [TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Max == 0 || ( [TrusangBlueToothSdkDataManager share].showModel.heartRete > [TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Min && [TrusangBlueToothSdkDataManager share].showModel.heartRete < [TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Max)) {
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@(HealthShow_Type_Good)];
            }else if ([TrusangBlueToothSdkDataManager share].showModel.heartRete <= [TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Min ) {
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@(HealthShow_Type_Bad)];//危险|
            }else if ([TrusangBlueToothSdkDataManager share].showModel.heartRete >= [TrusangBlueToothSdkDataManager share].showModel.heartReteAlarmLimit_Max ){
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Headerate withObject:@(HealthShow_Type_Warning)];//需要注意安全|
            }else{
            }
            //上传当前最近心率值
            [[HealthBaseDataManager share]updataWithUserId:self.thisViewUseUserId withNowHeartReatInfo:[TrusangBlueToothSdkDataManager share].showModel.now_HeartRateDetail withNowBpInfo:[TrusangBlueToothSdkDataManager share].showModel.now_BpDetail];
            
        }
        NSLog(@"| heartReat == %ld",[TrusangBlueToothSdkDataManager share].showModel.heartRete);
    }else if ([keyPath isEqualToString:kvoKtemperature]){//实时体温
        [self.healthDataOnlyMainNumArray replaceObjectAtIndex:Row_Num_Tempe withObject:@([TrusangBlueToothSdkDataManager share].showModel.temperature)];//体温
        if ([TrusangBlueToothSdkDataManager share].showModel.temperature <= 0) {
            [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@(HealthShow_Type_NoStaus)];
        }else{//max38.0 min36.0 有初始值
            if ( ( [TrusangBlueToothSdkDataManager share].showModel.temperature  > [TrusangBlueToothSdkDataManager share].showModel.temperatureAlarmLimit_Min) && ( [TrusangBlueToothSdkDataManager share].showModel.temperature  < [TrusangBlueToothSdkDataManager share].showModel.temperatureAlarmLimit_Max) ) {
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@(HealthShow_Type_Good)];
            }else if ([TrusangBlueToothSdkDataManager share].showModel.temperature  >= 39.5){
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@(HealthShow_Type_Bad)];//危险|
            }else if ( [TrusangBlueToothSdkDataManager share].showModel.temperature  >= [TrusangBlueToothSdkDataManager share].showModel.temperatureAlarmLimit_Max) {
                [self.healthStatusSaveArray replaceObjectAtIndex:Row_Num_Tempe withObject:@(HealthShow_Type_Warning)];//需要注意安全|
            }else{
            }
            //上传最近体温
            [[HealthBaseDataManager share]updataWithUserId:self.thisViewUseUserId withNowTempInfo:[TrusangBlueToothSdkDataManager share].showModel.now_TempDetail];
            
        }
        NSLog(@"| temperature == %f",[TrusangBlueToothSdkDataManager share].showModel.temperature);
    }else if ([keyPath isEqualToString:kvoKbp_bp]){
        //NSLog(@"| bp = %ld ,sp = %ld \n bo = %ld",[TrusangBlueToothSdkDataManager share].showModel.bp_bp, [TrusangBlueToothSdkDataManager share].showModel.bp_sp,[TrusangBlueToothSdkDataManager share].showModel.bo);
    }else if ([keyPath isEqualToString:kvoKbp_sp]){
        //NSLog(@"| bp = %ld ,sp = %ld \n bo = %ld",[TrusangBlueToothSdkDataManager share].showModel.bp_bp, [TrusangBlueToothSdkDataManager share].showModel.bp_sp,[TrusangBlueToothSdkDataManager share].showModel.bo);
    }else if ([keyPath isEqualToString:kvoKbo]){
        //NSLog(@"| bp = %ld ,sp = %ld \n bo = %ld",[TrusangBlueToothSdkDataManager share].showModel.bp_bp, [TrusangBlueToothSdkDataManager share].showModel.bp_sp,[TrusangBlueToothSdkDataManager share].showModel.bo);

    }else{
    }
    //UI处理
    if ( [keyPath isEqualToString:kvoKsaveNowDevName] || [keyPath isEqualToString:kvoKtemperature] || [keyPath isEqualToString:kvoKheartReat] || [keyPath isEqualToString:kvoK_History_sleep] ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //列表数据更新
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self upTopViewStatus];//本地数据
            //20211228  成功上传后 重新加载健康数据 使用 网络数据 不用本地数据
        });
        
    }
}
#pragma mark == 历史数据变化监听 上传历史
- (void)getNewChangeOfHealthHistoryInfoWithKeyPath:(NSString *)keyPath {
    NSLog(@"历史数据变化监听 上传历史 %@",keyPath);
    if ([keyPath isEqualToString: kvoK_History_temperature]) {
        [self sendHistory_Temp];
       //NSLog(@"|历史 temperature == %@",[TrusangBlueToothSdkDataManager share].showModel.histroy_TempArr);
    }else if ([keyPath isEqualToString:kvoK_History_heartReat]){
        [self sendHistory_HeartRate];
        //NSLog(@"|历史 hr = %@",[TrusangBlueToothSdkDataManager share].showModel.histroy_HeartRateArr);
    }else if ([keyPath isEqualToString:kvoK_History_bpsp]){
        //NSLog(@"|历史 bp = %@",[TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr);
    }else if ([keyPath isEqualToString:kvoK_History_bo]){
       // NSLog(@"|历史 bo = %@",[TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr);
    }else if ([keyPath isEqualToString:kvoK_History_sleep]){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //列表数据更新
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self upTopViewStatus];//本地数据
        });
        [self sendHistory_sleep];
        //NSLog(@"|历史 sleep = %@",[TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr);
        
    }else{}
}

#pragma mark - fb KVO  end


 
#pragma mark == 历史记录 调用上传对应属性历史
 
- (void)sendHistory_sleep{
    //
    if ([TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr.count > 0) {
        [[HealthBaseDataManager share]updataWithUserId: self.thisViewUseUserId withHistorySleepInfoArr: [TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr ];
    }else{
        NSLog(@"历史睡眠数据 空");
    }
    
}
- (void)sendHistory_Temp{
    //
    if ([TrusangBlueToothSdkDataManager share].showModel.histroy_TempArr.count > 0){
        //上传温度
        [[HealthBaseDataManager share]updataWithUserId: self.thisViewUseUserId withHistoryTempInfoArr: [TrusangBlueToothSdkDataManager share].showModel.histroy_TempArr ]; 
     
    }else{
        NSLog(@"历史 temperature 空");
    }
}

- (void)sendHistory_HeartRate{
    if ([TrusangBlueToothSdkDataManager share].showModel.histroy_HeartRateArr.count > 0) {
        //上传 心率 血压 （lookHistory_Bp  bp和hr同时数据  只调用一次上传）
        [[HealthBaseDataManager share]updataWithUserId: self.thisViewUseUserId withHeartReatInfoArr:[TrusangBlueToothSdkDataManager share].showModel.histroy_HeartRateArr withDBPandSBPInfoArr:[TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr];
    }else{
        NSLog(@"历史 HeartRateArr 空");
    }
}
/**
 - (void)lookHistory_Bp{
     //
     if ([TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr.count>0) {
         for (int i = 0 ; i < [TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr.count; i++) {
             ZHJBloodPressure *bpObj = [TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr[i];
             //NSLog(@"查看 [历史记录] ———————————— [血压类] 平均=%ld  最大=%ld 最小=%ld ",(long)bpObj.avg,(long)bpObj.max,(long)bpObj.min);
             for (int j = 0 ; j < bpObj.details.count; j ++) {
                 ZHJBloodPressureDetail *bpDetailOneObj = bpObj.details[j];
                 NSString *dateStr = bpDetailOneObj.dateTime;
                 NSInteger dbp = bpDetailOneObj.DBP;
                 NSInteger sbp = bpDetailOneObj.SBP;
                 //NSLog(@"查看 [历史记录] ———————————— [血压类]  %@ ，dbp=%ld sbp=%ld",dateStr,dbp,sbp);
             }
         }
     }else{
        // NSLog(@"历史 血压数据 空")
     }
 }
 - (void)lookHistory_Bo{
     //
     if ([TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr.count>0) {
         for (int i = 0 ; i < [TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr.count; i++) {
             ZHJBloodOxygen *boObj = [TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr[i];
             //NSLog(@"查看 [历史记录] ———————————— [血氧类] 平均=%ld  最大=%ld 最小=%ld ",(long)boObj.avg,(long)boObj.max,(long)boObj.min);
             for (int j = 0 ; j < boObj.details.count; j ++) {
                 ZHJBloodOxygenDetail *boDetailOneObj = boObj.details[j];
                 NSString *dateStr = boDetailOneObj.dateTime;
                 NSInteger bo = boDetailOneObj.BO;
           
                 //NSLog(@"查看 [历史记录] ———————————— [血氧类]  %@ ，bo=%ld",dateStr,bo);
             }
         }
     }else{
         NSLog(@"历史 血压数据 空")
     }
 }
 */

@end
