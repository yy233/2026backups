//
//  PairingViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/23.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PairingViewController.h"
#define  udp_servicePort  14000
#define  udp_selfPort   14001
#import "WillSendTcpWifiDataViewController.h"
//udp+
@interface PairingViewController ()<GCDAsyncUdpSocketDelegate,TCPDelegate>
///udp
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,assign) UInt16 servicePort;//send是14000
@property (nonatomic,assign) UInt16 selfPort;//bindToPort 是14001

@property (nonatomic,strong) NSString *nameOfUdpStr;
@property (nonatomic,strong) NSString *addressOfTcpStr;
@property (nonatomic,assign) UInt16 portOfTcp;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *labelOfnow;
@property (nonatomic,strong) NSTimer *timerOfStopAnimation;//定时初始化udp广播发送
//

@property (nonatomic,strong) UIButton *nextBtn;//收到Ok后显示 没有使用
@property (nonatomic,assign) BOOL isUdpGetInfo;//udp得到数据
@end

@implementation PairingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"机器人配对", nil);//  Robot matching
    
    [self initView];
    
}
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.img];
    [self.view addSubview:self.labelOfnow];
    [self.view addSubview:self.nextBtn];
    [self labelAndNextBtnYs];
    _img.hidden = NO;
    _nextBtn.hidden = YES;
    [self loopBasecAnimation];//旋转
    _labelOfnow.text = NSLocalizedString(@"正在请求机器人信息", nil);//@"requesting robot info"
    [self initData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",_timerOfStopAnimation);
    
    
}
#pragma mark -- 替换返回按钮
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeReturnBarItem];
}

- (void)changeReturnBarItem{
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackRootVcAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;//原back--左边的项目是后退按钮。
}

- (void)goBackRootVcAction:(UIBarButtonItem *)sender{
    
    Y_WEAKSELF
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"您将离开添加界面", nil)   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
#pragma mark --
- (void)initData{
    _isUdpGetInfo = NO;
    [self initUdpGb];//开始udp
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    [_udpSocket close];
    _udpSocket = nil;
    //
    [_timerOfStopAnimation setFireDate:[NSDate distantFuture]];
    [_timerOfStopAnimation invalidate];
    _timerOfStopAnimation = nil;
   
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_udpSocket) {
        [_udpSocket close];
        _udpSocket = nil;
        NSLog(@"viewDidDisappear _udpSocket close %@",_udpSocket);
    }
}

#pragma mark -- showContAddmsg该机器人暂无法添加
- (void)showContAddmsg{
    //停止转盘
    [self stopLoopAnimation];
    //数据初始化状态
    _labelOfnow.text = NSLocalizedString(@"暂时无法添加该机器人，请先升级APP", nil) ;
    //弹出框
    //    [self.view makeToast:@"该机器人暂无法添加，请先升级APP" duration:4 position:@"center"];
    UIAlertController *alertOfShow = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"暂时无法添加该机器人，请先升级APP", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertOfShow addAction:knowAction];
    
    alertOfShow.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertOfShow animated:YES completion:nil];
    
}
#pragma mark ------------------------ 数据部分
//
- (void)initUdpGb{
    _servicePort = udp_servicePort;
    _selfPort = udp_selfPort;
    [self initUDP];
    [self timerInit];
    [self sendMsgToService];
}
- (void)initUDP{
    [TCPManager shareTCPManager].tcpDelegate = self; //udp也用
}
- (void)timerInit{
    _timerOfStopAnimation = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerOfStopAnimationMethod:) userInfo:nil  repeats:YES];
}
- (void)timerOfStopAnimationMethod:(NSTimer *)timer{
    //默认wifi情况
    if (_isUdpGetInfo) {//得到过数据则不发广播了
        [timer invalidate];
        timer = nil;
    }else{
        [self sendMsgToService];
    }
    NSLog(@"定时 pariringVc timerOfStopAnimationMethod");
}

- (void)sendMsgToService{
    NSLog(@"udp发广播");
    if (_udpSocket == nil) {
        
    }else{
        [[TCPManager shareTCPManager] doDuankaiTcp];
        [_udpSocket close];
        _udpSocket = nil;
    }
    
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_udpSocket bindToPort:_selfPort error:&error];
    [_udpSocket enableBroadcast:YES error:&error];
    [_udpSocket beginReceiving:&error];
    NSData *data = [@"robot searching" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [_udpSocket sendData:data toHost:@"255.255.255.255" port:_servicePort withTimeout:-1 tag:1];
//     [_udpSocket sendData:data toHost:@"255.255.255.255" port:_servicePort withTimeout:1 tag:1];
    //     [_udpSocket sendData:data toHost:@"255.255.255.255" port:_servicePort withTimeout:15 tag:1];
}


#pragma mark --  //udp回调方法
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    //     [self.view makeToast:@"正在发起对机器人的连接，请稍后"  duration:3 position:@"center"];
}


