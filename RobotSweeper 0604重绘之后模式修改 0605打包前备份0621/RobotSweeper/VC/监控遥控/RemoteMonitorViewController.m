//
//  RemoteMonitorViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/8.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "RemoteMonitorViewController.h"
#import "XYSwitch.h"
@interface RemoteMonitorViewController ()<XmppManagerDelegate,JkYkNeedMessageAndUserStatusDelegate>
//顶部
@property (nonatomic,strong)IJKFFMoviePlayerController *player;
@property (nonatomic,strong)UIView *topBackView;
@property (nonatomic,strong)UILabel *timeTitleL;
@property (nonatomic,strong)UILabel *timeContentL;
@property (nonatomic,strong)UILabel *electricTitleL;
@property (nonatomic,strong)UILabel *electricContentL;
@property (nonatomic,strong)NSString *electricContentStr;//0124

//1114新增tiemr长按使用
@property (nonatomic,assign)NSTimer *longTapTimer;
@property (nonatomic,assign)int longTapTimerNum;//长按非结束时 判断 执行所用的num ==0结束  非0 继续发送

//方向盘
/* order_control val
   val:0停止 1前进 2后推 3左 4右
 */
//根据背景图颜色控制点击是否响应
@property (nonatomic,strong)UIView *directionBackView;
@property (nonatomic,strong)OBShapedButton *stopBtn;
@property (nonatomic,strong)OBShapedButton *goBtn;
@property (nonatomic,strong)OBShapedButton *backBtn;
@property (nonatomic,strong)OBShapedButton *leftBtn;
@property (nonatomic,strong)OBShapedButton *rightBtn;

@property (nonatomic,strong)UIView *clicksignView;//Click on the sign 点击手势的view
//@property (nonatomic,assign)BOOL isCanClick;//可以点击当在清扫中时则弹出框 1210

@property (nonatomic,assign)int timeOfCantGetClearnType;//=0初始时，发送0or1之后的=5，时间参数在5秒内由接受数据-1直到=0大于0时不赋值给clearnSwitch

@property (nonatomic,assign)int isRobotOrAppOffLine;//可以点击当在离线状态时则弹出框0 在线 1扫地机离线 2用户离线
//底部
@property (nonatomic,strong)XYSwitch *clearnSwitch;
@property (nonatomic,strong)UIButton *clearnBtn;
@property (nonatomic,strong)XYSwitch *monitorSwitch;

@property (nonatomic,strong)NSTimer* timerOfSetClearnSwitch;//视频按钮状态
@property (nonatomic,strong)NSTimer* timerOfSetTime;//时间更新
@property (nonatomic,assign)int  timerOfSetTimeNum;//时间更新总秒数

//新增自动清扫按钮和回充按钮1225
@property (nonatomic,strong)UIImageView *imgvLineBomm;//虚线
@property (nonatomic,strong)UIButton *automaticCleanBtn;//清扫按钮
@property (nonatomic,strong)UIButton *homeChargeBtn;//回充按钮
@property (nonatomic,assign)int  isClearningStatusOrChargingStatus;//清扫or充电int 初始0 清扫1 充电2
//1225新增label
@property (nonatomic,strong)UILabel *labelOfGoBtn;
@property (nonatomic,strong)UILabel *labelOfRightBtn;
@property (nonatomic,strong)UILabel *labelOfLeftBtn;

//0118新增
@property (nonatomic,strong)NSTimer *timerOfSendFeng;
//20190619新增num
@property (nonatomic,assign)int upViewTimerNumber;
@end

