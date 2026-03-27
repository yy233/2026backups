//
//  RemoteControlPopView.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/18.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "RemoteControlPopView.h"

@interface RemoteControlPopView ()
@property (weak, nonatomic) IBOutlet UILabel *fenJiLabel;

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;

@property (weak, nonatomic) IBOutlet UISwitch *fengSwitch;
//
@property (nonatomic,strong)UIView *directionBackView;
@property (nonatomic,strong)OBShapedButton *stopBtn;
@property (nonatomic,strong)OBShapedButton *goBtn;
@property (nonatomic,strong)OBShapedButton *leftBtn;
@property (nonatomic,strong)OBShapedButton *rightBtn;
@property (nonatomic,strong)UIView *clicksignView;//Click on the sign 点击手势的view

@property (nonatomic,strong)UILabel *labelOfGoBtn;
@property (nonatomic,strong)UILabel *labelOfRightBtn;
@property (nonatomic,strong)UILabel *labelOfLeftBtn;
@property (nonatomic,assign)BOOL isEn;
@property (nonatomic,assign)int isClearningStatusOrChargingStatus;
@property (nonatomic,assign)int longTapTimerNum;//长按初始
@property (nonatomic,assign)NSTimer *longTapTimer;
@property (nonatomic,assign)BOOL isCanClick;
@property (nonatomic,assign)int isRobotOrAppOffLine;//可以点击当在离线状态时则弹出框0 在线 1扫地机离线 2用户离线
@end

