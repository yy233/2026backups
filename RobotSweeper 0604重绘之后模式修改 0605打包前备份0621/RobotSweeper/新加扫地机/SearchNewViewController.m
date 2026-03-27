//
//  SearchNewViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SearchNewViewController.h"
#import<SystemConfiguration/CaptiveNetwork.h>

@interface SearchNewViewController ()<UITableViewDelegate,UITableViewDataSource,GCDAsyncUdpSocketDelegate,TCPDelegate>
@property (weak, nonatomic) IBOutlet UITableView *textTableView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lodingL;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong) NSArray *arrOfTextMessage;//展示文本
@property (nonatomic,strong) NSArray *arrOfTextMessageTwo;//展示文本

@property (nonatomic,strong) NSTimer* timerOfStopAnimation;

///
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,assign) UInt16 servicePort;//send是14000
@property (nonatomic,assign) UInt16 selfPort;//bindToPort 是14001

@property (nonatomic,strong) NSString *nameOfUdpStr;
@property (nonatomic,strong) NSString *addressOfTcpStr;
@property (nonatomic,assign) UInt16 portOfTcp;
///
@property (nonatomic,strong) NSString *strOfOurWif;
@property (nonatomic,strong) NSString *strOfNowWifi;//当前连接Wi-Fi名字 searchAction时用于判断是否符合扫地机Wi-Fi的
@property (nonatomic,strong) NSTimer *getWifStatusOfTimer;
@property (nonatomic,assign) int getWifiStatusOfaddNum;

@property (nonatomic,assign) BOOL canPushVc;

@property (nonatomic,assign) int searchNum;//_searchNum
@end

@implementation SearchNewViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"搜索机器人", nil);
    
    [self saveOurWift];
    [self initData];
    [self initView];
    
    
    
}



- (void)dealloc{
    [self class];
}
- (void)saveOurWift{//初始化时的Wi-Fi
    _strOfOurWif = [self getWifi];//获取当前Wi-Fi
    [DataManager shareDataManager].homeWifi = _strOfOurWif;//存储的Wi-Fi
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- viewWillAppear

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.topItem.title = @"";
    _searchNum = 0;
    _canPushVc = YES;
    NSString *wfstr = [self getWifi];
    if (wfstr.length==0) {
        wfstr = @"暂无";
    }
     _lodingL.text = @"";
//    _lodingL.text = [NSString stringWithFormat:@"当前手机Wi-Fi:%@",wfstr];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        _lodingL.text = [NSString stringWithFormat:@"当前Wi-Fi:%@",[self getWifi]];
//        _lodingL.text = @"请确保扫地机Wi-Fi已经连上";
    }];
    
    
    _getWifiStatusOfaddNum = 1;
    _getWifStatusOfTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(wifiStatus) userInfo:nil repeats:YES];
    [_getWifStatusOfTimer fire];

//    [self imgAddAnimation];
//    [self imgBeginAnimation];
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
   
        [_udpSocket close];
        _udpSocket = nil;
    
    if ([_getWifStatusOfTimer isValid]) {
        [_getWifStatusOfTimer invalidate];
        
    }
    
    if ([_timerOfStopAnimation isValid]) {
//        [self stopLoopAnimation];
        [_timerOfStopAnimation invalidate];
    }else{
        [_timerOfStopAnimation invalidate];
//        [self stopLoopAnimation];
    }
   
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
//    [self imgEndAnimation];
    
 
    [self stopLoopAnimation];
    _getWifStatusOfTimer = nil;
    _timerOfStopAnimation = nil;
    if (_udpSocket) {
        [_udpSocket close];
        _udpSocket = nil;
    }
   
    
}


#pragma mark --  wifiStatus

- (void)wifiStatus{
    if ([ToolOfBasic currentNetworkStatus]) {
        _getWifiStatusOfaddNum = [ToolOfBasic currentNetworkStatus];
        NSLog(@"888=========有网,%d",_getWifiStatusOfaddNum);//4g=2 wifi=1
        if ([ToolOfBasic currentNetworkStatus]==1) {
            _strOfNowWifi = [self getWifi];//判断是否合乎Wi-Fi组是否可以添加
        }else{
            _strOfNowWifi = @"WAN";//非Wi-Fi是4G之类的网络
        }
        
    }else{
        _getWifiStatusOfaddNum = [ToolOfBasic currentNetworkStatus];
        NSLog(@"666=========没网");
        
    }
}
#pragma mark -- init

