//
//  ImMainChatListViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "ImMainChatListViewController.h"
#import "IMBase.h"
#import "ImChatVc.h"

#import "TUIChatConversationModel.h"
#import "TUIConversationListController_Minimalist.h" //会话列表
#import "TUIContactController_Minimalist.h" //三行 通讯录界面

#import "TUIFriendProfileController_Minimalist.h" //好友信息
#import "TUIFindContactViewController_Minimalist.h"

//
#import "TUIFindContactCellModel_Minimalist.h" //添加好友相关
#import "TUIFriendRequestViewController_Minimalist.h" //添加好友相关
//#import "TUIContactFloatController.h"
#import "TUIFloatViewController.h"

//
#import "ImMainConversationListVc_Minimalist.h"

#import "ChatBaseTools.h"

#import "ChatMainVcUseNoLoginShowView.h"
#import "Socialize-Swift.h"

#import "CreatGroupVc.h"
#import "GroupOfQRvc.h"

#import "TUIBaseChatViewController_Minimalist.h"
#import "TUIGroupChatViewController_Minimalist.h"
#import "TUIC2CChatViewController_Minimalist.h"
#import "IMGoChatOneUserInfoVcTool.h"
@interface ImMainChatListViewController () <TUIConversationListControllerListener,TUIPopViewDelegate>
@property (nonatomic,strong) NSMutableArray *saveAdmainManagerArr;
@property (nonatomic,strong) ChatMainVcUseNoLoginShowView *thisNoLoginShowView;

@property (nonatomic,strong) ImMainConversationListVc_Minimalist *childvc;

@end

@implementation ImMainChatListViewController

