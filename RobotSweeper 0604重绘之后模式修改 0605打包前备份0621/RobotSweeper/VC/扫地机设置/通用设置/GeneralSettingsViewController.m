//
//  GeneralSettingsViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/9.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "GeneralSettingsViewController.h"
#import "SetOfLanguageChoosePopView.h"

@interface GeneralSettingsViewController ()<XmppManagerDelegate>
@property (nonatomic,strong) UIView *languageBackView;
@property (nonatomic,strong) UIButton *languageBtn;
@property (nonatomic,strong) UILabel *languageDetailLable;
@property (nonatomic,strong) UIImageView *languagePushImgV;
@property (nonatomic,strong) UIAlertController *languageChangeAlert;
@property (nonatomic,strong) NSString *strOfLanguage;

@property (nonatomic,strong) NSMutableArray *arrOfPopTitle;
@property (nonatomic,strong) NSMutableArray *arrOfPopTitleNum;
@property (nonatomic,strong) SetOfLanguageChoosePopView *setOfLanguageChoosePopView;
//语音部分1220新增
@property (nonatomic,strong) UIView *nameBackView;
@property (nonatomic,strong) UIView *voiceBackView;
@property (nonatomic,strong) UIView *restartBackView;
@property (nonatomic,strong) UIButton *nameBtn;
@property (nonatomic,strong) UILabel *nameNickL;
@property (nonatomic,strong) UILabel *voiceL;
@property (nonatomic,strong) UISlider *voiceSlider;
@property (nonatomic,strong) UIButton *restartBtn;

@property (nonatomic,strong) UIImageView *onePushImgV;
@property (nonatomic,strong) UIImageView *twoPushImgV;

@property (nonatomic,strong) UIAlertController *nameChangeAlert;
@property (nonatomic,strong) UIAlertController *restartAlert;

@property (nonatomic,strong) NSString *strOfVoiceInfo;
@property (nonatomic,strong) NSMutableArray*numbers;
@property (nonatomic,assign) BOOL isCanSaveNewV;

//20190410新增 跌落开关
@property (nonatomic,strong) UIView *dieLuoBackView;
@property (nonatomic,strong) UILabel *dieLuoLabel;
@property (nonatomic,strong) UILabel *dieLuoDetailLabel;

@property (nonatomic,strong) UISwitch *dieLuoSwith;

@end

@implementation GeneralSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"通用设置", nil) ;
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    [self initData];
    [self initView];
    
}

- (void)initData{
    //
    [XmppManager shareXmppManager].delegates = self;
    
//    DataManager.shareDataManager.openTime = array[9]
//    DataManager.shareDataManager.volumeStr = array[10]
   
    _jidStrOfThisRobot = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    _nameStrOfThisRobot = @"";
    
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:_jidStrOfThisRobot]) {
            
          _nameStrOfThisRobot = [dicOfRobot objectForKey:@"nickName"];
        }
    }
    if([_nameStrOfThisRobot isEqualToString: @""]||_nameStrOfThisRobot==nil){
        _nameStrOfThisRobot = NSLocalizedString(@"暂无昵称",nil);
    }
 
    _isCanSaveNewV = YES;//可以接受v
    
    
    //语音
    _strOfLanguage = [DataManager shareDataManager].robotLanguage;
   
}
- (void)initView{
    [self.view addSubview:self.nameBackView];
    [self.view addSubview:self.voiceBackView];
    [self.view addSubview:self.restartBackView];
    [self.view addSubview:self.nameNickL];
    [self.view addSubview:self.nameBtn];
    [self.view addSubview:self.voiceL];
    [self.view addSubview:self.voiceSlider];
    [self.view addSubview:self.dieLuoBackView];
    [self.view addSubview:self.dieLuoLabel];
    [self.view addSubview:self.dieLuoDetailLabel];
    [self.view addSubview:self.dieLuoSwith];
    
    [self.view addSubview:self.restartBtn];
    [self.view addSubview:self.onePushImgV];
    [self.view addSubview:self.twoPushImgV];
//    [self getNewYueSuOfSetVc];
    //1220新增语音环境
    [self.view addSubview:self.languageBackView];
    [self.view addSubview:self.languageDetailLable];
    [self.view addSubview:self.languagePushImgV];
    [self.view addSubview:self.languageBtn];
   
 
    [self getAllYueSuOfSetVc];
    //附值
    _nameNickL.text = _nameStrOfThisRobot;
    if ([DataManager shareDataManager].volumeStr.length!=0) {
        _strOfVoiceInfo = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].volumeStr];
    }
    
    
    _languageDetailLable.text = _strOfLanguage;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --___________ 语种部分