@implementation RemoteMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"监控", nil) ;
    self.view.backgroundColor = [UIColor whiteColor];

    [self initData];
    [self initView];
    [self isOnlyShowMonitorChangView:_isOnlyShowMonitor];//20190523
    [self initTimer];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];//删除视频视图
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
}
- (void)initView{
    
    //20190619
   [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//删除全部之后更新会有新图
    if (_player!=nil) {
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
    }
    
    [ShareUser sharedUserInfo].userMode.nowRobotJidMonitor = @"";
    if ([ShareUser sharedUserInfo].userMode.nowRobotJidMonitor.length==0) {
//        NSString* str1 = @"rtsp://r.robotleo.com/live";
        NSString* str1 = @"rtsp://sweep.robotleo.com/live";//0129更改服务器地址
        NSString* strID = [ShareUser sharedUserInfo].userMode.nowRobotJid;
//        NSString* strEnd = [NSString stringWithFormat:@"%@%@0.sdp",str1,[strID substringFromIndex:strID.length-6]];//0103不拼接0 直接取后六位
        NSString* strEnd = [NSString stringWithFormat:@"%@%@.sdp",str1,[strID substringFromIndex:strID.length-6]];//0103不拼接0 直接取后六位
        [ShareUser sharedUserInfo].userMode.nowRobotJidMonitor = strEnd;
    }
    
    //视频监控地址的请求  request_monitor请求监控 response_monitor反馈监控信息 监控开启命令
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_monitor"];
     if ([ShareUser sharedUserInfo].userMode.nowRobotJidMonitor.length!=0) {
        [self monitorV];
    }else{
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_monitor"];
    }
    
    [self.view addSubview:self.topBackView];
    [_topBackView addSubview:self.timeTitleL];
    [_topBackView addSubview:self.timeContentL];
    [_topBackView addSubview:self.electricTitleL];
    [_topBackView addSubview:self.electricContentL];
    
    [self.view addSubview:self.directionBackView];
//    [_directionBackView addSubview:self.stopBtn];
//    [_directionBackView addSubview:self.backBtn];
    [_directionBackView addSubview:self.goBtn];
    [_directionBackView addSubview:self.rightBtn];
    [_directionBackView addSubview:self.leftBtn];
    [_directionBackView addSubview:self.clicksignView];//点击响应对应坐标
    //label
    [_goBtn addSubview:self.labelOfGoBtn];//1225新增
    [_leftBtn addSubview:self.labelOfLeftBtn];
    [_rightBtn addSubview:self.labelOfRightBtn];
    
    [self.view addSubview:self.clearnSwitch];//清扫选择器
//    [self.view addSubview:self.clearnBtn];//隐藏现不用btn类型改回switch
    [self.view addSubview:self.monitorSwitch];//视频
    
    [self getnewYuShuOfTopV];//顶部
    [self getnewYuShuOfDirectionV];//方向盘
    [self getnewYuShuOfBottonV];//底部
    //现在的风机开关协议未有，现隐藏clearnSwitch
//    _clearnSwitch.hidden = YES;;//1219风机协议OK
    
    //新增清扫和回充按钮 1225
    [self.view addSubview:self.imgvLineBomm];
    [self.view addSubview:self.automaticCleanBtn];
    [self.view addSubview:self.homeChargeBtn];
    [self getnewYuShuofBmV];
    _electricContentL.text = _electricContentStr;
    
}

- (void)initTimer{//视频开关的显示状态 和 view更新的次数
    _upViewTimerNumber = 0;
    
    _timerOfSetClearnSwitch = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([ShareUser sharedUserInfo].userMode.nowRobotJidMonitor.length == 0) {//请求数据
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_monitor"];
        }else{//更新ui
            if (_isRobotOrAppOffLine==0) {
                if ([self.player isPlaying]) {
                    NSLog(@"开着isPlaying==yes");
                    [self.monitorSwitch stateOn];
                    _monitorSwitch.isOn = YES;
                    
                }else{
                    NSLog(@"关着isPlaying==no");
                    [self.monitorSwitch stateOff];
                    _monitorSwitch.isOn = NO;
                    
                    
                }
            }else{//离线状态
                NSLog(@"关着isPlaying==no");
                [self.monitorSwitch stateOff];
                _monitorSwitch.isOn = NO;
            }
            
        }
        
        //    _upViewTimerNumber = 0;
        if (_upViewTimerNumber>0) {
            
            _upViewTimerNumber-=1;
            if (_player.isPlaying==NO) {//视频没有播放才重新刷新view
                [self initView];
                [self isOnlyShowMonitorChangView:_isOnlyShowMonitor];//20190618//从离线切换到在线 重新请求视频
            }
        }else{
            
        }
        
    }];
}
#pragma mark -----------------------------------------监控漂浮按钮点击过来时 只显示监控相关不显示遥控等按钮--------
- (void)isOnlyShowMonitorChangView:(BOOL)isShow{
    if (isShow) {
        //显示一部分 隐藏其余按钮
        _clicksignView.hidden = YES;
        _directionBackView.hidden = YES;
        _imgvLineBomm.hidden = YES;
        _homeChargeBtn.hidden = YES;
        _automaticCleanBtn.hidden = YES;
        _monitorSwitch.hidden = YES;
        _clearnSwitch.hidden = YES;
        
        //遥控时间 也隐藏 且更换电量的约束
        _timeTitleL.hidden = YES;
        _timeContentL.hidden = YES;
        [self chanDumpEnergyConstranint];
    }else{
        //全部显示
    }
}
- (void)chanDumpEnergyConstranint{
    [_electricTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15);
        make.height.equalTo(_topBackView.mas_height);
//        make.centerX.equalTo(_topBackView).multipliedBy(1.25);//
         make.centerX.equalTo(_topBackView).multipliedBy(0.85);//1-0.15 + 0.125*0.5==925x
        
    }];
    [_electricContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15);
        make.height.equalTo(_topBackView.mas_height);
        make.left.equalTo(_electricTitleL.mas_right);
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    _timerOfSendFeng = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendFengJiInfo:) userInfo:nil repeats:NO];//主线程
    //20190517 发送风机相关指令 是否移除 待定
    //20190606
    
}
- (void)sendFengJiInfo:(NSTimer *)timer{
    
    //电量足够 非清扫 非充电非回充 在线状态
    if([[_electricContentStr stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue]>20 && _isRobotOrAppOffLine==0 && _isClearningStatusOrChargingStatus==0){//在线 _isRobotOrAppOffLine 0
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 0"];//@"风机边刷
    }
    [timer invalidate];
    timer = nil;
    NSLog(@"风机初始发送数据");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timerOfSetClearnSwitch invalidate];
    _timerOfSetClearnSwitch  = nil;
    [_timerOfSetTime invalidate];
    _timerOfSetTime = nil;
    [_longTapTimer invalidate];
    _longTapTimer = nil;
    //离开遥控模式 退出边刷
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 1"];
    
}
- (void)initData{
 
    
    if (_strOfShowAreaTimeCharge.length>0) {
//        _timeContentL.text = [NSString stringWithFormat:@"%@'",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"][1]];
        _electricContentL.text = [NSString stringWithFormat:@"%@%%",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"].lastObject];
        _electricContentStr = [NSString stringWithFormat:@"%@%%",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"].lastObject];//电量0124
        
    }
//    [XmppManager shareXmppManager].delegates = self;//更换了协议
//
    
    //可点击    
//    _isCanClick = YES;更具地图数据来
    //清扫按钮
    _timeOfCantGetClearnType = 0;
    
    _isRobotOrAppOffLine=0;//在线
     _longTapTimerNum = 0;//长按初始
     _isClearningStatusOrChargingStatus = 0;//清扫or充电int 初始0 清扫1 充电2
   
}

#pragma mark -- time定时启动
- (void)beginDateChange{
 
    if (_timerOfSetTime!=nil) {//点击遥控按钮后调用，不为空则已经调用过。
        return;
    }
    _timerOfSetTimeNum = 0;
    
    
    _timerOfSetTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerOfSetTimeAction:) userInfo:nil repeats:YES];
    
//    _timerOfSetTime = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        _timerOfSetTimeNum+=1;
//        _timeContentL.text = [NSString stringWithFormat:@"%@",[ToolOfBasic timeStr:_timerOfSetTimeNum]];
//    }];
}
- (void)timerOfSetTimeAction:(NSTimer*)timer{
    _timerOfSetTimeNum+=1;
    _timeContentL.text = [NSString stringWithFormat:@"%@",[ToolOfBasic timeStr:_timerOfSetTimeNum]];
    //1208新增 err弹出框只弹出1次的问题 但要兼顾延迟 即：原定时间10秒清空errArr数据 现在map界面timer停止，在此处通知调用map页errorArr清空方法
        if (_timerOfSetTimeNum%10==0) {//10秒
//    if (_timerOfSetTimeNum%3==0) {//3秒
        //通知 没有效果暂时用block
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"DeletCodeErrArrNotice" object:nil];
        if(self.errDeletbloc != nil){
            self.errDeletbloc(@"deletcodeErrAr");
        }
    }
}