#pragma mark === 登录按钮占位视图
- (ChatMainVcUseNoLoginShowView *)thisNoLoginShowView{
    if(!_thisNoLoginShowView){
        _thisNoLoginShowView = [[ChatMainVcUseNoLoginShowView alloc]init];
        [_thisNoLoginShowView.showLoginBtn addTarget:self action:@selector(showLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thisNoLoginShowView;
}
- (void)showLoginAction{
    DLog(@" 显 ");
//    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowOrHidden, @(0));//0822 只有收到显示隐藏才发这个 不然只发登录notice
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(NociceName_WindowSubBaoHUOWebView_ShowAndNeedSendSigWithDoLoginAction, @"去登录");
}

#pragma mark === 获取客服im arr
- (NSMutableArray *)saveAdmainManagerArr{
    if(!_saveAdmainManagerArr){
        _saveAdmainManagerArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveAdmainManagerArr;
}

#pragma mark === nav items
#define  kTheme_Type_Key   @"Theme_Type"
- (void)initRightItems{
    
    NSLog(@"nav ting  %@" ,self.navigationController.navigationBar.tintColor);
    UIImage *rightImg;
    if( [[ShareLocale shared].nowThemeStr isEqualToString:kTheme_Type_Key]){
        rightImg = [[UIImage imageNamed:@"通讯录"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else{
        rightImg = [[UIImage imageNamed:@"通讯录"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];// 始终根据Tint Color绘制图片，忽略图片的颜色信息。
     }
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:rightImg  forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.widthAnchor constraintEqualToConstant:24].active = YES;
    [rightButton.heightAnchor constraintEqualToConstant:24].active = YES;
    UIBarButtonItem *rbtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItems:@[rbtnItem] animated:YES];
   
}
//旧版加好友
- (void)addFriendAction{
    DLog(@"");
    [self addToContacts];
}

//搜索框 点击事件0605
- (void)searchTopBtnAction{
    DLog(@"搜索框 点击事件0605");
    [self addToContacts];
}
#pragma mark === addToContacts
//弹出搜索界面可以加好友
- (void)addToContacts {
    TUIFindContactViewController_Minimalist *add = [[TUIFindContactViewController_Minimalist alloc] init];
    add.type = TUIFindContactTypeC2C_Minimalist;
    @weakify(self)
    add.onSelect = ^(TUIFindContactCellModel_Minimalist * cellModel) {
        @strongify(self)
        [self dismissViewControllerAnimated:NO completion:^{
            TUIFriendRequestViewController_Minimalist *frc = [[TUIFriendRequestViewController_Minimalist alloc] init];
            frc.profile = cellModel.userInfo;
            
            TUIFloatViewController *bfloatVC = [[TUIFloatViewController alloc] init];
            [bfloatVC appendChildViewController:(id)frc topMargin:kScale390(87.5)];
            [bfloatVC.topGestureView setTitleText:TIMCommonLocalizableString(Info) subTitleText:@"" leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:@""];
            bfloatVC.topGestureView.rightButton.hidden = YES;
            bfloatVC.topGestureView.subTitleLabel.hidden = YES;
            bfloatVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:bfloatVC animated:YES completion:nil];
            bfloatVC.topGestureView.leftButtonClickCallback = ^{
                [self dismissViewControllerAnimated:YES completion:^{}];
            };
        }];

    };
    TUIFloatViewController *floatVC = [[TUIFloatViewController alloc] init];
    [floatVC appendChildViewController:(id)add topMargin:kScale390(87.5)];
    [floatVC.topGestureView setTitleText:TIMCommonLocalizableString(TUIKitAddFriend) subTitleText:@"" leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:@""];
    floatVC.topGestureView.rightButton.hidden = YES;
    floatVC.topGestureView.subTitleLabel.hidden = YES;
    floatVC.topGestureView.leftButtonClickCallback = ^{
        [self dismissViewControllerAnimated:YES completion:^{}];
    };
    floatVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:floatVC animated:YES completion:nil];
}
//加群 创建新群拉人
- (void)groupInfoAddA{
    DLog(@"");
    CreatGroupVc *vc = [[CreatGroupVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = Y_LocaleTypeFile_NSLocalString(@"创建群聊");
    
    [self pushVc:vc];

}
//扫码
- (void)scanAction{
    [self sacnQRGetInfoAction];
}
//通讯录
- (void)goTongXunLuListAction{
    //多功能

    DLog(@"");
    TUIContactController_Minimalist *vc = [[TUIContactController_Minimalist alloc] init];
    vc.haveSearchBool = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.title = Y_LocaleTypeFile_NSLocalString(@"通讯录");
    [self pushVc:vc];
    
}
- (void)rightItemAction:(UIButton *)barButItem{
    NSMutableArray *menus = [NSMutableArray array];
    
    TUIPopCellData *group = [[TUIPopCellData alloc] init];
    group.image = [UIImage imageNamed:@"创建群聊"];
    group.title =Y_LocaleTypeFile_NSLocalString(@"创建群聊");
    
    [menus addObject:group];
    

    TUIPopCellData *tongxunlu = [[TUIPopCellData alloc] init];
    tongxunlu.image = [UIImage imageNamed:@"通讯录"];
    tongxunlu.title = Y_LocaleTypeFile_NSLocalString(@"通讯录");
    
    [menus addObject:tongxunlu];

    TUIPopCellData *scan = [[TUIPopCellData alloc] init];
    scan.image = [UIImage imageNamed:@"扫一扫"];
    scan.title = Y_LocaleTypeFile_NSLocalString(@"扫一扫");
    
    [menus addObject:scan];
    
    CGFloat height = [TUIPopCell getHeight] * menus.count + TUIPopView_Arrow_Size.height;
    CGFloat orginY = StatusBar_Height + NavBar_Height;
    TUIPopView *popView = [[TUIPopView alloc] initWithFrame:CGRectMake(Screen_Width - 140, orginY, 130, height)];
    
    // rightItemAction countView nil
    CGRect frameInNaviView = [self.navigationController.view convertRect:barButItem.frame fromView:barButItem.superview];
    popView.arrowPoint = CGPointMake(frameInNaviView.origin.x + frameInNaviView.size.width * 0.5, orginY);
    popView.delegate = self;
    [popView setData:menus];
    [popView showInWindow:self.view.window];
}
- (void)popView:(TUIPopView *)popView didSelectRowAtIndex:(NSInteger)index{
    switch (index) {
        case 0://@"创群"
        {
            [self groupInfoAddA];
        }
            break;
            
        case 1://@"通讯录"
        {
            [self goTongXunLuListAction];
        }
            break;

        case 2://@"扫一扫"
        {
            [self scanAction];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ============================================================ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainVcViews];
    [self addNotices];
    [self checkCreatOrCantCreate];
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
}

- (void)addNotices{
    Y_NSNotificationCenter_Creat_NameAction(kNotice_Name_ChatMainListDataReload, doChatMainListDataReload);
    Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, changeZhuTi);//changeZhuTi 语言切换通知可用于黑白色主题切换
    [self addChatGoOnePersonInfoVcNotice];

}
 
- (void)changeZhuTi{
    [self viewWillAppear:YES];
    [self setTheme];

}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(kNotice_Name_ChatMainListDataReload)
}
- (void)doChatMainListDataReload{
    DLog(@"更新语言时 刷新列表 系统消息符合规则的部分可能会有语言展示变动 未登录状态 按钮语言更换");
    [self.thisNoLoginShowView.showLoginBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"Login")];
    if(isNil(self.childvc.tableView)){
        return;
    }
    
    [self.childvc.tableView reloadData];
    
}

#pragma mark ===== 本跳转原本跳转vc是IMChatVc 当前暂用主页0823
#define ChatGoOnePersonInfoVcNotice    @"ChatGoOnePersonInfoVcNotice"

- (void)addChatGoOnePersonInfoVcNotice{
   
    Y_NSNotificationCenter_Creat_NameAction(ChatGoOnePersonInfoVcNotice, goOnePersonInfoVcWithNotice:)
    NSLog(@"addVoiceAndLiveNotice --- %@",[NSThread currentThread]);
}


- (void)goOnePersonInfoVcWithNotice:(NSNotification *)notice{

    NSLog(@" goOnePersonInfoVcWithNotice %@ ",notice);
    NSLog(@" goOnePersonInfoVcWithNotice object %@ ",notice.object);//block
    NSLog(@" goOnePersonInfoVcWithNotice userInfo %@ ",notice.userInfo);//parm
    
    NSArray *arrInfo = [NSArray arrayWithArray: notice.object];//用的obj
    
    //0807更换成web
    /**
     ImOneUserInfoViewController *vc = [[ImOneUserInfoViewController alloc]init];
     if(arrInfo.count == 3){
         vc.friendId = arrInfo.firstObject;
         vc.headerImgstr = arrInfo.lastObject;
         vc.addressShowStr = arrInfo[1];
     }
     [self.navigationController pushViewController:vc animated:YES];
     */
    
    [IMGoChatOneUserInfoVcTool gotoImOneUserInfoViewControllerWithUserImId:arrInfo.firstObject withOtherInfo:arrInfo withusePushVc: self];
    
   
}
#pragma mark =====
#pragma mark === login btn ui

- (void)initMainVcViews{
    [self.view addSubview:self.thisNoLoginShowView];
    [_thisNoLoginShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_thisNoLoginShowView.superview);
        make.top.equalTo(_thisNoLoginShowView.superview).offset(144+KNavBarHeight);//_headerView.frame.size.height
    }];
    [self checkUIOfLoginInfo];
    [self setTheme];
}
- (void)setTheme{
   
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }
}
#pragma mark === check ui
- (void)checkUIOfLoginInfo{
    DLog(@"");
    if([ShareUserInfo share].userInfo.address.length > 0 ){
        self.thisNoLoginShowView.hidden = YES;
        [self initRightItems];
        [self checkNowInfoDoLoginTengXun];//  if([ShareUserInfo share].userInfo.address.length > 0 ){登录各个账号

    }else{
        self.thisNoLoginShowView.hidden = NO;
    }
}
#pragma mark === chat LLLogin 和 chat systemGroup
- (void)checkNowInfoDoLoginTengXun{

    if( [V2TIMManager sharedInstance].getLoginStatus == V2TIM_STATUS_LOGINED ||  [V2TIMManager sharedInstance].getLoginStatus == V2TIM_STATUS_LOGINING){//已登录
        NSLog(@"checkNowInfoDoLoginTengXun  登录或正砸登录");
    }else if(  [V2TIMManager sharedInstance].getLoginStatus ==  V2TIM_STATUS_LOGOUT ){//无登录
        NSLog(@"checkNowInfoDoLoginTengXun  没在登录");
        [self chatLoginActions]; //未登录状态才获取登录相关东西 处理登录的UI界面
    }
     
}
- (void)chatLoginActions{
    DLog(@"");
    if([ShareUserInfo share].userInfo.imId.length <= 0 ){
        return;
    }
    WEAKSELF
    [IMBase imLoginInfoUserID:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
                      userSig:([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"")
                   withBlockk:^(BOOL loginStue) {
       
       if(loginStue){
           BOOL haveChatMainViewBool = NO;
           for ( UIView *subv in self.view.subviews) {
               if(subv.tag == 8888){
                   haveChatMainViewBool = YES;
               }
           }
           if(haveChatMainViewBool){//8888 tag
               NSLog(@"chat view 有containsObject聊天主列表view  无需继续作initChatView");
           }else{
               NSLog(@"chat view 没有containsObject聊天主列表view 可能还没登上去 直接加载试一试看看 initChatView");
               [weakSelf initChatView];
           }
       }else{
//           Y_SVP_SHOW_ERR_MES(@"登录失败 ")
           NSLog(@"失败 --- 腾讯登录")
       }
   }];
   [ChatBaseTools getGroupAdmainManagerWithBlock:^(NSArray * _Nullable listArrOfBlock, BOOL succes) {
       if(succes){
           weakSelf.saveAdmainManagerArr = [[NSMutableArray alloc]initWithArray:listArrOfBlock];
           dispatch_async(dispatch_get_main_queue(), ^{
               Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_ChatAdmainMemberArrInfo, weakSelf.saveAdmainManagerArr);
           });
           
       }else{
           NSLog(@"获取客服imidss失败");
           
       }
   }];
}
#pragma mark ===== viewWillAppear  nav 和 check ui
- (UIColor *)navBackColor {
//    return [UIColor clearColor];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
//        UIColor * beginColor =  rgba(216, 251, 235, 1);//取中间值变成不透明的和ZhiBoTopTypeChooseView同色不透明
        UIColor * beginColor = JianBian_Blue_Color;//浅蓝
        return beginColor;
    }else{
       // return Color_51BlackColor;;
        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
    }
}

 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [OtherNetWorkTools getShenHeInfoWithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
    }];
    
    [self setTheme];
    
    self.title = Y_LocaleTypeFile_NSLocalString(@"聊天");
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [self setup_NavigationBar_TransparentBk_blackText];
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    }else{
        [self setup_NavigationBar_TransparentBk_whiteText];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    }
    
    
    [self checkUIOfLoginInfo];

    if(isNil(self.childvc.view)){
        NSLog(@"chat 没有聊天主列表view 可能还没登上去 登上后会加载 initChatView");
    }else{
        BOOL haveChatMainViewBool = NO;
        for ( UIView *subv in self.view.subviews) {
            if(subv.tag == 8888){
                haveChatMainViewBool = YES;
            }
        }
        if(haveChatMainViewBool){//8888 tag
            NSLog(@"chat view 有containsObject聊天主列表view  无需继续作initChatView");
        }else{
            NSLog(@"chat view 没有containsObject聊天主列表view 可能还没登上去 直接加载试一试看看 initChatView");
            [self initChatView];
        }
    }
   
    
