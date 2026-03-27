//
//  RemoteMonitorTwoHaveMonitorViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/7/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "RemoteMonitorTwoNoMonitorViewController.h"
#import "MapStrengthChoosePopView.h"
//    ORDER_brushclose = "order_brush 0";//边刷关闭
//   ORDER_brushback = "order_brush 1";//退出遥控
//   ORDER_brushstart = "order_brush 2";//边刷打开
//有监控的vc
#import "XYSwitch.h"
#import "DirectionBtn.h"
#import "DirectionImgV.h"


@interface RemoteMonitorTwoNoMonitorViewController ()<XmppManagerDelegate,UIGestureRecognizerDelegate,JkYkNeedMessageAndUserStatusDelegate>

//顶部
@property (nonatomic,strong)UIView *topBackView;
@property (nonatomic,strong)UILabel *timeTitleL;
@property (nonatomic,strong)UILabel *timeContentL;
@property (nonatomic,strong)UILabel *electricTitleL;
@property (nonatomic,strong)UILabel *electricContentL;
@property (nonatomic,strong)NSString *electricContentStr;//0124


@property (nonatomic,strong)NSTimer* timerOfSetTime;//时间更新
@property (nonatomic,assign)int  timerOfSetTimeNum;//时间更新总秒数

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
//@property (nonatomic,strong)UIButton *goBtn;

//@property (nonatomic,strong)OBShapedButton *backBtn;
@property (nonatomic,strong)OBShapedButton *leftBtn;
@property (nonatomic,strong)OBShapedButton *rightBtn;

@property (nonatomic,strong)UIView *clicksignView;//Click on the sign 点击手势的view
//@property (nonatomic,assign)BOOL isCanClick;//可以点击当在清扫中时则弹出框 1210从地图页初始化
@property (nonatomic,assign)int timeOfCantGetClearnType;//=0初始时，发送0or1之后的=5，时间参数在5秒内由接受数据-1直到=0大于0时不赋值给clearnSwitch

@property (nonatomic,assign)int isRobotOrAppOffLine;//可以点击当在离线状态时则弹出框0 在线 1扫地机离线 2用户离线
//底部
@property (nonatomic,strong)XYSwitch *clearnSwitch;
@property (nonatomic,strong)UIButton *clearnBtn;//使用btn换掉switch开关

//新增自动清扫按钮和回充按钮
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

//20190313新增地图view
@property (nonatomic,strong)UIImageView *imgViewOfmap;//用方向盘的背景图试试
@end

@implementation RemoteMonitorTwoNoMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"遥控", nil);
    self.view.backgroundColor = [UIColor whiteColor];
     [self initData];
    [self initView];
//    [self initData];
}
- (void)initView{
    [self.view addSubview:self.topBackView];
    [_topBackView addSubview:self.timeTitleL];
    [_topBackView addSubview:self.timeContentL];
    [_topBackView addSubview:self.electricTitleL];
    [_topBackView addSubview:self.electricContentL];
    
    [self.view addSubview:self.directionBackView];
//    [_directionBackView addSubview:self.stopBtn];
    [_directionBackView addSubview:self.goBtn];
//    [_directionBackView addSubview:self.backBtn];
    [_directionBackView addSubview:self.rightBtn];
    [_directionBackView addSubview:self.leftBtn];
    [_directionBackView addSubview:self.clicksignView];//点击响应对应坐标
    //label
    [_goBtn addSubview:self.labelOfGoBtn];//1225新增
    [_leftBtn addSubview:self.labelOfLeftBtn];
    [_rightBtn addSubview:self.labelOfRightBtn];
    
    
    
    [self.view addSubview:self.clearnSwitch];
//    [self.view addSubview:self.clearnBtn];
    [self getnewYuShuOfTopV];
    [self getnewYuShuOfDirectionV];
    [self getnewYuShuOfBottonV];
    //新增清扫和回充按钮
    [self.view addSubview:self.imgvLineBomm];
    [self.view addSubview:self.automaticCleanBtn];
    [self.view addSubview:self.homeChargeBtn];
    [self getnewYuShuofBmV];
    _electricContentL.text = _electricContentStr;
    //现在的风机开关协议未有，现隐藏clearnSwitch
//    _clearnSwitch.hidden = YES;//1219风机协议OK
    
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _timerOfSendFeng = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendFengJiInfo:) userInfo:nil repeats:NO];//主线程
  
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    _imgViewOfmap = [[UIImageView alloc]initWithFrame:_directionBackView.frame];
    _imgViewOfmap.center = _directionBackView.center;
    [_directionBackView.superview addSubview:_imgViewOfmap];
    [_imgViewOfmap.superview sendSubviewToBack:_imgViewOfmap];
    _imgViewOfmap.layer.magnificationFilter = kCAFilterNearest;
}
    