#pragma mark --
- (void)receiveXmppJkYkMessageWithMessage:(NSString *)message{
    
    if (_isRobotOrAppOffLine!=0 || self.player.isPlaying==NO) {
        _upViewTimerNumber += 1;//更新view20190619
    }
    
    //在线信息

    NSArray *arrOfmsg = [NSArray arrayWithArray:[message componentsSeparatedByString:@" "]];
    NSString *type = arrOfmsg.firstObject;
    
    if (_timeOfCantGetClearnType>0) {//清扫按钮的赋值响应延时int
        _timeOfCantGetClearnType=_timeOfCantGetClearnType-1;
    }
    if ([message containsString:@"停止清扫"]||[message containsString:@"休眠中"]) {
        
        if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
            _clearnBtn.selected = NO;
            _isCanClick = YES;
        }
    }
    
    if ([message containsString:@"清扫中"]) {//清扫中离线中都不可点
        
        //清扫按钮是开启
          if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
              _clearnBtn.selected = YES;
               _isCanClick = NO;  //不可点击
          }
    }
    
    if ([type isEqualToString:@"clean_info"] && arrOfmsg.count>=6) {
        int modenum =  [[NSString stringWithFormat:@"%@",arrOfmsg[1]] intValue];//1模式2力度
        if (modenum==0) {
            
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _clearnBtn.selected = NO;
                _isCanClick = YES;  //可点击
                if (_isClearningStatusOrChargingStatus!=2) {
                    _isClearningStatusOrChargingStatus = 0;
                }
            }
        }else{//清扫模式
            _isClearningStatusOrChargingStatus = 1;
            //清扫按钮是开启
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _clearnBtn.selected = YES;
                _isCanClick = NO;  //不可点击
                _isClearningStatusOrChargingStatus = 1;
            }
        }
        
        
        //        _timeContentL.text = [NSString stringWithFormat:@"%@'",arrOfmsg[3]];
        _electricContentL.text = [NSString stringWithFormat:@"%@%%",arrOfmsg.lastObject];//电量
    }
    _isRobotOrAppOffLine = 0;//0 在线
    
    
    //1207 以上为中文和空格分割的情况 以下新增  以前中文现在数字msg，用协议来直接判断
    //:格式的状态
    if ([message containsString:@":"]) {
        NSArray *arrOfmsgOfState = [NSArray arrayWithArray:[message componentsSeparatedByString:@":"]];
        NSString *typeOfState = arrOfmsgOfState.firstObject;
        if ([typeOfState containsString:@"nav_cleaning"] || [typeOfState containsString:@"zone_cleaning"] || [typeOfState containsString:@"emphases_cleaning"] || [typeOfState containsString:@"followall_cleaning"]) {//start_home
            //4种清扫状态
            _isClearningStatusOrChargingStatus = 1;
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _isCanClick = NO;//不可点击
                _isClearningStatusOrChargingStatus = 1;
            }
        }else if ([typeOfState containsString:@"stop_clean"]){//stop_home
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _isCanClick = YES;//可点击
                _isClearningStatusOrChargingStatus = 0;
            }
        }else if([typeOfState containsString:@"start_home"]){//开始回充
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _isCanClick = NO;
                _isClearningStatusOrChargingStatus = 2;
            }
        }else if([typeOfState containsString:@"charing"]){//充电中
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _isCanClick = NO;
                _isClearningStatusOrChargingStatus = 2;
            }
            
        }else{//stop_home
            if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
                _isCanClick = YES;//可点击
            }
        }
    }
    
    //1221补充
    if([message containsString:@"standby"] || [message containsString:@"sleep"]){
        if(self.errDeletbloc != nil){
            self.errDeletbloc(@"deletcodeErrAr");
        }// 清空codeErr存储的Arr
        _isClearningStatusOrChargingStatus = 0;//清空清扫or充电状态
    }
    
    //0107 回充清扫按钮的颜色与可否点击
    if (_isClearningStatusOrChargingStatus == 1) {
        //清扫状态 充电可用
        [self automaticCleanBtnStatus:NO];
        [self homeChargeBtnStatus:YES];
    }else if (_isClearningStatusOrChargingStatus==2){
        //清扫可用 充电状态
        [self automaticCleanBtnStatus:YES];
        [self homeChargeBtnStatus:NO];
    } else {
        //2个按钮都可用
        [self automaticCleanBtnStatus:YES];
        [self homeChargeBtnStatus:YES];
    }
    
    if ([type isEqualToString:@"response_monitor"]&&arrOfmsg.count==2) {
        [ShareUser sharedUserInfo].userMode.nowRobotJidMonitor = [NSString stringWithFormat:@"%@",arrOfmsg.lastObject];
        if (_player==nil) {
             [self monitorV];//监控view
        }else{
//            if (_player.view) {
//                <#statements#>
//            }
        }
        
    }
    _isRobotOrAppOffLine = 0;//0 在线
    
    
    
}
- (void)receiveXmppJkYkUserStatusWithMessage:(NSString *)message{
    if ([message isEqualToString:@"扫地机离线"]) {//0 在线 1扫地机离线 2用户离线
        _isRobotOrAppOffLine = 1;
    }
    if ([message isEqualToString:@"用户离线"]) {
        _isRobotOrAppOffLine = 2;
    }
    //20190618新增在线后重新连接 (用户or扫地机)
    if ([message containsString:@"在线"]) {
        _isRobotOrAppOffLine = 0;
        NSLog(@"20190618新增在线后重新连接 %@",message);
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
    
        [self initView];
        [self isOnlyShowMonitorChangView:_isOnlyShowMonitor];//20190618 离线后上线 重新更新视频
    }
    NSLog(@"JkYkUserStatus_isRobotOrAppOffLine =%d",_isRobotOrAppOffLine);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- view
#pragma mark -- monitorV
- (void)monitorV{
    
    
    NSString *strOfMonitor = [ShareUser sharedUserInfo].userMode.nowRobotJidMonitor;
    IJKFFOptions *opt = [IJKFFOptions optionsByDefault];
 
    
     /*
     [opt setFormatOptionValue:@"tcp" forKey:@"rtsp-tcp"];
     [opt setPlayerOptionIntValue:60  forKey:@"max-fps"];
     [opt setPlayerOptionIntValue:30 forKey:@"r"];
     //跳帧开关
     [opt setPlayerOptionIntValue:1  forKey:@"framedrop"];
     [opt setPlayerOptionIntValue:0  forKey:@"start-on-prepared"];
     [opt setPlayerOptionIntValue:0  forKey:@"http-detect-range-support"];
     [opt setPlayerOptionIntValue:48  forKey:@"skip_loop_filter"];
     [opt setPlayerOptionIntValue:0  forKey:@"packet-buffering"];
     [opt setPlayerOptionIntValue:2000000 forKey:@"analyzeduration"];
     [opt setPlayerOptionIntValue:25  forKey:@"min-frames"];
     [opt setPlayerOptionIntValue:1  forKey:@"start-on-prepared"];
     [opt setCodecOptionIntValue:8 forKey:@"skip_frame"];
     [opt setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
     [opt setFormatOptionValue:@"81920" forKey:@"probsize"];
     //自动转屏开关
     [opt setFormatOptionIntValue:0 forKey:@"auto_convert"];
     //重连次数
     [opt setFormatOptionIntValue:1 forKey:@"reconnect"];
    
    
    //TODO:开启硬解码
    [opt setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    [opt setPlayerOptionIntValue:256000 forKey:@"videotoolbox-max-frame-width"]; // 指定最大宽度
    */
    
//    //20190619删除原视频的view和
//    if (_player.view != nil) {//ijksdlgview
//        [_player.view removeFromSuperview];
//        _player = nil;
//    }
    _player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:strOfMonitor withOptions:opt];

    _player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;//IJKMPMovieScalingModeNone  IJKMPMovieScalingModeAspectFit 半屏全数据,  IJKMPMovieScalingModeAspectFill不变形全屏半数据  IJKMPMovieScalingModeFill 变形全屏全数据
    self.player.shouldAutoplay = YES;
    [self.player setOptionValue:@"tcp" forKey:@"rtsp_transport" ofCategory:kIJKFFOptionCategoryFormat];
  /*  */
    //rtsp设置 https://ffmpeg.org/ffmpeg-protocols.html#rtsp
     [self.player setOptionValue:@"video"  forKey:@"allowed_media_types" ofCategory: kIJKFFOptionCategoryFormat];
     [self.player setOptionValue:@"prefer_tcp"  forKey:@"rtsp_flags" ofCategory: kIJKFFOptionCategoryFormat];
    
      [self.player setOptionIntValue:20000  forKey:@"timeout" ofCategory: kIJKFFOptionCategoryFormat];
    //控制延迟
    [self.player setOptionIntValue:1316 forKey:@"buffer_size" ofCategory:kIJKFFOptionCategoryFormat];
    [self.player setOptionIntValue:1 forKey:@"infbuf" ofCategory:kIJKFFOptionCategoryFormat];
    //
    [self.player setOptionIntValue:100 forKey:@"analyzemaxduration" ofCategory:kIJKFFOptionCategoryFormat];
    [self.player setOptionIntValue:10240 forKey:@"probesize" ofCategory:kIJKFFOptionCategoryFormat]; //
    //
    [self.player setOptionIntValue:1 forKey:@"flush_packets" ofCategory:kIJKFFOptionCategoryFormat];//关闭播放器的缓存
    [self.player setOptionIntValue:0 forKey:@"packet-buffering" ofCategory:kIJKFFOptionCategoryFormat];//去掉缓冲区
    [self.player setOptionIntValue:1 forKey:@"framedrop" ofCategory:kIJKFFOptionCategoryFormat];

    
    self.player.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
 
    [self.view addSubview:self.player.view];
    [self.player.view sendSubviewToBack:self.view];

    [self.player prepareToPlay];
    //    [self.player play];

    
}
#pragma mark -- 长按指令需要轻微移动 才执行的情况使用定时器 暂时不写touchesEnded响应不完全
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    if ([[touch view] isEqual:_clicksignView]) {
        NSLog(@"touchesBegan=point=point=%f %f ",point.x,point.y);
        [self getInfoTosendxmppwithtapPoint:point];
    }
}
#pragma mark -- 手指抬起的响应
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    if ([[touch view] isEqual:_clicksignView]) {
        NSLog(@"touchesCancelled=point=point=%f %f ",point.x,point.y);
        [self upGesAction:point];
        NSLog(@"touchesCancelled %ld",[touch view].tag);
    }else{
        NSLog(@"touchesCancelled %ld",[touch view].tag);
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    if ([[touch view] isEqual:_clicksignView]) {
        NSLog(@"touchesEnded=point=point=%f %f ",point.x,point.y);
        [self upGesAction:point];
        NSLog(@"touchesEnded %ld",[touch view].tag);
    }else{
        NSLog(@"touchesEnded %ld",[touch view].tag);
    }
    
}
#pragma mark -- down和手指抬起的方法
- (void)upGesAction:(CGPoint)touchPoint{
    [self.view layoutIfNeeded];
    CGFloat radiu = self.directionBackView.bounds.size.width*0.5; //半径
    CGPoint cneterP = CGPointMake(radiu, radiu);
    if (CGRectContainsPoint(_directionBackView.bounds, touchPoint)) {
        CGFloat lenOfPP = [ToolOfBasic getLineDustanceApToBpWithPa:touchPoint pb:cneterP];
        if (lenOfPP<radiu) {//点到点的距离小于半径
            NSLog(@"upGesAction");
            if(_isRobotOrAppOffLine!=0){
                //扫地机或用户离线
                if (_isRobotOrAppOffLine==1) {
                    [self.view makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
                    return;
                }
                if (_isRobotOrAppOffLine==2) {
                    [self.view makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
                    return;
                }
            }else{
                if(_isCanClick){//如果非清扫状态，手势区域，发出停止
//                    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_control 0"];
                }else{
                    //清扫状态 在点击发送方向就弹出过
                    //                    [self.view makeToast:@"机器人处于清扫状态，暂时不可控制" duration:1.0 position:@"center"];
                    return;
                }
            }
            
        }
        
    }
}

#pragma mark -- directionBtnAction
//方向盘点击事件
- (void)directionBtnAction:(UIButton *)sender{
    [self beginDateChange];
    
    NSInteger i = sender.tag-TAG_BTN_C;
    if(i==0){
        return;
    }
    NSString *sendStr = [NSString stringWithFormat:@"order_control %ld",(long)i];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
 
    NSLog(@"tag=%ld",sender.tag);
}

/***
 **/

#pragma mark -- view 方向盘点击不响应 用坐标和顶部的新view //sigleTapView 点击 viewTouchedLongTime 长按
- (void)sigleTapView:(UIGestureRecognizer *)ges{
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            [self sigleTagWithges:ges];
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"UIGestureRecognizerStateChanged");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded");
            if (_isCanClick) {
                [self sigleTapEndOrCancelWithges:ges];
            }
            
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled");
            if (_isCanClick) {
                [self sigleTapEndOrCancelWithges:ges];
            }
            break;
            
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed");
            if (_isCanClick) {
                [self sigleTapEndOrCancelWithges:ges];
            }
            break;
        default:
            NSLog(@"UIGestureRecognizerStateCancelled %ld",(long)ges.state);
            break;
    }
    
    
    
}
- (void)sigleTagWithges:(UIGestureRecognizer*)ges{
    NSLog(@"点击V  %@",ges);
    CGPoint point = [ges locationInView:_clicksignView];
    NSLog(@"点击Vnt=point=point=%f %f ",point.x,point.y);
    [self getInfoTosendxmppwithtapPoint:point];
}
- (void)sigleTapEndOrCancelWithges:(UIGestureRecognizer*)ges{
    NSLog(@"点击V  %@",ges);
    CGPoint point = [ges locationInView:_clicksignView];
    NSLog(@"点击Vnt=point=point=%f %f ",point.x,point.y);
    [self upGesAction:point];
}
- (void)viewTouchedLongTime:(UILongPressGestureRecognizer *)ges{
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan long");
            [self longTapWithGes:ges];
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"UIGestureRecognizerStateChanged long");
            [self longTapWithGes:ges];//changed时也调用 新增timer在非移动状态下也能调用发送指令
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded long");
            if (_isCanClick) {
                [self longTapEndOrCancelWithGes:ges];
            }
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"UIGestureRecognizerStateCancelled long");
            _longTapTimerNum=0;//停止下发长按调用的方向指令
            if (_isCanClick) {
                [self longTapEndOrCancelWithGes:ges];
            }
            break;
            
        case UIGestureRecognizerStateFailed:
            NSLog(@"UIGestureRecognizerStateFailed long");
            _longTapTimerNum=0;//停止下发长按调用的方向指令
            if (_isCanClick) {
                [self longTapEndOrCancelWithGes:ges];
            }
            break;
        default:
            NSLog(@"UIGestureRecognizerStateCancelled long %ld",(long)ges.state);
            break;
    }
}
- (void)longTapWithGes:(UILongPressGestureRecognizer *)ges{
      _longTapTimerNum+=1;
    if (_longTapTimer==nil) {
        //初始 长按后的发送方向时间1.0s->0.1s  1秒(s)=1000毫秒(ms) 现在100ms发一次
        _longTapTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(longTapTimerAction:) userInfo:ges repeats:YES];
        
    }
}
- (void)longTapTimerAction:(NSTimer *)timer{
    if (_longTapTimerNum==0) {
        //为0时 即得到过结束状态
        NSLog(@"长按timer0");
        [_longTapTimer invalidate];
        _longTapTimer = nil;
    }else{
        [self timerOfLongTapContinue:timer.userInfo];
        NSLog(@"长按timer=%d",_longTapTimerNum);
    }
    
}
- (void)timerOfLongTapContinue:(UILongPressGestureRecognizer *)ges{
    NSLog(@"长按V %@",ges);
    CGPoint point = [ges locationInView:_clicksignView];
    NSLog(@"长按=point=point=%f %f ",point.x,point.y);
    [self getInfoTosendxmppwithtapPoint:point];
}
- (void)longTapEndOrCancelWithGes:(UILongPressGestureRecognizer *)ges{
     _longTapTimerNum=0;//停止下发长按调用的方向指令
    NSLog(@"长按V %@",ges);
    CGPoint point = [ges locationInView:_clicksignView];
    NSLog(@"长按=point=point=%f %f ",point.x,point.y);
    [self upGesAction:point];
}