@implementation RemoteControlPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
//        [self initData];
//        [self initView];
    }
    return self;

}
- (void)initData{
    if ([NowLanguageTool robotAppOfGetPreferredLanguageNum]>0) {
        _isEn=YES;
    }else{
        _isEn=NO;
    }
    
     _isClearningStatusOrChargingStatus = 0;//清扫or充电int 初始0 清扫1 充电2
    _longTapTimerNum = 0;//长按初始
    _isCanClick = YES;

}
- (void)initView{
    _fenJiLabel.text = NSLocalizedString(@"风机", nil);
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [DataManager shareDataManager].colorOfMainType.CGColor;
    _fengSwitch.onTintColor = [DataManager shareDataManager].colorOfMainType;
    [_fengSwitch setOn:NO];//初始状态为设置为不开风机。
    [_fengSwitch addTarget:self action:@selector(fengSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topBackView addSubview:self.directionBackView];
    [_directionBackView addSubview:self.goBtn];
    [_directionBackView addSubview:self.rightBtn];
    [_directionBackView addSubview:self.leftBtn];
    [_directionBackView addSubview:self.clicksignView];//点击响应对应坐标
    //label
    [_goBtn addSubview:self.labelOfGoBtn];
    [_leftBtn addSubview:self.labelOfLeftBtn];
    [_rightBtn addSubview:self.labelOfRightBtn];
    
    [self getnewYuShuOfDirectionV];//约束
}
#pragma mark__扫地机xmpp信息
- (void)getxmppUserStatusMsg:(NSString *)message{
    //- (void)receiveXmppUserStatusWithMessage:(NSString *)message{
    if ([message isEqualToString:@"扫地机离线"]) {//0 在线 1扫地机离线 2用户离线
        _isRobotOrAppOffLine = 1;
        return;
    }
    if ([message isEqualToString:@"用户离线"]) {
        _isRobotOrAppOffLine = 2;
        return;
    }
  
}
- (void)getxmppMsg:(NSString*)message{
 
    _isRobotOrAppOffLine = 0;//0 在线  //    _isRobotOrAppOffLine = 0;//其他协议数据则为在线状态，由接受的message更新
    
    if ([message containsString:@"clean_info 0"]) {//非清扫状态
        _isCanClick = YES;
        _isClearningStatusOrChargingStatus = 0;
    }
    if([message containsString:@"standby"] || [message containsString:@"sleep"]){
        _isClearningStatusOrChargingStatus = 0;//清空清扫or充电状态
    }
    //:格式的状态
    if ([message containsString:@":"]) {
        NSArray *arrOfmsgOfState = [NSArray arrayWithArray:[message componentsSeparatedByString:@":"]];
        NSString *typeOfState = arrOfmsgOfState.firstObject;
        if ([typeOfState containsString:@"nav_cleaning"] || [typeOfState containsString:@"zone_cleaning"] || [typeOfState containsString:@"emphases_cleaning"] || [typeOfState containsString:@"followall_cleaning"]) {//start_home
 
                _isCanClick = NO;//不可点击
                _isClearningStatusOrChargingStatus = 1;
 
        }else if ([typeOfState containsString:@"stop_clean"] || [typeOfState containsString:@"stop_charge"] || [typeOfState containsString:@"stop_home"]){//stop_home
 
                _isCanClick = YES;//可点击
                _isClearningStatusOrChargingStatus = 0;
 
        }else if([typeOfState containsString:@"start_home"]){//开始回充
 
                _isCanClick = NO;
                _isClearningStatusOrChargingStatus = 2;
 
        }else if([typeOfState containsString:@"charing"]){//充电中
                 _isCanClick = NO;
                _isClearningStatusOrChargingStatus = 2;
 
        }else{//stop_home
                 _isCanClick = YES;//可点击
         }
    }
    
}
    
#pragma mark__
- (void)fengSwitchAction:(UISwitch*)sender{
    //    ORDER_brushclose = "order_brush 0";//边刷关闭
    //   ORDER_brushback = "order_brush 1";//退出遥控
    //   ORDER_brushstart = "order_brush 2";//边刷打开
    if (_isRobotOrAppOffLine==1) {
        [self makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        [sender setOn:!sender.isOn];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
        [self makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        [sender setOn:!sender.isOn];
        return;
    }
    //判断是否发送控制指令
    if (_isClearningStatusOrChargingStatus==1) {
        [self makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
        [sender setOn:!sender.isOn];
        return;
    } else if(_isClearningStatusOrChargingStatus==2){
        [self makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];//充电状态 座充状态 以后能够弹出框离开充电桩指令exit_charging_station
       [sender setOn:!sender.isOn];
        return;
    }
    if(_isCanClick==NO){
        [self makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil)  duration:1.5 position:@"center"];
        [sender setOn:!sender.isOn];
        return;
    }
 
    
    if (sender.isOn) {//2 打开 0关闭
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 2"];
    }else{
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"order_brush 0"];
    }
    
}

#pragma mark -- getter //方向盘

- (UIView *)directionBackView{
    if (!_directionBackView) {
        _directionBackView = [[UIView alloc]init];
    }
    return _directionBackView;
}

- (OBShapedButton *)goBtn{
    if (!_goBtn) {
        _goBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
//        [_goBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _goBtn.tag = TAG_BTN_C+1;
        
        UIImage *goimg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"xiangqian"];
        [_goBtn setImage:goimg  forState:UIControlStateNormal];
        _goBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goBtn;
}

- (OBShapedButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
//        [_leftBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
//        [_rightBtn addTarget:self action:@selector(directionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark --label

- (UILabel *)labelOfGoBtn{
    if (!_labelOfGoBtn) {
        _labelOfGoBtn = [[UILabel alloc]init];
        _labelOfGoBtn.text = NSLocalizedString(@"向前", nil);
        _labelOfGoBtn.textAlignment = NSTextAlignmentCenter;
         if (_isEn==NO) {
            _labelOfGoBtn.font = [UIFont systemFontOfSize:10];
        }else{
            _labelOfGoBtn.font = [UIFont systemFontOfSize:6];
            
        }
    }
    return _labelOfGoBtn;
}

- (UILabel *)labelOfLeftBtn{
    if (!_labelOfLeftBtn) {
        _labelOfLeftBtn = [[UILabel alloc]init];
        _labelOfLeftBtn.text = NSLocalizedString(@"左转", nil);
        _labelOfLeftBtn.textAlignment = NSTextAlignmentRight;
        
        if (_isEn==NO) {
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:10];
        }else{
            _labelOfLeftBtn.font = [UIFont systemFontOfSize:6];
        }
    }
    return _labelOfLeftBtn;
}

- (UILabel *)labelOfRightBtn{
    if (!_labelOfRightBtn) {
        _labelOfRightBtn = [[UILabel alloc]init];
        _labelOfRightBtn.text = NSLocalizedString(@"右转", nil);
        _labelOfRightBtn.textAlignment = NSTextAlignmentLeft;
        if (_isEn==NO) {
            _labelOfRightBtn.font = [UIFont systemFontOfSize:10];
        }else{
            _labelOfRightBtn.font = [UIFont systemFontOfSize:6];
        }
        
    }
    return _labelOfRightBtn;
}
#pragma mark -- 方向盘
- (void)getnewYuShuOfDirectionV{
    //    _directionBackView.backgroundColor = UIColor.brownColor;
    ////    _directionBackView.frame = _topBackView.frame;
    ////    _directionBackView.center = _topBackView.center;
    //
//    //方向盘背景v
    [_directionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBackView.mas_left);
        make.right.equalTo(_topBackView.mas_right);
        make.top.equalTo(_topBackView.mas_top);
        make.bottom.equalTo(_topBackView.mas_bottom);
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
    
    
    //titleLable
    [_labelOfGoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_goBtn);
        make.centerY.equalTo(_goBtn).multipliedBy(1.2);
//        make.width.equalTo(_goBtn.mas_width).multipliedBy(0.3);
        make.width.equalTo(_goBtn.mas_width).multipliedBy(0.4);
        make.height.equalTo(_goBtn.mas_height).multipliedBy(0.2);
        
    }];
    
    [_labelOfLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftBtn).multipliedBy(1);;
        make.centerY.equalTo(_leftBtn).multipliedBy(1.4);
//        if (_isEn==NO) {
//            make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.4);//
//        }else{
//            make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.5);
//        }
        if (_isEn==NO) {
            make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.5);//
        }else{
            make.width.equalTo(_leftBtn.mas_width).multipliedBy(0.6);
        }
        
        make.height.equalTo(_leftBtn.mas_height).multipliedBy(0.15);
        
    }];
    
    [_labelOfRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightBtn).multipliedBy(1);
        make.centerY.equalTo(_rightBtn).multipliedBy(1.4);
