//
//  MainBaseViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/27.
//

#import "MainBaseViewController.h"
#import "ChatSeverConnectionBegin.h"//chatwebsocket
@interface MainBaseViewController ()

@end

@implementation MainBaseViewController

//chatwebsocket
- (void)chatSeverConnectionBeginGetNeedInfoAndFirstOpenSocketAction{
    [[ChatSeverConnectionBegin share]initChatWithSocketNeedInfoAndOpenSocket];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNoticeThemeIsChange];
    [self initNoticeChangeHouseWithChangeCommnityIdToRefreshMainVcInfo];
  
}
 

- (MainTableViewHeaderView *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[MainTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, mainTableViewCell_Height_HeaderViewView)];
    }
    return _tableViewHeaderView;
}
- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImgView;
}

#pragma mark ==
- (NSMutableArray *)headerViewRightTextArr{
    if (!_headerViewRightTextArr) {
        _headerViewRightTextArr = [NSMutableArray arrayWithObjects:@"",@"便民服务",@"养老医疗",@"推荐服务",@"社区通讯录",@"实惠生活",@"社区趣事", nil];
    }
    return _headerViewRightTextArr;
}
#pragma mark === data
- (NSMutableArray *)topSourceArr{
    if (!_topSourceArr) {
        _topSourceArr = [[NSMutableArray alloc]init];
    }
    return _topSourceArr;
}
- (NSMutableArray *)topImgUrlArr{
    if (!_topImgUrlArr) {
        _topImgUrlArr = [[NSMutableArray alloc]init];
    }
    return _topImgUrlArr;
}
- (NSMutableArray *)topImgTitleArr{
    if (!_topImgTitleArr) {
        _topImgTitleArr = [[NSMutableArray alloc]init];
    }
    return _topImgTitleArr;
}

- (NSMutableArray *)centerMenuSourceArr{
    if (!_centerMenuSourceArr) {
        _centerMenuSourceArr = [[NSMutableArray alloc]init];
    }
    return _centerMenuSourceArr;
}
- (NSMutableArray *)centerOneImgArr{
    if (!_centerOneImgArr) {
        _centerOneImgArr = [[NSMutableArray alloc]init];
    }
    return _centerOneImgArr;
}
- (NSMutableArray *)centerOneTitleArr{
    if (!_centerOneTitleArr) {
        _centerOneTitleArr = [[NSMutableArray alloc]init];
    }
    return _centerOneTitleArr;
}

- (NSMutableArray *)centeradvertScrollviewSourceArr{
    if (!_centeradvertScrollviewSourceArr) {
        _centeradvertScrollviewSourceArr = [[NSMutableArray alloc]init];
    }
    return _centeradvertScrollviewSourceArr;
}
- (NSMutableArray *)centerAddressBookSourceArr{
    if (!_centerAddressBookSourceArr) {
        _centerAddressBookSourceArr = [[NSMutableArray alloc]init];
    }
    return _centerAddressBookSourceArr;
}
- (NSMutableArray *)centerShoppingSourceArr{
    if (!_centerShoppingSourceArr) {
        _centerShoppingSourceArr = [[NSMutableArray alloc]init];
    }
    return _centerShoppingSourceArr;
}
- (NSMutableArray *)shoppingScrollViewArr{
    if (!_shoppingScrollViewArr) {
        _shoppingScrollViewArr = [[NSMutableArray alloc]init];
    }
    return _shoppingScrollViewArr;
}
- (NSMutableArray *)bottomNewsSourceArr{
    if (!_bottomNewsSourceArr) {
        _bottomNewsSourceArr = [[NSMutableArray alloc]init];
    }
    return _bottomNewsSourceArr;
}
- (NSInteger)bottomNewsPageNum{
    if (!_bottomNewsPageNum) {
        _bottomNewsPageNum = 1;
    }
    return _bottomNewsPageNum;
}
- (NSInteger)bottomShengHuoGuangChangPageNum{
    if (!_bottomShengHuoGuangChangPageNum) {
        _bottomShengHuoGuangChangPageNum = 1;
    }
    return _bottomShengHuoGuangChangPageNum; 
}
//07后数据增
- (NSMutableArray *)zuFangArr{
    if (!_zuFangArr) {
        _zuFangArr = [[NSMutableArray alloc]init];
    }
    return _zuFangArr;
}
- (NSMutableArray *)erShouArr{
    if (!_erShouArr) {
        _erShouArr = [[NSMutableArray alloc]init];
    }
    return _erShouArr;
}


