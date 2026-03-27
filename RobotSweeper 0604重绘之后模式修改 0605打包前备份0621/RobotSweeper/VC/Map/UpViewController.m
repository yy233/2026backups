//
//  UpViewController.m
//  RobotSweeper
//  升级跳转页进度条
//  Created by Joey on 2018/4/10.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "UpViewController.h"
#import "ZZCircleProgress.h"
#define ZZRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface UpViewController ()<XmppManagerDelegate>

@property (nonatomic,strong) ZZCircleProgress *upProgressView;
@property (nonatomic,assign) CGFloat upProgressNum;//当前值
@property (nonatomic,strong) NSTimer *upViewTimer;//升级数据更新的timer
@property (nonatomic,assign) CGFloat upProgressNumMax;//限制最高值
@property (nonatomic,strong) NSTimer *requestRobotTimer;//发送请求
@property (nonatomic,assign) int upfailOrSuccessNum;//成功=1或失败=2


@property (nonatomic,strong) NSTimer *csTimer;//超时判断的timer
@property (nonatomic,assign) int csTimerNum;//超时判断的数

@property (nonatomic,strong) UILabel *labelOfNowState;

@end

@implementation UpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"UpViewController  _isSlamUp导航版软件= %d,_isCtrlUp控制板硬件= %d",_isSlamUp,_isCtrlUp);
    self.title = NSLocalizedString(@"升级中", nil) ;
    [self leftItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.upProgressNum = 0.0;
    self.upProgressNumMax = 0.1;
    _upfailOrSuccessNum = 0;
    _upViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(upViewTimerMethod:) userInfo:nil repeats:YES];
    [self.view addSubview:self.upProgressView];
    [self.view addSubview:self.labelOfNowState];
    [XmppManager shareXmppManager].delegates = self;
    /** //10版本才有的方法
    _upViewTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (_upProgressNum<_upProgressNumMax) {//到达设置的Max前继续赋值
            _upProgressNum += 0.01;
            _upProgressView.progress =_upProgressNum;
            NSLog(@"max=%f,num=%f",_upProgressNumMax,_upProgressNum);
        }else{ //到达设置的Max后可不暂停 暂停启动是根据Max变化来定
            NSLog(@"到达max=%f,num=%f",_upProgressNumMax,_upProgressNum);
          
            if (_upProgressNumMax>=1||_upProgressNum==1) {//最大1，已计数到1则停
                 NSLog(@"invalidate max=%f,num=%f",_upProgressNumMax,_upProgressNum);
                _upProgressView.progress = 1;
                 [timer invalidate];
            }
        }
    }];
     */
   
    
    
}
- (void)upViewTimerMethod:(NSTimer *)timer{
    //
    if (_upProgressNum<_upProgressNumMax) {//到达设置的Max前继续赋值
        _upProgressNum += 0.01;
        _upProgressView.progress =_upProgressNum;
        NSLog(@"max=%f,num=%f",_upProgressNumMax,_upProgressNum);
        
    }else{ //到达设置的Max后可不暂停 暂停启动是根据Max变化来定
        NSLog(@"到达max=%f,num=%f",_upProgressNumMax,_upProgressNum);
        
        if (_upProgressNumMax>=1||_upProgressNum==1) {//最大1，已计数到1则停
            NSLog(@"invalidate max=%f,num=%f",_upProgressNumMax,_upProgressNum);
            _upProgressView.progress = 1;
            [timer invalidate];
        }
    }
    
    //
    int nowN = _upProgressNum*100/10;
    
    BOOL isAllUp = (_isSlamUp==YES)&&(_isCtrlUp==YES)?YES:NO;
    if (isAllUp) {
        switch (nowN) {
            case 10:
                _labelOfNowState.text = NSLocalizedString(@"升级成功",nil);
                break;
            case 9:

                if (_upProgressNum==0.9) {
                    _labelOfNowState.text = NSLocalizedString(@"检测升级结果",nil);
                }else{
                     _labelOfNowState.text =  NSLocalizedString(@"机器人正在重新启动，时间可能需要三分钟，请耐心等候",nil);//1214新增
                }
//                _labelOfNowState.text = NSLocalizedString(@"检测升级结果",nil);
                break;
            case 8:
                if (_upProgressNum==0.8) {
                    _labelOfNowState.text = NSLocalizedString(@"软件系统新包下载成功",nil);
                    break;
                }else{
                   _labelOfNowState.text = NSLocalizedString(@"软件系统新包烧写中",nil);
                }
                
                break;
            case 7:
                _labelOfNowState.text = NSLocalizedString(@"软件系统新包下载中",nil);
                break;
            case 6:
                _labelOfNowState.text = NSLocalizedString(@"软件系统新包下载中",nil);
                break;
            case 5:
                _labelOfNowState.text = NSLocalizedString(@"软件系统新包下载中",nil);
                break;
            case 4:
                _labelOfNowState.text = NSLocalizedString(@"硬件系统新包烧写完成,检测升级结果", nil) ;
                break;
            case 3:
               
                if (_upProgressNum==0.3) {
                     _labelOfNowState.text = NSLocalizedString(@"硬件系统新包下载完成",nil);
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"硬件系统新包烧写中",nil);
                }
                break;
            case 2:
                _labelOfNowState.text = NSLocalizedString(@"硬件系统新包下载中", nil);
                break;
            case 1:
              
                if (_upProgressNum>0.11) {
                      _labelOfNowState.text = NSLocalizedString(@"硬件系统新包下载中", nil);
                }else{
                     _labelOfNowState.text = NSLocalizedString(@"升级条件检测中，请稍后", nil);
                }
                break;
            case 0:
                _labelOfNowState.text = NSLocalizedString(@"升级条件检测中，请稍后", nil);
                break;
                
            default:
                break;
        }
    }else{
        switch (nowN) {
            case 10:
                _labelOfNowState.text = NSLocalizedString(@"升级成功", nil) ;
                break;
            case 9:
                if (_upProgressNum==0.9) {
                    _labelOfNowState.text = NSLocalizedString(@"检测升级结果",nil);
                }else{
                    _labelOfNowState.text =  NSLocalizedString(@"机器人正在重新启动，时间可能需要三分钟，请耐心等候",nil);//1214新增
                }
                
//                _labelOfNowState.text = NSLocalizedString(@"检测升级结果",nil);
                break;
            case 8:
                if (_upProgressNum==0.8) {
                    _labelOfNowState.text = NSLocalizedString(@"下载成功", nil);
                    break;
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"解压新版本，删除旧版本", nil);
                    break;
                }
                
                break;
            case 7:
                if(_isSlamUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"软件下载中", nil);
                }else if (_isCtrlUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"硬件下载中", nil);
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                }
//                _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                break;
            case 6:
                if(_isSlamUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"软件下载中", nil);
                }else if (_isCtrlUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"硬件下载中", nil);
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                }
//                _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                break;
            case 5:
                if(_isSlamUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"软件下载中", nil);
                }else if (_isCtrlUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"硬件下载中", nil);
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                }
//                _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                break;
            case 4:
                if(_isSlamUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"软件下载中", nil);
                }else if (_isCtrlUp==YES){
                    _labelOfNowState.text = NSLocalizedString(@"硬件下载中", nil);
                }else{
                    _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                }//1214测试
