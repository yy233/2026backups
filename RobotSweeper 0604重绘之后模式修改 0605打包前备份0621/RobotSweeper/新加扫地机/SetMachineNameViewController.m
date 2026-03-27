//
//  SetMachineNameViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetMachineNameViewController.h"

@interface SetMachineNameViewController ()<XmppManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveNameBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (nonatomic,assign) BOOL isLoginXmpp;
@property (nonatomic,assign) int canSave;
@property (nonatomic,strong) NSTimer *getWifStatusActionTimer;
@property (nonatomic,strong) NSTimer *chaoshiTimer;
@property (nonatomic,assign) int timerNum;
@end

@implementation SetMachineNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgV.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];//扫地机图标更具app不同而定
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    _saveNameBtn.layer.cornerRadius = 5;
    _saveNameBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _nameTextF.tintColor = [DataManager shareDataManager].colorOfMainType;
    
    _isLoginXmpp = NO;
    _canSave = 0;
    _timerNum = 0;
//    [ShareUser sharedUserInfo].userMode.nowRobotJid = @"01010100100660501c6de";
//    [self initxmpp];
    [self changeBackItem];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _getWifStatusActionTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(wifiStatus) userInfo:nil repeats:YES];

    _chaoshiTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendConnect) userInfo:nil repeats:YES];//超时提醒
    
    //在这里写会出现无法跳转功能
//    [[NSRunLoop mainRunLoop] addTimer:_getWifStatusActionTimer forMode:NSDefaultRunLoopMode];//会无法出现本界面
//    [[NSRunLoop mainRunLoop] addTimer:_chaoshiTimer forMode:NSDefaultRunLoopMode];//超时提醒
//    [[NSRunLoop mainRunLoop] run];//主线程永远等待，但让出主线程时间片
        [[NSRunLoop mainRunLoop] addTimer:_getWifStatusActionTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop mainRunLoop] addTimer:_chaoshiTimer forMode:NSRunLoopCommonModes];//超时提醒
    
 
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_chaoshiTimer invalidate];
    _chaoshiTimer = nil;
    [_getWifStatusActionTimer invalidate];
    _getWifStatusActionTimer = nil;
    
}

- (void)changeBackItem{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;//原back--左边的项目是后退按钮。
}
- (void)goBackAction:(UIBarButtonItem *)sender{
    
    [self goBackAction];
}
- (void)goBackAction{
    Y_WEAKSELF
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"返回提示" , nil)  message:NSLocalizedString( @"您将离开添加界面", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消" , nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认" , nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf popVc];
    }];
    
    [alertVc addAction:cancelAc];
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
}



#pragma mark -- pop