- (PopViewAddressBookDetaillPhoneList *)popViewPhoneBookList{//非getter
    _popViewPhoneBookList = [[PopViewAddressBookDetaillPhoneList alloc]init];
    _popViewPhoneBookList.delegate = self;
    _popViewPhoneBookList.tag = TAG_PopTableView_PhoneList;
    return _popViewPhoneBookList;
}
- (NSMutableArray *)popViewPhoneDetailListDataSource{
    if (!_popViewPhoneDetailListDataSource) {
        _popViewPhoneDetailListDataSource = [[NSMutableArray alloc]init];
    }
    return _popViewPhoneDetailListDataSource;
}

//天气
- (NSDictionary *)wearherMainDic{
    if (!_wearherMainDic) {
        _wearherMainDic = [[NSDictionary alloc]init];
    }
    return _wearherMainDic;
}
- (NSMutableArray *)wearherRightArr{
    if (!_wearherRightArr) {
        _wearherRightArr = [[NSMutableArray alloc]init];
    }
    return _wearherRightArr;
}
//
- (NSMutableArray *)recommendedServiceNewsListArr{
    if (!_recommendedServiceNewsListArr) {
        _recommendedServiceNewsListArr = [[NSMutableArray alloc]init];
    }
    return _recommendedServiceNewsListArr;
}
//未实名认证
- (PopViewWithGoToRealCertification *)popViewGotoCertification{
    _popViewGotoCertification = [[PopViewWithGoToRealCertification alloc]init];
    _popViewGotoCertification.delegate = self;
    return _popViewGotoCertification;
}
//未实名认证
- (void)popViewGotoRealCertification{
}

//
//更多服务逐步开发提示PopViewWithMoreServiceWillBeOpeningUp
- (PopViewWithMoreServiceWillBeOpeningUp *)popViewMoreServiceWillOpening{
    _popViewMoreServiceWillOpening = [[PopViewWithMoreServiceWillBeOpeningUp alloc]init];
     return _popViewMoreServiceWillOpening;
}
 
