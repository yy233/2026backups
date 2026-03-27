//
//  GenerateQrCodeViewController.m
//  二维码相关添加扫地机demo
//
//  Created by Joey on 2018/5/9.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "GenerateQrCodeViewController.h"
#import "SGQRCode.h"

#import<AVFoundation/AVCaptureDevice.h>

#import <AVFoundation/AVMediaFormat.h>

#import<AssetsLibrary/AssetsLibrary.h>

#import<CoreLocation/CoreLocation.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


//屏幕宽高
//屏幕宽度、高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define _mainW [UIScreen mainScreen].bounds.size.width
#define _mainH [UIScreen mainScreen].bounds.size.height

@interface GenerateQrCodeViewController ()<SGQRCodeScanManagerDelegate,SGQRCodeAlbumManagerDelegate,XmppManagerDelegate,CAAnimationDelegate>

{
    
     int line_tag;
}
@property (nonatomic,strong) SGQRCodeScanManager *scanManager;
@property (nonatomic,strong) SGQRCodeAlbumManager *albumManager;

@property (nonatomic,strong) UIAlertController *alertOfF;
@property (nonatomic,assign) int getStrCount;

@property (nonatomic,assign) BOOL robotIsOnLine;
@property (nonatomic,assign) int timerNum;
@property (nonatomic,strong) NSTimer *timerOfrobotIsOnLine;

@property (nonatomic,strong) NSMutableArray *arrOfJidAndNickName;//2 count

@property (nonatomic,strong) UIAlertController *alertControllerOfAddRobot;
@property (nonatomic,assign) int photorightNum;//相册权限数num
@end
/**当前二维码协议
 ROBOTJID:jid;NICKNAME:昵称;TYPE:01
 */
@implementation GenerateQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"添加扫地机";
     self.title = NSLocalizedString(@"添加机器人", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initRightItemBtn];
    _getStrCount = 0;
    [self initData];
    [self initView];
}

- (void)initView{
    [self setOverlayPickerView];
}
#pragma mark -- 添加扫描数据得到后的 停止或开始动画的通知
- (void)initData{
      line_tag = TAG_BTN_C+666;
    //新增监听对动画进行起停

//    [self.scanManager addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    //    [_session removeObserver:self forKeyPath:@"running" context:nil];
}

#pragma mark -- 二维码扫描操作部分
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_scanManager == nil) {
        _scanManager = [SGQRCodeScanManager sharedManager];
        NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
        [_scanManager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
        _scanManager.delegate = self;
  
    }

    [self.scanManager startRunning];
    [self lineViewRunOrStop:YES];//开始动画
    
}
#pragma mark -- rightItem

- (void)initRightItemBtn{
    
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"相册", nil)   style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
//    self.navigationController.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)rightBtnAction:(UIBarButtonItem *)sender{
    [self goPhotoGetRightNumAction];
    
}

#pragma mark -- 相册权限
- (void)goPhotoGetRightNumAction{
    
        _photorightNum = 0;
        // 1、 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            // 判断授权状态
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusNotDetermined) {//尚未对此应用程序做出选择
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus statusP) {
                    if (statusP == PHAuthorizationStatusAuthorized) { // 用户第一次同意了访问相册权限
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            _photorightNum+=1;
                        });
//                        [self getNum];//20190410隐藏该调用防止错误
                    } else { // 用户第一次拒绝了访问相机权限
                        //不跳转
                        return ;
                    }
                    
                }];
                
                
            }else if (status == PHAuthorizationStatusRestricted){//无权访问照片
                [self getNum];
                
            }else if(status == PHAuthorizationStatusDenied) {//User已明确拒绝
                [self getNum];
            }else if (status == PHAuthorizationStatusAuthorized){//已授权
                _photorightNum += 1;
                [self getNum];
            }else{
                [self getNum];
            }
        }
        
 }
- (void)getNum{
    if (_photorightNum>0) {
        [self goPhotoVc];
    }else{
        [self goSetVc];
    }
}


- (void)goPhotoVc{
    /// 从相册中读取二维码方法
    _albumManager = [SGQRCodeAlbumManager sharedManager];
    [_albumManager readQRCodeFromAlbumWithCurrentController:self];
    _albumManager.delegate = self;
}
- (void)goSetVc{
    //没有权限
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
        if(@available(iOS 10.0 ,*)){//ios10+
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }else{
        [self.view makeToast:NSLocalizedString(@"无法跳转到设置页,请手动切换到系统设置界面,设置权限", nil) duration:3.0 position:@"center"];
    }
}
#pragma mark --扫面二维码的代理方法
/// 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects{
    NSLog(@"metadataObjects = %@",metadataObjects);
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    [self getStrOfQrCode:metadataObject.stringValue];
}