//    [self navigationBarWhiteStyleWithColorChanged:self.color]

    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [self setup_NavigationBar_TransparentBk_blackText];
    }else{
        [self setup_NavigationBar_TransparentBk_whiteText];
    }
    
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  [self navBackColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        
        navigationBar.shadowImage = [UIImage new];
        
        
        UIColor *attDicUseColor;
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            attDicUseColor  = Color_51BlackColor;
        }else{
            attDicUseColor = [UIColor whiteColor];
        }
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0f],
            NSForegroundColorAttributeName:attDicUseColor};
        
        
        navigationBar.titleTextAttributes = attDic;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= appearance;
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        }else{
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        }
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        }else{
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        }
        navigationBar.shadowImage = [UIImage new];
        [[UINavigationBar appearance] setTranslucent:NO];
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        }else{
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        }
    }
//    [self setupNavigationBarTransparentStyle];
//    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
//
//        [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor whiteColor]];
//    }else{
//        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_51BlackColor];
//
//    }
//    UINavigationBar *navBarAppearance = [UINavigationBar appearance];
//    [navBarAppearance setTintColor:[UIColor greenColor]];
//    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: U]
    //通知全部需要管理圆list的
    dispatch_async(dispatch_get_main_queue(), ^{
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_ChatAdmainMemberArrInfo, self.saveAdmainManagerArr);
    });
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }

    //颜色问题用labl
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textColor = TIMCommonDynamicColor(@"nav_title_text_color", @"#000000");
    [titleLabel sizeToFit];
    titleLabel.text = self.title;
    self.navigationItem.titleView = titleLabel;
    
    //刷新cell颜色
    [self.childvc.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];//0824暂时不给nav颜色处理 只处理成非隐藏

 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    /**
     for (UIViewController * vc in self.navigationController.viewControllers) {
         if ([vc isKindOfClass:NSClassFromString(@"CreatGroupVc")] || [vc isKindOfClass:NSClassFromString(@"CreatGroupVc")]) {
             
             if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
                 [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex: Theme_Nav_COlOR_Light_Str]];
             }else{
                 [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
             }
         }
     }
     */
 
    //子页的nav
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex: Theme_Nav_COlOR_Light_Str]];
    }else{
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
    }
    

}
 