//右下角 按钮 //rightbtn弹出的
-  (PopViewWithOtherFunction *)popViewWithOtherFunction{
    _popViewWithOtherFunction = [[PopViewWithOtherFunction alloc]init];
    _popViewWithOtherFunction.delegate = self;
    return _popViewWithOtherFunction;
}
//右下角 按钮 UI
- (UIButton *)mainVcBottomRightBtn{
    if (!_mainVcBottomRightBtn) {
        _mainVcBottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainVcBottomRightBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Floatingwindow"] selectedImg:[UIImage imageNamed:@"FloatingwindowSelected"]];
        [_mainVcBottomRightBtn addTarget:self action:@selector(mainVcBottomRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainVcBottomRightBtn;
}
- (void)initMianBottomRightBtnView{
    [self.view addSubview:self.mainVcBottomRightBtn];
    [_mainVcBottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(44);
        make.right.equalTo(_mainVcBottomRightBtn.superview).offset(-16);
        make.bottom.equalTo(_mainVcBottomRightBtn.superview).offset(-KTabBarHeight-20);
    }];
}
//右下角 按钮 ACTION
- (void)mainVcBottomRightBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected==YES) {//弹出
        [self.popViewWithOtherFunction showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy]; 
    }else{//关闭
        [self.popViewWithOtherFunction dismissThePopView];
    }
}
//社区切换
- (PopViewWithChangeCommunity *)popViewWithChangeCommunity{
    _popViewWithChangeCommunity = [[PopViewWithChangeCommunity alloc]init];
    _popViewWithChangeCommunity.delegate = self;
    return _popViewWithChangeCommunity;
}
#pragma mark== 服务热线
- (void)showHouLinePopV{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"服务热线" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.backgroundColor = [UIColor whiteColor];
    alertController.view.layer.cornerRadius = 5;
    alertController.view.layer.masksToBounds = YES;
    alertController.view.bounds = CGRectMake(0, 0, alertController.view.bounds.size.width, 280);
    //
    UIView *alertBackView = [[UIView alloc] init];//back
    alertBackView.backgroundColor = [alertController.view.backgroundColor colorWithAlphaComponent:0.8];
    UILabel *alertNameL = [[UILabel alloc]init];
    alertNameL.textColor = [UIColor blackColor];
    alertNameL.font = [UIFont boldSystemFontOfSize:20];
    alertNameL.textAlignment = NSTextAlignmentCenter;
    alertNameL.text = Hot_Photos;
    [alertBackView addSubview:alertNameL];
    //
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [callBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
    [callBtn newAnBtnWithTextStr:@"立即拨打"];
    [callBtn newAnBtnWithBackColor:Color_38BlueColor];
    [callBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:Color_38BlueColor];
    [callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertBackView addSubview:callBtn];
    //
    [alertNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.superview).offset(10);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(alertNameL.superview).offset(-10);
        make.height.offset(20);
    }];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.mas_bottom).offset(20);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(callBtn.superview.mas_right).offset(-10);
        make.height.offset(40);
    }];
    //
    [alertController.view addSubview:alertBackView];
    [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertBackView.superview).offset(60);
        make.left.equalTo(alertBackView.superview).offset(0);
        make.right.equalTo(alertBackView.superview).offset(0);
        make.height.offset(100);
    }];
    //占位
    UIAlertAction *centerZanWeiOneAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *centerZanWeiTwoAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];

    //
    UIAlertAction *bottomKnowAlertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:centerZanWeiOneAlertAction];
    [alertController addAction:centerZanWeiTwoAlertAction];
    [alertController addAction:bottomKnowAlertAction];
    //
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callBtnAction:(UIButton *)sender{
    NSString *phoneStr = sender.titleLabel.text;
    [self callPhoneWithStr:phoneStr];
}

- (void)callPhoneWithStr:(NSString *)phoneStr{
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
    
}
#pragma mark === 基础方法
- (void)pushVc:(id)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - navigationBar主题色
- (void)setupNavigationBarStyleWithThemeColor {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    self.navigationItem.rightBarButtonItem.tintColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ZYThemeManager shareManager].navigationItemThemeColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ZYThemeManager shareManager].navigationItemThemeColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf7f7f9_D001534;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_Lf7f7f9_D001534] forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)setupNavigationBarWhiteStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    };
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor blackColor]
    }];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor whiteColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)setupNavigationBarStyleWithMainColor{  //更改透明为主题色
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].themeColorVCBackViewColor] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setupNavigationBarTransparentStyle {
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setupNavigationBarClearTransparentStyle {
    [self.navigationItem setBackButtonTitle:@""];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor clearColor]};
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = [UIColor clearColor];
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setupNavigationBarBlackStyle {
    NSDictionary *attDic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:MainBackgroundColor]];
    [self.navigationController.navigationBar setBackgroundColor:MainBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:MainBackgroundColor]; 
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.titleTextAttributes = attDic;
        appearance.backgroundColor = MainBackgroundColor;
        //去掉导航栏下的阴影线
        appearance.shadowColor= [UIColor clearColor];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        [self.navigationController.navigationBar setTitleTextAttributes:attDic];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:MainBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
}
#pragma mark == 主题色
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
// }
- (void)initNoticeThemeIsChange{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    DLog(@"themeIsChange");
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
    Y_NSNotificationCenter_RemoveNotice_Name(Notice_ChangeHouseWithChangeCommnityId_ToRefreshMainVcInfo_Name)

}
#pragma mark  == 切换房屋后 小区变了 数据刷新
- (void)initNoticeChangeHouseWithChangeCommnityIdToRefreshMainVcInfo{
    Y_NSNotificationCenter_Creat_NameAction(Notice_ChangeHouseWithChangeCommnityId_ToRefreshMainVcInfo_Name, noticeWithCommnityIdIsChangeToRefreshMainVcInfo)
}
@end