/// 根据光线强弱值打开手电筒的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue{
//    NSLog(@"brightnessValue=%f",brightnessValue);
}
#pragma mark --从相册中读取二维码的代理方法

/// 图片选择控制器取消按钮的点击回调方法
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager{
    NSLog(@" 图片选择控制器取消的回调");
     _getStrCount = 0;
    [self.navigationController popoverPresentationController];
}

/// 图片选择控制器读取图片二维码信息成功的回调方法
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result{
//    ROBOTJID 020101001006a050182a2 nickNmae 扫地机123
    
    
    NSArray *arrOfSource = [result componentsSeparatedByString:@";"];
    if (arrOfSource.count!=3) {
        [self.view makeToast:NSLocalizedString(@"未发现二维码，请确认后重试", nil)  duration:2 position:@"center"];
        return;
    }else{
         [self getStrOfQrCode:result];
    }
   
}

/// 图片选择控制器读取图片二维码信息失败的回调函数
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager{
      [self.view makeToast:NSLocalizedString(@"未发现二维码，请确认后重试", nil)  duration:2 position:@"center"];
}
#pragma mark --   [self getStrOfQrCode];

- (void)getStrOfQrCode:(NSString *)str{
    /**当前二维码协议
     ROBOTJID:jid;NICKNAME:昵称;TYPE:01
     */
    
    NSArray *arrOfSource = [str componentsSeparatedByString:@";"];
    if (arrOfSource.count!=3) {
        return;
    }
    
    NSArray *firstArr = [[NSString stringWithFormat:@"%@",arrOfSource.firstObject] componentsSeparatedByString:@":"];
    NSArray *twoArr = [[NSString stringWithFormat:@"%@",arrOfSource[1]] componentsSeparatedByString:@":"];
    NSArray *thrArr = [[NSString stringWithFormat:@"%@",arrOfSource.lastObject] componentsSeparatedByString:@":"];
    
    
    if ([firstArr.firstObject isEqualToString:@"ROBOTJID"] &&[twoArr.firstObject isEqualToString:@"NICKNAME"]&&[thrArr.firstObject isEqualToString:@"TYPE"] ) {//符合扫地机二维码格式
        
        //type 字端 比较是否为可添加的型号 品牌
        NSString *strOfGetType = [NSString stringWithFormat:@"%@", thrArr.lastObject];
        NSString *newStrOfGetType = @"";
        if (strOfGetType.length==1 && [strOfGetType intValue]<=9) {
            newStrOfGetType = [NSString stringWithFormat:@"0%@",strOfGetType]; //一位数变两位数=>str
        }else{
            newStrOfGetType = strOfGetType; //两位数=>str
        }
        NSLog(@"dddarr=%@",[DataManager shareDataManager].appCanAddRobotTypeArr);
        //判断是否支持该type
        if (![[DataManager shareDataManager].appCanAddRobotTypeArr containsObject:newStrOfGetType]) {
            [self.view makeToast:NSLocalizedString(@"APP升级后，才能添加该扫地机", nil)  duration:5 position:@"center"];
//            [self.navigationController popViewControllerAnimated:YES];
//            [self.navigationController popoverPresentationController];
            return;
        }
        
        _getStrCount += 1;//符合的二维码得到次数
        if (_getStrCount==1){
            //弹出框后
            _arrOfJidAndNickName = [NSMutableArray arrayWithObjects:firstArr.lastObject,twoArr.lastObject, nil];
            [self lineViewRunOrStop:NO];//得到符合的数据则停止动画
//            if (!_alertControllerOfAddRobot) { //添加前刷过其他二维码时，标题数据会变化，此if不要
                Y_WEAKSELF
            NSString *txtstr = NSLocalizedString(@"您是否要添加扫地机", nil);
                NSString *strOfmsg = [NSString stringWithFormat:@"%@：%@",txtstr,twoArr.lastObject];
                _alertControllerOfAddRobot = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:strOfmsg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *noAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _getStrCount = 0;
                    [self lineViewRunOrStop:YES];//取消时则开始动画
                }];
                UIAlertAction *yesAlertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //添加操作
                    [weakSelf addRobotActionOfSendXmpp];
                }];
                
                [_alertControllerOfAddRobot addAction:noAlertAction];
                [_alertControllerOfAddRobot addAction:yesAlertAction];
                