- (void)languageBtnAction:(UIButton *)sender{
    [self.view addSubview:self.setOfLanguageChoosePopView];

    /**  系统弹出框
    if (_languageChangeAlert==nil) {
        _languageChangeAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示音语种",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
  
        
        UIAlertAction *chineseAction = [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
            _languageDetailLable.text = @"中文";
             [self setNewLanguageLabelOfNum:0];
        }];
        UIAlertAction *englishAction = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
            _languageDetailLable.text = @"English";
            [self setNewLanguageLabelOfNum:1];
            
        }];
        [_languageChangeAlert addAction:chineseAction];
        [_languageChangeAlert addAction:englishAction];
 
    }
    _languageChangeAlert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:_languageChangeAlert animated:YES completion:nil];
    */
}

#pragma mark -- 名字部分
#pragma mark -- BtnAction

- (void)nameBtnAction:(UIButton *)sender{
    __block GeneralSettingsViewController *  blockSelf = self;
    if (_nameChangeAlert==nil) {
         _nameChangeAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改设备昵称",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [_nameChangeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textAlignment = NSTextAlignmentCenter;
            textField.placeholder = NSLocalizedString(@"设备昵称",nil);
            textField.text = blockSelf.nameStrOfThisRobot;
            [textField addTarget:blockSelf action:@selector(nameTextChangeActionEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
        }];

        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self changeNameAction];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
       
        [_nameChangeAlert addAction:cancelAction];
        [_nameChangeAlert addAction:yesAction];
        
    }
    _nameChangeAlert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:_nameChangeAlert animated:YES completion:nil];
    
    
}

//输入框
- (void)nameTextChangeActionEditingChanged:(UITextField *)textField{
    _nameStrOfThisRobot = textField.text;
    NSLog(@"EditingChanged  %@",_nameStrOfThisRobot);
}

//yesAction
- (void)changeNameAction{
    
    if (_nameStrOfThisRobot.length==0) {
        [self.view makeToast:NSLocalizedString(@"请输入昵称",nil) duration:1.0 position:@"center"];
        return;
    }
    [MBProgressHUD showMessage:NSLocalizedString(@"正在修改昵称",nil)];

    //服务器
    NSString *eqh = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone",eqh,@"eqHardwareSerial",_nameStrOfThisRobot,@"nickName",nil];
    //S_equipmentAddEqu
   
    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentUpdateNickName withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"------%@",responsObject);
        NSLog(@"----error--%@",error.description);

        if (_Success) {
            [self.view makeToast:NSLocalizedString(@"修改昵称成功",nil) duration:3 position:@"center"];
 
            _nameNickL.text = _nameStrOfThisRobot;
            
            
            //通知地图页换名，
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object: [NSString stringWithFormat:@"%@",_nameStrOfThisRobot]];