- (void)sendFengJiInfo:(NSTimer *)timer{
    //电量足够>20 非清扫 非充电非回充_isClearningStatusOrChargingStatus=0 在线状态0 则发送？
    if([[_electricContentStr stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue]>20 && _isRobotOrAppOffLine==0 && _isClearningStatusOrChargingStatus==0){//在线 _isRobotOrAppOffLine 0
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 0"];//@"风机边刷
    }
    [timer invalidate];
    timer = nil;
    NSLog(@"风机初始发送数据");
}


- (void)initData{
    if (_strOfShowAreaTimeCharge.length>0) {
        _timeContentL.text = [NSString stringWithFormat:@"%@'",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"][1]];
         _electricContentL.text = [NSString stringWithFormat:@"%@",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"].lastObject];
        _electricContentStr = [NSString stringWithFormat:@"%@%%",[_strOfShowAreaTimeCharge componentsSeparatedByString:@"|"].lastObject];//电量0124
    }
//    [XmppManager shareXmppManager].delegates = self;//error弹出框的需求，更换成mapvc的新协议。
 
    //可点击
//    _isCanClick = YES;//1210初始化更具地图页的数据来

    _timeOfCantGetClearnType = 0;//状态位
    _isRobotOrAppOffLine=0;//在线
    _longTapTimerNum = 0;//长按初始
    
    _isClearningStatusOrChargingStatus = 0;//清扫or充电int 初始0 清扫1 充电2
}

#pragma mark --
//新增code error 数据部分 //代理一对一此监控遥控的error数据需要使用mapvc的数据，那么本vc不能使用xmpp数据的代理，需要使用map新的数据代理方法
-(void)receiveXmppJkYkMessageWithMessage:(NSString *)message{
    
    
    
    NSArray *arrOfmsg = [NSArray arrayWithArray:[message componentsSeparatedByString:@" "]];
    NSString *type = arrOfmsg.firstObject;
   
    if (_timeOfCantGetClearnType>0) {//清扫按钮的赋值响应延时int
        _timeOfCantGetClearnType=_timeOfCantGetClearnType-1;
    }
    
   
    NSLog(@"num=%d  _clearnBtn.selected=%d",_timeOfCantGetClearnType,_clearnBtn.selected);
    if ([message containsString:NSLocalizedString(@"停止清扫", nil) ]||[message containsString:NSLocalizedString(@"休眠中", nil)]) {
       
        //清扫按钮是关闭
        if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
            _clearnBtn.selected = NO;
             _isCanClick = YES;  //可点击
        }
    }
    
    if ([message containsString:NSLocalizedString(@"充电中", nil)]) {
       
        if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
            _clearnBtn.selected = NO;//按钮关闭
            _isCanClick = YES;  //可点击
            _isClearningStatusOrChargingStatus = 2;
        }
    }
    if ([message containsString:NSLocalizedString(@"清扫中", nil) ]) {
      
        //清扫按钮是开启
        if (_timeOfCantGetClearnType<=0) {//小于0时做赋值
            _clearnBtn.selected = YES;//按钮绿色开启状态
            _isCanClick = NO;  //不可点击
            _isClearningStatusOrChargingStatus = 1;
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
            _isClearningStatusOrChargingStatus = 1;//清扫中
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
        if(self.errDeletblock != nil){
            self.errDeletblock(@"deletcodeErrAr");
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
    
    
    //20190313地图数据放在directionBackView上
    if (DataManager.shareDataManager.mapImgBeforeData!=nil) {
        _imgViewOfmap.image = [UIImage imageWithData:DataManager.shareDataManager.mapImgBeforeData];
//        _imgViewOfmap.contentMode =
        _imgViewOfmap.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)setRobotImgRect{

    //计算地图扫地机点
    NSArray *arrOfNowWAndH = [MapDataTool getMapWAndH];
//    _imgViewOfmap.frame

}
- (void)receiveXmppJkYkUserStatusWithMessage:(NSString *)message{
//- (void)receiveXmppUserStatusWithMessage:(NSString *)message{
    if ([message isEqualToString:@"扫地机离线"]) {//0 在线 1扫地机离线 2用户离线
        _isRobotOrAppOffLine = 1;
        return;
    }
    if ([message isEqualToString:@"用户离线"]) {
        _isRobotOrAppOffLine = 2;
        return;
    }
//    _isRobotOrAppOffLine = 0;//其他协议数据则为在线状态，由接受的message更新
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- time定时启动
- (void)beginDateChange{
    
    if (_timerOfSetTime!=nil) {//点击遥控按钮后调用，不为空则已经调用过。
        return;
    }
    _timerOfSetTimeNum = 0;
    _timerOfSetTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerOfSetTimeAction:) userInfo:nil repeats:YES];
//    _timerOfSetTime = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//    }];
    
}
- (void)timerOfSetTimeAction:(NSTimer*)timer{
    _timerOfSetTimeNum+=1;
    _timeContentL.text = [NSString stringWithFormat:@"%@",[ToolOfBasic timeStr:_timerOfSetTimeNum]];
    //1208新增 err弹出框只弹出1次的问题 但要兼顾延迟 即：原定时间10秒清空errArr数据 现在map界面timer停止，在此处通知调用map页errorArr清空方法
    if (_timerOfSetTimeNum%10==0) {//10秒
//      if (_timerOfSetTimeNum%3==0) {//3秒
        //通知 没有效果暂时用block
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"DeletCodeErrArrNotice" object:nil];
          if(self.errDeletblock != nil){
              self.errDeletblock(@"deletcodeErrArr");
          }
    }
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
    if ([[touch view] isEqual:_clicksignView]) {//点击的是方向盘区域时
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
                    [self.view makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil) duration:1.0 position:@"center"];
                    return;
                }
            }else{
                if(_isCanClick){//如果非清扫状态=既可点击状态，手势在区域内，发出停止
//                    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_control 0"];
                }else{
                    //清扫状态 在点击发送方向就弹出过此处不弹出
//                    [self.view makeToast:@"机器人处于清扫状态，暂时不可控制" duration:1.0 position:@"center"];
                    return;
                }
            }
 
        }
        
    }
}

