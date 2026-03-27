//
//  MyViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "MyViewController.h"
#import "MyHeaderView.h"
#import "MySetViewController.h"
#import "MyDapViewController.h"
#import "MyNftMainListViewController.h"
#import "OneListPopView.h"

#import "TUiJianWebVc.h"
#import "LoginWebVC.h"
#import "MySubsWebVc.h"

//视频音频的登录
#import "LiveRoomBase.h"
#import "VoiceRoomBase.h"

#import "ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc.h"
#import "Socialize-Swift.h"

#import "PopViewOfUserQRUseInfo.h"

#import "ChatMainVcUseNoLoginShowView.h"

#define NociceName_WindowSubBaoHUOWebView_ShowOrHidden  @"NociceName_WindowSubBaoHUOWebView_ShowOrHidden"

//#define MyVc_CellBkC  rgba(72, 71, 81, 1)
//#define MyVc_CellBkC  rgba(255, 255, 255, 0.08)
//#define  Black_COlor4    43 42  53 rgba(43, 42, 53, 1)
//#define  Black_COlor2    26 25  37   rgba(26, 25, 37, 1)

@interface MyViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyHeaderView *headerView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *imgNamedataArr;
@property (nonatomic,strong) OneListPopView *popViewOfList;
@property (nonatomic,strong) PopViewOfUserQRUseInfo *popViewQRWithUserInfo;
@property (nonatomic,strong) ChatMainVcUseNoLoginShowView *thisNoLoginShowView;

@end


@implementation MyViewController

#pragma mark ===  账号登录view

- (ChatMainVcUseNoLoginShowView *)thisNoLoginShowView{
    if(!_thisNoLoginShowView){
        _thisNoLoginShowView = [[ChatMainVcUseNoLoginShowView alloc]init];
        [_thisNoLoginShowView.showLoginBtn addTarget:self action:@selector(showLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thisNoLoginShowView;
}
- (void)showLoginAction{
    DLog(@" 显 ");
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction, @"去登录");
}
#pragma mark === live voice 的相关登录

- (void)initVoiceAndLiveLogin{
    
    if( [V2TIMManager sharedInstance].getLoginStatus == V2TIM_STATUS_LOGINED ||  [V2TIMManager sharedInstance].getLoginStatus == V2TIM_STATUS_LOGINING){//已登录
        NSLog(@"initVoiceAndLiveLogin  登录或正砸登录");
    }else if(  [V2TIMManager sharedInstance].getLoginStatus ==  V2TIM_STATUS_LOGOUT ){//无登录
        NSLog(@"initVoiceAndLiveLogin  没在登录");
    }
    [self initVoiceLogin];
    [self initLiveAndLogin];
}
- (void)initLiveAndLogin{
    [LiveRoomBase liveRoomLoginInfoUserID:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
                                  userSig:([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"")
                               withBlockk:^(BOOL loginStue) {
        if(loginStue){
            NSLog(@"live voice 登录");
        }else{
            NSLog(@"live voice 登录失败");
        }
    }];
}
- (void)initVoiceLogin{
    [[VoiceRoomBase shareVoice] voiceRoomLoginAction];
}


#pragma mark === view datas
- (NSArray *)dataArr{
    _dataArr = @[Y_LocaleTypeFile_NSLocalString(@"我的友圈" ),
                 Y_LocaleTypeFile_NSLocalString(@"我的粉圈" ),
//                 Y_LocaleTypeFile_NSLocalString(@"web3名片" ),//"名片"@"名片_D"
                 Y_LocaleTypeFile_NSLocalString(@"我的FreeID" ),
                 Y_LocaleTypeFile_NSLocalString(@"我的收藏" ),
                 Y_LocaleTypeFile_NSLocalString(@"Token入驻申请" ),
                 Y_LocaleTypeFile_NSLocalString(@"设置" )];
    return _dataArr;
}

- (NSArray *)imgNamedataArr{
    if(!_imgNamedataArr){
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            _imgNamedataArr = @[@"友圈",@"粉圈",@"ID_g",@"收藏",@"入驻",@"设置_g"];
        }else{
            _imgNamedataArr = @[@"友圈_D",@"粉圈_D",@"ID_D",@"收藏_D",@"入驻_D",@"设置_D"];
        }
    }
    return _imgNamedataArr;
}
#pragma mark === view

//bk
- (void)initSelfViews{
    //渐变色
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    bgColorView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-KNavBarHeight, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgColorView];
 
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (MyHeaderView *)headerView{
    if(!_headerView){
        _headerView = [MyHeaderView instaceThisViewSelf];
        _headerView.frame  =  CGRectMake(0, 0, Screen_W, 144);
    }
    return _headerView;
}

- (void)initRightItems{
    if([ShareUserInfo share].userInfo.address.length > 0 ){//登录状态 钱包分享按钮
        UIBarButtonItem *walletItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStylePlain target:self action:@selector(walletItemAction)];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"分享_nav"] style:UIBarButtonItemStylePlain target:self action:@selector(shareItemAction)];
        [self.navigationItem setRightBarButtonItems:@[walletItem,shareItem] animated:YES];
        
    }else{//非登录界面 设置按钮
        UIBarButtonItem *walletItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStylePlain target:self action:@selector(walletItemAction)];
        UIBarButtonItem *setItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"设置_g"] style:UIBarButtonItemStylePlain target:self action:@selector(setItemAction)];
        [self.navigationItem setRightBarButtonItems:@[walletItem,setItem] animated:YES];
    }

}