//            [self noticepost:_nameStrOfThisRobot];//这个通知有问题它不响应
            //替换单例中所存的arr
            NSMutableDictionary *dicWillChangeName = [NSMutableDictionary dictionary];
            NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
             NSMutableArray *arrOflistSave = [NSMutableArray arrayWithArray:arrOflist];
            for ( NSDictionary *dicOfRobot in arrOflistSave) {//便利时不要去更改该内容会产生崩溃
                if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:_jidStrOfThisRobot]) {
                    dicWillChangeName = [NSMutableDictionary dictionaryWithDictionary:dicOfRobot];
                    [arrOflist removeObject:dicOfRobot];
                }
            }
            
            [dicWillChangeName setObject:_nameStrOfThisRobot forKey:@"nickName"];
            [arrOflist addObject:dicWillChangeName];
            [UserTool sharedUserTool].listOfRobotsArr = [NSMutableArray arrayWithArray:arrOflist];
            
        }else{
//            NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
            NSString *msg = NSLocalizedString(@"修改昵称失败", nil);
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"修改昵称失败，请查看网络是否可用", nil) ;
                }else{
                    msg = NSLocalizedString(@"修改昵称失败",nil);
                }
                
            }
            if (_SuccessOrErrCode==400) {
                msg = NSLocalizedString(@"用户名不能为空",nil);
            }else if (_SuccessOrErrCode==401){
                msg = NSLocalizedString(@"修改昵称失败，请稍后重试",nil);
            }else{
                
            }
            [self.view makeToast:msg duration:2 position:@"bottom"];
            ///
        }
        
    }];

}

- (void)noticepost:(NSString *)nicknameStr{
    
    NSLog(@"noticepost  %@",[NSThread currentThread]);
    //1.gcd
    dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"1=%@",[NSThread currentThread]);
         [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:self userInfo:@{@"gcd_nick":nicknameStr}];
          [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:nil userInfo:@{@"gcd_nick":@"obj=nil"}];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:@"gcd_userInfo=nil" userInfo:nil];
    });
   //2.nsoperation
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
         NSLog(@"2=%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:self userInfo:@{@"nsoperation_nick":nicknameStr}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:nil userInfo:@{@"nsoperation_nick":@"obj=nil"}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:@"nsoperation_userInfo=nil" userInfo:nil];
    }];
    //nsthread
    [self performSelectorOnMainThread:@selector(cssend:) withObject:nil waitUntilDone:NO];
    
}
- (void)cssend:(NSString*)nicknameStr{
     NSLog(@"3=%@",[NSThread currentThread]);
    nicknameStr = @"NICHENG";
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:self userInfo:@{@"NSThread_nick":nicknameStr}];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:nil userInfo:@{@"NSThread_nick":@"obj=nil"}];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRobotNickNameNotification" object:@"NSThread_userInfo=nil" userInfo:nil];
}
#pragma mark -- 重启