#pragma mark -- view 方向盘点击不响应 用坐标和顶部的新view //sigleTapView 点击 viewTouchedLongTime 长按
- (void)sigleTapView:(UIGestureRecognizer *)ges{
   
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            [self sigleTagWithges:ges];
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"UIGestureRecognizerStateChanged");
//            [self sigleTagWithges:ges];//change时调用测试
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
        //初始  长按后的发送方向时间1.0s->0.1s  1秒(s)=1000毫秒(ms) 现在100ms发一次
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
    [self upGesAction:point];//若手势在圆内的抬起，会发出停止指令
}
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
    
    
    if (_isRobotOrAppOffLine==1) {
        [self.view makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
        [self.view makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil) duration:1.0 position:@"center"];
        return;
    }
    
    if (_isClearningStatusOrChargingStatus==1) {
          [self.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
         return;
    } else if(_isClearningStatusOrChargingStatus==2){
        [self.view makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];////充电状态 座充状态 以后能够弹出框离开充电桩指令
         return;
    }
    if(_isCanClick==NO){
        [self.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
        return;
    }
    if([_electricContentL.text floatValue]<=20){
        [self.view makeToast:NSLocalizedString(@"电量过低,暂时不可操纵", nil) duration:1.0 position:@"center"];
        return;
    }
    //0=stop ,go=1,3=left,4=right;
    //判断是否发送控制指令
    [self beginDateChange];//定时器启动
    NSInteger i = tag;
    switch (tag) {
        case 0://停止单独数据传出
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
//      [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
//      [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    NSLog(@"sendStr = %@",sendStr);
}

#pragma mark -- directionBtnAction 方向盘 点击事件 现不响应 已被_clicksignView遮住
- (void)directionBtnAction:(UIButton *)sender{
    
//    [self beginDateChange];//定时器启动
//    NSInteger i = sender.tag-TAG_BTN_C;
//    NSString *sendStr = [NSString stringWithFormat:@"order_control %ld",(long)i];
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    NSLog(@"Btn点击 tag=%ld",(long)sender.tag);
}
#pragma mark -- directionBtnAction 方向盘上 按钮的长按手势 现不响应 已遮住
- (void)buttonTouchedLongTime:(UIButton *)sender{
//    [self beginDateChange];//定时器启动
//    NSInteger i = sender.tag-TAG_BTN_C;
//    NSString *sendStr = [NSString stringWithFormat:@"order_control %ld",(long)i];
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];
    NSLog(@"Btn长按 tag=%ld",(long)sender.tag);
}
#pragma mark -- topV顶部时间和电量
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
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.top.equalTo(_topBackView.mas_bottom);
    }];

 
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_directionBackView.mas_bottom).offset(5);
        make.right.equalTo(_directionBackView.mas_right).multipliedBy(0.5).offset(-1);//右约束是背景图的中心
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.5).offset(-2);
        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.7);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_directionBackView.mas_bottom).offset(5);
        make.left.equalTo(self.leftBtn.mas_right).offset(1);//并挨着
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.5).offset(-2);
        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.7);
    }];
 
    [_goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_directionBackView);
        make.top.equalTo(_directionBackView.mas_top);