- (void)initData{
    /*
     1.请注意：每一次添加扫地机操作，只支持一部iPhone手机
     
     2.请把手机靠近要添加的扫地机
     
     3.请打开扫地机的电源开关，并等待启动完成
     
     4.请长按扫地机上的Wi-Fi重置按钮3秒以上，直到听到提示音为止
     
     5.点击 切换Wi-Fi热点，将手机Wi-Fi切换到“ligong........”热点上
     
     6.点击 搜索扫地机，等待手机APP出现下一步操作的页面
     
     机器人
     */
    
    _arrOfTextMessage = @[NSLocalizedString(@"1.请注意：每一次添加机器人操作，只支持一部手机", nil),NSLocalizedString(@"2.请把手机靠近要添加的机器人", nil),NSLocalizedString(@"3.请打开机器人的电源开关，并等待启动完成，网络连接成功语音提示", nil),NSLocalizedString(@"4.请长按机器人上的Wi-Fi重置按钮3秒以上，直到听到提示音为止", nil),NSLocalizedString(@"5.点击切换Wi-Fi热点，将手机Wi-Fi切换到“|”热点上", nil),NSLocalizedString(@"6.点击搜索机器人，等待手机APP出现下一步操作的页面", nil)];
   
    _arrOfTextMessageTwo = @[ NSLocalizedString(@"1.其他客户端已绑定机器人",nil), NSLocalizedString(@"2.该客户端通过‘设备二维码分享’进行了设备分享",nil), NSLocalizedString(@"3.你可以，通过",nil)];
    _searchNum = 0;
    //；若扫地机已经配好家庭网络，手机可在家庭网络状态下直接点击搜索
    
}
- (void)initView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _textTableView.tableHeaderView = [UIView new];
    _textTableView.tableFooterView = [UIView new];
    self.textTableView.estimatedRowHeight = 40;//估算高度
    self.textTableView.rowHeight = UITableViewAutomaticDimension;
    _textTableView.delegate = self;
    _textTableView.dataSource = self;
//    _textTableView.showsHorizontalScrollIndicator = NO;
//    _textTableView.showsVerticalScrollIndicator = NO;
    
    
    //加载图标
    UIImage *loogImg = [UIImage imageNamed:@"加载图标"];
    [loogImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _img.image = loogImg;
    _img.tintColor = [DataManager shareDataManager].colorOfMainType;
 
}

#pragma mark -- 更换为robot的Wi-Fi
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

- (NSString *)getWifi{
    
    if ([ToolOfBasic currentNetworkStatus] == AFHttpReachableViaWiFi) {//wifi

        NSString * strOfWifi = @"";
        
        id info = nil;
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        for (NSString *ifnam in ifs) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            
            
            NSString *str = info[@"SSID"];

            strOfWifi = str;
            if (strOfWifi.length == 0) {
                //            [MBProgressHUD showError:@"扫地机联网失败 请重新添加"];
                [self.view makeToast:NSLocalizedString(@"机器人联网失败 请重新添加", nil) duration:3 position:@"center"];
//
            }
            
        }
        return strOfWifi;
    }else{
//        [MBProgressHUD showError:@"请将手机连接到扫地机的网络。"];
        if([ToolOfBasic currentNetworkStatus] == AFHttpNotReachable){//no
             [self.view makeToast:NSLocalizedString(@"请将手机连接到扫地机的网络", nil)  duration:3 position:@"center"];
        }else{//4g
//             [self.view makeToast:@"请连接家庭Wi-Fi" duration:3 position:@"center"];
        }
       
        return @"";
    }
    
}