#pragma mark === view actions
//钱包
#define WebView_goWalletPage_NoticeName  @"WebView_goWalletPage_NoticeName" //kOcSendToJsFunction_apiCall_methodObj_goWalletPage

- (void)walletItemAction{
    DLog()
    Y_NSNotificationCenter_PostNotice_NilObject_Name(WebView_goWalletPage_NoticeName);
}

//分享
- (void)shareItemAction{
    DLog()
    [Y_ToolOfOthers shareLinkUrlWithStr:@"https://www.freeper.io/" withNowVc:self];//分享
    
}
//设置
- (void)setItemAction{
    DLog();
    MySubsWebVc *vc = [[MySubsWebVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.subTypeUrlSuix = MySubVc_Url_Suix_MySet;
    [self pushVc:vc];
    
}

#pragma mark ============================================== viewDidLoad

#define  kTheme_Type_Key   @"Theme_Type"
#pragma mark === uis
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLanguageChangeNotice];
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }
    
    
    [self initSelfViews];

    
    UIView *tabn_footV  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H*0.5)];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        tabn_footV.backgroundColor = [UIColor whiteColor];
    }else{
        tabn_footV.backgroundColor = Black_COlor4;
    }
    self.tableView.tableFooterView = tabn_footV;
    self.headerView.headimgTopBtn.backgroundColor = [UIColor clearColor];
    self.headerView.headimgTopBtn.titleLabel.text = @"";
    self.headerView.idInfoTopBtn.titleLabel.text = @"";
    self.headerView.idInfoTopBtn.imageView.layer.masksToBounds = YES;
    self.headerView.idInfoTopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerView.idInfoTopBtn newAnBtnWithTextStr:@""];
    [self.headerView.headimgTopBtn newAnBtnWithTextStr:@""];
    self.headerView.headimg.image  = [BaseImgTool placeholdHeadImg];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.scrollEnabled = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.thisNoLoginShowView];
    
    NSLog(@"self.headerView.size == %@",NSStringFromCGSize(_headerView.frame.size));
    [_thisNoLoginShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_thisNoLoginShowView.superview);
        make.top.equalTo(_thisNoLoginShowView.superview).offset(144);//_headerView.frame.size.height
    }];
    [self checkUIOfLoginInfo];
     
    
    
}
#pragma mark === ui
- (void)checkUIOfLoginInfo{
    [self initRightItems];
    if([ShareUserInfo share].userInfo.address.length > 0 ){
        self.headerView.idInfoTopBtn.hidden = NO;
        self.thisNoLoginShowView.hidden = YES;
        [self initVoiceAndLiveLogin];//登录各账号
        [self initHeaderData];
    }else{
        self.thisNoLoginShowView.hidden = NO;
        self.headerView.idInfoTopBtn.hidden = YES;
    }
    
}
#pragma mark === notice
- (void)initLanguageChangeNotice{
    Y_NSNotificationCenter_Creat_NameAction(WebView_Langeuge_Change_NoticeName, noticeLanguageChange);
    Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, changeZhuTi);//changeZhuTi 语言切换通知可用于黑白色主题切换

}
- (void)changeZhuTi{
 
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        _imgNamedataArr = @[@"友圈",@"粉圈",@"ID_g",@"收藏",@"入驻",@"设置_g"];//@"名片"
    }else{
        _imgNamedataArr = @[@"友圈_D",@"粉圈_D",@"ID_D",@"收藏_D",@"入驻_D",@"设置_D"];//@"名片_D"
    }
    
    UIView *tabn_footV  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H*0.5)];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        tabn_footV.backgroundColor = [UIColor whiteColor];
    }else{
        tabn_footV.backgroundColor = Black_COlor4;
    }
    self.tableView.tableFooterView = tabn_footV;
    [self.tableView reloadData];
    //非登录状态
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];
    }
    [self viewWillAppear:YES];
}
- (void)noticeLanguageChange{
    [self.thisNoLoginShowView.showLoginBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"Login")];
    [self.tableView reloadData];
}
 

