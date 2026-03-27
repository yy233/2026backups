//
//  RobotSetViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/8.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "RobotSetViewController.h"
#import "ProductGuideViewController.h"

#import "RobotSetTableViewCell.h"
@interface RobotSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *robotSetTableV;
@property (nonatomic,strong)NSMutableArray *robotSetDataSource;
@end

@implementation RobotSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.title = NSLocalizedString(@"机器人设置", nil);
    [[ToolOfNetWork sharedTools] endXml];
}
- (void)initData{
    _robotSetDataSource = [NSMutableArray arrayWithObjects:NSLocalizedString(@"打扫记录", nil),NSLocalizedString(@"通用设置", nil),NSLocalizedString(@"设备二维码分享", nil),NSLocalizedString(@"产品指南", nil),NSLocalizedString(@"设备绑定详情", nil),NSLocalizedString(@"固件更新", nil),NSLocalizedString(@"关于本机", nil), nil];
}
- (void)initView{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
    [[UINavigationBar appearance] setBackIndicatorImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.topItem.title = @"";

    [self.view addSubview:self.robotSetTableV];
    
}
- (void)popvc{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _robotSetDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RobotSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotSetTableViewCell"];
    if (!cell) {
        cell = [[RobotSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RobotSetTableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textL.text = _robotSetDataSource[indexPath.section];
    switch (indexPath.section) {
        case 5:
            if (_isCanUpOfhardware||_isCanUpOfSoftware) {
                cell.upImgV.hidden = NO;
            }else{
                cell.upImgV.hidden = YES;
            }
            break;
            
        default:
            cell.upImgV.hidden = YES;
            break;
    }
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewH = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 1)];
    viewH.backgroundColor = [UIColor clearColor];
    return viewH;//段落间隙部分
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *viewH = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 1)];
    viewH.backgroundColor = [UIColor clearColor];
    return viewH;
}
- (UIView *)robotSetTableHeaderView{
    UIView *headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 20)];//50+50
    headerBackView.backgroundColor = [UIColor clearColor];
    return headerBackView;
}