//        make.width.equalTo(_directionBackView.mas_width);
        make.width.equalTo(_directionBackView.mas_width).multipliedBy(0.95);//背景img能更具btn的缩放而缩放

        make.height.equalTo(_directionBackView.mas_height).multipliedBy(0.5);
    }];
    
    [_clicksignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_directionBackView.mas_left);
        make.right.equalTo(_directionBackView.mas_right);
        make.top.equalTo(_directionBackView.mas_top);
        make.bottom.equalTo(_directionBackView.mas_bottom);
    }];
//    _leftBtn.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
//    _rightBtn.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.2];
//    _goBtn.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
    
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
    
//    _labelOfLeftBtn.backgroundColor = [UIColor redColor];
//    _labelOfRightBtn.backgroundColor = [UIColor redColor];
}
#pragma mark -- 底部清扫开关
- (void)getnewYuShuOfBottonV{
//    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(70);
//        make.height.offset(35);
//        make.left.equalTo(_directionBackView.mas_left);
//        make.top.equalTo(_directionBackView.mas_bottom).offset(30);
//    }];
    
    [_clearnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.height.offset(35);
        make.left.equalTo(_directionBackView.mas_left);
        make.top.equalTo(_directionBackView.mas_bottom).offset(30);
    }];
    
    
     __weak RemoteMonitorTwoNoMonitorViewController *selfWeak = self;
    _clearnSwitch.changeStateBlock = ^(BOOL isOn) {
        if (isOn) {
            //开启
            NSLog(@"开");
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于离线状态", nil)  duration:1.0 position:@"center"];
                _clearnSwitch.isOn = NO;
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态",nil) duration:1.0 position:@"center"];
                _clearnSwitch.isOn = NO;
                return;
            }
            if (_isClearningStatusOrChargingStatus==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
                _clearnSwitch.isOn = NO;
                return;
            } else if(_isClearningStatusOrChargingStatus==2){
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];////充电状态 座充状态 以后能够弹出框离开充电桩指令
                _clearnSwitch.isOn = NO;
                return;
            }
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 2"];//@"风机边刷开关开启
        }else{
            //关闭
            if (_isRobotOrAppOffLine==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于离线状态", nil) duration:1.0 position:@"center"];
                _clearnSwitch.isOn = YES;
                return;
            }
            if (_isRobotOrAppOffLine==2) {
                [selfWeak.view makeToast:NSLocalizedString(@"用户处于离线状态",nil) duration:1.0 position:@"center"];
                _clearnSwitch.isOn = YES;
                return;
            }
            
            if (_isClearningStatusOrChargingStatus==1) {
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
                _clearnSwitch.isOn = YES;
                return;
            } else if(_isClearningStatusOrChargingStatus==2){
                [selfWeak.view makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];////充电状态 座充状态 以后能够弹出框离开充电桩指令
                _clearnSwitch.isOn = YES;
                return;
            }
            NSLog(@"设为关闭状态");
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 0"];//@"风机边刷开关关闭"
        }
    };
    
}
- (void)getnewYuShuofBmV{
//    [self.view addSubview:self.automaticCleanBtn];
//    [self.view addSubview:self.homeChargeBtn];
    
    [_imgvLineBomm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_directionBackView.mas_right);
        make.left.equalTo(_directionBackView.mas_left);
        make.top.equalTo(_clearnSwitch.mas_bottom).offset(10);
        make.height.offset(2);
    }];
    [_automaticCleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4);
        make.left.equalTo(_directionBackView.mas_left);
        make.top.equalTo(_clearnSwitch.mas_bottom).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [_homeChargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4);
        make.right.equalTo(_directionBackView.mas_right);
        make.top.equalTo(_clearnSwitch.mas_bottom).offset(30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    [ToolOfBasic drawLineByImageView:_imgvLineBomm];
    //_clearnSwitch

}
#pragma mark -- getter //topv
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView    = [[UIView alloc]init];
    }
    return _topBackView;
}