#pragma mark =====viewDidAppear 状态栏主题

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;  //可以自动休眠     //防止直播杀掉时禁止休眠没被更换状态 此程序开启时把自动休眠功能开启

    [self.tableView reloadData];
    [self setNeedsStatusBarAppearanceUpdate];
  
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
}
 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
#pragma mark = viewWillAppear 基础UI更新
 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.title = Y_LocaleTypeFile_NSLocalString(@"我的");
    self.edgesForExtendedLayout = UIRectEdgeNone;//0905 nav后坐标开始
    [self.tableView reloadData];
    [self checkUIOfLoginInfo];
    
    //非登录状态
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }
    
}
#pragma mark = headerv data
- (void)initHeaderData{
    self.headerView.backgroundColor = [UIColor clearColor];
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    UIImage *pImg;
    if([nowThemeStr isEqualToString: @"light"]){
        pImg = [UIImage imageNamed:@"default_c2c_head_0821W"];

    }else{
        pImg = [UIImage imageNamed:@"default_c2c_head_0821D"];

    }
    
    [self.headerView.headimg sd_setImageWithURL:[UrlWithString getURLWithStr: [ShareUserInfo share].userInfo.profileImageUrl] placeholderImage:pImg ];
    if(isNil([ShareUserInfo share].userInfo.address)){
        return;
    }else{
        [self.headerView.idInfoTopBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.headimgTopBtn addTarget:self action:@selector(headImgAction) forControlEvents:UIControlEventTouchUpInside];

        self.headerView.nickName.text = [self suoDuanAddressStr];//昵称=address
        if([TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.username].length > 0){//有昵称 则用昵称 不用address
            self.headerView.nickName.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.username];
        }
        if([TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.saveMydomain].length > 0){//有域名 则用域名 不用name
            self.headerView.nickName.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.saveMydomain];
        }
        if([TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.useDomain].length > 0){//有域名 则用域名 不用name
            self.headerView.nickName.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.useDomain];
        }
        self.headerView.idInfo.text = [NSString stringWithFormat:@"ID:%@", [ShareUserInfo share].userInfo.imId];//id=imId
        
    }
  
}