#pragma mark =====  chat Main UIs
- (void)initChatView{
    //游客无需chatlistview
    if([ShareUserInfo share].userInfo.imId.length <= 0 ){
        return;
    }
    
    //会话list
    ImMainConversationListVc_Minimalist* childvc = [[ImMainConversationListVc_Minimalist alloc]init];
    self.childvc = childvc;
    
    self.childvc.delegate = self;
    [self.childvc.searchTopBtn addTarget:self action:@selector(searchTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addChildViewController:self.childvc];
    //
    self.childvc.view.tag = 8888;
    [self.view addSubview:self.childvc.view];
    DLog(@"self.childvc  ----- %@",self.childvc );
    DLog(@"self.childvc view  ----- %@",self.childvc.view );
}

//pushToChatViewController:userID: 推送信息的点击跳转事件
- (void)pushToChatViewController:(NSString *)groupID userID:(NSString *)userID{
    TUIConversationCellData *conversation = [[TUIConversationCellData alloc]init];
    conversation.groupID = groupID;
    conversation.userID = userID;
    [self conversationListController:self didSelectConversation:conversation];
}
#pragma mark ==== 点击后触发的协议相关

/**
 *  在会话列表中，获取会话展示信息时候回调。
 */
//- (NSString *)getConversationDisplayString:(V2TIMConversation *)conversation{
//
//}
/**
 *  在会话列表中，点击了具体某一会话后的回调。
 *  您可以通过该回调响应用户的点击操作，跳转到该会话对应的聊天界面。
 */

#define  kFreeper_Message_ID   @"Freeper_Message"
#define  kFreeper_Notification_ID   @"Freeper_Notification"
#define  kFreeper_C2C_Freeper       @"c2c_Freeper" //0828判断条件处理

- (void)conversationListController:(UIViewController *)conversationController didSelectConversation:(TUIConversationCellData *)conversation{
    DLog()

 
    TUIChatConversationModel *data = [[TUIChatConversationModel alloc] init];
    data.userID = conversation.userID;
    data.groupID = conversation.groupID;
    
    //c2c_Freeper 
    if([data.userID isEqualToString:kFreeper_Message_ID]  || [data.userID isEqualToString:kFreeper_Notification_ID]
       || [[NSString stringWithFormat:@"%@",data.conversationID] containsString:kFreeper_C2C_Freeper] ){
        //系统消息列表
        ChatWithSystemInfoListVc_S *vc  = [[ChatWithSystemInfoListVc_S alloc] init];
        vc.conversation = conversation;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else {
        TUIChatConversationModel *conversationModel = [TUIChatConversationModel new];
        conversationModel.title = conversation.title;
        conversationModel.userID = conversation.userID;
        conversationModel.groupID = conversation.groupID;
        conversationModel.conversationID = conversation.conversationID;
        conversationModel.avatarImage = conversation.avatarImage;
        conversationModel.faceUrl = conversation.faceUrl;
 
        TUIBaseChatViewController_Minimalist *chatVC = nil;
        if (conversationModel.groupID.length > 0) {
            chatVC = [[TUIGroupChatViewController_Minimalist alloc] init];
        } else if (conversationModel.userID.length > 0) {
            chatVC = [[ TUIC2CChatViewController_Minimalist alloc] init];
        }
        chatVC.conversationData = conversationModel;
        chatVC.title = conversationModel.title;
//        chatVC.highlightKeyword = highlightKeyword;
//        chatVC.locateMessage = locateMessage;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self dealNavWithVcNotHid:chatVC];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
    /** 弃用 ImChatVc
     {
         data.groupID = conversation.groupID;
         data.title = conversation.title;
         data.conversationID = conversation.conversationID;
         
         ImChatVc *vc = [[ImChatVc alloc]init];
         vc.converInfo  = data;
         vc.isGroupType = data.groupID.length>0 ? YES :NO;
         vc.groupId = data.groupID;
         vc.friendId = data.userID;
         vc.title = data.title;
         vc.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:vc animated:YES];
     }
     */
   
    
  

}

- (void)dealNavWithVcNotHid:(UIViewController *)vc{
    
    [vc.navigationController setNavigationBarHidden:NO animated:YES];
    [vc.navigationController.navigationBar setTranslucent:NO];

}

/**
 *  清空所有会话未读数回调。
 */
- (void)onClearAllConversationUnreadCount{
    
}

/**
 *  会话列表多选面板关闭。
 */
- (void)onCloseConversationMultiChooseBoard{
    
}


#pragma mark ==== 其他初始数据

- (void)initWithCanOrCantCreatZhiBoInfo{
    [self checkCreatOrCantCreate];
}

//验证用户是否已经发行过圈 如果有域名 那么肯定发过粉友
- (void)checkCreatOrCantCreate{
    //加载时间花费 需要在点击之前有结果
    //按钮显示隐藏 在结果出来时更改好了
    if(isNil([ShareUserInfo share].userInfo)){
        [ShareUserInfo share].userInfo = [[UserModel alloc]init];
    }
    //
    if([ShareUserInfo share].userInfo.useDomain.length>0){
        [ShareUserInfo share].canCreatZhiboBool = YES;//已经发过粉友了
        return;
    }
    if([ShareUserInfo share].canCreatZhiboBool){//已经发过粉友了
        return; //已经发过粉友了
    }else{
        if([ShareUserInfo share].userInfo.address.length >0 && [ShareUserInfo share].userInfo.token.length >0 && [ShareUserInfo share].userInfo.imSignature.length >0){
            [LoginUseModel checkVerifySignaturewithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
                if(succes){
                    if([[dicOfBlock allKeys] containsObject:@"nftDomainGroupList"]){
                        NSArray *nftDomainGroupListArr = [[NSArray alloc]initWithArray:[dicOfBlock objectForKey:@"nftDomainGroupList"]];
                        //验证用户是否已经发行过圈子  //其他情况下 校验另一个接口 如登陆时未发行圈子，发行之后再去创建直播页面
                        if(nftDomainGroupListArr.count>0){
                            [ShareUserInfo share].canCreatZhiboBool = YES;//已经发过粉友了
                            if([ShareUserInfo share].userInfo.saveMydomain.length<=0){
                                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary: [nftDomainGroupListArr firstObject]];
                                if([[dataDic allKeys] containsObject:@"domain"]){
                                    NSString *domainS =   [dataDic objectForKey:@"domain"];
                                    [ShareUserInfo share].userInfo.saveMydomain = domainS;//保存域名
                                }
                            }
                        }else{
                            if([ShareUserInfo share].userInfo.useDomain.length>0){
                                [ShareUserInfo share].canCreatZhiboBool = YES;
                            }else{
                                [ShareUserInfo share].canCreatZhiboBool = NO;
                            }
                            
                        }
                    }
                }
            }];
        }
    }

    
}




#pragma mark===
//聊天的右上角调起扫码
- (void)sacnQRGetInfoAction{
    [self sacnQRGetInfoDic:@{}];
}
#pragma mark ====
- (void)sacnQRGetInfoDic:(NSDictionary *)bodyDic{
    NSLog(@"调起扫二维码功能 sacnQRGetInfoDic  : %@",bodyDic);
    WEAKSELF
    STRONGSELF
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    XCQRCodeVC *VC = [[XCQRCodeVC alloc] init];
                    VC.hidesBottomBarWhenPushed = YES;
                    VC.modalPresentationStyle = UIModalPresentationFullScreen;
                    VC.resBlock = ^(NSString * _Nullable rStr) {
                        NSLog(@" resBlock 得到的结果是： %@",rStr);
                        [strongSelf dealQRresStrInfoWithDataDic:bodyDic andResStr:rStr];
                    };
                    if(isNotNil(self.navigationController)){
                        VC.isPushType = YES;
                        [self.navigationController pushViewController:VC animated:YES];
                        NSLog(@"二维码 扫码 跳转 push");
                    }else{
                        VC.isPushType = NO;
                        [self presentViewController:VC animated:YES completion:^{
                            NSLog(@"二维码 扫码 跳转 presen");
                        }];
                    }
                    
                    
                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            XCQRCodeVC *VC = [[XCQRCodeVC alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            VC.resBlock = ^(NSString * _Nullable rStr) {
                NSLog(@" resBlock 得到的结果是： %@",rStr);
                [strongSelf dealQRresStrInfoWithDataDic:bodyDic andResStr:rStr];
            };
            if(isNotNil(self.navigationController)){
                VC.isPushType = YES;
                VC.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController pushViewController:VC animated:YES];
                NSLog(@"二维码 扫码 跳转 push");
            }else{
                VC.isPushType = NO;
                VC.modalPresentationStyle = UIModalPresentationFormSheet;//占据屏幕中间的一小块（比较常用）
                [self presentViewController:VC animated:YES completion:^{
                    NSLog(@"二维码 扫码 跳转 presen");
                }];
            }
        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [self failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [self unknown];
        }
        
    }];
    
    
}
#pragma mark ====
#define Notice_Name_GotoImOneUserInfoVc  @"Notice_Name_GotoImOneUserInfoVc"
#define Notice_Name_AddOnePersion        @"Notice_Name_AddOnePersion"
#define Notice_Name_ChatGroupQR_ScanActionTool                          @"Notice_Name_ChatGroupQR_ScanActionTool"//群 扫码后 直接进群 或者 申请加群相关


