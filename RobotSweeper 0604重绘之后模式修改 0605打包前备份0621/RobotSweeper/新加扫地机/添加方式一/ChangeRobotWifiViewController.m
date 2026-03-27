//
//  ChangeRobotWifiViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/23.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ChangeRobotWifiViewController.h"
#import<SystemConfiguration/CaptiveNetwork.h>
#import "PairingViewController.h"//app和robot配对界面
@interface ChangeRobotWifiViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nowWifiLabel;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeWifiBtn;
@property (nonatomic,strong) NSString *strOfNowWifi;
@property (nonatomic,strong) NSTimer *timerOfGetWifi;
@property (nonatomic,assign) int isCanPushNum;

@end

@implementation ChangeRobotWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"连接机器人热点", nil);
    _isCanPushNum = 0;
    [self initView];
    [self initData];
}
- (void)initView{
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _okBtn.hidden = YES;//去掉跳转按钮直接判断 CleanRobot
    _changeWifiBtn.layer.cornerRadius = 5;
    _changeWifiBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _isCanPushNum = 0;
    _timerOfGetWifi = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getWifiTimerAction:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timerOfGetWifi invalidate];
    _timerOfGetWifi = nil;
}


#pragma mark -- initData CleanRobot data push
- (void)initData{//实时更新Wi-FiSSID
    _nowWifiLabel.text = [self getWifi];
    //判断
//    if([_nowWifiLabel.text containsString:@"sweep"]&&_isCanPushNum==0){ //1217两种格式都判断可跳转
       if(([_nowWifiLabel.text containsString:@"CleanRobot"]||[_nowWifiLabel.text containsString:@"sweep"]) &&_isCanPushNum==0){
         _isCanPushNum += 1;
        [_timerOfGetWifi invalidate];//停止检测
        [self pushNextVc];
    }
    //如果没有数据则文本赋值为
    if(_nowWifiLabel.text.length==0||[_nowWifiLabel.text isEqualToString:NSLocalizedString(@"正在搜索当前Wi-Fi", nil) ]){
        _nowWifiLabel.text = NSLocalizedString(@"正在搜索当前Wi-Fi", nil);
    }
}
- (void)pushNextVc{
    self.title = @"";
    PairingViewController *pairVc = [[PairingViewController alloc]init];
    [self.navigationController pushViewController:pairVc animated:YES];
}
#pragma mark -- 定时更新Wi-Fi
- (void)getWifiTimerAction:(NSTimer *)timer{
    _strOfNowWifi = [self getWifi];//获取当前Wi-Fi
    [self initData];//空与非空都要更新
    NSLog(@"定时 changeRobotVc getWifiTimerAction");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//原来的跳转按钮被隐藏了 现只有切换按钮 此方法中文本暂不国际化
- (IBAction)okBtnAction:(UIButton *)sender {
//    if (_nowWifiLabel.text.length>0) {
//        if ([_nowWifiLabel.text containsString:@"CleanRobot"]) {//跳转
//            self.title = @"";
//            PairingViewController *pairVc = [[PairingViewController alloc]init];
//            [self.navigationController pushViewController:pairVc animated:YES];
//        }else{
//            //非robotWi-Fi
//            [self.view makeToast:@"当前网络不是机器人网络" duration:2 position:@"bottom"];
//        }
//
//    }else{
//        [self.view makeToast:@"机器人网络切换较慢,请稍等" duration:2 position:@"bottom"];
//    }
}
- (IBAction)changeWifiBtnAction:(UIButton *)sender {
    [self changeWifiVc];
}

#pragma mark -- 获取当前ssid
- (NSString *)getWifi{
    
    if ([ToolOfBasic currentNetworkStatus] == AFHttpReachableViaWiFi) {//wifi
        
        NSString * strOfWifi = @"";
        
        id info = nil;
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        for (NSString *ifnam in ifs) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            
            
            NSString *str = info[@"SSID"];
            
            strOfWifi = str;
            
        }
        return strOfWifi;
    }else{
        return @"";//非Wi-Fi模式
    }
    
    
}
#pragma mark -- 跳到手机设置页去连接Wi-Fi
- (void)changeWifiVc{
    //试写新跳转方式
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        if(@available(iOS 10.0 ,*)){//ios10+
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }else{
        [self.view makeToast:NSLocalizedString(@"无法跳转到设置页,请手动切换到系统设置界面,更换Wi-Fi热点", nil)  duration:4.0 position:@"center"];
    }
}

@end