//            }
            [self  presentViewController:_alertControllerOfAddRobot animated:YES completion:nil];
            
            NSLog(@"_getStrCount=1  %d___=1____有弹出框  信息%@_______",_getStrCount ,_arrOfJidAndNickName);
        }
        NSLog(@"_getStrCount ______________ %d    信息%@",_getStrCount,_arrOfJidAndNickName);
    }
   
  
    /**
    
    //以前的解析方式
    NSArray *arrOfS = [str componentsSeparatedByString:@" "];
   
    
    if (arrOfS.count==4 && [arrOfS.firstObject isEqualToString:@"ROBOTJID"]) {
        _getStrCount += 1;//符合的二维码得到次数
        if (_getStrCount==1) {
            //弹出框后
            [self lineViewRunOrStop:NO];//得到符合的数据则停止动画
            if (!_alertControllerOfAddRobot) {
                NSString *strOfmsg = [NSString stringWithFormat:@"您是否要添加扫地机：%@",arrOfS[3]];
                _alertControllerOfAddRobot = [UIAlertController alertControllerWithTitle:@"提示" message:strOfmsg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *noAlertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _getStrCount = 0;
                    [self lineViewRunOrStop:YES];//取消时则开始动画
                    
                }];
                UIAlertAction *yesAlertAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //添加操作
                    _arrOfJidAndNickName = [NSMutableArray arrayWithObjects:arrOfS[1],arrOfS[3], nil];
                    [self addRobotActionOfSendXmpp];
                }];
                
                [_alertControllerOfAddRobot addAction:noAlertAction];
                [_alertControllerOfAddRobot addAction:yesAlertAction];
                
            }
            [self  presentViewController:_alertControllerOfAddRobot animated:YES completion:nil];
            
            
        }
    }
      */
}

- (void)addRobotActionOfSendXmpp{
    //发请求 得到OK-->在线--》现在不要判断在线这一步；
    //加列表 得到success-->加好友
    
    _robotIsOnLine = NO;
    XmppManager.shareXmppManager.delegates = self;
    [ShareUser sharedUserInfo].userMode.nowRobotJid = _arrOfJidAndNickName.firstObject;
//    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
    
    [self add];
    
/*
     [self.view makeToast:@"正在请求扫地机在线状态" duration:0.3 position:@"center"];
    _timerNum = 0;
    _timerOfrobotIsOnLine = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (_timerNum<15) {
            _timerNum+=1;
            if (_timerNum%3==0) {
                [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_connect"];
            }
        }else{
            [MBProgressHUD hideHUD];
            [_timerOfrobotIsOnLine invalidate];
            _timerOfrobotIsOnLine = nil;
            [self.view makeToast:@"扫地机不在线，暂不能添加" duration:0.5 position:@"bottom"];
            _getStrCount = 0;
        }
        
    }];
 */

}


#pragma mark -- xmpp
-(void)sendMessageSuccess{
    
}
-(void)sendMessageFail{
    
}

-(void)receiveXmppMessageWithMessage:(NSString *)message{
    //暂时不要这判断在线的这一步
   /* if ([message isEqualToString:@"request_connect ok"]) {
        [MBProgressHUD hideHUD];
        [_timerOfrobotIsOnLine invalidate];
        _timerOfrobotIsOnLine = nil;
        [self add];
        
    }
    */
}
- (void)add{    //如果昵称为空则附上jid
    [self.view makeToast:NSLocalizedString(@"正在添加扫地机" , nil) duration:0.3 position:@"bottom"];
    _robotIsOnLine = YES;

    if (_arrOfJidAndNickName.count==2) {
        if ([_arrOfJidAndNickName.lastObject isEqualToString:@""]) {
            [_arrOfJidAndNickName removeLastObject];
            [_arrOfJidAndNickName addObject:_arrOfJidAndNickName.firstObject];
        }
        [self addRobotActionOfListAdd];
    }else if (_arrOfJidAndNickName.count==1){
        [_arrOfJidAndNickName addObject:_arrOfJidAndNickName.firstObject];
        
        [self addRobotActionOfListAdd];
    }
}

