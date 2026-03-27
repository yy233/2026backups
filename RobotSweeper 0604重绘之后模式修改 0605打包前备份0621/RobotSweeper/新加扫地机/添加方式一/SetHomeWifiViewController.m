//
//  SetHomeWifiViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/23.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetHomeWifiViewController.h"
#import<SystemConfiguration/CaptiveNetwork.h>
#import "ChangeRobotWifiViewController.h"

@interface SetHomeWifiViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changeWitiBtn;
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextF;
@property (nonatomic,assign) int okBtnNumOfCanTap;


@property (weak, nonatomic) IBOutlet UIButton *okBtn;//下一步btn

@property (nonatomic,strong)NSString * strOfOurWif;
@property (nonatomic,strong)NSTimer *timerOfGetWifi;
@end

@implementation SetHomeWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}
- (void)initView{
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _ssidTextField.tintColor = [DataManager shareDataManager].colorOfMainType;
    _passWordTextF.tintColor = [DataManager shareDataManager].colorOfMainType;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"设置机器人工作Wi-Fi", nil);
    [self.view endEditing:YES];
    [_passWordTextF resignFirstResponder];
    [_ssidTextField resignFirstResponder];
    
    if ([ShareUser sharedUserInfo].userMode.userWiFiArr.count>=2) {
        _ssidTextField.text = [ShareUser sharedUserInfo].userMode.userWiFiArr[0];
        _passWordTextF.text = [ShareUser sharedUserInfo].userMode.userWiFiArr[1];
    }else{
        //在非两个都有数据时，则用homeWifi更新界面
        if (!(_ssidTextField.text.length>0&&_passWordTextF.text.length>0)) {
             _ssidTextField.text = [DataManager shareDataManager].homeWifi;
        }
       
    }
     _timerOfGetWifi = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getWifiTimerAction:) userInfo:nil repeats:YES];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [_passWordTextF resignFirstResponder];
    [_ssidTextField resignFirstResponder];
    [_timerOfGetWifi invalidate];//停止
    _timerOfGetWifi = nil;
    NSLog(@"viewWillDisappear   =   停止");
}

#pragma mark -- 定时更新Wi-Fi
- (void)getWifiTimerAction:(NSTimer *)timer{
    _strOfOurWif = [self getWifi];//获取当前Wi-Fi
    if (_strOfOurWif.length>0) {
        [DataManager shareDataManager].homeWifi = _strOfOurWif;//存储的Wi-Fi
        [self initData];
    }
    NSLog(@"定时 setHomewifiVc getWifiTimerAction");
}
- (void)initData{
    
    if (_passWordTextF.isFirstResponder || _ssidTextField.isFirstResponder) {
        //用户写入时不更新
        NSLog(@"不更新界面");
    }else{
        //在非两个都有数据时，则用 更新界面
        if (!(_ssidTextField.text.length>0&&_passWordTextF.text.length>0)  && _strOfOurWif.length > 0) {
            _ssidTextField.text = _strOfOurWif;
            NSLog(@"更新界面");
        }else{
             NSLog(@"不更新界面2");
        }
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeWitiBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    [_passWordTextF resignFirstResponder];
    [_ssidTextField resignFirstResponder];
    //切换
    
    
    //系统Wi-Fi页
    [self changeWifiVc];
    //如果已经有2个数据后，则在此 去掉密码数据，使返回界面后能够更新Wi-Fi名；
    _ssidTextField.text = @"";
    _passWordTextF.text = @"";
}
#pragma mark -- ok btn
- (IBAction)okBtnAction:(UIButton *)sender {
    
    NSString *wifnameStr = [_ssidTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passStr = [_passWordTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉左右两边的空格
    
    if (wifnameStr.length<=0) {
        [self.view makeToast:NSLocalizedString(@"请输入Wi-Fi名", nil)  duration:2 position:@"center"];
        return;
    }
//    if (passStr.length<=0) {
//        [self.view makeToast:NSLocalizedString(@"Wi-Fi密码不能为空", nil)  duration:2 position:@"center"];
//        return;
//    }
    
    [ShareUser sharedUserInfo].userMode.userWiFiArr = [@[wifnameStr,passStr]mutableCopy];
    NSLog(@"wifiarr = %@  %lu  %lu  ",wifnameStr,(unsigned long)wifnameStr.length,(unsigned long)passStr.length);
    self.title = @"";
    ChangeRobotWifiViewController *changeRobotWifiVc = Y_storyBoard_id(@"ChangeRobotWifiViewController");
    [self.navigationController pushViewController:changeRobotWifiVc animated:YES];
}

#pragma mark -- 2 btn
- (IBAction)RememberPsd:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)psdShowOrHiden:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passWordTextF.secureTextEntry = NO;
    }else{
        _passWordTextF.secureTextEntry = YES;
    }
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
            [self.view makeToast:NSLocalizedString(@"无法跳转到设置页,请手动切换到系统设置界面,更换Wi-Fi热点", nil) duration:4.0 position:@"center"];
        }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