- (NSString *)suoDuanAddressStr{
    if([ShareUserInfo share].userInfo.saveMydomain.length>0){
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];

    }else{
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.address];

    }
}
//长度0816
#define Free_SubStr @".free"
- (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr{
    
    NSInteger Free_SubStrLen = Free_SubStr.length;
    if(addressStrOrDomainStr.length <= Free_SubStrLen){
        return addressStrOrDomainStr;
    }
    
    NSString *subfixStr = [addressStrOrDomainStr substringFromIndex:addressStrOrDomainStr.length-5];
    if([subfixStr isEqualToString:Free_SubStr]){//域名模样的nike
        if(addressStrOrDomainStr.length>16){//前四后4+5==9个 中间拼*号
            NSString *okStr = @"";
            //取后四位和前四位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:4];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-(4+Free_SubStrLen)];//倒数4的字符 加上后缀 位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return okStr;
        }else{//没超过16
            return addressStrOrDomainStr;//返回整个
        }
    }else{//非域名模样 昵称或者0x地址
        if( addressStrOrDomainStr.length > 12){ //12位以上 就*
            NSString *okStr = @"";
//            取后6位和前6位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:6];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-6];//倒数6的位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return  okStr;

        }else if ( addressStrOrDomainStr.length > 0){
            return addressStrOrDomainStr;
            
        }else{
            return @"-";//@"地址缺失"
        }
    }
   
}

- (void)copyAction{
    if([ShareUserInfo share].userInfo.imId.length >0 ){
//        [Y_ToolOfOthers copyStrClickWithStr:[TextShowWithModelStr textShowWithModelStr: [ShareUserInfo share].userInfo.imId]];
        [self showUserQR];
    }
}
- (void)headImgAction{
    if([ShareUserInfo share].userInfo.imId.length >0 ){
        DLog(@"去 pages/user/info 界面");
        MySubsWebVc *vc = [[MySubsWebVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.subTypeUrlSuix = MySubVc_Url_Suix_UserInfo;
        [self pushVc:vc];
        
    }
}

#pragma mark === qr  show data
- (void)showUserQR{
    self.popViewQRWithUserInfo = [[PopViewOfUserQRUseInfo alloc]init];
    [self.popViewQRWithUserInfo showInView:self.view thePopViewSubViewHeight:500.0 WithArray:@[].mutableCopy];
    [self.popViewQRWithUserInfo fillPopQrInfoWithUse];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    if(!cell){
        cell =  [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyTableViewCell"];
    }
    cell.titLabel.text = self.dataArr[indexPath.row];
    cell.imgV.image = [UIImage imageNamed:self.imgNamedataArr[indexPath.row]];
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        cell.titLabel.textColor = Color_51BlackColor;
    }else{
        cell.titLabel.textColor = [UIColor whiteColor];
    }
    cell.imgV.backgroundColor = [UIColor clearColor];
 
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
 
//tableView首行圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 圆角角度
    CGFloat radius = 30.f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    if (rowNum == 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    }else{
        if (indexPath.row == 0) {
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
            //           }else if (indexPath.row == rowNum - 1){
            //               // 每组最后一行（添加左下和右下的圆角）
            //               bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        }else{
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
    // 设置填充颜色
    //         normalLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
    //        normalLayer.fillColor = [[UIColor whiteColor] CGColor];
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        normalLayer.fillColor = [[UIColor whiteColor] CGColor];
    }else{
        normalLayer.fillColor = [Black_COlor4 CGColor];//
    }
    // 添加图层到nomarBgView中
    [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
    nomarBgView.backgroundColor = UIColor.clearColor;
    //         nomarBgView.backgroundColor = UIColor.whiteColor;
    cell.backgroundView = nomarBgView;
    //此时圆角显示就完成了，但是如果没有取消cell的点击效果，还是会出现一个灰色的长方形的形状，再用上面创建的selectLayer给cell添加一个selectedBackgroundView
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    //        selectLayer.fillColor = [[UIColor whiteColor] CGColor];
    
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        selectLayer.fillColor = [[UIColor whiteColor] CGColor];
    }else{
        selectLayer.fillColor = [Black_COlor4 CGColor];
    }
    
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;
}
//didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MySubsWebVc *vc = [[MySubsWebVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MyFriends;
            }
            break;
        case 1:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MyFans;
            }
            break;
       
        case 2:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MyFreeIds;
            }
            break;
        case 3:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MyCollect;
            }
            break;
        case 4:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MySettleIN;
            }
            break;
        case 5:
            {
                vc.subTypeUrlSuix = MySubVc_Url_Suix_MySet;
            }
            break;
            
            
        default:
        {
            NSLog(@"其他 暂无");
        }
            break;
    }
    [self pushVc:vc];
}

 
@end


#pragma  mark === === === === === === === === === === === === === === MyTableViewCell

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titLabel];
        [self.contentView addSubview:self.rightIcon];
        
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(25);
            make.centerY.equalTo(_imgV.superview);
            make.left.equalTo(_imgV.superview).offset(30);
        }];
        [_titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titLabel.superview).offset(65);
            make.height.centerY.equalTo(_imgV);
        }];
        [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightIcon.superview).offset(-16);
            make.centerY.height.equalTo(_imgV);
            make.width.offset(10);
        }];
        
    }
    return self;
}


- (UIImageView *)imgV{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV.layer.cornerRadius = 6.0;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
- (UIImageView *)rightIcon{
    if(!_rightIcon){
        _rightIcon = [[UIImageView alloc]init];
        _rightIcon.contentMode = UIViewContentModeScaleAspectFit;
        _rightIcon.image = [UIImage imageNamed:kImgName_rightSkip_Gray];
    }
    return _rightIcon;
}
- (UILabel *)titLabel{
    if(!_titLabel){
        _titLabel = [[UILabel alloc]init];
    }
    return _titLabel;
}




@end

 