//                _labelOfNowState.text = NSLocalizedString(@"下载中", nil);
                break;
            case 3:
                _labelOfNowState.text = NSLocalizedString(@"开始下载", nil);
                break;
            case 2:
                _labelOfNowState.text = NSLocalizedString(@"开始下载", nil);
                break;
            case 1:
                _labelOfNowState.text = NSLocalizedString(@"升级条件检测中，请稍后", nil);
                
                break;
            case 0:
                _labelOfNowState.text = NSLocalizedString(@"升级条件检测中，请稍后", nil);
                break;
            default:
                break;
        }
    }
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _csTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(csTimerMethod:) userInfo:nil repeats:YES];
    
}

- (void)csTimerMethod:(NSTimer *)timer{
    if (self.csTimerNum<200) {
        self.csTimerNum+=1;
        NSLog(@"没数据时长_csTimerNum=%d",self.csTimerNum);
    }else{
        if (self.csTimerNum == 200) {
            
            [self showMessageWithMsg:@"连接超时"];
            
            
        }
    }
}
- (void)leftItem{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;//原back--左边的项目是后退按钮。
}
//现在返回按钮不返回到其他界面
- (void)goBackAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"扫地机正在升级,暂时无法返回到其他界面", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }];
//
    [alertVc addAction:cancelAc];
//    [alertVc addAction:yesAc];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark -- timmer
- (void)beginTimerRequestOfRobotTimer{
    _requestRobotTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(beginTimerMethod:) userInfo:nil repeats:YES];
    /**
    _requestRobotTimer =  [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
    }];
     */
}