- (void)popVc{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc{
    
   // [self class];
    
}

- (void)wifiStatus{
    if ([ToolOfBasic currentNetworkStatus]) {
        NSLog(@"————————有网");
        [self initxmpp];
        [_getWifStatusActionTimer invalidate];
    }else{
         NSLog(@"————————没网");
         
    }
}


- (void)initxmpp{
        [XmppManager shareXmppManager].delegates = self;
        NSString *userName = [ShareUser sharedUserInfo].userMode.userName;
        NSString *passWord = [ShareUser sharedUserInfo].userMode.passWord;
        NSLog(@"initLoginXmpp %@%@",[ShareUser sharedUserInfo].userMode.userName,passWord);
        [[XmppManager shareXmppManager]loginXmpp:userName password:passWord pre:^(BOOL finish) {

            if (finish) {
                NSLog(@"xmpp登录成功+request_connect");
                _isLoginXmpp = YES;
                
                [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
                [self performSelector:@selector(delaysendxmppMethod) withObject:nil afterDelay:3.0f];
        
                [self.view makeToast:NSLocalizedString(@"xmpp登录成功", nil)  duration:3 position:@"center"];
    
            }else{
                NSLog(@"xmpp登录失败");
                 [self.view makeToast:NSLocalizedString(@"xmpp登录失败", nil) duration:2 position:@"center"];
                
            }
        }];
}


#pragma mark --  --xmppdelegate

-(void)sendMessageFail{
    NSLog(@"发送请求连接的信息 失败继续发连接请求");

//    [self performSelector:@selector(delaysendxmppMethod) withObject:nil afterDelay:4.0f];
}
- (void)delaysendxmppMethod{
    
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
   
}
- (void)sendMessageSuccess{
    NSLog(@"发送请求连接的信息成功");
}
-(void)receiveXmppMessageWithMessage:(NSString *)message{
    NSLog(@"XmppMessage---%@",message);
 
    //现在只要收到信息即可记为可保存状态
         _canSave += 1;
         _timerNum=0;
        if (_canSave ==1) {//自动添加部分cansave==1时才运行，其他值有手动操作执行
            [self.view makeToast:NSLocalizedString(@"机器人账号连接成功，可点击按钮保存该机器人", nil) duration:3 position:@"center"];
            if (!self.nameTextF.isFirstResponder) {
                //并且不是在输入时的状态
                 [self saveBtnAction:nil];
            }
           
        }
 
    
    
}
-(void)receiveXmppUserStatusWithMessage:(NSString *)message{
    NSLog(@"message=%@",message);
    if ([message isEqualToString:@"用户登录成功"]) {
        NSLog(@"xmpp登录成功");
        _isLoginXmpp = YES;
        _timerNum = 0;
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
        

    }else if ([message isEqualToString:@"用户离线"]){
//          _isLoginXmpp = NO;
    }
    
}
- (void)sendConnect{
    _timerNum+=1;
    NSLog(@"_timerNum=%d _canSave %d",_timerNum,_canSave);
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
    //登录状态后长时间 未有数据
    if (_timerNum>=120 && _canSave==0) {
        [self.view makeToast:NSLocalizedString(@"扫地机长时间未回复信息,可重新添加", nil) duration:4 position:@"center"];
        [_chaoshiTimer invalidate];
        _chaoshiTimer = nil;
        _timerNum = 0;
    }
    //有数据了
    if ( _canSave >1) {
        [_chaoshiTimer invalidate];
        _chaoshiTimer = nil;
    }
}
#pragma mark -- saveBtnAction
- (IBAction)saveBtnAction:(UIButton *)sender {
 
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    /*  */
    if (sender==nil) {
        //即得到了扫地机数据的情况
        _isLoginXmpp = YES;//不需要登录部分判断了可以直接做http
        _canSave=1;
        
    }
    
    if (_isLoginXmpp == NO) {
        [self initxmpp];
        [self.view makeToast:NSLocalizedString(@"正在登录本账号，请稍后", nil) duration:2 position:@"center"];
        return;
    }
    if (_canSave == 0) {
        [self.view makeToast:NSLocalizedString(@"正在连接机器人，请稍后", nil) duration:2 position:@"bottom"];
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
        //test
//        [[XmppManager shareXmppManager]sendTestRequsetconnect];

        
        return;
    }
  
    NSString* nickStr =  [_nameTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nickStr.length<=0) {
        [self.view makeToast:NSLocalizedString(@"请输入机器人昵称", nil) duration:2 position:@"center"];
        return;
    }
    

    //昵称大于20 切
    NSString *robotnickName = nickStr;
    NSString *nickN = [NSString stringWithFormat:@"%@",robotnickName];
    if (robotnickName.length>=20) {
        nickN = [[NSString stringWithFormat:@"%@",robotnickName]substringFromIndex:robotnickName.length-6];
    }
    //xmpp

    [[XmppManager shareXmppManager]addFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid  nickName:nickN];
    //test
  [[XmppManager shareXmppManager]addFriendActionWithFriendName:[ShareUser sharedUserInfo].userMode.nowRobotJid  nickName:@"test"];
    
    //服务器
    NSString *eqh = [DataManager shareDataManager].sweeperIMEI;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].userMode.userNameNoSuffix],@"userPhone",eqh,@"eqHardwareSerial",nickN,@"nickName",nil];
    [[ToolOfNetWork sharedTools]endXml];
    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentAddEqu withParams:parm finished:^(id responsObject, NSError *error) {
        NSLog(@"_canSave=%d",_canSave);
     
//         NSString *msg = [responsObject objectForKey:@"msg"];
        
        if (_Success) {
//            [self.view makeToast:msg duration:3 position:@"center"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        
        }else{
            //403扫地机已存在
            //402扫地机不存在
            //401用户不存在
//            [self.view makeToast:msg duration:3 position:@"center"];
            
            NSString *msg = NSLocalizedString(@"添加失败", nil);
//            if ([msg isEqualToString:@"该扫地机已存在"]|| [[responsObject objectForKey:@"code"] intValue]==403) {
            
            if (_SuccessOrErrCode==201) {//修改密码
                msg = NSLocalizedString(@"修改昵称成功", nil);
            }else if(_SuccessOrErrCode==401){//400昵称空去掉了该情况
                 msg = NSLocalizedString(@"扫地机编号不能为空", nil);
            }else if(_SuccessOrErrCode==402){
                 msg = NSLocalizedString(@"用户不存在", nil);
            }else if(_SuccessOrErrCode==403){
                 msg = NSLocalizedString(@"该扫地机不存在", nil);
            }else if(_SuccessOrErrCode==404){
//                 msg = NSLocalizedString(@"添加失败", nil);
                 msg = NSLocalizedString(@"添加失败，请稍后重试", nil);
            }
              [self.view makeToast:msg duration:3 position:@"center"];
                [self.navigationController popToRootViewControllerAnimated:YES];
 
        }
        
    }];
   
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
@end