- (void)restartBtnAction:(UIButton *)sender{
    if (_restartAlert==nil) {
        _restartAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"是否确定重启设备",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
           
            [self reBootAction];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
         _restartAlert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
        [_restartAlert addAction:cancelAction];
        [_restartAlert addAction:yesAction];
        
    }
    _restartAlert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:_restartAlert animated:YES completion:nil];
    
    
}
#pragma mark -- 重启
- (void)reBootAction{
     [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"reboot_device 1"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 接收音量／语种
- (void)receiveXmppMessageWithMessage:(NSString *)message{
    
     NSLog(@"cansave=%d %@",_isCanSaveNewV,[ToolOfBasic nowTimeOfLong]);
    NSArray *array = [message componentsSeparatedByString:@" "];
    if ([array.firstObject isEqualToString:@"about_device"]&&array.count>=11&&_isCanSaveNewV==YES) {//_isCanSaveNewV可以接受v
        //11位才是声音
        _strOfVoiceInfo = [NSString stringWithFormat:@"%@",array[10]];//11c 10index
        //点击滑动时屏蔽掉about_device
        _voiceSlider.value = [_strOfVoiceInfo floatValue];
        [DataManager shareDataManager].volumeStr = _strOfVoiceInfo;
        
    }
    NSLog(@"_isCanSaveNewV=%d %@",_isCanSaveNewV,[ToolOfBasic nowTimeOfLong]);
    
    //1220新增语言环境数据
    if([array.firstObject isEqualToString:@"language_info"]){
        if ([array.lastObject intValue]==0) {
            _languageDetailLable.text = @"中文";
        }else if([array.lastObject intValue]==1){
            _languageDetailLable.text = @"English";
        }else{
        }
    }
    
    
    if ([array.firstObject isEqualToString:@"prevent_drop_info"]) {
        if ([array.lastObject intValue]==0) {
            [_dieLuoSwith setOn:NO];
            [DataManager shareDataManager].robotPreventDrop = NO;
        }else if([array.lastObject intValue]==1){
            [_dieLuoSwith setOn:YES];
            [DataManager shareDataManager].robotPreventDrop = YES;//防跌落功能开启

        }else{
            
        }
    }
}
#pragma mark --
//sliderTouchDown
//sliderTouchCancel
//滑动时的有效
- (void)sliderTouchDown:(UISlider *)sender{
      NSLog(@"sliderTouchDown==%f",sender.value);
    _isCanSaveNewV = NO;//滑动手势在手指放上去时的不接受vinfo的设置
}
//没效果
- (void)sliderTouchCancel:(UISlider *)sender{
         NSLog(@"sliderTouchCancel==%f",sender.value);
//     _isCanSaveNewV = yes;
}
#pragma mark -- sliderValueChanged 音量滑动事件 发送音量数据 changede
- (void)sliderValueChanged:(UISlider *)sender{//v
    
   /**
     _isCanSaveNewV = NO;//0129滑动时
    NSLog(@"value==%f",sender.value);
    CGFloat vfolat = sender.value;//float
    int vint = ceilf(vfolat);//向上取整
    int senderValueLevleInt = vint*16/100;
     NSLog(@"senderValueLevleInt==%d",senderValueLevleInt);
    [self leaveSender:senderValueLevleInt];
    */
    //0130现在没有16个级别 直接发 or接收
    _isCanSaveNewV = NO;
    NSString *strOfSendV = [NSString stringWithFormat:@"volume_control %d",(int)sender.value];
     [_voiceSlider setValue:sender.value animated:NO];
    [DataManager shareDataManager].volumeStr = strOfSendV;
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendV];
    [self performSelector:@selector(setCanNewV) withObject:nil afterDelay:5]; //延时5 5秒内不接受扫地机给的音量值 _isCanSaveNewV = YES;
}
- (void)setCanNewV{
    _isCanSaveNewV = YES;
}
#pragma mark - UIGesture 音量点击事件
- (void)voiceSliderTapGesture:(UITapGestureRecognizer *)ges {
    /**
     _isCanSaveNewV = NO;//点击事件 接受声音的info的操作停止5秒
    NSLog(@"voiceSliderTapGesture");
    CGPoint touchPoint = [ges locationInView:_voiceSlider];
    CGFloat vfolat = (_voiceSlider.maximumValue - _voiceSlider.minimumValue) * (touchPoint.x / _voiceSlider.frame.size.width );
    NSLog(@"vfolat==%f",vfolat);
    int vint = ceilf(vfolat);//向上取整
    int senderValueLevleInt = vint*16/100;
    NSLog(@"senderValueLevleInt==%d",senderValueLevleInt);
    [self leaveSender:senderValueLevleInt];
    */
    //0130 没有16级别 直接发
    _isCanSaveNewV = NO;//点击事件 接受声音的info的操作停止5秒
    NSLog(@"voiceSliderTapGesture");
    CGPoint touchPoint = [ges locationInView:_voiceSlider];
    CGFloat vfolat = (_voiceSlider.maximumValue - _voiceSlider.minimumValue) * (touchPoint.x / _voiceSlider.frame.size.width );
    [_voiceSlider setValue:vfolat animated:NO];
    NSString *strOfSendV = [NSString stringWithFormat:@"volume_control %d",(int)vfolat];
    [DataManager shareDataManager].volumeStr = strOfSendV;
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendV];
    [self performSelector:@selector(setCanNewV) withObject:nil afterDelay:5]; //延时5 5秒内不接受扫地机给的音量值 _isCanSaveNewV = YES;
    
}