- (void)beginTimerMethod:(NSTimer *)timer{
      [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
      [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"upgrade_get_info"];//1226新增 防止升级信息成功失败的数据 被错过时 界面停留 的情况
}
#pragma mark --
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.csTimerNum = 0;
    [_csTimer invalidate];
    _csTimer = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  self.csTimerNum = 0;
    if (_upViewTimer) {
        [_upViewTimer invalidate];
        _upViewTimer = nil;
    }
    
    if (_requestRobotTimer) {
        [_requestRobotTimer invalidate];
        _requestRobotTimer = nil;
    }
}
#pragma mark -- degle

- (void)receiveXmppMessageWithMessage:(NSString * _Nonnull)message{
     NSLog(@"==%@",message);
    /*第一份协议 以后没有再用 仅保留代码*/
    NSArray *arrOfMessage = [message componentsSeparatedByString:@"_"];
    if ([arrOfMessage.firstObject isEqualToString:@"code"]&&[arrOfMessage[1] isEqualToString:@"i"]) {//升级信息
        NSLog(@"升级信息codemessage==%@",message);
        NSString *strOfP = @"";
        switch ([arrOfMessage[2] intValue]) {// 010 -  10
            case 10:
                  self.csTimerNum = 0;
                [self showMessageWithMsg:@"电量不足"];
                break;
            case 11://开始升级
                self.csTimerNum = 0;
                _upProgressNumMax = 0.09;
                break;
            case 12://升级界面（进度）10 20 30 90 100
                self.csTimerNum = 0;
                strOfP = [NSString stringWithFormat:@"%@",arrOfMessage[3]];//[]
                if (strOfP.length==4) {
                    strOfP = [strOfP substringWithRange:NSMakeRange(1, 2)];
                }else{
                    strOfP = [strOfP substringWithRange:NSMakeRange(1, 3)];
                }
                //10 20 30 40
                switch ([strOfP intValue]) {
                        
                    case 30:
                        _upProgressNumMax = 0.30;
                        _upProgressNum = 0.30;
                        break;
                    case 90:
                        _upProgressNumMax = 0.98;
                        [self beginTimerRequestOfRobotTimer];
                        break;
                    case 100:
                        
                        _upProgressNumMax = 1;
                        _upProgressNum = 0.98;
                        [_requestRobotTimer invalidate];//已重启且有数据了 成功的数据
                        break;
                        
                    default://10 20 31-89
                        _upProgressNumMax = [strOfP floatValue]/100;
//                        _upProgressNum = _upProgressNumMax-0.01;
                        _upProgressNum = _upProgressNumMax;
                        NSLog(@"strdefault=%@",strOfP);
                        break;
                }
                break;
            case 13:
                self.csTimerNum = 0;
                _upProgressNumMax = 1;
                _upProgressNum = 1;
                [self showMessageWithMsg:@"升级成功"];
                
                break;
            case 14:
                  self.csTimerNum = 0;
                [self showMessageWithMsg:@"升级失败"];//对Max比较获取错误原因
                _upProgressNumMax = _upProgressNum;//更改Max停止进度条的增加
                if (_requestRobotTimer) { //失败的数据
                    [_requestRobotTimer invalidate];
                    _requestRobotTimer = nil;
                }
                break;
                
                
            default:
                break;
        }
    }
    if ([message isEqualToString:@"upgrading:10"]) {
        NSLog(@"upgrading:10得到");
    }
     /*第二份协议*/
    NSArray *arrOfMessageTwo = [message componentsSeparatedByString:@":"];
    if ([arrOfMessageTwo.firstObject isEqualToString:@"low_power"]) {//电量不足
        self.csTimerNum = 0;
        [self showMessageWithMsg:@"电量不足"];
     
    }
    if ([arrOfMessageTwo.firstObject isEqualToString:@"start_upgrade"]) {//开始升级
      //开始升级
        self.csTimerNum = 0;
        _upProgressNumMax = 0.09;
    }
    if ([arrOfMessageTwo.firstObject isEqualToString:@"upgrading"]) {//升级中
        NSLog(@"升级中upgrading————————————= %@",message);
       /*
        self.csTimerNum = 0;
        strOfP = [NSString stringWithFormat:@"%@",arrOfMessage[3]];//[]
        if (strOfP.length==4) {
        strOfP = [strOfP substringWithRange:NSMakeRange(1, 2)];
        }else{
        strOfP = [strOfP substringWithRange:NSMakeRange(1, 3)];
        }
        break;*/
         int strOfP = 10;//初始量
      
        
        //10 20 30 40
        strOfP = [arrOfMessageTwo.lastObject intValue];
        CGFloat strOfPfloat = [arrOfMessageTwo.lastObject floatValue] ;
        switch (strOfP) {
                
            case 30:
                _upProgressNumMax = 0.30;
                _upProgressNum = 0.29;
                break;
            case 90:
                _upProgressNumMax = 0.98;
                [self beginTimerRequestOfRobotTimer];
                break;
            case 100:
                
                _upProgressNumMax = 1;
                _upProgressNum = 0.98;
                [_requestRobotTimer invalidate];//已重启且有数据了
                break;
                
            default://10 20 31-89
               
                _upProgressNumMax =  strOfPfloat/100;
                _upProgressNum = _upProgressNumMax-0.01;
              
                NSLog(@"得到升级数据附strOfP =%d _upProgressNumMax=%f",strOfP,_upProgressNumMax);
                break;
        }
    }
    if ([arrOfMessageTwo.firstObject isEqualToString:@"success_upgrade"]) {//升级成功
        self.csTimerNum = 0;
        _upProgressNumMax = 1;
        _upProgressNum = 1;
        [self showMessageWithMsg:@"升级成功"];
        
    }
    if ([arrOfMessageTwo.firstObject isEqualToString:@"faild_upgrade"]) {//升级失败
        self.csTimerNum = 0;
        [self showMessageWithMsg:@"升级失败"];//对Max比较获取错误原因
        _upProgressNumMax = _upProgressNum;//更改Max停止进度条的增加
        if (_requestRobotTimer) {
            [_requestRobotTimer invalidate];
            _requestRobotTimer = nil;
        }
    }
   
    NSLog(@"upvc得到的数据==%@",message);
}
- (void)receiveXmppUserStatusWithMessage:(NSString * _Nonnull)message{
//    if ([message isEqualToString:@"用户离线"]||[message isEqualToString:@"用户上线"]||[message isEqualToString:@"扫地机离线"]||[message isEqualToString:@"扫地机在线"]) {
//        [self.view makeToast:message duration:1 position:@"center"];
//        NSLog(@"%@",message);
//        //
//        if ([message isEqualToString:@"扫地机离线"] && _upProgressNumMax<0.98 && _csTimerNum>120) {//  90没得到且离线
//            [self showMessageWithMsg:@"升级失败"];
//        }
//        
//    }
    
    if ([message isEqualToString: @"用户离线"] ||[message isEqualToString:@"扫地机离线"] ) {
        
        [self.view makeToast:NSLocalizedString(message, nil)  duration:1 position:@"center"];
        NSLog(@"%@",message);
        _upProgressNumMax = _upProgressNum;
        
    }
    if ([message isEqualToString:@"用户上线"]||[message isEqualToString:@"扫地机在线"]) {
         [self.view makeToast:NSLocalizedString(message,nil) duration:1 position:@"center"];
    }
    
}