#pragma mark --
#pragma mark -- 搜索扫地机
//- (IBAction)searchAction:(UIBarButtonItem *)sender {
// /* 防多次点击*/
//    _searchNum += 1;
//    NSLog(@"%d",_searchNum);
//    if (_searchNum==1) {
//        NSLog(@"%d====1",_searchNum);
//        _lodingL.text = @"正在搜索扫地机";
//        _img.hidden = NO;
//        [self loopBasecAnimation];
//        
//        _servicePort = 14000;
//        _selfPort = 14001;
//        [self initUDP];
//        [self sendMsgToService];
//        [self timerInit];
//    }
//}
- (void)searchAction{
    /**
     不执行的情况 原有3种网 现切到的时第4种网时。
     */
    
    
    /**
     执行时
     */
    /* 防多次点击*/
    _searchNum += 1;
    NSLog(@"%d",_searchNum);
    if (_searchNum==1) {
        NSLog(@"%d====1",_searchNum);
//        _lodingL.text = @"正在搜索扫地机";
        
        _img.hidden = NO;
        [self loopBasecAnimation];
        
        _servicePort = 14000;
        _selfPort = 14001;
        [self initUDP];
        [self sendMsgToService];
        [self timerInit];
    }
    
}


- (void)timerInit{
    _timerOfStopAnimation = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerOfStopAnimationMethod:) userInfo:nil  repeats:YES];
    [_timerOfStopAnimation fire];
   /**
    _timerOfStopAnimation = [NSTimer timerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (_getWifiStatusOfaddNum==1) {//wifi
             [self loopBasecAnimation];
            [self sendMsgToService];
        }else{
            if (_getWifiStatusOfaddNum!=1) {//4g或者0 nil
                [self loopBasecAnimation];
                [self.view makeToast:@"正在切换网络，网络切换较慢请稍后"  duration:1 position:@"center"];
            }
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timerOfStopAnimation forMode:NSDefaultRunLoopMode];
    [_timerOfStopAnimation fire];
    */
}
- (void)timerOfStopAnimationMethod:(NSTimer *)timer{
    if (_getWifiStatusOfaddNum==1) {//wifi
        [self loopBasecAnimation];
        [self sendMsgToService];
    }else{
        if (_getWifiStatusOfaddNum!=1) {//4g或者0 nil
            [self loopBasecAnimation];
            [self.view makeToast:NSLocalizedString(@"正在切换网络，网络切换较慢请稍后", nil)   duration:1 position:@"center"];
        }
    }
}

#pragma mark -- succeedSearch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
  
}



- (void)succeedSearch{
     /*
      [DataManager shareDataManager].sweeperIP = _addressOfTcpStr;
      [DataManager shareDataManager].sweeperPort = array[1];
      [DataManager shareDataManager].sweeperID = array[3];
      */
    self.title = @"";
    SucceedSearchGetWifiViewController *getwifiVc = Y_storyBoard_id(@"SucceedSearchGetWifiViewController");
    getwifiVc.strOfMachineName = _nameOfUdpStr;
    getwifiVc.wifiOurStr = _strOfOurWif;
    
    getwifiVc.portOfTcp =[[DataManager shareDataManager].sweeperPort intValue];
    getwifiVc.addressOfTcpStr =  [DataManager shareDataManager].sweeperIP;
    
   
    if (!_canPushVc) {
        return;
    }
    _canPushVc = NO;
    [self.navigationController pushViewController:getwifiVc animated:YES];
    
}
#pragma mark -- 动画
-(void)loopBasecAnimation

