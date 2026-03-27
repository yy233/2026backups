//
//  ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc.m
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
// 保留本页留档 暂时用的是swiftvc页

#import "ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc.h"
#import "CreateLiveOrVoiceView.h"
#import "CreatOfBottomBtnView.h"

#import "LiveRoomBase.h"
#import "VoiceRoomChuanZhiModel.h"
#import "VoiceRoomBase.h"


#import <BRPickerView/BRPickerView.h>

#import "ZhiBoBaseNetTools.h"


#define  header_Img @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F4d2a8885-131d-4530-835a-0ee12ae4201b%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1687765377&t=ee61d1320c1668366c988c53715b0c3e"

#define header_Img_mao @"https://img1.baidu.com/it/u=3864853044,2957414387&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=501"

#define  bk_Img @"https://bkimg.cdn.bcebos.com/pic/8d5494eef01f3a297848d3cb9725bc315c607c36?x-bce-process=image/watermark,image_d2F0ZXIvYmFpa2UyMjA=,g_7,xp_5,yp_5"
#define  bk_Img_hua @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202005%2F30%2F20200530161734_3vQuu.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1687923611&t=31c4e0bc84c34a92b8a4837194847d6e"
#import "Socialize-Swift.h"

//@import  ImSDK_Plus;
//@import  TUIVoiceRoom;
//@import  Toast_Swift;
//#import <TUIVoiceRoom/TUIVoiceRoom-umbrella.h>
//#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>
//#import <TUIVoiceRoom/TUIVoiceRoomKit.h>
//#import <TRTCVoiceRoomDef.h>
//TRTCVoiceRoomEnteryControlDelegate
//#import "VoiceRoomBase.h"
@interface ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc () <CreateLiveOrVoiceViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) CreateLiveOrVoiceView *topView;
@property (nonatomic,strong) CreatOfBottomBtnView *footerBtnV;

//基础数据
@property (nonatomic,strong) NSString *saveFenMianImgStr;
@property (nonatomic,strong) NSString *saveTitleStr;
@property (nonatomic,assign) BOOL isPublicType;
@property (nonatomic,assign) BOOL nowWillCreateTypeIsVoice;
@property (nonatomic,strong) NSString *saveKaiBoTimeStr;


@end

@implementation ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc

- (UIImageView *)maxBgView{
    if(!_maxBgView){
        _maxBgView = [[UIImageView alloc]init];
        _maxBgView.image = [UIImage imageNamed:@"img_live_create"];
        _maxBgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _maxBgView;
}
- (LiveUseCarmeraView *)liveUseCarmeraView{
    if(!_liveUseCarmeraView){
        _liveUseCarmeraView = [[LiveUseCarmeraView alloc] initWithFrame:CGRectZero];
        [_liveUseCarmeraView setupCameraWithPosition:AVCaptureDevicePositionFront onVideoOrientation:AVCaptureVideoOrientationPortrait];//AVCaptureVideoOrientationLandscapeLeft
     }
    return _liveUseCarmeraView;
 }

- (UIImageView *)centerBgZheXianView{
     
    if(!_centerBgZheXianView){
        _centerBgZheXianView = [[UIImageView alloc]init];
        _centerBgZheXianView.image = [UIImage imageNamed:@"voice_Zhe"];
        _centerBgZheXianView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _centerBgZheXianView;
}

- (CreateLiveOrVoiceView *)topView{
    if(!_topView){
        _topView = [[CreateLiveOrVoiceView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 380+88)];//3行选择区域+toph填写区
        _topView.delegate = self;
    }
    return _topView;
}
- (CreatOfBottomBtnView *)footerBtnV{
    if(!_footerBtnV){
        _footerBtnV = [[CreatOfBottomBtnView alloc]initWithFrame:CGRectZero];
        [_footerBtnV.footerB newAnBtnWithTextStr:@"完成"];
        [_footerBtnV.footerB newAnBtnWithTextColor:[UIColor blackColor]];
        [_footerBtnV.footerB addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtnV;
}

- (void)touchChooseLiveType{
    DLog(@"视频类型");
    self.nowWillCreateTypeIsVoice = NO;
    self.maxBgView.hidden = NO;
    self.liveUseCarmeraView.hidden = NO;
     self.centerBgZheXianView.hidden = YES;
    
}
- (void)touchChooseVoiceType{
    self.nowWillCreateTypeIsVoice = YES;
    DLog(@"语音类型");
    self.maxBgView.hidden = YES;
    self.liveUseCarmeraView.hidden = YES;
    self.centerBgZheXianView.hidden = NO;
}

- (void)touchChangePubOrPriType{
    DLog(@"公开私有");
    if(self.topView.btnOfPubOrPir.selected == YES){
        DLog(@"公开");
    }else{
        DLog(@"私有");
    }
    
}

- (void)touchChooseFengMianPic{
    DLog(@"换照片");
    [self.view endEditing:YES];
    [self iconImgTap];
    
}
- (void)footerBtnAction{
 
    NSLog(@"----- footerBtnAction  完成-----");
    self.saveTitleStr = self.topView.inputTitleTF.text;
    if( isNil(self.saveTitleStr) || self.saveTitleStr.length <= 0 ){
        Y_SVP_SHOW_INFO_MES( Y_LocaleTypeFile_NSLocalString( @"没有设置标题"));
        return;
    }
    if(isNil(self.saveFenMianImgStr) || self.saveFenMianImgStr.length <= 0 ){
        Y_SVP_SHOW_INFO_MES( Y_LocaleTypeFile_NSLocalString(@"没有设置封面"));
        return;
    }
  
    //公开=选中状态
    BOOL gongKaiBool = NO;
    if(self.topView.btnOfPubOrPir.selected){
        gongKaiBool = YES;
    }else{
        gongKaiBool = NO;
    }
    
   
    if(self.topView.typeOfAtOnce.isSelected){//立即开播0823调整
        [self nowGoTokaiBo];
        return;
        //非立即开播--
        //选择开播的日期
        if( isNil(self.saveKaiBoTimeStr) || self.saveKaiBoTimeStr.length <= 0 ){
            Y_SVP_SHOW_INFO_MES(Y_LocaleTypeFile_NSLocalString(@"请选择开播的日期") );
            return;
        }

    }
    
    //http://api.local.com:8888/project/416/interface/api/15413
    ZhiBoBaseInfo  *addZhiBoModel = [[ZhiBoBaseInfo alloc]init];
    addZhiBoModel.title = self.saveTitleStr;
    addZhiBoModel.picture = self.saveFenMianImgStr;
    addZhiBoModel.startDatetime = self.saveKaiBoTimeStr;
    addZhiBoModel.recode =  (self.topView.btnOfPubOrPir.selected) ?  @"" : @"私密直播";//有值表示私密直播，无值表示公共直播
    addZhiBoModel.category =  self.nowWillCreateTypeIsVoice ? @"1": @"2";//1、video音视频， 2、audio音频， 3、else 其他
     
    //
    [ZhiBoBaseNetTools insertActivityData:addZhiBoModel WithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            NSLog(@"dicOfBloc =。 %@",dicOfBlock);
        }
    }];
   
    

    
}


- (void)touchKaiBoTime{
    DLog(@"开播时间");
    // 1.创建日期选择器
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    // 2.设置属性
    datePickerView.pickerMode = BRDatePickerModeYMDHMS;
    datePickerView.title = @""; //@"选择月日小时分";
    // datePickerView.selectValue = @"2019-10-30";
    datePickerView.minDate = [NSDate  dateWithTimeIntervalSinceNow: 3600*0.5];//[NSDate br_setYear:1949 month:3 day:12];
    datePickerView.maxDate = [NSDate  dateWithTimeIntervalSinceNow: 3600*24*365];
    datePickerView.selectDate = [NSDate  dateWithTimeIntervalSinceNow: 3600*0.5]; //[NSDate br_setYear:2019 month:10 day:30];
    datePickerView.isAutoSelect = YES;
    WEAKSELF
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        NSLog(@"选择的值：%@", selectValue);
        weakSelf.saveKaiBoTimeStr =  [YTimeStamp getTimeTimestamp_haoMiao_Date:selectDate];
        weakSelf.topView.kaiBoTimeL.text = selectValue;
    };
    // 设置自定义样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = [UIColor whiteColor];//BR_RGB_HEX(0x, 1.0f);
    customStyle.pickerTextColor = Color_Main_Green;// [UIColor gree];
    customStyle.separatorColor = [UIColor blackColor];
    
    //语言设置
    // language: zh-Hans（简体中文）、zh-Hant（繁体中文）、en（英语 ）
    NSString *nowLangs =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]];
    if(nowLangs.length>0 && ( [nowLangs containsString:@"zh-Hans"] || [nowLangs containsString:@"zh-Hant"] || [nowLangs containsString:@"en"]) ){
        customStyle.language = nowLangs;
    }else{//跟随系统
    }
    datePickerView.pickerStyle = customStyle;
    // 3.显示
    [datePickerView show];
    
}
- (void)nowGoTokaiBo{
    DLog(@"立即开播");
    
    DLog(@"直播配置完成");
    
    
    
    self.saveTitleStr = self.topView.inputTitleTF.text;
    if( isNil(self.saveTitleStr) || self.saveTitleStr.length <= 0 ){
        Y_SVP_SHOW_INFO_MES(Y_LocaleTypeFile_NSLocalString(@"没有设置标题") );
        return;
    }
//    if(isNil(self.saveFenMianImgStr) || self.saveFenMianImgStr.length <= 0 ){
//        Y_SVP_SHOW_INFO_MES(@"没有设置封面");
//        return;
//    }
 
    if(self.nowWillCreateTypeIsVoice){
        DLog(@"当前是语音类型");
        
        VoiceRoomChuanZhiModel *vChuanZhiModel = [[VoiceRoomChuanZhiModel alloc]init];
        vChuanZhiModel.Voice_Room_Name = self.saveTitleStr;
        vChuanZhiModel.Voice_Room_Introduction = @"";//暂无位置写入介绍信息
//        vChuanZhiModel.Voice_Room_BkImg = self.saveFenMianImgStr;//bk_Img;
        vChuanZhiModel.Voice_Room_BkImg =  bk_Img;
        vChuanZhiModel.Voice_Room_NeedRequest = YES;//需要同意才能上麦
        NSString *nickName = [ShareUserInfo share].userInfo.address;
        vChuanZhiModel.Voice_User_NickName = nickName;//用户昵称
        vChuanZhiModel.Voice_User_HeadImg = header_Img;
        
        WEAKSELF
        [[VoiceRoomBase shareVoice]creatVoiceRoomWithRootVc:self withVoiceXiangGuanInfo:vChuanZhiModel withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
            
            if(succes){
                DLog(@" ---------------- creatVoiceRoomWithInfo succ")
                [weakSelf pushVc:vc];
                
            }else{
                DLog(@"");
            }
            
        }];
        
    } else{
        
        
        switch (0) {
            case 0:
            {
                DLog(@"视频类型");
//                [LiveRoomBase liveroomCreateWithRoomIdStr:(NSString *)roomIdStr withTitle:self.saveTitleStr withFengMianUrlStr: self.saveFenMianImgStr withIsPublicBool: self.isPublicType];
              
                 [LiveRoomBase liveroomCreateWithRoomIdStr:@"" withActivityIdstr:@"" withTitle:self.saveTitleStr withFengMianUrlStr:self.saveFenMianImgStr withIsPublicBool:self.isPublicType];
//                if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length>0){//私密
//                    [LiveRoomBase liveroomCreateWithRoomIdStr:zhiBoInfoModel.roomId
//                                            withActivityIdstr:zhiBoInfoModel.activityId
//                                                    withTitle:zhiBoInfoModel.title
//                                           withFengMianUrlStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.picture]
//                                             withIsPublicBool:YES
//                                           withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
//                                                 withOtherDic:@{}];
//                }else{
//                    [LiveRoomBase liveroomCreateWithRoomIdStr:zhiBoInfoModel.roomId withActivityIdstr:zhiBoInfoModel.activityId withTitle:zhiBoInfoModel.title withFengMianUrlStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.picture] withIsPublicBool:YES];
//                }
            }
                break;
            case 1:
            {
                // 1------测试 去 视频房间
                int roomId = 10086;
                [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:@"roomNameStr" withActivityId:@"" withThisLiveRoomEnterRoomID:roomId];
//                if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length > 0){//私密直播
//                    [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
//                                                       withActivityId:zhiBoInfoModel.activityId
//                                          withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue]
//                                                   withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
//                                                         withOtherDic:@{}];
//                }else{
//                     [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
//                                                       withActivityId:zhiBoInfoModel.activityId
//                                          withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue] ];
//                }
            }
                break;
            case 2:
            {
                
                
                
                //2------测试 去 语音房间
                VoiceRoomChuanZhiModel *vChuanZhiModel = [[VoiceRoomChuanZhiModel alloc]init];
                vChuanZhiModel.Voice_User_NickName = @"voice1g观众";
                vChuanZhiModel.Voice_User_HeadImg = header_Img;
                //                vChuanZhiModel.Voice_Room_ID = @"1179402493"
                vChuanZhiModel.Voice_Room_ID = @"2024615538"; //1704024694 //307895640
                //1179402493 //10086
                WEAKSELF
                [[VoiceRoomBase shareVoice]enterVoiceRoomWithRootVc:self withInfo:vChuanZhiModel  withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
                    if(succes){
                        DLog(@" ---------------- enterVoiceRoomWithInfo succ ")
                        [weakSelf pushVc:vc];
                        
                    }else{
                        DLog(@"进语音房间失败");
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}

 
#pragma mark ====
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(27, 26, 39, 1);//创建页保持黑色的背景
    self.nowWillCreateTypeIsVoice = YES;
    self.isPublicType = YES;
    [self initViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UIColor *)navBackColor{
    return rgba(27, 26, 39, 1);
//    return [UIColor blackColor];//黑色nav
}
- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.isLijiZhiBoCreatIng = NO;
    
//   [self setup_NavigationBar_TransparentBk_blackText];
//   if (@available(iOS 15.0, *)) {
//       UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//       [appearance configureWithDefaultBackground];
//       appearance.shadowColor = nil;
//       appearance.backgroundEffect = nil;
//       appearance.backgroundColor =  [self navBackColor];
//       UINavigationBar *navigationBar = self.navigationController.navigationBar;
//       navigationBar.backgroundColor = [self navBackColor];
////       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//       navigationBar.barTintColor = [UIColor whiteColor];
//       navigationBar.shadowImage = [UIImage new];
//       NSDictionary *attDic = @{
//           NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//           NSForegroundColorAttributeName:[UIColor whiteColor]};
//       navigationBar.titleTextAttributes = attDic;
//       navigationBar.standardAppearance = appearance;
//       navigationBar.scrollEdgeAppearance= appearance;
//
//   }
//   else {
//       UINavigationBar *navigationBar = self.navigationController.navigationBar;
//       navigationBar.backgroundColor = [self navBackColor];
////       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//       navigationBar.barTintColor = [UIColor whiteColor];
//       navigationBar.shadowImage = [UIImage new];
//       [[UINavigationBar appearance] setTranslucent:NO];
//   }
 
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];//1B1A27
    self.view.backgroundColor = rgba(27, 26, 39, 1);
//    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor redColor]];
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{//本页面颜色保持黑色bk 黑色nav 白色状态栏
    return UIStatusBarStyleLightContent;//白色内容
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"创建页 viewDidAppear");//来回切换滑动会导致走主页列表的will 需要重新处理颜色 无效
//    [self setup_NavigationBar_TransparentBk_blackText];
//    if (@available(iOS 15.0, *)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        [appearance configureWithDefaultBackground];
//        appearance.shadowColor = nil;
//        appearance.backgroundEffect = nil;
//        appearance.backgroundColor =  [self navBackColor];
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
// //       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//        navigationBar.barTintColor = [UIColor whiteColor];
//        navigationBar.shadowImage = [UIImage new];
//        NSDictionary *attDic = @{
//            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
//            NSForegroundColorAttributeName:[UIColor whiteColor]};
//        navigationBar.titleTextAttributes = attDic;
//        navigationBar.standardAppearance = appearance;
//        navigationBar.scrollEdgeAppearance= appearance;
//
//    }
//    else {
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
// //       navigationBar.barTintColor = [self navBackColor];白色返回按钮?无效
//        navigationBar.barTintColor = [UIColor whiteColor];
//        navigationBar.shadowImage = [UIImage new];
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];
}

- (void)initViews{
    [self.view addSubview:self.maxBgView];
    [self.view addSubview:self.centerBgZheXianView];
    [self.view addSubview:self.liveUseCarmeraView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.footerBtnV];
    [_maxBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_maxBgView.superview);
    }];
    [_centerBgZheXianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_centerBgZheXianView.superview);
        make.centerY.equalTo(_centerBgZheXianView.superview);
        make.height.equalTo(_centerBgZheXianView.superview).multipliedBy(0.35);
    }];
    [_liveUseCarmeraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_liveUseCarmeraView.superview);
    }];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.superview).offset(100);
        make.left.right.equalTo(_topView.superview);
        make.height.offset( 380+88);
    }];
    [_footerBtnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_footerBtnV.superview);
        make.top.equalTo(_topView.mas_bottom);
    }];

    
}