- (UILabel *)timeTitleL{
    if (!_timeTitleL) {
        _timeTitleL = [[UILabel alloc]init];
        _timeTitleL.text = NSLocalizedString(@"遥控\n时间", nil) ;
        _timeTitleL.numberOfLines = 2;
        _timeTitleL.font = [UIFont systemFontOfSize:12];
        _timeTitleL.textAlignment = NSTextAlignmentCenter;
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
        _electricTitleL.text = NSLocalizedString(@"剩余\n电量",nil);
        _electricTitleL.numberOfLines = 2;
        _electricTitleL.font = [UIFont systemFontOfSize:12];
        _electricTitleL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _electricTitleL;
}
- (UILabel *)electricContentL{
    if (!_electricContentL) {
        _electricContentL = [[UILabel alloc]init];
        _electricContentL.font = [UIFont systemFontOfSize:20];
        _electricContentL.textAlignment = NSTextAlignmentLeft;
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
//        [_stopBtn setImage:[UIImage imageNamed:@"Angle_Reset1_colour"] forState:UIControlStateNormal];
        _stopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _stopBtn;
}
- (OBShapedButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
//- (UIButton *)goBtn{
//    if (!_goBtn) {
//        _goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        长按手势
        UILongPressGestureRecognizer *longPressOfGoBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
        longPressOfGoBtn.minimumPressDuration = 0.5; //定义按的时间
        [_goBtn  addGestureRecognizer:longPressOfGoBtn];
        
        _goBtn.tag = TAG_BTN_C+1;
        //cs
//        [_goBtn setImage:[UIImage imageNamed:@"遥控测试"]
//                forState:UIControlStateNormal];
        UIImage *goImg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"xiangqian"];
        [_goBtn setImage:goImg  forState:UIControlStateNormal];
//        [_goBtn setBackgroundImage:goImg forState:UIControlStateNormal];
//        [_goBtn setTitle:@"forward向前" forState:UIControlStateNormal];
        [_goBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _goBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
     
    }
    return _goBtn;
}

//- (OBShapedButton *)backBtn{
//    if (!_backBtn) {
//        _backBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
//        [_backBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        _backBtn.tag = TAG_BTN_C+2;
//        [_backBtn setImage:[UIImage imageNamed:@"Angle_Down1_colour"] forState:UIControlStateNormal];
//        _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
//    return _backBtn;
//}
- (OBShapedButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];//点击手势
       //长按手势
        UILongPressGestureRecognizer *longPressOfLeftBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
        longPressOfLeftBtn.minimumPressDuration = 0.5; //定义按的时间
        [_leftBtn  addGestureRecognizer:longPressOfLeftBtn];
        
        _leftBtn.tag = TAG_BTN_C+3;
        
//        [_leftBtn setImage:[UIImage imageNamed:@"Angle_Left1_colour"] forState:UIControlStateNormal];
        UIImage *lImg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zuozhuan"];
        [_leftBtn setImage:lImg  forState:UIControlStateNormal];
//        [_leftBtn setBackgroundImage:lImg  forState:UIControlStateNormal];
//        [_leftBtn setTitle:@"left左转" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftBtn;
}
- (OBShapedButton *)rightBtn{
    if ( !_rightBtn ) {
        _rightBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //长按手势
        UILongPressGestureRecognizer *longPressOfRightBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTouchedLongTime:)];
        longPressOfRightBtn.minimumPressDuration = 0.5; //定义按的时间
        [_rightBtn  addGestureRecognizer:longPressOfRightBtn];
        
        _rightBtn.tag = TAG_BTN_C+4;
        
         UIImage *rImg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"youzhuan"];
         [_rightBtn setImage:rImg  forState:UIControlStateNormal];