{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    
    rotationAnimation.duration = 2;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount =ULLONG_MAX;
    
    rotationAnimation.speed = 2.0;
    
    
    [_img.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


-(void)stopLoopAnimation

{
    [_img.layer removeAllAnimations];
   
}




#pragma mark --暂不用的动画
- (void)imgAddAnimation{
    self.img.hidden = NO;
    self.img.layer.cornerRadius = CGRectGetMidX(_img.bounds)*0.5;
    self.img.layer.masksToBounds = YES;
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    moveAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    moveAnimation.duration = 30;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    moveAnimation.cumulative = NO;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.repeatCount = FLT_MAX;
    
    [self.img.layer addAnimation:moveAnimation forKey:@"AnimatedKey"];
    [self.img stopAnimating];
    
    // 加载动画 但不播放动画
    self.img.layer.speed = 0.0;
    
}

- (void)imgBeginAnimation{
    self.img.layer.speed = 2.0;
    self.img.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.img.layer timeOffset];
    CFTimeInterval timeSincePause = [self.img.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.img.layer.beginTime = timeSincePause;
}

- (void)imgEndAnimation{
    CFTimeInterval pausedTime = [self.img.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.img.layer.speed = 0.0;
    self.img.layer.timeOffset = pausedTime;
}




#pragma mark -- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
         return _arrOfTextMessage.count;
    }else{
         return _arrOfTextMessageTwo.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12.5];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section==0) {
        
        if (indexPath.row==4) {
         
           
            cell.textLabel.attributedText = [self getStrOfQHCell:_arrOfTextMessage[indexPath.row]];
            
            
        }else if (indexPath.row==5){
            cell.textLabel.attributedText = [self getStrOfSSCell:_arrOfTextMessage[indexPath.row]];
        }else{
            cell.textLabel.text = _arrOfTextMessage[indexPath.row]!=nil?_arrOfTextMessage[indexPath.row] : @"注意事项";

        }
        
    }else{
       
        if (indexPath.row==2) {
         
            cell.textLabel.attributedText = [self getStrOfLastCell];
        }else{
            cell.textLabel.text = _arrOfTextMessageTwo[indexPath.row]!=nil?_arrOfTextMessageTwo[indexPath.row] : @"注意事项";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *sectionHeaderL = [[UILabel alloc]init];
    sectionHeaderL.backgroundColor = Y_RGBA(245, 245, 245, 1);
    sectionHeaderL.font = [UIFont systemFontOfSize:14];
    sectionHeaderL.frame = CGRectMake(10, 0, _textTableView.width-20, 20);
    if (section==0) {
        sectionHeaderL.text = NSLocalizedString(@"添加方式一", nil) ;

    }else{
        sectionHeaderL.text = NSLocalizedString(@"添加方式二",nil);
    }
    return sectionHeaderL;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row==2) {
        //扫一扫
        GenerateQrCodeViewController *generateQrCodeVc = [[GenerateQrCodeViewController alloc]init];
        [self.navigationController pushViewController:generateQrCodeVc animated:YES];
    }
    if (indexPath.section == 0) {
        if (indexPath.row==4) {
            //切换
            [self changeWifiVc];
            
        }
        if (indexPath.row==5) {
            //搜索
            [self searchAction];
        }
        
    }
}
#pragma mark -- 多色str cell
#pragma mark -- 方法一的cell
//5.点击切换Wi-Fi热点，将手机Wi-Fi切换到“|”热点上
- (NSMutableAttributedString *)getStrOfQHCell:(NSString *)str{
    UIColor *textShowColor = [DataManager shareDataManager].colorOfMainType;
    
    //匹配Wi-Fi前缀
    NSString *strOfWf = [DataManager shareDataManager].wifiMatchStr;
    
    str = [str stringByReplacingOccurrencesOfString:@"|" withString:strOfWf];
    //前4
    int a = 3;
    int b = 9;
    if (self.title.length>5) {//switch wi-fi hotspots 6 5 8+2
        //前   5.Click the
        a = 10;
        b = 21;
    }else{
        //前4
        a = 3;
        b = 9;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, a)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.5] range:NSMakeRange(a+1, b)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(a+b, attributedStr.length-a-b)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, a)];//黑
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];//maincolor
    //下划线
    [attributedStr addAttribute:NSUnderlineColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(a+1, b)];
    return attributedStr;
}

//6.点击搜索扫地机
- (NSMutableAttributedString *)getStrOfSSCell:(NSString *)str{
    UIColor *textShowColor = [DataManager shareDataManager].colorOfMainType;
    //search robot
    int a = 3;
    int b = 5;
    if (self.title.length>5) {
        //前   5.Click to
        a = 11;
        b = 12;
    }else{
        //前4
        a = 3;
        b = 5;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, a)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.5] range:NSMakeRange(a+1, b)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(a+b, attributedStr.length-a-b)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, a)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];
    //下划线
    [attributedStr addAttribute:NSUnderlineColorAttributeName value:textShowColor range:NSMakeRange(a+1, b)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(a+1, b)];
    return attributedStr;
}