- (void)leaveSender:(int)leaveInt{
    /**
     小数向上取整，指小数部分直接进1            x=3.14，ceilf(x)=4
     小数向下取整，指直接去掉小数部分          x=3.14，floor(x)=3*/
    
    CGFloat v= leaveInt*100.0/16.0;//float
    int vSendnum = ceilf(v);
    [_voiceSlider setValue:vSendnum animated:NO];
     NSLog(@"leaveSender:leaveInt= %d v= %f vSend=%d", leaveInt,v,vSendnum);
      NSString *strOfSendVoluem = [NSString stringWithFormat:@"volume_control %d",vSendnum];
    _isCanSaveNewV = NO;
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfSendVoluem];
     [self performSelector:@selector(setCanNewV) withObject:nil afterDelay:5]; //延时5 5秒内不接受扫地机给的音量值 _isCanSaveNewV = YES;
}
#pragma mark -- 三个控件都在的约束
- (void)getAllYueSuOfSetVc{
    //superv
    [_nameBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(100);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    //1220新增语种
    [_languageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_nameBackView.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    //v
    [_voiceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_languageBackView.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(100);
    }];
    
    //20190411新增
    [_dieLuoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_voiceBackView.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    
    //重绘
    [_restartBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_dieLuoBackView.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    
    
    //subv——————————————————————————————————————
    //昵称
    [_nameNickL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_nameBackView);
        make.left.equalTo(self.view.mas_left).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-60);//图片在
        make.height.equalTo(_nameBackView.mas_height).offset(-10);
    }];
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_nameBackView);
        make.width.equalTo(_nameBackView.mas_width).offset(-20);
        make.height.equalTo(_nameBackView.mas_height).offset(-10);
    }];
    //重绘
    [_restartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_restartBackView);
        make.width.equalTo(_restartBackView.mas_width).offset(-20);
        make.height.equalTo(_restartBackView.mas_height).offset(-10);
    }];
  
    
    
    //音量
    [_voiceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_voiceBackView.mas_top).offset(5);
        make.width.equalTo(_voiceBackView.mas_width).offset(-20);
        make.height.offset(25);
    }];
    [_voiceSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(_voiceBackView).offset(-20);
        make.top.equalTo(_voiceL.mas_bottom).offset(5);
        make.bottom.equalTo(_voiceBackView.mas_bottom).offset(-5);
    }];
    
    //20190411新增跌落
    [_dieLuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_dieLuoBackView.mas_top).offset(5);
        make.width.equalTo(_dieLuoBackView.mas_width).offset(-20);
        make.height.offset(24);
    }];
    
    [_dieLuoDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dieLuoLabel.mas_bottom);
        make.left.equalTo(_dieLuoLabel.mas_left);
        make.right.equalTo(_dieLuoBackView.mas_right).offset(-120);
        make.bottom.equalTo(_dieLuoBackView.mas_bottom).offset(2);
        
    }];
    
    [_dieLuoSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_dieLuoBackView);
        make.height.offset(40);
        make.width.offset(90);
        make.right.equalTo(_dieLuoBackView.mas_right).offset(-30);
    }];
    
    //
    [_onePushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nameBackView.mas_right).offset(-20);
        make.centerY.equalTo(_nameBackView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    [_twoPushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_restartBackView.mas_right).offset(-20);
        make.centerY.equalTo(_restartBackView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    
    //1220新增语种subv
    //subv
    [_languageDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_languageBackView);
        make.left.equalTo(self.view.mas_left).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-60);//图片在
        make.height.equalTo(_languageBackView.mas_height).offset(-10);
    }];
    
    [_languagePushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_languageBackView.mas_right).offset(-20);
        make.centerY.equalTo(_languageBackView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    [_languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_languageBackView);
        make.width.equalTo(_languageBackView.mas_width).offset(-20);
        make.height.equalTo(_languageBackView.mas_height).offset(-10);
    }];

}
#pragma mark -- yueshu 没有音量的约束
- (void)getNewYueSuOfSetVc{
    //superv
    [_nameBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(100);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    //无v
    [_voiceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_nameBackView.mas_bottom).offset(30);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(100);
    }];
    [_restartBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_nameBackView.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(60);
    }];
    
   //subv
    [_nameNickL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_nameBackView);
        make.left.equalTo(self.view.mas_left).offset(100);
        make.right.equalTo(self.view.mas_right).offset(-60);//图片在
        make.height.equalTo(_nameBackView.mas_height).offset(-10);
    }];
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_nameBackView);
        make.width.equalTo(_nameBackView.mas_width).offset(-20);
        make.height.equalTo(_nameBackView.mas_height).offset(-10);
    }];
    
    [_restartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_restartBackView);
        make.width.equalTo(_restartBackView.mas_width).offset(-20);
        make.height.equalTo(_restartBackView.mas_height).offset(-10);
    }];
    
    [_voiceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_voiceBackView.mas_top).offset(5);
        make.width.equalTo(_voiceBackView.mas_width).offset(-20);
        make.height.offset(25);
    }];
    [_voiceSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(_voiceBackView).offset(-20);
        make.top.equalTo(_voiceL.mas_bottom).offset(5);
        make.bottom.equalTo(_voiceBackView.mas_bottom).offset(-5);
    }];
 
    [_onePushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nameBackView.mas_right).offset(-20);
        make.centerY.equalTo(_nameBackView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    [_twoPushImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_restartBackView.mas_right).offset(-20);
        make.centerY.equalTo(_restartBackView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
}
#pragma mark -- 1220新增语言
- (UIView *)languageBackView{
    if (!_languageBackView) {
        _languageBackView = [[UIView alloc]init];
        _languageBackView.backgroundColor = [UIColor whiteColor];;;
    }
    return _languageBackView;
}

- (UIButton *)languageBtn{
    if (!_languageBtn) {
        _languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _languageBtn.titleLabel.numberOfLines = 3;
        [_languageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _languageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_languageBtn addTarget:self action:@selector(languageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_languageBtn setTitle:NSLocalizedString(@"提示音语种",nil)  forState:UIControlStateNormal];
    }
    return _languageBtn;
}

- (UILabel *)languageDetailLable{
    if (!_languageDetailLable) {
        _languageDetailLable = [[UILabel alloc]init];
        _languageDetailLable.text = _strOfLanguage;
        _languageDetailLable.font = [UIFont systemFontOfSize:14];
        _languageDetailLable.textColor = [UIColor lightGrayColor];
        _languageDetailLable.textAlignment = NSTextAlignmentRight;
    }
    return _languageDetailLable;
}
- (UIImageView *)languagePushImgV{
    if (!_languagePushImgV) {
        _languagePushImgV = [[UIImageView alloc]initWithImage:Y_IMAGE(@"跳转")];
        _languagePushImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _languagePushImgV;
}

#pragma mark -- getter view部分
- (UIView *)nameBackView{
    if (!_nameBackView) {
        _nameBackView = [[UIView alloc]init];
        _nameBackView.backgroundColor = [UIColor whiteColor];;;
    }
    return _nameBackView;
}
- (UIView *)voiceBackView{
    if (!_voiceBackView) {
        _voiceBackView = [[UIView alloc]init];
        _voiceBackView.backgroundColor = [UIColor whiteColor];
    }
    return _voiceBackView;
}
- (UIView *)restartBackView{
    if (!_restartBackView) {
        _restartBackView = [[UIView alloc]init];
        _restartBackView.backgroundColor = [UIColor whiteColor];
    }
    return _restartBackView;
}

- (UIButton *)nameBtn{
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameBtn.titleLabel.numberOfLines = 3;
        [_nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nameBtn setTitle:NSLocalizedString(@"设备名称",nil)  forState:UIControlStateNormal];
    }
    return _nameBtn;
}
- (UILabel *)nameNickL{
    if (!_nameNickL) {
        _nameNickL = [[UILabel alloc]init];
        _nameNickL.text = _nameStrOfThisRobot;
        _nameNickL.font = [UIFont systemFontOfSize:14];
        _nameNickL.textColor = [UIColor lightGrayColor];
        _nameNickL.textAlignment = NSTextAlignmentRight;
    }
    return _nameNickL;
}

- (UIButton *)restartBtn{
    if (!_restartBtn) {
        _restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_restartBtn setTitle:NSLocalizedString(@"重启设备（软重启）",nil) forState:UIControlStateNormal];
        [_restartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _restartBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [_restartBtn addTarget:self action:@selector(restartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _restartBtn;
}

- (UILabel *)voiceL{
    if (!_voiceL) {
        _voiceL = [[UILabel alloc]init];
        _voiceL.text = NSLocalizedString(@"提示音音量：",nil);
    }
    return _voiceL;
}
- (UISlider *)voiceSlider{
    if (!_voiceSlider) {
        _voiceSlider = [[UISlider alloc]init];
        
        _voiceSlider.minimumValue = 0;
        _voiceSlider.maximumValue = 100;
        _voiceSlider.tintColor = [DataManager shareDataManager].colorOfMainType;
        _voiceSlider.value = 100;// 设置初始值
        if ([DataManager shareDataManager].volumeStr.length!=0) {
            _voiceSlider.value = [[NSString stringWithFormat:@"%@",[DataManager shareDataManager].volumeStr] floatValue];
        }
        //滑动
        _voiceSlider.continuous = NO;// YES设置可连续变化 no在放开时响应方法
        [_voiceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        //点击
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceSliderTapGesture:)];
        [_voiceSlider addGestureRecognizer:tapGesture];
        
        //监听UIControlEventTouchDown UIControlEventTouchCancel
         [_voiceSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:   UIControlEventTouchDown];// 针对值变化添加响应方法
         [_voiceSlider addTarget:self action:@selector(sliderTouchCancel:) forControlEvents:   UIControlEventTouchUpInside];// 针对值变化添加响应方法
    }
    
    return _voiceSlider;
}
- (UIImageView *)onePushImgV{
    if (!_onePushImgV) {
        _onePushImgV = [[UIImageView alloc]initWithImage:Y_IMAGE(@"跳转")];
        _onePushImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _onePushImgV;
}

- (UIImageView *)twoPushImgV{
    if (!_twoPushImgV) {
        _twoPushImgV = [[UIImageView alloc]initWithImage:Y_IMAGE(@"跳转")];
        _twoPushImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _twoPushImgV;
}
#pragma  mark =========================================跌落开关v========
///20190411新增跌落开关
- (UIView *)dieLuoBackView{
    if (!_dieLuoBackView) {
        _dieLuoBackView = [[UIView alloc]init];
        _dieLuoBackView.backgroundColor = [UIColor whiteColor];
    }
    return _dieLuoBackView;
}

- (UILabel *)dieLuoLabel{
    if (!_dieLuoLabel) {
        _dieLuoLabel = [[UILabel alloc]init];
        _dieLuoLabel.text = NSLocalizedString(@"防跌落", nil);
    }
    return _dieLuoLabel;
}
- (UILabel *)dieLuoDetailLabel{
    if (!_dieLuoDetailLabel) {
        _dieLuoDetailLabel = [[UILabel alloc]init];
        _dieLuoDetailLabel.text = NSLocalizedString(@"楼梯台阶等跌落环境,请勿关闭防跌落开关", nil);//Stairs and other falling environments, please do not turn off the fall
        _dieLuoDetailLabel.font = [UIFont systemFontOfSize:12];
        _dieLuoDetailLabel.textColor = UIColor.redColor;
        _dieLuoDetailLabel.numberOfLines = 2;
    }
    return _dieLuoDetailLabel;
}


- (UISwitch *)dieLuoSwith{
    if (!_dieLuoSwith ) {
        _dieLuoSwith = [[UISwitch alloc]init];
        _dieLuoSwith.onTintColor = [DataManager shareDataManager].colorOfMainType;
        if ([DataManager shareDataManager].robotPreventDrop==YES) {
             [_dieLuoSwith setOn:YES];
        }else{
             [_dieLuoSwith setOn:NO];
        }
//        _dieLuoSwith.transform= CGAffineTransformMakeScale(1.2,0.8); //大小
        [_dieLuoSwith addTarget:self action:@selector(switchActionOfdieluo:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _dieLuoSwith;
}
#pragma  mark =========================================switchActionOfdieluo 跌落开关action========
- (void)switchActionOfdieluo:(UISwitch *)sender{
    if (sender.isOn) {
        NSLog(@"switchActionOfdieluo on");//开启
        [DataManager shareDataManager].robotPreventDrop = YES;
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"prevent_drop_info 1"];

    }else{
        NSLog(@"switchActionOfdieluo off");//关闭
        [DataManager shareDataManager].robotPreventDrop = NO;//
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"prevent_drop_info 0"];
        
    }
}


#pragma  mark =========================================setOfLanguageChoosePopView========
#pragma mark -- setOfLanguageChoosePopView
- (SetOfLanguageChoosePopView *)setOfLanguageChoosePopView{
    if (!_setOfLanguageChoosePopView) {
        //数据
        _setOfLanguageChoosePopView = [[[NSBundle mainBundle]loadNibNamed:@"SetOfLanguageChoosePopView" owner:self options:nil]objectAtIndex:0];
        _setOfLanguageChoosePopView.titleLabel.text = NSLocalizedString(@"提示音语种",nil);
        _setOfLanguageChoosePopView.frame = self.view.frame;
        //按钮
        [_setOfLanguageChoosePopView.cancelBtn addTarget:self action:@selector(changeLanguageCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_setOfLanguageChoosePopView.yesBtn addTarget:self action:@selector(changeLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    //数据
    _arrOfPopTitle = [NSMutableArray arrayWithObjects:@"中文",@"English",@"无语音提示", nil];
    if ([[DataManager shareDataManager].robotLanguage isEqualToString:_arrOfPopTitle.firstObject]) {
        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"1",@"0",@"0", nil];
    }else if([[DataManager shareDataManager].robotLanguage isEqualToString:_arrOfPopTitle[1]]){
        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"0",@"1",@"0", nil];
    }else if([[DataManager shareDataManager].robotLanguage isEqualToString:_arrOfPopTitle.lastObject]){
        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"0",@"0",@"1", nil];
    }else{
        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];//0103新增
    }
    //    _arrOfPopTitle = [NSMutableArray arrayWithObjects:@"中文",@"English", nil];

//    if ([[DataManager shareDataManager].robotLanguage isEqualToString:_arrOfPopTitle.firstObject]) {
//        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"1",@"0", nil];
//    }else if([[DataManager shareDataManager].robotLanguage isEqualToString:_arrOfPopTitle.lastObject]){
//        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"0",@"1", nil];
//    }else{
//        _arrOfPopTitleNum = [NSMutableArray arrayWithObjects:@"0",@"0", nil];//0103新增
//    }
    [_setOfLanguageChoosePopView setDataWithTitleArr:_arrOfPopTitle numArr:_arrOfPopTitleNum];
    //显隐
    if (_setOfLanguageChoosePopView.hidden==YES) {
        _setOfLanguageChoosePopView.hidden = NO;
    }

    return _setOfLanguageChoosePopView;
    
}

- (void)changeLanguageCancelAction:(UIButton *)sender{
    _setOfLanguageChoosePopView.hidden = YES;
}
- (void)changeLanguageAction:(UIButton *)sender{

    if ([_setOfLanguageChoosePopView.arrOfTableViewDataNum indexOfObject:@"1"] != NSNotFound) {
        
        NSInteger inde =[_setOfLanguageChoosePopView.arrOfTableViewDataNum indexOfObject:@"1"] ;
    
        [DataManager shareDataManager].robotLanguage = _arrOfPopTitle[inde];
        _languageDetailLable.text = _arrOfPopTitle[inde];
        [self setNewLanguageLabelOfNum:inde];
        _setOfLanguageChoosePopView.hidden = YES;
    }else{
        //全空 0 无响应
    }
}
- (void)setNewLanguageLabelOfNum:(NSInteger)num{
    if (num==0) {//中文
        [[XmppManager shareXmppManager]sendmsgOfoneSqWithMessage:@"set_language 0"];
    }else if(num==1){//英文
        [[XmppManager shareXmppManager]sendmsgOfoneSqWithMessage:@"set_language 1"];
    }else{//@"无语音提示",
        [[XmppManager shareXmppManager]sendmsgOfoneSqWithMessage:@"set_language 9"];//set_language 9
    }
    
    
}
@end
