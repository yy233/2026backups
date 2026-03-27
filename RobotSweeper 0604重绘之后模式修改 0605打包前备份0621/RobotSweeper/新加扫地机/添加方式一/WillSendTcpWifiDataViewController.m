//
//  WillSendTcpWifiDataViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/28.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "WillSendTcpWifiDataViewController.h"
#import "SetNickNameViewController.h"
#import "SDCycleScrollView.h"//滚动轮播
@interface WillSendTcpWifiDataViewController ()<TCPDelegate,XmppManagerDelegate,SDCycleScrollViewDelegate>
//tcp
@property (nonatomic,assign) int okBtnNumOfCanTap;//tcp连接失败或者断开过_okBtnNumOfCanTap置0

//xmpp
@property (nonatomic,strong) NSTimer *xmppGetOkTimer;//定时发送connect
@property (nonatomic,strong) UIButton *nextBtn;//收到Ok后显示
@property (nonatomic,strong) UILabel *labelOfnow;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,assign) BOOL isGetXmppInfo;//得到了xmpp数据
@property (nonatomic,assign) int isDontGetXmppInfoNum;//没有得到了xmpp数据时间计数


//1203新增轮播图去掉旋转view
@property (nonatomic,strong) UIView *backViewOfLunbo;//轮播图背景位置
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView; // 轮播图
@property (nonatomic,strong) NSMutableArray *arrOfRunVTitle;//轮播图title
@property (nonatomic,strong) NSMutableArray *imageNamesArr;//本地图片
@end

@implementation WillSendTcpWifiDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"等待机器人回复", nil) ;
    [[TCPManager shareTCPManager] doDuankaiTcp];
    _okBtnNumOfCanTap = 0;
    _isGetXmppInfo = NO;
    [self initView];
}
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.img];
//    [self.view addSubview:self.labelOfnow];
//    [self.view addSubview:self.nextBtn];
//    [self labelAndNextBtnYs];
//    _img.hidden = YES;
//    [self loopBasecAnimation];//旋转
//    _labelOfnow.backgroundColor = [UIColor cyanColor];
    /**新增轮播*/
    [self dataOfRunViews];//轮播图的数据
    [self.view addSubview:self.backViewOfLunbo];//背景
    //轮播v
    [self cycleRunView];//轮播图
    [self.view addSubview:self.labelOfnow];//label
    [self.view addSubview:self.nextBtn];//btn
    [self yuesuOfBackViewOfLunbo];//更新约束
    
    _nextBtn.hidden = YES;
    _labelOfnow.text =  NSLocalizedString(@"正在请求机器人信息", nil);

    [self initTcp];//先停掉数据部分 发送tcp数据
    
}

- (void)dataOfRunViews{
    
//    _arrOfRunVTitle = [[NSMutableArray alloc] initWithObjects:@"1、启于座充",@"2、整理杂物",@"3、正确搬运", nil];//图片配文字
    if(self.title.length>7){//由title取 英文
        
        _arrOfRunVTitle = [[NSMutableArray alloc] initWithObjects:@"1、Start cleaning from the charging seat\nBefore the first cleaning, please charge for more than 3 hours;\nAt ordinary times, Start cleaning from the charging seat.",@"2、Sorting out debris.\nPlease dispose of the ropes, slippers, bottles and cans and small utensils scattered on the ground properly before the robot cleaning.\nAvoid winding, jamming, or collision causing property damage.",@"3、Correct handling\nTry not to interfere with the CleanRobot when cleaning.\nIf handling is required, lift with both hands from both sides.", nil];//图片配文字
    }else{//中文
        
        _arrOfRunVTitle = [[NSMutableArray alloc] initWithObjects:@"1、启于座充\n首次清扫之前，请先进行3小时以上的充电；\n平时使用中，尽量从充电座开始清扫",@"2、整理杂物\n请在它清扫前，将地上散落的绳线、拖鞋、瓶罐、小器具以及易碎易倒的物品进行妥善处置。\n避免清扫中出现缠绕，卡住，或者碰撞造成财产损失。",@"3、正确搬运\n在清扫时尽量不要干预它。\n如果需要搬运，请用双手从两侧抱起。", nil];//图片配文字
    }

 
    //图片名
    _imageNamesArr = [[NSMutableArray alloc] initWithObjects:@"add_one",@"add_two",@"add_thr", nil];
    
}