- (UIView *)robotSetTableFooterView{
    UIView *footerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 100)];//50+50
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footerBtn.frame = CGRectMake(Y_mainW*0.2, 10+25, Y_mainW*0.65, 40);
    footerBtn.layer.cornerRadius = 5;
    footerBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    [footerBtn setTitle:NSLocalizedString(@"解除绑定",nil) forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerBackView addSubview:footerBtn];
    
    return footerBackView;

}
- (void)footerBtnAction:(UIButton *)sender{
    NSLog(@"footerBtnAction 解除绑定");
    
//    NSString *messageStr = [NSString stringWithFormat:@"您将删除%@扫地机",model.nickName];
    NSString *messageStr = NSLocalizedString(@"您将与这台机器人解除绑定",nil);
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"解绑提示",nil) message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletOneRobot:sender];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)deletOneRobot:(UIButton *)sender{

    if (![ToolOfBasic currentNetworkStatus]) {
        [MBProgressHUD showError:NSLocalizedString(@"网络异常,请检查您的网络设置!", nil) ];
    }else{
        [MBProgressHUD showMessage:NSLocalizedString(@"正在解除绑定", nil) ];
        NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone", nil];
        
        [parms setObject:[ShareUser sharedUserInfo].userMode.nowRobotJid forKey:@"eqHardwareSerial"];
        
        [[ToolOfNetWork sharedTools]endXml];
        [[ToolOfNetWork sharedTools]YrequestDeleteURL:S_equipmentRemove withParams:parms    finished:^(id responsObject, NSError *error) {
                [MBProgressHUD hideHUD];
 
        if (_Success) {
            //删除xmpp好友关系
            //            [[XmppManager shareXmppManager]deletFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid];
            [MBProgressHUD showSuccess:NSLocalizedString(@"解绑成功",nil)];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            //失败
            
            NSString *msg = @"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"解绑失败,请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"解绑失败,请稍后再试", nil);
                }
                
            }
            if (msg.length==0) {
                msg = NSLocalizedString(@"解绑失败", nil);
            }
            if (_SuccessOrErrCode==400) {
                msg =  NSLocalizedString(@"用户名不能为空", nil);
            }else if (_SuccessOrErrCode==401){
                msg =  NSLocalizedString(@"扫地机编号不能为空", nil);
            }else if (_SuccessOrErrCode==402){
                msg =  NSLocalizedString(@"该编号扫地机不存在", nil);
            }else if (_SuccessOrErrCode==403){
                msg =  NSLocalizedString(@"用户不存在", nil);
            }else if (_SuccessOrErrCode==404){
                msg =  NSLocalizedString(@"解绑失败，请稍后重试", nil);
            }else{
                if (msg.length==0) {
                  msg =  NSLocalizedString(@"解绑失败，请稍后重试", nil);
                }
            }
            
            [self.view makeToast:msg duration:2 position:@"bottom"];
        }
        }];
   }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    indexPath.section
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelect = %ld",(long)indexPath.section);
     self.title = @"";
    if (indexPath.section==0) {
        ClearnCodeViewController *clearnCodeVc = [[ClearnCodeViewController alloc]init];
          [self.navigationController pushViewController:clearnCodeVc animated:YES];
    }
    if (indexPath.section==1) {
        GeneralSettingsViewController *generalSettingsVc = [[GeneralSettingsViewController alloc]init];
        [self.navigationController pushViewController:generalSettingsVc animated:YES];
    }
    if (indexPath.section==2) {
        CreateQrCodeViewController *createQrCodeVc = [[CreateQrCodeViewController alloc]init];
        [self.navigationController pushViewController:createQrCodeVc animated:YES];
    }
    
    if (indexPath.section==3) {
        //产品指南上线暂隐
        ProductGuideViewController *productGuideVc = [[ProductGuideViewController alloc]init];
        [self.navigationController pushViewController:productGuideVc animated:YES];
//        [MBProgressHUD showError:@"暂无产品指南"]
//        YPageViewController *productGuideVc = [[YPageViewController alloc]init];
//        [self.navigationController pushViewController:productGuideVc animated:YES];
    }
    if (indexPath.section==4) {
        DeviceBindingDetailsViewController *deviceBindingDetailsVc = [[DeviceBindingDetailsViewController alloc]init];
        [self.navigationController pushViewController:deviceBindingDetailsVc animated:YES];
    }
    
    if (indexPath.section==5) {
        
        //mapvc用过的要处理掉  DataManager.shareDataManager.currentFriewareVersion
        // DataManager.shareDataManager.currentNavigationVersion
        FirmwareUpdateDetailViewController *firmwareUpdateDetailVc = [[FirmwareUpdateDetailViewController alloc]init];
        firmwareUpdateDetailVc.isCanUpOfSoftware  = self.isCanUpOfSoftware;
        firmwareUpdateDetailVc.isCanUpOfhardware = self.isCanUpOfhardware;
        [self.navigationController pushViewController:firmwareUpdateDetailVc animated:YES];
    }
    
    if (indexPath.section==6) {
        //关于本扫地机
        AboutThisRobotViewController *aboutThisRobotVc = [[AboutThisRobotViewController alloc]init];
        aboutThisRobotVc.areaTimeCharges = self.areaTimeChargeStr;
        [self.navigationController pushViewController:aboutThisRobotVc animated:YES];

    }
}
#pragma mark -- get

- (UITableView *)robotSetTableV{
    if (!_robotSetTableV) {
//        _robotSetTableV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _robotSetTableV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _robotSetTableV.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
        _robotSetTableV.delegate = self;
        _robotSetTableV.dataSource = self;
        _robotSetTableV.tableHeaderView = [self robotSetTableHeaderView];
        _robotSetTableV.tableFooterView = [self robotSetTableFooterView];
           /**bug section header height must not be negative - provided height 11和10返回的不同 遂去掉 添加代理方法返回headerView和footerView.
        'NSInternalInconsistencyException', reason: 'table view row height must not be negative - provided height for index path (<NSIndexPath: 0xc000000000000616> {length = 2, path = 6 - 0}) is -0.100000'
            */
        //组头的高度-0.01 10.1的iPhone7跳转崩溃试试加上这个
//        _robotSetTableV.estimatedRowHeight = 0.1;
//        _robotSetTableV.estimatedSectionHeaderHeight = 0.1;
//        _robotSetTableV.estimatedSectionFooterHeight = 0.1;
//        _robotSetTableV.sectionHeaderHeight = 0.01;
//        _robotSetTableV.sectionFooterHeight = 0.01;
        
    }
    return _robotSetTableV;
}

@end