//二维码的扫描结果相关处理和发送数据给web
- (void)dealQRresStrInfoWithDataDic:(NSDictionary *)bodyDic andResStr:(NSString *)resStr{

    //处理info
    WebViewUseDataModel *mainDataModel = [WebViewUseDataModel mj_objectWithKeyValues:bodyDic];
    NSDictionary *resStrDic = [Y_ToolOfOthers dictionaryWithJsonString:resStr];
    //----聊天扫用户imID码
    if( ([[resStrDic allKeys] containsObject:@"imId"] || [[resStrDic allKeys] containsObject:@"groupId"]) && [[resStrDic allKeys] containsObject:@"type"] ){
        NSInteger resTypeNum = [[resStrDic objectForKey:@"type"]  intValue];
        if(resTypeNum == 2000){
            NSString *imId = [NSString stringWithFormat:@"%@",[resStrDic objectForKey:@"imId"]];
            if(imId.length<=0){
                return;
            }
            //延时 等二维码回来后 再通知跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_AddOnePersion, imId);//添加好友 而不是个人中心页
            });
            return;
        }else if(resTypeNum == 2001){
            NSString *groupId = [NSString stringWithFormat:@"%@",[resStrDic objectForKey:@"groupId"]];
            if(groupId.length<=0){
                return;
            }
            //延时 等二维码回来后 再通知跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *garr = @[groupId,self];
                Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_ChatGroupQR_ScanActionTool, garr);//扫码后 加群
            });
            return;
        }
    }else{
        NSLog(@" %@",resStr);
    }

}

#pragma mark ==== 扫描时可能调用的权限相关alert
- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}

- (void)unknown {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}


@end