#pragma mark -- viewDidAppear 替换返回按钮 runview等
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self changeReturnBarItem];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark —————— 滚动视图
- (void)cycleRunView{

    CGRect cycleFram = CGRectMake(0, 0, Y_mainW, (Y_mainH-Y_getRectNavAndStatusHight)*0.67);//加在背景上
//    CGRect cycleFram = CGRectMake(0, 0, Y_mainW, Y_mainH-64);//加在背景上
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:cycleFram shouldInfiniteLoop:YES imageNamesGroup:self.imageNamesArr];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//SDCycleScrollViewPageContolAlimentCenter;//
    _cycleScrollView.titlesGroup = _arrOfRunVTitle;
    _cycleScrollView.backgroundColor = [UIColor whiteColor];//0104新增背景色
    if (self.title.length<=7) {
          _cycleScrollView.titleLabelHeight = 100;
    }else{
          _cycleScrollView.titleLabelHeight = 120;//英文
    }
    _cycleScrollView.titleLabelHeight = 150;
//    _cycleScrollView.titleLabelHeight = 90;
    //
    _cycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft; //NSTextAlignmentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
    _cycleScrollView.autoScrollTimeInterval = 4;
    [self.backViewOfLunbo addSubview:_cycleScrollView];//加上
    //--- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        _cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFill;
    });
    //         --- block监听点击方式
    Y_WEAKSELF
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        NSLog(@">>>>>  %ld", (long)index);
        
    };
    
}

#pragma mark -- navigationItem
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

- (void)timerLongAndPopV{
    Y_WEAKSELF
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"长时间没有接收到机器人的回复，添加失败。您将离开添加界面，可重新添加。", nil)   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAc = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf popVc];
    }];
    
    [alertVc addAction:yesAc];
    alertVc.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark --
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //
    [_xmppGetOkTimer setFireDate:[NSDate distantFuture]];
    [_xmppGetOkTimer invalidate];
    _xmppGetOkTimer = nil;
    
}