//         [_rightBtn setBackgroundImage:rImg  forState:UIControlStateNormal];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_rightBtn setTitle:@"right右转" forState:UIControlStateNormal];
        
        [_rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _rightBtn;
    
}

- (UIView *)clicksignView{
    if (!_clicksignView) {
        _clicksignView = [[UIView alloc]init];
 
        
//        长按手势
        UILongPressGestureRecognizer *longPressOfGoBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouchedLongTime:)];
        longPressOfGoBtn.minimumPressDuration = 0.5; //定义按的时间
        longPressOfGoBtn.allowableMovement=0.1;//move的移距离响应
        longPressOfGoBtn.delegate = self;
        [_clicksignView  addGestureRecognizer:longPressOfGoBtn];
      
//
        //点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapView:)];
        [singleTap setNumberOfTapsRequired:1];
        singleTap.delegate = self;
        [_clicksignView addGestureRecognizer:singleTap];
        
        
        _clicksignView.tag = 333;
    }
    return _clicksignView;
}
 
//换回switch
- (UIButton *)clearnBtn{
    if (!_clearnBtn) {
        _clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearnBtn setImage:[UIImage imageNamed:@"清扫开关灰色"] forState:UIControlStateNormal];
          [_clearnBtn setImage:[UIImage imageNamed:@"清扫开关灰色"] forState:UIControlStateHighlighted];
         [_clearnBtn setImage:[UIImage imageNamed:@"清扫开关绿色"] forState:UIControlStateSelected];
        [_clearnBtn setImage:[UIImage imageNamed:@"清扫开关绿色"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_clearnBtn addTarget:self action:@selector(clearnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearnBtn;
}
- (void)clearnBtnAction:(UIButton *)sender{
    if (_isRobotOrAppOffLine==1) {
        [self.view makeToast:NSLocalizedString(@"机器人处于离线状态", nil) duration:1.0 position:@"center"];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
        [self.view makeToast:NSLocalizedString(@"用户处于离线状态",nil) duration:1.0 position:@"center"];
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
        _timeOfCantGetClearnType = 15;//延时接受
    }
    
   
}
- (XYSwitch *)clearnSwitch{
    if (!_clearnSwitch) {
        
        _clearnSwitch =   [[XYSwitch alloc] initWithTextFont:[UIFont systemFontOfSize:11] OnText:NSLocalizedString(@"风机", nil)  offText:NSLocalizedString(@"风机",nil) onBackGroundColor:[DataManager shareDataManager].colorOfMainType offBackGroundColor:nil onButtonColor:nil offButtonColor:nil onTextColor:[DataManager shareDataManager].colorOfMainType andOffTextColor:nil];
        
        
    }
    return _clearnSwitch;
}

#pragma mark --label
//1225试写title

- (UILabel *)labelOfGoBtn{
    if (!_labelOfGoBtn) {
        _labelOfGoBtn = [[UILabel alloc]init];
        _labelOfGoBtn.text = NSLocalizedString(@"向前", nil);
        _labelOfGoBtn.textAlignment = NSTextAlignmentCenter;
//        _labelOfGoBtn.backgroundColor = [UIColor whiteColor]; //12 7 15 10
        if (self.title.length<3) {
            _labelOfGoBtn.font = [UIFont systemFontOfSize:15];
        }else{
            _labelOfGoBtn.font = [UIFont systemFontOfSize:10];
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
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:15];

        }else{
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:10];
           
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
            _labelOfRightBtn.font = [UIFont systemFontOfSize:15];

        }else{
            _labelOfRightBtn.font = [UIFont systemFontOfSize:10];
            
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
         _automaticCleanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
        _homeChargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_homeChargeBtn addTarget:self action:@selector(homeChargeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _homeChargeBtn;
}

- (void)homeChargeBtnAction:(UIButton *)sender{
    //发送充电 charge
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"charge"];
    UIAlertController *exitVcToCleanAlertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否退出遥控模式,执行回家充电",nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送充电
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"charge"];
        if(self.errDeletblock != nil){
            self.errDeletblock(@"charge");
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

        if(self.errDeletblock != nil){
            self.errDeletblock(@"auto_clean");
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timerOfSetTime invalidate];
    _timerOfSetTime = nil;
    [_longTapTimer invalidate];
    _longTapTimer = nil;
    [_timerOfSendFeng invalidate];
    _timerOfSendFeng = nil;
    //离开遥控模式 退出边刷
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 1"];
}
#pragma mark -- 暂时不用这个画图
#pragma mark -- 画扇形
/**
- (void)drawArcFillWithPosition:(NSString*)fx
{
    
    [self.view layoutIfNeeded];
    CGRect fram = self.directionBackView.frame;
    CGFloat radiu = CGRectGetMidX(self.directionBackView.frame)-0.05*Y_mainW;// 0.9w 0.5x -2 但是该图片非正规平分120 而是150 110左右
    CGPoint centP = CGPointMake(radiu, radiu);
    
    if ([fx isEqualToString:@"top"]) {//begA:-20 endA:-160 begA:-160 endA:90] right begA:90 endA:-20];
        radiu = radiu-Y_mainW*0.005;
        DirectionBtn *diBtnT = [[DirectionBtn alloc]initWithFrame:fram radius:radiu centerP:centP begA:-20 endA:-160];
        //        DirectionImgV *diBtnT = [[DirectionImgV alloc]initWithFrame:fram radius:radiu centerP:centP begA:-20 endA:-160];
        diBtnT.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.1];
        UITapGestureRecognizer *tapPressOfGoBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(directionimgVtapAction:)];
        [tapPressOfGoBtn setNumberOfTapsRequired:1];
        [diBtnT  addGestureRecognizer:tapPressOfGoBtn];
        
        //        长按手势
        UILongPressGestureRecognizer *longPressOfGoBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(directionimgVtapLongAction:)];
        longPressOfGoBtn.minimumPressDuration = 1.5; //定义按的时间
        [diBtnT  addGestureRecognizer:longPressOfGoBtn];
        diBtnT.tag = 666660;
        [self.view addSubview:diBtnT];
    }else if ([fx isEqualToString:@"left"]){//begA:-160 endA:90] right begA:90 endA:-20];
        radiu = radiu-Y_mainW*0.005;
        DirectionBtn *diBtnLeft = [[DirectionBtn alloc]initWithFrame:fram radius:radiu centerP:centP begA:-160 endA:90];
        diBtnLeft.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.0];
        [self.view addSubview:diBtnLeft];
        
    }else{//right begA:90 endA:-20];
        radiu = radiu-Y_mainW*0.005;
        DirectionBtn *diBtnRight= [[DirectionBtn alloc]initWithFrame:fram radius:radiu centerP:centP begA:90 endA:-20];
        [diBtnRight addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //        长按手势
        UILongPressGestureRecognizer *longPressOfGoBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(directionimgVtapLongAction:)];
        longPressOfGoBtn.minimumPressDuration = 1.5; //定义按的时间
        [diBtnRight  addGestureRecognizer:longPressOfGoBtn];
        diBtnRight.tag = 666669;
        
        diBtnRight.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.0];
        
        [self.view addSubview:diBtnRight];
    }

}
 
#pragma mark --DirectionBtn   directionimgVtapAction
- (void)directionimgVtapAction:(UIGestureRecognizer *)sender{
    //点击手势

    NSLog(@"directionimgVtapAction %d",[sender view].tag);
}
- (void)directionimgVtapLongAction:(UIGestureRecognizer *)sender{
    NSLog(@"directionimgVtapLongAction %ld",[sender view].tag);
}
*/
@end
