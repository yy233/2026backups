//
//  SucceedSearchGetWifiViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SucceedSearchGetWifiViewController.h"
#import<SystemConfiguration/CaptiveNetwork.h>

@interface SucceedSearchGetWifiViewController ()<UITextFieldDelegate,TCPDelegate,XmppManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;


@property (weak, nonatomic) IBOutlet UITextField *passWordTextF;
@property (nonatomic,assign) int okBtnNumOfCanTap;

@end

@implementation SucceedSearchGetWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"连接机器人", nil) ;
    _okBtnNumOfCanTap = 0;//扫地机连上tcp后
  
    [self initView];
}
- (void)initView{
    _imgV.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];//扫地机图标更具app不同而定
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _wifiNameTextF.tintColor = [DataManager shareDataManager].colorOfMainType;
    _passWordTextF.tintColor = [DataManager shareDataManager].colorOfMainType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//      self.navigationController.navigationBar.topItem.title = @"";
    //
    if ([ShareUser sharedUserInfo].userMode.userWiFiArr.count>=2) {
        _wifiNameTextF.text = [ShareUser sharedUserInfo].userMode.userWiFiArr[0];
        _passWordTextF.text = [ShareUser sharedUserInfo].userMode.userWiFiArr[1];
    }else{
        _wifiNameTextF.text = [DataManager shareDataManager].homeWifi;
    }

    [self addKeyBoardNoticf];
    _nameL.text = @"CleanRobot";
//    _nameL.text = _strOfMachineName;
//    _nameL.text = [DataManager shareDataManager].sweeperIMEI;
 
    //
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        _wifiNameTextF.text = [self  getWifi];
    }];

     [self initTcp];//
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[TCPManager shareTCPManager] doDuankaiTcp];
}

- (NSString *)getWifi{
    
   NSString * strOfWifi = @"";
    
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSString *str = info[@"SSID"];
        strOfWifi = str;
        if (strOfWifi.length == 0) {
             [self.view makeToast:NSLocalizedString(@"机器人联网失败 请重新添加", nil) duration:3 position:@"center"];
        }
    }
    
    return strOfWifi;
}


#pragma mark -- Wi-Fi  不改网
//隐藏的按钮 功能无法做出Wi-Fi列表
- (IBAction)changeWifiBtnAction:(UIButton *)sender {
    
    
}