#pragma mark --  -- tcp
- (void)initTcp{
    
    [TCPManager shareTCPManager].tcpDelegate = self;
    [[TCPManager shareTCPManager] doDuankaiTcp];
    [[TCPManager shareTCPManager] doConnect];
    
}
#pragma mark -- tcp协议
- (void)socketDidConnectSuccessWithTcpStatus:(enum TcpStatus)tcpStatus{
    switch (tcpStatus) {
            
        case TcpStatusIsTCPConnect:
            
            //            [self.view makeToast:@"连接成功，可以提交Wi-Fi名和密码" duration:3 position:@"center"];
            
            _labelOfnow.text = NSLocalizedString(@"配对成功,正在发送Wi-Fi数据", nil) ;
            
            if (_okBtnNumOfCanTap==0) {//初始／断过／会重新发一次
                [self sendSSIDToServer];
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
    NSLog(@"%ld",(long)tcpStatus);
}

- (void)socketDidReceiveDataWithMsg:(NSString *)msg withData:(NSData *)data{
    
}
- (void)socketDidReceiveDataWithMsg:(NSString *)msg withData:(NSData *)data tag:(NSInteger)tag{
    
}
- (void)sendSSIDToServer{
    
    NSString *wifnameStr = [ShareUser sharedUserInfo].userMode.userWiFiArr.firstObject;
    NSString *passStr = [ShareUser sharedUserInfo].userMode.userWiFiArr.lastObject;
    
    [[TCPManager shareTCPManager]sendSSIDWithArray:@[wifnameStr,passStr]];

    _okBtnNumOfCanTap +=1;
    NSLog(@"发送了Wi-Fi和其密码_okBtnNumOfCanTap=%d",_okBtnNumOfCanTap);
    //    writeData在manager有写
    
}
//发送成功
- (void)reloadProgressWithPro:(CGFloat)pro{
    NSLog(@"wifi发送ing");
    if (pro == 10000) {
        
        [self succeedSend];
        
    }
}
- (void)succeedSend{
    //发送Wi-Fi成功等待扫地机注册后返回OK
    _labelOfnow.text = NSLocalizedString(@"发送Wi-Fi数据成功,等待机器人返信息\n等待时间会较长", nil) ;
    [self beginXmppSend];
    [[TCPManager shareTCPManager]doDuankaiTcp];//断开
}

#pragma mark -- xmpp
- (void)beginXmppSend{
    [XmppManager shareXmppManager].delegates = self;
    [self initGetOkTimer];
}
- (void)initGetOkTimer{
    
    _isDontGetXmppInfoNum = 0;
    _xmppGetOkTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendXmppConnectRequestAction:) userInfo:nil repeats:YES];
}
- (void)sendXmppConnectRequestAction:(NSTimer *)timer{
    
    if (!_isGetXmppInfo) {//没得到info时不停
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
        _isDontGetXmppInfoNum +=1;
        if (_isDontGetXmppInfoNum>=60) {//这是一个每3秒执行操作的timer 此处为3分钟的
            [self timerLongAndPopV];//超时弹出框
            //显示状态则代表已经收到数据 不用再发了
            [_xmppGetOkTimer setFireDate:[NSDate distantFuture]]; //
            [_xmppGetOkTimer invalidate];
            _xmppGetOkTimer = nil;
            [timer setFireDate:[NSDate distantFuture]];//
            [timer invalidate];
            timer = nil;
        }
    }else{
        _isDontGetXmppInfoNum = 0;
        //显示状态则代表已经收到数据 不用再发了
        [_xmppGetOkTimer setFireDate:[NSDate distantFuture]]; //
        [_xmppGetOkTimer invalidate];
        _xmppGetOkTimer = nil;
        [timer setFireDate:[NSDate distantFuture]];//
        [timer invalidate];
        timer = nil;
    }
    NSLog(@"定时  xmpptiemr sendXmppConnectRequestAction");
}
- (void)receiveXmppMessageWithMessage:(NSString *)message{
    //    request_connect ok//    [self stopLoopAnimation];//停止旋转
    
    _isGetXmppInfo = YES;
    _labelOfnow.text = NSLocalizedString(@"已匹配成功", nil) ;
    _nextBtn.hidden = NO; //出现Next按钮
}
- (void)receiveXmppUserStatusWithMessage:(NSString *)message{
    
}
- (void)sendMessageFail{
    
}
- (void)sendMessageSuccess{
    
}


- (void)nextBtnAction:(UIButton *)sender{
    //去昵称页
    self.title = @"";
    SetNickNameViewController *setNickNameVc = Y_storyBoard_id(@"SetNickNameViewController");
    [self.navigationController pushViewController:setNickNameVc animated:YES];
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
        _labelOfnow.numberOfLines = 0;
    }
    return _labelOfnow;
}
- (UIButton *)nextBtn{
    
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(0, 0, Y_mainW*0.6, 50);
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
        [_nextBtn setTitle:NSLocalizedString(@"下一步", nil)  forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextBtn;
}
//////

- (UIView *)backViewOfLunbo{
    if (!_backViewOfLunbo) {
        _backViewOfLunbo = [[UIView alloc]init];
//        _backViewOfLunbo.backgroundColor = [UIColor redColor];
       
    }
    return _backViewOfLunbo;
}

- (void)yuesuOfBackViewOfLunbo{
    [_backViewOfLunbo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Y_getRectNavAndStatusHight);
        make.width.equalTo(self.view.mas_width);//.multipliedBy(0.8)
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.6);//0.67处为底部 0.66f匹配frame
    }];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Y_getRectNavAndStatusHight);
        make.width.equalTo(self.view.mas_width);//.multipliedBy(0.8)
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).multipliedBy(0.67);//0.67处为底部 0.66f匹配frame
    }];
    //重新更新约束
    [_labelOfnow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cycleScrollView.mas_bottom).offset(10);
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
///
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