//        if (_isEn==NO) {
//            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.3);//
//        }else{
//            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.5);
//        }
        if (_isEn==NO) {
            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.4);//
        }else{
            make.width.equalTo(_rightBtn.mas_width).multipliedBy(0.6);
        }
        make.height.equalTo(_rightBtn.mas_height).multipliedBy(0.15);
        
    }];
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
    NSLog(@"单点000001");
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
    if (self.hidden==true) {
        return;
    }
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
#pragma mark -- down和手指抬起的方法
- (void)upGesAction:(CGPoint)touchPoint{
    [self layoutIfNeeded];
    CGFloat radiu = self.directionBackView.bounds.size.width*0.5; //半径
    CGPoint cneterP = CGPointMake(radiu, radiu);
    if (CGRectContainsPoint(_directionBackView.bounds, touchPoint)) {
        CGFloat lenOfPP = [ToolOfBasic getLineDustanceApToBpWithPa:touchPoint pb:cneterP];
        if (lenOfPP<radiu) {//点到点的距离小于半径
            NSLog(@"upGesAction距离OK");
            if(_isRobotOrAppOffLine!=0){
                //扫地机或用户离线
                if (_isRobotOrAppOffLine==1) {
                    [self makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
                    return;
                }
                if (_isRobotOrAppOffLine==2) {
                    [self makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
                    return;
                }
            }else{
                if(_isCanClick){//如果非清扫状态，手势区域，发出停止
                    [self getInfoTosendxmppwithtapPoint:touchPoint];//20190329
                }else{
                    //清扫状态 在点击发送方向就弹出过
                    //                    [self.view makeToast:@"机器人处于清扫状态，暂时不可控制" duration:1.0 position:@"center"];
                    return;
                }
            }
            
        }
        
    }
}

/**
 **/

#pragma mark -- 计算point
- (void)getInfoTosendxmppwithtapPoint:(CGPoint )touchPoint{//clicksignView 和directionBackView同样大小就相通使用
    [self layoutIfNeeded];
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
        [self makeToast:NSLocalizedString(@"机器人处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        return;
    }
    if (_isRobotOrAppOffLine==2) {
        [self makeToast:NSLocalizedString(@"用户处于离线状态，暂时不可控制", nil)  duration:1.0 position:@"center"];
        return;
    }
    //判断是否发送控制指令
    if (_isClearningStatusOrChargingStatus==1) {
        [self makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil) duration:0.8 position:@"center"];
        return;
    } else if(_isClearningStatusOrChargingStatus==2){
        [self makeToast:NSLocalizedString(@"机器人处于充电状态，暂时不可控制", nil) duration:0.8 position:@"center"];//充电状态 座充状态 以后能够弹出框离开充电桩指令exit_charging_station
        return;
    }
    if(_isCanClick==NO){
        [self makeToast:NSLocalizedString(@"机器人处于清扫状态，暂时不可控制", nil)  duration:1.5 position:@"center"];
        return;
    }
//    if([_electricContentL.text floatValue]<=20){
//        [self makeToast:NSLocalizedString(@"电量过低,暂不可操纵", nil)  duration:1.0 position:@"center"];
//        return;
//    }
    
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
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:sendStr];//少发一个（手指离开界面后扫地机继续走遥控方向时间过长）
    NSLog(@"sendStr = %@",sendStr);
}
@end