/**
 **/

#pragma mark -- 计算point
- (void)getInfoTosendxmppwithtapPoint:(CGPoint )touchPoint{//clicksignView 和directionBackView同样大小就相通使用
    [self.view layoutIfNeeded];
    CGFloat radiu = self.directionBackView.bounds.size.width*0.5; //半径
    CGPoint cneterP = CGPointMake(radiu, radiu);
    if (CGRectContainsPoint(_directionBackView.bounds, touchPoint)) {
        CGFloat lenOfPP = [ToolOfBasic getLineDustanceApToBpWithPa:touchPoint pb:cneterP];
        if (lenOfPP<radiu) {//点到点的距离小于半径
            //x值 区分位置是t l r
            if (touchPoint.x<radiu) {//top left
                CGPoint czP = CGPointMake(touchPoint.x, radiu);//垂足p
                CGFloat jd = [ToolOfBasic getAnglesWithThreePoint:touchPoint pointB:cneterP pointC:czP];
                NSLog(@"tl角度=%f",jd);//（后20~160度为top 20～-90为右 -90~160为左）-->0-20和负角度=左 20-90正角度为top
                if (jd>20) {
                    NSLog(@"前钮位置");
                    [self sendXmppWithtag:1];
                }else{
                    NSLog(@"左钮位置");
                    [self sendXmppWithtag:3];
                }
            }else{//t r
                CGPoint czP = CGPointMake(touchPoint.x, radiu);//垂足p AB为直角边
                CGFloat jd = [ToolOfBasic getAnglesWithThreePoint:touchPoint pointB:cneterP pointC:czP];
                NSLog(@"tr角度=%f",jd);//(图 20~160度为top 20～-90为右 -90~160为左)-->0-20和负角度=右 20-90正角度为top
                if (jd>20) {
                    NSLog(@"前按钮位置");
                    [self sendXmppWithtag:1];
                }else{
                    NSLog(@"右按钮位置");
                    [self sendXmppWithtag:4];
                }
            }
            
        }else{
            NSLog(@"lenOfPP过长不在园内=%f",lenOfPP);
        }
        
    }
    
}
- (void)sendXmppWithtag:(int)tag{
    //0=stop ,go=1,3=left,4=right;
    
    if (_isRobotOrAppOffLine==1) {
         [self.view makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
         [self.view makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        return;
    }
    //判断是否发送控制指令
    if (_isClearningStatusOrChargingStatus==1) { 
        [self.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
         return;
    } else if(_isClearningStatusOrChargingStatus==2){
        [self.view makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];//充电状态 座充状态 以后能够弹出框离开充电桩指令exit_charging_station
         return;
    }
    if(_isCanClick==NO){
        [self.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil)  duration:1.5 position:@"center"];
        return;
    }
    if([_electricContentL.text floatValue]<=20){
        [self.view makeToast:NSLocalizedString(@"电量过低,暂不可操纵", nil)  duration:1.0 position:@"center"];
        return;
    }
    [self beginDateChange];//定时器启动
    NSInteger i = tag;
    switch (tag) {
        case 0:
            return;
            break;
        case 1:
            _goBtn.selected = !_goBtn.selected;
            
            break;
        case 3:
            _leftBtn.selected = !_leftBtn.selected;
            break;
        case 4:
            _rightBtn.selected = !_rightBtn.selected ;
            break;
        default:
            break;
    }
    
    NSString *sendStr = [NSString stringWithFormat:@"order_control %ld",(long)i];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    NSLog(@"sendStr = %@",sendStr);
}

#pragma mark -- topV
- (void)getnewYuShuOfTopV{
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);
        make.width.equalTo(self.view.mas_width).offset(-20);
        make.top.equalTo(self.view).offset(100);
    }];
    
    
    [_timeContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15).offset(8);
        make.height.equalTo(_topBackView.mas_height);
        make.centerX.equalTo(_topBackView).multipliedBy(0.75);
        
    }];
    [_timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15).offset(-8);
        make.height.equalTo(_topBackView.mas_height);
        make.right.equalTo(_timeContentL.mas_left);
    }];
    [_electricTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15);
        make.height.equalTo(_topBackView.mas_height);
        make.centerX.equalTo(_topBackView).multipliedBy(1.25);
        
    }];
    [_electricContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topBackView);
        make.width.equalTo(_topBackView.mas_width).multipliedBy(0.15);
        make.height.equalTo(_topBackView.mas_height);
        make.left.equalTo(_electricTitleL.mas_right);
        
    }];
    
}
#pragma mark -- 方向盘
- (void)getnewYuShuOfDirectionV{
    
    //方向盘背景v
    [_directionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.6);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
    }];
    
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_directionBackView.mas_bottom).offset(5);
        make.right.equalTo(_directionBackView.mas_right).multipliedBy(0.5).offset(-1);//右约束是背景图的中心
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.5);
        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.7);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_directionBackView.mas_bottom).offset(5);
        make.left.equalTo(self.leftBtn.mas_right).offset(1);//并挨着
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.5);
        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.7);
    }];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_directionBackView);
        make.top.equalTo(_directionBackView.mas_top);
        make.width.equalTo(_directionBackView.mas_width);
        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.5);
    }];
    
    [_clicksignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_directionBackView.mas_left);
        make.right.equalTo(_directionBackView.mas_right);
        make.top.equalTo(_directionBackView.mas_top);
        make.bottom.equalTo(_directionBackView.mas_bottom);
    }];
    
    /**
    
    [_directionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_directionBackView);
        make.centerY.equalTo(_directionBackView);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
        make.height.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
    }];
    
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_directionBackView);
        make.top.equalTo(_directionBackView.mas_top);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.9);
        make.height.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_directionBackView);
        make.bottom.equalTo(_directionBackView.mas_bottom);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.9);
        make.height.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_directionBackView);
        make.left.equalTo(_directionBackView.mas_left);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
        make.height.equalTo(_directionBackView.mas_width).multipliedBy(0.9);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_directionBackView);
        make.right.equalTo(_directionBackView.mas_right);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.3);
        make.height.equalTo(_directionBackView.mas_width).multipliedBy(0.9);
    }];
     */
    //titleLable 1225新增
    [_labelOfGoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goBtn);
        make.centerY.equalTo(_goBtn).multipliedBy(1.2);
        make.width.equalTo(_goBtn.mas_width).multipliedBy(0.3);
        make.height.equalTo(_goBtn.mas_height).multipliedBy(0.2);
        
    }];
    
    [_labelOfLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftBtn).multipliedBy(1);;
        make.centerY.equalTo(_leftBtn).multipliedBy(1.4);
        if (self.title.length<3) {
             make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.4);//
        }else{
             make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.5);
        }
       
        make.height.equalTo(_leftBtn.mas_height).multipliedBy(0.15);
        
    }];
    
    [_labelOfRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightBtn).multipliedBy(1);
        make.centerY.equalTo(_rightBtn).multipliedBy(1.4);
        if (self.title.length<3) {
            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.3);//
        }else{
            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.5);
        }
        make.height.equalTo(_rightBtn.mas_height).multipliedBy(0.15);
        
    }];
}
#pragma mark -- 底部约束与方法
- (void)getnewYuShuOfBottonV{
//    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(70);
//        make.height.offset(35);
//        make.left.equalTo(self.view.mas_left).offset(10);
//        make.centerY.equalTo(_directionBackView.mas_centerY).offset(-20);
//    }];
    [_clearnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.height.offset(35);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerY.equalTo(self.view).multipliedBy(1.6);
    }];

    
   
    [_monitorSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.height.offset(35);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(_clearnSwitch.mas_bottom).offset(40);
    }];
 __weak RemoteMonitorViewController *selfWeak = self;
    Y_WEAKSELF
    _monitorSwitch.changeStateBlock = ^(BOOL isOn) {
        if (isOn) {
            //开启
            NSLog(@"开");
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于离线状态,暂时不可连接监控", nil) duration:1.0 position:@"center"];
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态,暂时不可连接监控", nil)  duration:1.0 position:@"center"];
                return;
            }
            [weakSelf.player play];
        }else{
            //关闭
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于离线状态,暂时不可连接监控", nil) duration:1.0 position:@"center"];
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态,暂时不可连接监控", nil) duration:1.0 position:@"center"];
                return;
            }
            NSLog(@"设为关闭状态");
            [weakSelf.player pause];
        }
    };
    
    _clearnSwitch.changeStateBlock = ^(BOOL isOn) {
        if (isOn) {
            //开启
            NSLog(@"开");
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast: NSLocalizedString(@"机器人处于离线状态", nil)  duration:1.0 position:@"center"];
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态",nil) duration:1.0 position:@"center"];
                return;
            }
           [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 2"];//@"风机边刷开关开启
        }else{
            //关闭
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于离线状态", nil) duration:1.0 position:@"center"];
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态",nil) duration:1.0 position:@"center"];
                return;
            }
            NSLog(@"设为关闭状态");
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 0"];//@"风机边刷开关开启
        }
    };
    
}