- (void)sendMessageSuccess{
    
}

- (void)sendMessageFail{
    
}

#pragma mark -- showMessageWithMsg
//国际化
- (void)showMessageWithMsg:(NSString *)msgStr{
//显示成功失败等数据后 弹出框出现 则转盘的timer停止更新label
    if ([msgStr isEqualToString:@"升级失败"]) {
          [_upViewTimer invalidate];
    }

    NSString *strOfInfo = @"";
    if ([msgStr isEqualToString:@"连接超时"]) {
        //此处不给label赋值    _labelOfNowState.text = msgStr;
//        strOfInfo = NSLocalizedString(@"连接超时,请确认网络状态", nil);
        strOfInfo = NSLocalizedString(@"长时间未收到升级相关数据,请确认网络状态", nil);
        UIAlertController *upVcAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(msgStr, nil)   message:strOfInfo preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *knowAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//升级包下载失败、解压失败，超时
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [upVcAlert addAction:knowAlertAction];
        [self presentViewController:upVcAlert animated:YES completion:nil];
         return;
    }
   
    if ([msgStr isEqualToString:@"升级失败"]) {
        if (_isCtrlUp==YES&&_isSlamUp==YES) {//10-30控制板 50-80导航版
           
            if (_upProgressNumMax <= 0.11) {
                strOfInfo = NSLocalizedString( @"请确保机器人电量大于50%或在充电状态中", nil);
                
            }else if(_upProgressNumMax>0.11&&_upProgressNumMax<=0.30){
                strOfInfo = NSLocalizedString(@"硬件系统下载新包失败，请稍后重试", nil);
            }else if(_upProgressNumMax>0.30&&_upProgressNumMax<=0.50){
                strOfInfo = NSLocalizedString(@"硬件系统更新失败，请稍后重试", nil);
            }else if(_upProgressNumMax>0.50&&_upProgressNumMax<=0.80){
                strOfInfo = NSLocalizedString(@"软件系统下载新包失败，请稍后重试", nil);
            }else if(_upProgressNumMax>0.80&&_upProgressNumMax<=0.99){
                strOfInfo = NSLocalizedString(@"软件系统更新失败，请稍后重试", nil);
            }else{
                strOfInfo = NSLocalizedString(@"机器人更新失败，请稍后重试", nil);
            }
        }else{
            if (_upProgressNumMax <= 0.11) {
                strOfInfo = NSLocalizedString(@"请确保机器人电量大于50%或在充电状态中", nil);
            }else if(_upProgressNumMax>0.11&&_upProgressNumMax<=0.80){
                strOfInfo = NSLocalizedString(@"机器人下载新包失败，请稍后重试", nil);
            }else{
                strOfInfo = NSLocalizedString(@"机器人更新失败，请稍后重试", nil);
            }
        }
        //加
        if ([msgStr isEqualToString:@"电量不足"]) {
            strOfInfo = NSLocalizedString(@"请确保机器人电量大于50%或在充电状态中", nil) ;//
        }//扫地机电量不足
        
        //新增的label附上失败的数据
        _labelOfNowState.text = strOfInfo;
        
       
        //弹出框msgStr
        UIAlertController *upVcAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"升级失败", nil)  message:strOfInfo preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *knowAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//升级包下载失败、解压失败
                [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [upVcAlert addAction:knowAlertAction];
        [self presentViewController:upVcAlert animated:YES completion:nil];

    }else if([msgStr isEqualToString:@"升级成功"]){
        //新增的label附上成功的数据
        _labelOfNowState.text = NSLocalizedString(msgStr,nil);
        
        UIAlertController *upVcAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(msgStr,nil) preferredStyle:UIAlertControllerStyleAlert];//1207国际版显示中文bug已修改
        
        UIAlertAction *knowAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [upVcAlert addAction:knowAlertAction];
        [self presentViewController:upVcAlert animated:YES completion:nil];
    }
    NSLog(@"%@",msgStr);
    /**以前的数字
     if (_upProgressNumMax <= 0.1) {//10
     strOfInfo = @"升级条件不足";
     }else if(_upProgressNumMax <= 0.2){//20
     strOfInfo = @"扫地机内存不足或电量不足";
     
     }else if(_upProgressNumMax <=0.3){//30
     strOfInfo = @"扫地机下载新包失败";
     }else{
     strOfInfo = @"扫地机更新失败";
     }
     */
}