#pragma mark -- 记住密码
- (IBAction)passwordRememberBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark -- 明文
- (IBAction)showPassOrNoShow:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passWordTextF.secureTextEntry = NO;
    }else{
        _passWordTextF.secureTextEntry = YES;
    }
    
}
#pragma mark -- 提交
- (IBAction)okBtnAction:(UIButton *)sender {
   
    if (_okBtnNumOfCanTap==0) {
        NSString *wifnameStr = [_wifiNameTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *passStr = [_passWordTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉左右两边的空格
        
        if (wifnameStr.length<=0) {
            [self.view makeToast:NSLocalizedString(@"请输入Wi-Fi名", nil)  duration:2 position:@"center"];
            return;
        }
        if (passStr.length<=0) {
            [self.view makeToast:NSLocalizedString(@"Wi-Fi密码不能为空",nil) duration:2 position:@"center"];
            return;
        }
        
    //没有连接时
        [self.view makeToast:NSLocalizedString(@"等待通信连接", nil)  duration:1 position:@"bottom"];
    }else if(_okBtnNumOfCanTap==1){
          [self sendSSIDToServer];
    }else{
    //多次点击
    }
    
    
    
    
}
#pragma mark --tcp发送成功
- (void)succeedSend{
    //tcp发送成功
    //开始xmpp检测
    //btn
     [self.view makeToast:NSLocalizedString(@"发送Wi-Fi名和密码成功,请等待机器人账号注册", nil) duration:3 position:@"center"];
    [self getxmppGoNextVcOk];
//    
//    [XmppManager shareXmppManager].delegates = self;
//    NSString *userName = [ShareUser sharedUserInfo].userMode.userName;
//    NSString *passWord = [ShareUser sharedUserInfo].userMode.passWord;
//    NSLog(@"initLoginXmpp %@%@",[ShareUser sharedUserInfo].userMode.userName,passWord);
//    [[XmppManager shareXmppManager]loginXmpp:userName password:passWord pre:^(BOOL finish) {
//        
//      
//        if (finish) {
//            NSLog(@"xmpp登录成功");
//            [self.view makeToast:@"xmpp登录失败" duration:4 position:@"center"];
//            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
//
//        }else{
//            NSLog(@"xmpp登录失败");
//            
//        }
//    }];
   
}



#pragma mark -- getxmppOk
- (void)getxmppGoNextVcOk{
  
    SetMachineNameViewController *setNameVc = Y_storyBoard_id(@"SetMachineNameViewController");
    [self.navigationController pushViewController:setNameVc animated:YES];
}



#pragma mark --  --xmppdelegate
//- (void)sendMessageSuccess{
//    NSLog(@"发送请求连接的信息成功");
//}
//-(void)sendMessageFail{
//    
//    [self performSelector:@selector(delaysendxmppMethod) withObject:nil afterDelay:3.0f];
//    
//}
////延时发送
//- (void)delaysendxmppMethod{
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
//}
//-(void)receiveXmppMessageWithMessage:(NSString *)message{
//    
//    
//    if ([message  isEqual: @"request_connect ok"]){
////        [self getxmppOk];
//    }
//     
//
//}
//-(void)receiveXmppUserStatusWithMessage:(NSString *)message{
//    NSLog(@"message=%@",message);
//    
//}

#pragma mark --  -- tcp
- (void)initTcp{
    [TCPManager shareTCPManager].tcpDelegate = self;
    [[TCPManager shareTCPManager] doDuankaiTcp];
    [[TCPManager shareTCPManager] doConnect];
  
   
}

/*🐟    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
 //    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
 func socketDidReceiveData( msg:String, withData data:Data?)
 func socketDidConnectSuccess(tcpStatus:TcpStatus)
 func reloadProgress(pro:CGFloat)
 
 */

#pragma mark -- tcp协议
- (void)socketDidConnectSuccessWithTcpStatus:(enum TcpStatus)tcpStatus{
    switch (tcpStatus) {
            
        case TcpStatusIsTCPConnect:
            
            [self.view makeToast:NSLocalizedString(@"连接成功，可以提交Wi-Fi名和密码" , nil) duration:3 position:@"center"];
//            _okBtn.userInteractionEnabled = YES;
            if (_okBtnNumOfCanTap<=1) {
                _okBtnNumOfCanTap = 1;
            }
            
            
            break;

        case TcpStatusIsTCPFail:
            NSLog(@"tcp连接失败或者断开过_okBtnNumOfCanTap置0");
            _okBtnNumOfCanTap = 0;
            break;

        case TcpStatusIsServiceConnect:
         
            break;
            
        case TcpStatusIsServiceFail:
             NSLog(@"tcp连接失败或者断开过_okBtnNumOfCanTap=%d",_okBtnNumOfCanTap);
//            [self.view showToast:[YBassViewController failOfMessage:@"连接失败，请重新提交"] duration:3 position:@"center"];
            
            break;
            
        default:
            break;
    }
}

- (void)socketDidReceiveDataWithMsg:(NSString *)msg withData:(NSData *)data{
    
}
- (void)socketDidReceiveDataWithMsg:(NSString *)msg withData:(NSData *)data tag:(NSInteger)tag{
    
}
- (void)sendSSIDToServer{
   
//    [[TCPManager shareTCPManager]sendMsgWithMsg:@"hello"];
//    [[TCPManager shareTCPManager]sendMsgWithMsg:@"wifi0004ldyh0008ldyh8808"];

    
    NSString *wifnameStr = [_wifiNameTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passStr = [_passWordTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉左右两边的空格

    if (wifnameStr.length<=0) {
        [self.view makeToast:NSLocalizedString(@"请输入Wi-Fi名" , nil)  duration:2 position:@"center"];
        return;
    }
    if (passStr.length<=0) {
        [self.view makeToast:NSLocalizedString(@"Wi-Fi密码不能为空", nil) duration:2 position:@"center"];
        return;
    }
    
    [ShareUser sharedUserInfo].userMode.userWiFiArr = [@[wifnameStr,passStr]mutableCopy];
    
  
    [[TCPManager shareTCPManager]sendSSIDWithArray:@[wifnameStr,passStr]];
    [self.view makeToast:NSLocalizedString(@"正在提交 请稍后", nil) duration:4 position:@"center"];
    _okBtnNumOfCanTap +=1;
     NSLog(@"发送了Wi-Fi和其密码_okBtnNumOfCanTap=%d",_okBtnNumOfCanTap);
//    writeData在manager有写
    
    
//    //测监控发送数据 port 12043 mac 10c6de0
//    [[TCPManager shareTCPManager] sendMsgWithMsg:@"camera 1"];
    
}
//发送成功
- (void)reloadProgressWithPro:(CGFloat)pro{
    NSLog(@"wifi发送ing");
    if (pro == 10000) {
        
        [self succeedSend];
        
    }
}

#pragma mark --

#pragma mark -- NotificationKeyBoard

- (void)addKeyBoardNoticf{
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowAction:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAction:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现
- (void)keyboardWillShowAction:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
//    self.view.center = CGPointMake(Y_mainW*0.5,Y_mainH*0.5-height);
      self.view.center = CGPointMake(Y_mainW*0.5,Y_mainH*0.5-height*0.6);//升键盘高度的一半左右
}

//当键退出
- (void)keyboardWillHideAction:(NSNotification *)notification
{
    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [value CGRectValue];
//    int height = keyboardRect.size.height;
    self.view.center = CGPointMake(Y_mainW*0.5,Y_mainH*0.5);
}

#pragma mark -- touchesBegan

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

@end