#pragma mark -- getter //topv
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView    = [[UIView alloc]init];
//        _topBackView.backgroundColor = [UIColor whiteColor];
    }
    return _topBackView;
}

- (UILabel *)timeTitleL{
    if (!_timeTitleL) {
        _timeTitleL = [[UILabel alloc]init];
        _timeTitleL.text = NSLocalizedString(@"遥控\n时间", nil);
        _timeTitleL.numberOfLines = 2;
        _timeTitleL.font = [UIFont systemFontOfSize:12];
        _timeTitleL.textAlignment = NSTextAlignmentCenter;//NSTextAlignmentRight
        _timeTitleL.backgroundColor = [UIColor whiteColor];
    }
    return _timeTitleL;
}
- (UILabel *)timeContentL{
    if (!_timeContentL) {
        _timeContentL = [[UILabel alloc]init];
        _timeContentL.font = [UIFont systemFontOfSize:12];
        _timeContentL.textAlignment = NSTextAlignmentLeft;
        _timeContentL.backgroundColor = [UIColor whiteColor];
        _timeContentL.text = @"00:00:00";
    }
    return  _timeContentL;
}
- (UILabel *)electricTitleL{
    if (!_electricTitleL) {
        _electricTitleL = [[UILabel alloc]init];
        _electricTitleL.text = NSLocalizedString(@"剩余\n电量", nil);
        _electricTitleL.numberOfLines = 2;
        _electricTitleL.font = [UIFont systemFontOfSize:13];
        _electricTitleL.textAlignment = NSTextAlignmentCenter;
         _electricTitleL.backgroundColor = [UIColor whiteColor];
        
    }
    return _electricTitleL;
}
- (UILabel *)electricContentL{
    if (!_electricContentL) {
        _electricContentL = [[UILabel alloc]init];
        _electricContentL.font = [UIFont systemFontOfSize:20];
        _electricContentL.textAlignment = NSTextAlignmentLeft;
        _electricContentL.backgroundColor = [UIColor whiteColor];
    }
    return _electricContentL;
}
#pragma mark -- getter //方向盘