-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
 
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
//    [self.view makeToast:@"得到机器人信息"  duration:3 position:@"center"];
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    
    [sock close];
    _udpSocket = nil;
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
//    [self.view showToast:[YBassViewController failOfMessage:@"连接机器人失败，请重新搜索"] duration:3 position:@"center"];
//    [self stopLoopAnimation];
    //    _lodingL.text = @"暂时未搜索到扫地机";
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
     _isUdpGetInfo = YES;//得到了数据 timer该停止
     [_timerOfStopAnimation invalidate];/////停止发送广播，不在重置udp
     NSLog(@"didReceiveData  udp回调方法");
    NSString *addressStr = [GCDAsyncUdpSocket hostFromAddress:address];
    //ip
    _addressOfTcpStr = addressStr;
    NSLog(@"ip = %@",_addressOfTcpStr);
    
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array = [msg componentsSeparatedByString:@" "];
    //标示 port 名字 ID
    if (array.count>3) {//非单人添加扫地机时//arr4有个的信息
        
        //判断是否为可添加机器
        NSString *thisRobotType = [[NSString stringWithFormat:@"%@",array[3]] substringToIndex:2];
        NSMutableArray *arrOfT = [DataManager shareDataManager].appCanAddRobotTypeArr;
        if (![arrOfT containsObject:thisRobotType]) {
            
            [self showContAddmsg];//高级版扫地机app无法添加提示
            if (_udpSocket) {
                [_udpSocket close];
            }
            [sock close];
            NSLog(@"关闭");
            return;
        }
        
        //可添加时
       
         [self isUdpEndGetRobotInfo];//udp数据处理end
        _nameOfUdpStr = array[0];
        _portOfTcp = [array[1] intValue];
        NSLog(@"array = %@",array);
        [DataManager shareDataManager].sweeperIP = _addressOfTcpStr;
        [DataManager shareDataManager].sweeperPort = array[1];
        [DataManager shareDataManager].sweeperID = array[3];
        [DataManager shareDataManager].sweeperIMEI = array[3];
        _nameOfUdpStr = array[2];
        [ShareUser sharedUserInfo].userMode.nowRobotJid = array[3];

        if (_udpSocket) {
            [_udpSocket close];
        }
        [sock close];
        //
        [self initTcpWillSendMsg];//开启tcp
    }
}

- (void)socketDidConnectSuccessWithTcpStatus:(enum TcpStatus)tcpStatus{

}
#pragma mark -- tcp
- (void)isUdpEndGetRobotInfo{
     _labelOfnow.text = NSLocalizedString(@"机器人配对成功", nil);// 可以传密码了
    [self stopLoopAnimation];//停止img旋转
   
    [_timerOfStopAnimation setFireDate:[NSDate distantFuture]]; //停止udp的timer udpsock置nil
    [_timerOfStopAnimation invalidate];
    _timerOfStopAnimation = nil;
    
    
}
- (void)initTcpWillSendMsg{
    NSLog(@"开启tcp");
//    [self initTcp];
    WillSendTcpWifiDataViewController *willTcpVc = [[WillSendTcpWifiDataViewController alloc]init];
    self.title = @"";
    [self.navigationController pushViewController:willTcpVc animated:YES];
}




#pragma mark ------------------------ view部分

#pragma mark -- 动画
-(void)loopBasecAnimation

{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    
    rotationAnimation.duration = 6;//2
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount =ULLONG_MAX;
    
    rotationAnimation.speed = 2.0;
    
    
    [_img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


-(void)stopLoopAnimation

{
    [_img.layer removeAllAnimations];
    
}


#pragma mark --
- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.frame = CGRectMake(0, 0, Y_mainW*0.6, Y_mainW*0.6);
        _img.center = self.view.center;
        //加载图标
        UIImage *loogImg = [UIImage imageNamed:@"加载图标"];
        [loogImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _img.image = loogImg;
        _img.tintColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _img;
}

- (UILabel*)labelOfnow{
    if (!_labelOfnow) {
        _labelOfnow = [[UILabel alloc]init];
        _labelOfnow.frame  = CGRectMake(0, 0, Y_mainW*0.8, Y_mainH*0.15);
        _labelOfnow.textAlignment = NSTextAlignmentCenter;
        _labelOfnow.font  = [UIFont systemFontOfSize:15];
        
    }
    return _labelOfnow;
}
- (UIButton *)nextBtn{
    //udp界面 拿到数据 自动跳 不要这一步数据了
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(0, 0, Y_mainW*0.6, 50);
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextBtn;
}
- (void)labelAndNextBtnYs{
    [_labelOfnow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.12);
        make.centerX.equalTo(self.view);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelOfnow.mas_bottom).offset(10);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.offset(50);
        make.centerX.equalTo(self.view);
    }];
}

@end