#pragma mark ==
#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick

- (void)iconImgTap{
    DLog(@"");
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:Y_LocaleTypeFile_NSLocalString(@"取消") style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
       pickVC.allowsEditing = NO;
       pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   }else {
       
       pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
   }
   pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    if(isNil(photo)){
        Y_SVP_SHOW_INFO_MES(Y_LocaleTypeFile_NSLocalString( @"图片没被选中"));
        return;
    }
    Y_SVP_SHOW_MES_Loading
    WEAKSELF
    NSMutableDictionary *upImgDic = @{Img_Module_Key:Img_ModuleType_im}.mutableCopy;
    [PubNetwork pub_sendImgWithOneImgObj:photo andParms:upImgDic withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        Y_SVP_DISMISS
        if(succes){
            weakSelf.topView.fengMianImgV.image = photo;
            
            PubSendUpImgOkGetArrObjModel *mo = [PubSendUpImgOkGetArrObjModel mj_objectWithKeyValues:dicOfBlock];
            weakSelf.saveFenMianImgStr = mo.url;
            DLog(@"weakSelf.saveFenMianImgStr === %@ ",weakSelf.saveFenMianImgStr);
            
        }else{
            Y_SVP_SHOW_ERR_MES(Y_LocaleTypeFile_NSLocalString(@"上传失败") );
        }
    }];
}

@end