- (UIView *)directionBackView{
    if (!_directionBackView) {
        _directionBackView = [[UIView alloc]init];
    }
    return _directionBackView;
}

- (OBShapedButton *)stopBtn{
    if (!_stopBtn) {
        _stopBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_stopBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _stopBtn.tag = TAG_BTN_C+0;
        [_stopBtn setImage:[UIImage imageNamed:@"Angle_Reset1_colour"] forState:UIControlStateNormal];
        _stopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _stopBtn;
}
- (OBShapedButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_goBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _goBtn.tag = TAG_BTN_C+1;
    
        UIImage *goimg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"xiangqian"];
        [_goBtn setImage:goimg  forState:UIControlStateNormal];
        _goBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goBtn;
}

- (OBShapedButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = TAG_BTN_C+2;
        [_backBtn setImage:[UIImage imageNamed:@"Angle_Down1_colour"] forState:UIControlStateNormal];
        _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backBtn;
}
- (OBShapedButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag = TAG_BTN_C+3;
    
        UIImage *limg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zuozhuan"];
        [_leftBtn setImage:limg  forState:UIControlStateNormal];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
       
    }
    return _leftBtn;
}
- (OBShapedButton *)rightBtn{
    if ( !_rightBtn ) {
         _rightBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag = TAG_BTN_C+4;
    
       
        UIImage *rimg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"youzhuan"];
        [_rightBtn setImage:rimg  forState:UIControlStateNormal];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightBtn;
   
}
- (UIView *)clicksignView{
    if (!_clicksignView) {
        _clicksignView = [[UIView alloc]init];
        //        _clicksignView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        
        //        长按手势
        UILongPressGestureRecognizer *longPressOfGoBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouchedLongTime:)];
        longPressOfGoBtn.minimumPressDuration = 0.5; //定义按的时间
        longPressOfGoBtn.allowableMovement=0.1;//move的移距离响应
        [_clicksignView  addGestureRecognizer:longPressOfGoBtn];
        
        //         UIGestureRecognizerStateEnded
        //点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapView:)];
        [singleTap setNumberOfTapsRequired:1];
        [_clicksignView addGestureRecognizer:singleTap];
        _clicksignView.tag = 334;
        
    }
    return _clicksignView;
}
//换回switch不用btn
- (UIButton *)clearnBtn{
    if (!_clearnBtn) {
        _clearnBtn = [[UIButton alloc]init];
        [_clearnBtn setImage:[UIImage imageNamed:@"监控_清扫灰色"] forState:UIControlStateNormal];
        [_clearnBtn setImage:[UIImage imageNamed:@"监控_清扫灰色"] forState:UIControlStateHighlighted];
        [_clearnBtn setImage:[UIImage imageNamed:@"监控_清扫绿色"] forState:UIControlStateSelected];
        [_clearnBtn setImage:[UIImage imageNamed:@"监控_清扫绿色"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_clearnBtn addTarget:self action:@selector(clearnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearnBtn;
}
- (void)clearnBtnAction:(UIButton *)sender{
    if (_isRobotOrAppOffLine==1) {
        [self.view makeToast:NSLocalizedString(@"机器人处于离线状态", nil)  duration:1.0 position:@"center"];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
        [self.view makeToast:NSLocalizedString(@"用户处于离线状态", nil)  duration:1.0 position:@"center"];
        return;
    }
    
    sender.selected = !sender.selected;//更换状态
    if (sender.selected) {
        NSLog(@"开");
        NSString *sendStr = [NSString stringWithFormat:@"auto_clean"];
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];// auto_clean  order_control 0
        _isCanClick = NO;//不可点击
        _timeOfCantGetClearnType = 15;//延时接受数据状态，避免被切回原状态 由于数据量过大，该num设为较大值预计可在3秒内被-=0
    }else{
        //关闭
        NSLog(@"设为关闭状态");
        NSString *sendStr = [NSString stringWithFormat:@"order_control 0"];
//        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
        _isCanClick = YES;//可点击状态
       _timeOfCantGetClearnType = 15;//延时接受数据状态，避免被切回原状态 由于数据量过大，该num设为较大值预计可在3秒内被-=0
    }
}
////clearnSlider按钮
- (XYSwitch *)clearnSwitch{
    if (!_clearnSwitch) {
//名字更改
     _clearnSwitch =   [[XYSwitch alloc] initWithTextFont:[UIFont systemFontOfSize:11] OnText:NSLocalizedString(@"风机", nil)  offText:NSLocalizedString(@"风机",nil) onBackGroundColor:[DataManager shareDataManager].colorOfMainType offBackGroundColor:nil onButtonColor:nil offButtonColor:nil onTextColor:[DataManager shareDataManager].colorOfMainType andOffTextColor:nil];
        

    }
    return _clearnSwitch;
}
- (XYSwitch *)monitorSwitch{
    if(!_monitorSwitch){
        
        _monitorSwitch = [[XYSwitch alloc] initWithTextFont:[UIFont systemFontOfSize:11] OnText:NSLocalizedString(@"视频", nil)  offText:NSLocalizedString(@"视频", nil)  onBackGroundColor:[DataManager shareDataManager].colorOfMainType offBackGroundColor:nil onButtonColor:nil offButtonColor:nil onTextColor:[DataManager shareDataManager].colorOfMainType andOffTextColor:nil];
        
    }
    return _monitorSwitch;
}



#pragma mark --label

//1225试写title

- (UILabel *)labelOfGoBtn{
    if (!_labelOfGoBtn) {
        _labelOfGoBtn = [[UILabel alloc]init];
        _labelOfGoBtn.text = NSLocalizedString(@"向前", nil);
        _labelOfGoBtn.textAlignment = NSTextAlignmentCenter;
        _labelOfGoBtn.font = [UIFont systemFontOfSize:12];
        if (self.title.length<3) {
            _labelOfGoBtn.font = [UIFont systemFontOfSize:12];
        }else{
            _labelOfGoBtn.font = [UIFont systemFontOfSize:7];
            
        }
    }
    return _labelOfGoBtn;
}

- (UILabel *)labelOfLeftBtn{
    if (!_labelOfLeftBtn) {
        _labelOfLeftBtn = [[UILabel alloc]init];
        _labelOfLeftBtn.text = NSLocalizedString(@"左转", nil);
        _labelOfLeftBtn.textAlignment = NSTextAlignmentRight;

        if (self.title.length<3) {
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:12];
        }else{
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:7];
        }
    }
    return _labelOfLeftBtn;
}

- (UILabel *)labelOfRightBtn{
    if (!_labelOfRightBtn) {
        _labelOfRightBtn = [[UILabel alloc]init];
        _labelOfRightBtn.text = NSLocalizedString(@"右转", nil);
        _labelOfRightBtn.textAlignment = NSTextAlignmentLeft;
        if (self.title.length<3) {
            _labelOfRightBtn.font = [UIFont systemFontOfSize:12];
        }else{
            _labelOfRightBtn.font = [UIFont systemFontOfSize:7];
        }
        
    }
    return _labelOfRightBtn;
}
#pragma mark -- 新增2个按钮
//虚线
- (UIImageView *)imgvLineBomm{
    if (!_imgvLineBomm) {
        _imgvLineBomm = [[UIImageView alloc]init];
        //        _imgvLineBomm.backgroundColor = [UIColor orangeColor];
        _imgvLineBomm.frame = CGRectMake(0, 0, Y_mainW*0.99, 2);
    }
    return _imgvLineBomm;
}
//按钮
- (UIButton *)automaticCleanBtn{
    if (!_automaticCleanBtn) {
        _automaticCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _automaticCleanBtn.layer.cornerRadius = 5;
        _automaticCleanBtn.layer.borderWidth = 1;
        _automaticCleanBtn.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        [_automaticCleanBtn setTitleColor:[DataManager shareDataManager].colorOfMainType  forState:UIControlStateNormal];
        [_automaticCleanBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        [_automaticCleanBtn setTitle:NSLocalizedString(@"自动清扫", nil)  forState:UIControlStateNormal];
        _automaticCleanBtn.titleLabel.numberOfLines = 2;
        _automaticCleanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_automaticCleanBtn addTarget:self action:@selector(automaticCleanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _automaticCleanBtn;
}
- (void)automaticCleanBtnStatus:(BOOL)isCanTap{
    if (isCanTap) {
        _automaticCleanBtn.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        [_automaticCleanBtn setTitleColor:[DataManager shareDataManager].colorOfMainType  forState:UIControlStateNormal];
        [_automaticCleanBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        _automaticCleanBtn.userInteractionEnabled = YES;
    }else {
        _automaticCleanBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_automaticCleanBtn setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
        [_automaticCleanBtn setTintColor:[UIColor grayColor]];
        _automaticCleanBtn.userInteractionEnabled = NO;
    }
}
- (void)homeChargeBtnStatus:(BOOL)isCanTap{
    if (isCanTap) {
        _homeChargeBtn.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        [_homeChargeBtn setTitleColor:[DataManager shareDataManager].colorOfMainType  forState:UIControlStateNormal];
        [_homeChargeBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        _homeChargeBtn.userInteractionEnabled = YES;
    } else {
        _homeChargeBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_homeChargeBtn setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
        [_homeChargeBtn setTintColor:[UIColor grayColor]];
        _homeChargeBtn.userInteractionEnabled = NO;
    }
}
- (UIButton *)homeChargeBtn{
    if (!_homeChargeBtn) {
        _homeChargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _homeChargeBtn.layer.cornerRadius = 5;
        _homeChargeBtn.layer.borderWidth = 1;
        _homeChargeBtn.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
        [_homeChargeBtn setTitleColor:[DataManager shareDataManager].colorOfMainType  forState:UIControlStateNormal];
        [_homeChargeBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        [_homeChargeBtn setTitle:NSLocalizedString(@"回家充电", nil)  forState:UIControlStateNormal];
        _homeChargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_homeChargeBtn addTarget:self action:@selector(homeChargeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _homeChargeBtn;
}


- (void)homeChargeBtnAction:(UIButton *)sender{
    //发送充电 charge
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"charge"];
    //0107
    UIAlertController *exitVcToCleanAlertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否退出遥控模式,执行回家充电",nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送充电
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"charge"];
        if(self.errDeletbloc != nil){
            self.errDeletbloc(@"charge");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [exitVcToCleanAlertC addAction:cancelAction];
    [exitVcToCleanAlertC addAction:yesAction];
    exitVcToCleanAlertC.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:exitVcToCleanAlertC animated:YES completion:nil];
    
}
- (void)automaticCleanBtnAction:(UIButton *)sender{
    
    //
    UIAlertController *exitVcToCleanAlertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否退出遥控模式,执行自动清扫",nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送清扫
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"auto_clean"];
        if(self.errDeletbloc != nil){
            self.errDeletbloc(@"auto_clean");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [exitVcToCleanAlertC addAction:cancelAction];
    [exitVcToCleanAlertC addAction:yesAction];
    exitVcToCleanAlertC.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:exitVcToCleanAlertC animated:YES completion:nil];
    
}
#pragma mark -- 底部2按钮1225新增
- (void)getnewYuShuofBmV{
    
    [_imgvLineBomm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_directionBackView.mas_right);
        make.left.equalTo(_directionBackView.mas_left);
        make.top.equalTo(_directionBackView.mas_bottom).offset(5);
        make.height.offset(2);
    }];
    [_automaticCleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.4);
        make.left.equalTo(_directionBackView.mas_left);
        make.top.equalTo(_directionBackView.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [_homeChargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.4);
        make.right.equalTo(_directionBackView.mas_right);
        make.top.equalTo(_directionBackView.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [ToolOfBasic drawLineByImageView:_imgvLineBomm];
}
@end