#pragma mark -- http list add
- (void)addRobotActionOfListAdd{
    //xmpp
    NSLog(@"network_arrOfJidAndNickName======添加的是====%@",_arrOfJidAndNickName);
    [[XmppManager shareXmppManager]addFriendActionWithFriendName:[NSString stringWithFormat:@"%@", [ShareUser sharedUserInfo].userMode.nowRobotJid]  nickName:[NSString stringWithFormat:@"%@",_arrOfJidAndNickName.lastObject]];

    //服务器
    
    NSString *robotJid = _arrOfJidAndNickName.firstObject;
    NSString *robotnickName = _arrOfJidAndNickName.lastObject;
    NSString *nickN = [NSString stringWithFormat:@"%@",robotnickName];
    if (robotnickName.length>=20) {
        nickN = [[NSString stringWithFormat:@"%@",robotnickName]substringFromIndex:robotnickName.length-6];
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].userMode.userNameNoSuffix],@"userPhone",robotJid,@"eqHardwareSerial",nickN,@"nickName",nil];
    NSLog(@"parm=%@",parm);
   // [MBProgressHUD showMessage:@"正在添加扫地机"];
    [[ToolOfNetWork sharedTools]endXml];
    [[ToolOfNetWork sharedTools]YrequestURL:S_equipmentAddEqu withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"------%@",responsObject);
        NSLog(@"----error--%@",error.description);
       
        
        if (_Success) {
             NSString *msg = NSLocalizedString(@"添加成功", nil);
             [self.view makeToast:msg duration:3 position:@"center"];
          
             [self performSelector:@selector(popRootvc) withObject:@"stopRecord" afterDelay:0.5];
            
        }else{
            //403扫地机已存在
            //402扫地机不存在
            //401用户不存在
//            if ([msg isEqualToString:@"该扫地机已存在"]|| [[responsObject objectForKey:@"code"] intValue]==403) {
//                msg = @"您已经添加了此机器人";
//            }else if([msg isEqualToString:@"该扫地机不存在"] || [[responsObject objectForKey:@"code"] intValue]==402){
//                msg = @"您添加的机器人不存在,请确认后重试";
//
//            }else if([msg isEqualToString:@"用户不存在"]|| [[responsObject objectForKey:@"code"] intValue]==401){
//                msg = @"当前账号有错误,请重新登录";
//            }else{
//                msg = @"添加失败";
//            }
            
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
//                msg = NSLocalizedString(@"添加失败", nil);
                msg = NSLocalizedString(@"添加失败，请稍后重试", nil);
            }
           _alertOfF = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                 [self performSelector:@selector(popRootvc) withObject:@"stopRecord" afterDelay:1.0];
 
            }];
            [_alertOfF addAction:al];
            [self presentViewController:_alertOfF animated:YES completion:nil];
        }
        
    }];

}
- (void)popRootvc{
//     _getStrCount = 0;
      [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_scanManager) {
        [_scanManager stopRunning];
       
    }
    if (_albumManager) {

        _albumManager = nil;
    }
    if (_timerOfrobotIsOnLine) {
        [_timerOfrobotIsOnLine invalidate];
        _timerOfrobotIsOnLine = nil;
    }
    
     
}

#pragma mark --
#pragma mark -- 添加上动画和背景
/**
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
//    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, ScreenHeight)];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Y_mainW*0.25, ScreenHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
//    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 0, 30, ScreenHeight)];
     UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-ScreenWidth*0.25, 0, Y_mainW*0.25, ScreenHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
//    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth - 60, (self.view.center.y-(ScreenWidth-60)/2))];
    
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(Y_mainW*0.25, 0, Y_mainW*0.5, self.view.center.y-Y_mainW*0.25)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
//    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y+(ScreenWidth-60)/2), (ScreenWidth-60), (ScreenHeight-(self.view.center.y-(ScreenWidth-60)/2)))];
     UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(Y_mainW*0.25, (self.view.center.y+Y_mainW*0.25), Y_mainW*0.5, (ScreenHeight-(self.view.center.y-Y_mainW*0.25)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
//    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
//    [cancleBtn setImage:[UIImage imageNamed:@"nav_backButton_image"] forState:UIControlStateNormal];
//    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancleBtn];
    

    //网格
//    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, ScreenHeight-60)];
     UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*0.5, ScreenHeight*0.5)];
    centerView.center = self.view.center;
    centerView.image = [[UIImage imageNamed:@"scan_circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    centerView.tintColor = [DataManager shareDataManager].colorOfMainType;
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    //动态的线
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), ScreenWidth-60, 2)];
     UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.25, CGRectGetMaxY(upView.frame), ScreenWidth*0.5, 2)];
    line.tag = line_tag;
    line.image = [[UIImage imageNamed:@"scan_line"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
    line.tintColor = [DataManager shareDataManager].colorOfMainType;
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), ScreenWidth-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.numberOfLines = 2;
    msg.text = NSLocalizedString(@"将二维码放入框内,即可自动扫描", nil) ;
    [self.view addSubview:msg];
    
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 100)];
    //    label.backgroundColor = [UIColor clearColor];
    //    label.textColor = [UIColor whiteColor];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    label.font = [UIFont systemFontOfSize:15];
    //    label.text = @"";
    //    [self.view addSubview:label];
    
}


/**
 *
 *  监听扫码状态-修改扫描动画
 *
 */
- (void)lineViewRunOrStop:(BOOL)isRunning{
    if (isRunning) {
        [self addAnimation];
    }else{
        [self removeAnimation];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
       
    }
}
/**
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
//    CABasicAnimation *animation = [self moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-60-2] rep:OPEN_MAX];
    CABasicAnimation *animation = [self moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth*0.5-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}
//动画
- (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}


@end