#pragma mark -- getter
- (ZZCircleProgress *)upProgressView{
    
    if (!_upProgressView) {
        _upProgressView = [[ZZCircleProgress alloc]init];
        _upProgressView.frame = CGRectMake(0, 0, Y_mainW*0.6, Y_mainW*0.6);
        _upProgressView.center = self.view.center;
        _upProgressView.increaseFromLast = YES;
        _upProgressView.strokeWidth = 15;
        _upProgressView.progress = 0;
        _upProgressView.pathBackColor = [UIColor lightGrayColor];
        _upProgressView.pathFillColor = [DataManager shareDataManager].colorOfMainType;//主题色匹配
        _upProgressView.showProgressText = YES;
        _upProgressView.animationModel = CircleIncreaseByProgress;//CircleIncreaseSameTime
   
    }
    return _upProgressView;
}

- (UILabel *)labelOfNowState{
    if (!_labelOfNowState) {
        _labelOfNowState = [[UILabel alloc]init];
        _labelOfNowState.numberOfLines = 0;
        _labelOfNowState.textAlignment = NSTextAlignmentCenter;
        _labelOfNowState.frame = CGRectMake(Y_mainW*0.2,(Y_mainH*0.5+Y_mainW*0.3+10), Y_mainW*0.6, 100);
//        _labelOfNowState.backgroundColor = [UIColor cyanColor];
        //0.5h centerH 0.3W h
        
    }
    return _labelOfNowState;
}

@end