#pragma mark -- 方法二的cell

- (NSMutableAttributedString *)getStrOfLastCell{
    UIColor *textShowColor = [DataManager shareDataManager].colorOfMainType;
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"3.你可以，通过扫描二维码添加到机器人", nil)];
    
    int indexNum = 7;
    if(self.title.length>5){
        indexNum = 32;//3.You can add it to the robot by 
    }else{
        //前7个字符不是
        indexNum = 7;
    }
    
   
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, indexNum)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.5] range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, indexNum)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:textShowColor range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    //下划线
    [attributedStr addAttribute:NSUnderlineColorAttributeName value:textShowColor range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(indexNum+1, attributedStr.length-indexNum-1)];
    return attributedStr;
}

#pragma mark -- udp

- (void)initUDP{
    [TCPManager shareTCPManager].tcpDelegate = self;
}

- (void)sendMsgToService{
    
    if (_udpSocket == nil) {
        
    }else{
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
//     [_udpSocket sendData:data toHost:@"255.255.255.255" port:_servicePort withTimeout:15 tag:1];
}

//#pragma mark -- //tcp连接
//- (void)connectToService{
//     [TCPManager shareTCPManager].tcpDelegate = self;
//     [[TCPManager shareTCPManager] doConnect];
//}
#pragma mark --  //udp回调方法
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
//     [self.view makeToast:@"正在发起对机器人的连接，请稍后"  duration:3 position:@"center"];
}


-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
     [self.view makeToast:NSLocalizedString(@"连接机器人失败，请重新搜索",nil) duration:3 position:@"center"];
    [self stopLoopAnimation];
//    _lodingL.text = @"暂时未搜索到扫地机";
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    [self.view makeToast:NSLocalizedString(@"连接机器人成功" , nil)  duration:3 position:@"center"];
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    
    [sock close];
    _udpSocket = nil;
    
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error{
    [self.view makeToast:NSLocalizedString(@"连接机器人失败，请重新搜索", nil) duration:3 position:@"center"];
    [self stopLoopAnimation];
//    _lodingL.text = @"暂时未搜索到扫地机";
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    [_timerOfStopAnimation invalidate];
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
        
            [self showContAddmsg];
            if (_udpSocket) {
                [_udpSocket close];
            }
            [sock close];
             NSLog(@"关闭");
            return;
        }
        
        //可添加时
            _nameOfUdpStr = array[0];
            _portOfTcp = [array[1] intValue];
            NSLog(@"array = %@",array);
            [DataManager shareDataManager].sweeperIP = _addressOfTcpStr;
            [DataManager shareDataManager].sweeperPort = array[1];
            [DataManager shareDataManager].sweeperID = array[3];
            [DataManager shareDataManager].sweeperIMEI = array[3];
            _nameOfUdpStr = array[2];
            [ShareUser sharedUserInfo].userMode.nowRobotJid = array[3];
            
            [self succeedSearch];//tcp连接
            if (_udpSocket) {
                [_udpSocket close];
            }
        [sock close];
    }
    
    
    
}

- (void)socketDidConnectSuccessWithTcpStatus:(enum TcpStatus)tcpStatus{
    
}
#pragma mark -- showContAddmsg
- (void)showContAddmsg{
    //停止转盘
    [self stopLoopAnimation];
    //数据初始化状态
    [self initData];
    //弹出框
//    [self.view makeToast:@"该机器人暂无法添加，请先升级APP" duration:4 position:@"center"];
 
    UIAlertController *alertOfShow = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)  message:NSLocalizedString(@"该机器人暂无法添加，请先升级APP", nil)  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alertOfShow addAction:knowAction];

    alertOfShow.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alertOfShow animated:YES completion:nil];
    
}


/*🐟    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
 //    func socketDidReceiveData(msg:String, withData data:Data?,tag:Int)
 func socketDidReceiveData( msg:String, withData data:Data?)
 func socketDidConnectSuccess(tcpStatus:TcpStatus)
 func reloadProgress(pro:CGFloat)
 
 */

@end


