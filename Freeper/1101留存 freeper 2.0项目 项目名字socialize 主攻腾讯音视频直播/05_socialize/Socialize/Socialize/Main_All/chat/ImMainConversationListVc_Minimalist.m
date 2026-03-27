//
//  ImMainConversationListVc_Minimalist.m
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
//

#import "ImMainConversationListVc_Minimalist.h"
 
//  TUIConversationListController_Minimalist.m
//  TXIMSDK_TUIKit_iOS
 

#import "TUIConversationListController_Minimalist.h"
#import "TUIFoldListViewController_Minimalist.h"
#import "TUIConversationCell_Minimalist.h"
#import "TUIConversationCellData_Minimalist.h"
#import "TUICore.h"
#import "TUIDefine.h"
#import "TUIThemeManager.h"
#import "TUIFloatViewController.h"
#import "ChatBaseTools.h"


#import "JoinSystemGroupSubPopView.h"
#import "ChatAddFriendTool.h"//ChatGroupQRTool
#import "TUIGroupPendencyController.h"
#import "ToolsGetWebsite.h"

static NSString *kConversationCell_Minimalist_ReuseId = @"kConversationCell_Minimalist_ReuseId";
#pragma mark ====

//加入系统群的点击通知
#define ChatNotice_AddSystemGroup_Notice    @"ChatNotice_AddSystemGroup_Notice"

@interface ImMainListTableViewCell_AddSystemGroup ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *topL;
@property (nonatomic,strong) UILabel *bottomL;
@property (nonatomic,strong) UIButton *joinBtn;
@end

@implementation ImMainListTableViewCell_AddSystemGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.topL];
        [self.contentView addSubview:self.bottomL];
        [self.contentView addSubview:self.joinBtn];
        [self setCellUI];
    }
    return self;
}
- (void)setCellUI{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.superview).offset(20);
        make.top.equalTo(_imgView.superview).offset(10);
        make.bottom.equalTo(_imgView.superview).offset(-10);
        make.width.equalTo(_imgView.mas_height);

    }];
    
    [_topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(20);
        make.right.equalTo(_imgView.superview);
        make.top.equalTo(_imgView).offset(-5);
        make.height.offset(20.0);
        
    }];
    
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(20);
        make.right.equalTo(_imgView.superview);
        make.bottom.equalTo(_imgView).offset(5);
        make.height.offset(20.0);
        
    }];
    
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.height.offset(30);
        make.centerY.equalTo(_joinBtn.superview);
        make.right.equalTo(_joinBtn.superview).offset(-10);
    }];
    
}

- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"freeper_Icon_Light"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}
- (UILabel *)topL{
    if(!_topL){
        _topL = [[UILabel alloc]init];
        _topL.text = @"Freeper Chat";
        _topL.font = [UIFont boldSystemFontOfSize:18.0];
        _topL.textColor = [UIColor blackColor];
    }
    return _topL;
}

- (UILabel *)bottomL{
    if(!_bottomL){
        _bottomL = [[UILabel alloc]init];
        _bottomL.text = Y_LocaleTypeFile_NSLocalString(@"欢迎来到Freeper");
        _bottomL.font = [UIFont boldSystemFontOfSize:15.0];
        _bottomL.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    }
    return _bottomL;
}

- (UIButton *)joinBtn{
    if(!_joinBtn){
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn newAnBtnWithBackColor:Color_Socialize_GreenColor];
        [_joinBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_joinBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"加入")];
        [_joinBtn newAnBtnWithLayerCorNerNum:15.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];

        
    }
    return _joinBtn;
}
@end

#pragma mark ====

@interface ImMainListTableViewCell_GroupApplicationUseCell ()

@end

@implementation ImMainListTableViewCell_GroupApplicationUseCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.joinBtn.hidden = YES;
        self.topL.text = Y_LocaleTypeFile_NSLocalString(@"群通知");
        self.bottomL.text = Y_LocaleTypeFile_NSLocalString(@"申请加入");
        self.imgView.image = [UIImage imageNamed:@"群通知"];
        //
        self.topL.font = [UIFont boldSystemFontOfSize:16.0];
        self.bottomL.font = [UIFont boldSystemFontOfSize:14.0];
        self.bottomL.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        self.bottomL.numberOfLines = 2;
        
        
        NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
        if([nowThemeStr isEqualToString: @"light"]){
            self.topL.textColor = [Y_ToolOfOthers getColorWithHexString:@"#515151"];
            self.bottomL.textColor = [Y_ToolOfOthers getColorWithHexString:@"#515151"];
            
        }else{
            self.topL.textColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
            self.bottomL.textColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
        }

    }
    return self;
}
@end

#pragma mark ====
#pragma mark ====


@interface ImMainConversationListVc_Minimalist () <
                                             UIGestureRecognizerDelegate,
                                             UITableViewDelegate,
                                             UITableViewDataSource,
                                             UIPopoverPresentationControllerDelegate,
                                             TUINotificationProtocol,
                                             TUIConversationListDataProviderDelegate,
                                             TUIPopViewDelegate,
                                             JoinSystemGroupSubPopViewDelegate
                                            >

@property (nonatomic, strong) UIBarButtonItem *moreItem;
@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *doneItem;
@property (nonatomic, assign) BOOL showCheckBox;
@property (nonatomic, assign) BOOL isHaveShowTopCellWithAddSystemGroup;//是否显示加入系统群cell
@property (nonatomic, assign) BOOL isHaveShowTopCellWithGroupApplicationList;//是否显示 他人的加群申请 cell
@property (nonatomic, strong) NSMutableArray *getApplicationListArr;//他人的加群申请的arr
@property (nonatomic, strong)V2TIMGroupApplication *saveLasetNoDealGrouAppL;

@property (nonatomic,strong) JoinSystemGroupSubPopView *joinPopView;

@property (nonatomic ,strong) ImMainSearchBar_Minialist *searchBarM;

@property (nonatomic,strong) TUIGroupPendencyDataProvider *pendencyViewModel;

@end

@implementation ImMainConversationListVc_Minimalist


#pragma mark ==
 
- (void)addBkView{
   
   GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
   [self.view addSubview:bgColorView];
   [self.view bringSubviewToFront:self.tableView];//吧tabv 放到最前
   self.tableView.backgroundColor = [UIColor clearColor];
    
}
#pragma mark ==


- (instancetype)init {
    self = [super init];
    if (self) {
        self.isEnableSearch = YES;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    self.getApplicationListArr = [NSMutableArray arrayWithCapacity:0];
    [super viewDidLoad];
    [self setupNavigation];
    [self setupViews];
    [self.dataProvider loadNexPageConversations];
    self.showCheckBox = NO;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onFriendInfoChanged:) name:@"FriendInfoChangedNotification" object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(startCreatGroupNotification:) name:@"kTUIConversationCreatGroupNotification" object:nil];
    
    //0514
    [self addBkView];

}
 

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [TUICore unRegisterEventByObject:self];
}

- (UIColor *)navBackColor {
//    return  [UIColor whiteColor];
    return [UIColor clearColor];;
}

#define Line_ImgV_grrayColor    [UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(Screen_W, 4) cornerRadius:0.5];

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  [self navBackColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
//        navigationBar.shadowImage = [UIImage new];
        navigationBar.shadowImage = Line_ImgV_grrayColor;//[UIImage imageWithColor:[UIColor lightGrayColor]];
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= appearance;
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Line_ImgV_grrayColor;
        [[UINavigationBar appearance] setTranslucent:NO];
    }
//    [self setupNavigationBarTransparentStyle];

    
    //0804 切换时更新搜索语言文本
   self.searchBarM.searchBar.placeholder = TIMCommonLocalizableString(Search);
    //出现时重新获取list处理加群cell
    [self dealHaveShowOtherTableViewTopCells];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //界面展示时 作刷新动作处理cells 第一页数据 pageIndex = 0;
//    [self initDataFistPageList];//暂时不调用
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

 
- (void)initDataFistPageList{
    self.dataProvider.pageIndex = 0;
    [self.dataProvider loadNexPageConversations];
    self.showCheckBox = NO;
}

- (void)dealHaveShowOtherTableViewTopCells{
    //系统群 主动加cell
    self.isHaveShowTopCellWithAddSystemGroup = ![[ShareUserInfo share].userInfo.cogChannelId containsString:@"g"];//是否已经加了群
    NSLog(@"isHaveShowTopCellWithAddSystemGroup 1 %d",[[ShareUserInfo share].userInfo.cogChannelId containsString:@"g"]);
    NSLog(@"isHaveShowTopCellWithAddSystemGroup 2 %d",self.isHaveShowTopCellWithAddSystemGroup);
    NSLog(@"isHaveShowTopCellWithAddSystemGroup 3 %@",[ShareUserInfo share].userInfo.cogChannelId);
    if(self.isHaveShowTopCellWithAddSystemGroup == YES){
        [self.tableView reloadData];
    }
    //群通知 他人加群申请cell
    [self dealHaveGroupApplicationListShow];
}

//加群申请的通知 处理cell--群通知 申请加入 
- (void)dealHaveGroupApplicationListShow{
    //self.isHaveShowTopCellWithGroupApplicationList = NO;//will后不立即变化 拿到值变化后才做刷新 崩溃问题位置
    WEAKSELF
    [ChatGroupQRTool  cheackGroupHaveReqListDataWithBlock:^(NSMutableArray *getAlList, NSInteger noRedCount, BOOL success) {
        if(success){
            if(noRedCount ==0){
                weakSelf.isHaveShowTopCellWithGroupApplicationList = NO;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.getApplicationListArr = getAlList;//   V2TIMGroupApplication;
                [weakSelf initGroupLastApplicUseViewModel];//初始化将要使用的 加群申请数据
            }

        }else{
            weakSelf.isHaveShowTopCellWithGroupApplicationList = NO;
            [weakSelf.tableView reloadData];
        }
    }];
}
- (void)initGroupLastApplicUseViewModel{
    //NSMutableArray *list = @[].mutableCopy;
    //拿到数据 已经同意拒绝的数据 忽略掉 留下剩下未处理的群申请 作griupid 和isHaveShowTopCellWithGroupApplicationList yorn.
    NSString *getLastNoDealApplicationModel_GroupId = @"";
    NSInteger getAppCount = self.getApplicationListArr.count;
    
    for (int i = 0 ; i < getAppCount; i++) {
        V2TIMGroupApplication *lasetNoDealGrouAppL = (V2TIMGroupApplication *)self.getApplicationListArr[getAppCount-i-1];//从后往前拿 展示最新的一条数据
        if(lasetNoDealGrouAppL.handleStatus == V2TIM_GROUP_APPLICATION_HANDLE_STATUS_UNHANDLED){//未处理 可用
            self.isHaveShowTopCellWithGroupApplicationList = YES;
            getLastNoDealApplicationModel_GroupId = lasetNoDealGrouAppL.groupID;//拿到数据后 即可结束循环
            self.saveLasetNoDealGrouAppL = lasetNoDealGrouAppL;
            break;
        }else{//不符合要求的数据略过
        }
    }
    self.pendencyViewModel = [TUIGroupPendencyDataProvider new];
    if(getLastNoDealApplicationModel_GroupId.length<=0){
        self.isHaveShowTopCellWithGroupApplicationList = NO;//都处理过了 则设置为不展示该cell
        self.saveLasetNoDealGrouAppL = [[V2TIMGroupApplication alloc]init];
        [self.tableView reloadData]; //更新cell
        return;
    }else{
        self.isHaveShowTopCellWithGroupApplicationList = YES;
        [self.tableView reloadData]; //更新cell 刷新
    }
    self.pendencyViewModel.groupId = getLastNoDealApplicationModel_GroupId;
    [self.pendencyViewModel loadData];


    
}



- (void)touchCellBtnOfJoinSystemGroupAction{
    
    NSLog(@"  touchCellBtnOfJoinSystemGroupAction   ");
    
    self.joinPopView = [[JoinSystemGroupSubPopView alloc]init];
    self.joinPopView.joinGroupDelegate = self;
    [self.joinPopView showInView:self.view thePopViewSubViewHeight:0.9 WithArray:@[].mutableCopy];
}

//- (void)touchCellBtnOfGroupGroupApplicationList{
//    DLog(@"touchCellBtnOfGroupGroupApplicationList");
//
//
//}
- (void)touchOkOfJoinSystem{
    WEAKSELF
    STRONGSELF
    [ChatBaseTools chatAddSystemGroupWithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            if(isNil(dicOfBlock)){
                return;//空数据
            }
            if([dicOfBlock isKindOfClass:[NSString class]]){
                [ShareUserInfo share].userInfo.cogChannelId = [NSString stringWithFormat:@"%@",dicOfBlock];
                return;
            }
            if([dicOfBlock allKeys].count >0 && [[dicOfBlock allKeys] containsObject:@"channelId"]){
                NSString *groupIDStr =  [NSString stringWithFormat:@"%@",[dicOfBlock objectForKey:@"channelId"]];
                NSLog(@"groupIDStr --- %@",groupIDStr);
                if([groupIDStr containsString:@"g"] || groupIDStr.length > 0){
                    [ShareUserInfo share].userInfo.cogChannelId = groupIDStr;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.tableView reloadData];
                    });
                }else{
                    //数据有误
                }
            }
            
           
        }else{
            [ShareUserInfo share].userInfo.cogChannelId = @"g";
            [self.tableView reloadData];
        }

    }];
}

 


- (void)onFriendInfoChanged:(NSNotification *)notice
{
    V2TIMFriendInfo *friendInfo = notice.object;
    if (friendInfo == nil) {
        return;
    }
    for (TUIConversationCellData *cellData in self.dataProvider.conversationList) {
        if ([cellData.userID isEqualToString:friendInfo.userID]) {
            NSString *title = friendInfo.friendRemark;
            if (title.length == 0) {
                title = friendInfo.userFullInfo.nickName;
            }
            if (title.length == 0) {
                title = friendInfo.userID;
            }
            cellData.title = title;
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)setupNavigation
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:TUIConversationImagePath_Minimalist(@"nav_edit")]
                forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    editButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [editButton setFrame:CGRectMake(0, 0, 18 + 21 * 2, 18)];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:TUIDemoImagePath_Minimalist(@"nav_add")] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [moreButton setFrame:CGRectMake(0, 0, 20, 20)];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:TUIKitLocalizableString(TUIKitDone) forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setFrame:CGRectMake(0, 0, 30, 30)];

    self.editItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    self.doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    self.navigationItem.rightBarButtonItems = @[self.moreItem,self.editItem];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //0515
  
}

 
- (UIView *)createSearchBar{   //.placeholder = TIMCommonLocalizableString(Search);
    self.searchBarM = [[ImMainSearchBar_Minialist alloc] init];
    [ self.searchBarM setParentVC:self];
    [ self.searchBarM setEntrance:YES];
    return self.searchBarM;
}


- (UIButton *)searchTopBtn{
    if(!_searchTopBtn){
        _searchTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchTopBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
        _searchTopBtn.backgroundColor = [Color_Socialize_GreenColor colorWithAlphaComponent:0.01];
    }
    return _searchTopBtn;
}
- (void)setupViews {
     self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.view.bounds;
    if (![UINavigationBar appearance].isTranslucent && [[[UIDevice currentDevice] systemVersion] doubleValue]<15.0) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - TabBar_Height - NavBar_Height );
    }
    _tableView = [[UITableView alloc] initWithFrame:rect];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [_tableView registerClass:[ImMainListTableViewCell_Minimalist class] forCellReuseIdentifier:@"ImMainListTableViewCell_AddSystemGroup"];
    [_tableView registerClass:[ImMainListTableViewCell_Minimalist class] forCellReuseIdentifier:@"ImMainListTableViewCell_Minimalist"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.rowHeight = 64.0;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor lightGrayColor];
    //_tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);//cell60 5
    _tableView.delaysContentTouches = NO;
    
    UIView *searchBar = nil;
    if (self.isEnableSearch) {
        searchBar = [self createSearchBar];
    }

    UIView *willUseHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    willUseHeaderView.backgroundColor = [UIColor clearColor];

    
    //Fix  translucent = NO;
    if (searchBar) {
        [searchBar setFrame: CGRectMake(0, 0, self.view.bounds.size.width, 60)];
        searchBar.backgroundColor = [UIColor clearColor];//0514
        searchBar.superview.backgroundColor = [UIColor clearColor];//0514
        searchBar.superview.superview.backgroundColor = [UIColor clearColor];//0514
        //加一层 不做搜索 做点击
        [willUseHeaderView addSubview:searchBar];
        [willUseHeaderView addSubview:self.searchTopBtn];
        _tableView.tableHeaderView = willUseHeaderView;
        
    }else{
        [willUseHeaderView addSubview:self.searchTopBtn];
        _tableView.tableHeaderView =   willUseHeaderView;
    }
    [self.view addSubview:_tableView];
}


- (void)doneBarButtonClick:(UIBarButtonItem *)doneBarButton {

    [self openMultiChooseBoard:NO];
    self.navigationItem.rightBarButtonItems = @[self.moreItem,self.editItem];
}

- (void)editBarButtonClick:(UIButton *)editBarButton {
    
    [self openMultiChooseBoard:YES];
    [self enableMultiSelectedMode:YES];
    self.navigationItem.rightBarButtonItems = @[self.doneItem];
}

- (void)rightBarButtonClick:(UIButton *)rightBarButton
{
    NSMutableArray *menus = [NSMutableArray array];
    TUIPopCellData *friend = [[TUIPopCellData alloc] init];
    
    friend.image = TUIConversationDynamicImage(@"pop_icon_new_chat_img", [UIImage imageNamed:TUIConversationImagePath(@"new_chat")]);
    friend.title = TUIKitLocalizableString(ChatsNewChatText);
    [menus addObject:friend];
    
    TUIPopCellData *group = [[TUIPopCellData alloc] init];
    group.image = TUIConversationDynamicImage(@"pop_icon_new_group_img", [UIImage imageNamed:TUIConversationImagePath(@"new_groupchat")]);
    group.title = TUIKitLocalizableString(ChatsNewGroupText);
    [menus addObject:group];

    CGFloat height = [TUIPopCell getHeight] * menus.count + TUIPopView_Arrow_Size.height;
    CGFloat orginY = StatusBar_Height + NavBar_Height;
    TUIPopView *popView = [[TUIPopView alloc] initWithFrame:CGRectMake(Screen_Width - 155, orginY, 145, height)];
    CGRect frameInNaviView = [self.navigationController.view convertRect:rightBarButton.frame fromView:rightBarButton.superview];
    popView.arrowPoint = CGPointMake(frameInNaviView.origin.x + frameInNaviView.size.width * 0.5, orginY);
    popView.delegate = self;
    [popView setData:menus];
    [popView showInWindow:self.view.window];
}

#pragma TUIPopViewDelegate
- (void)popView:(TUIPopView *)popView didSelectRowAtIndex:(NSInteger)index
{
    if (0 == index) {
        [self startConversation:V2TIM_C2C];
    } else {
        [self startConversation:V2TIM_GROUP];
    }
}

- (void)startConversation:(V2TIMConversationType)type {
    TUIFloatViewController * floatVC = [[TUIFloatViewController alloc] init];

    void (^selectContactCompletion)(NSArray<TUICommonContactSelectCellData *> *) = ^(NSArray<TUICommonContactSelectCellData *> *array){
        if (V2TIM_C2C == type) {
            NSDictionary *param = @{
                TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_TitleKey : array.firstObject.title ?: @"",
                TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_UserIDKey : array.firstObject.identifier ?: @"",
                TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarImageKey : array.firstObject.avatarImage ? : DefaultAvatarImage,
                TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarUrlKey : array.firstObject.avatarUrl.absoluteString ? : @""
            };

            UIViewController *chatVC = (UIViewController *)[TUICore createObject:TUICore_TUIChatObjectFactory_Minimalist key:TUICore_TUIChatObjectFactory_GetChatViewControllerMethod param:param];
            [self.navigationController pushViewController:(UIViewController *)chatVC animated:YES];
        } else {
            @weakify(self)
            NSString *loginUser = [[V2TIMManager sharedInstance] getLoginUser];
            [[V2TIMManager sharedInstance] getUsersInfo:@[loginUser] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
                @strongify(self)
                NSString *showName = loginUser;
                if (infoList.firstObject.nickName.length > 0) {
                    showName = infoList.firstObject.nickName;
                }
                NSMutableString *groupName = [NSMutableString stringWithString:showName];
                for (TUICommonContactSelectCellData *item in array) {
                    [groupName appendFormat:@"、%@", item.title];
                }

                if ([groupName length] > 10) {
                    groupName = [groupName substringToIndex:10].mutableCopy;
                }
                void(^createGroupCompletion)(BOOL , V2TIMGroupInfo *,UIImage *) = ^(BOOL isSuccess, V2TIMGroupInfo * _Nonnull info,UIImage * _Nonnull submitShowImage) {
                    NSDictionary *param = @{
                        TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_TitleKey : info.groupName ?: @"",
                        TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_GroupIDKey : info.groupID ?: @"",
                        TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarUrlKey : info.faceURL ?: @"",
                        TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarImageKey : submitShowImage ? : [UIImage new],
                    };
                    
                    UIViewController *chatVC = (UIViewController *)[TUICore createObject:TUICore_TUIChatObjectFactory_Minimalist key:TUICore_TUIChatObjectFactory_GetChatViewControllerMethod param:param];
                    [self.navigationController pushViewController:(UIViewController *)chatVC animated:YES];
                    
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        for (UIViewController * vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:NSClassFromString(@"TUIGroupCreateController")] ||
                                [vc isKindOfClass:NSClassFromString(@"TUIContactSelectController")]) {
                                [tempArray removeObject:vc];
                            }
                        }
                        
                    self.navigationController.viewControllers = tempArray;

                };
                NSDictionary *param = @{
                    TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod_TitleKey : array.firstObject.title ?: @"",
                    TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod_GroupNameKey : groupName ?: @"",
                    TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod_GroupTypeKey : GroupType_Work,
                    TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod_CompletionKey : createGroupCompletion,
                    TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod_ContactListKey: array?:@[]
                };
                
                UIViewController *groupVC = (UIViewController *)[TUICore createObject:TUICore_TUIContactObjectFactory_Minimalist
                                                                                  key:TUICore_TUIContactObjectFactory_GetGroupCreateControllerMethod
                                                                                param:param];
        
                TUIFloatViewController * afloatVC = [[TUIFloatViewController alloc] init];
                [afloatVC appendChildViewController:groupVC topMargin:kScale390(87.5)];
                [afloatVC.topGestureView setTitleText:TIMCommonLocalizableString(ChatsNewGroupText) subTitleText:@"" leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:TIMCommonLocalizableString(TUIKitCreateFinish)];
                [self presentViewController:afloatVC animated:YES completion:nil];
                
            } fail:nil];
        }
    };
    NSDictionary *param = @{
        TUICore_TUIContactObjectFactory_GetContactSelectControllerMethod_TitleKey: TIMCommonLocalizableString(ChatsSelectContact),
        TUICore_TUIContactObjectFactory_GetContactSelectControllerMethod_MaxSelectCount: @(type == V2TIM_C2C ? 1 : INT_MAX),
        TUICore_TUIContactObjectFactory_GetContactSelectControllerMethod_CompletionKey : selectContactCompletion
    };
    UIViewController *vc = [TUICore createObject:TUICore_TUIContactObjectFactory_Minimalist key:TUICore_TUIContactObjectFactory_GetContactSelectControllerMethod param:param];
    [floatVC appendChildViewController:vc topMargin:kScale390(87.5)];
    [floatVC.topGestureView setTitleText:((V2TIM_C2C == type))?TIMCommonLocalizableString(ChatsNewChatText):TIMCommonLocalizableString(ChatsNewGroupText) subTitleText:@"" leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:(V2TIM_C2C == type)?@"":TIMCommonLocalizableString(TUIKitCreateNext)];

    floatVC.topGestureView.rightButton.enabled = NO;

    __weak typeof(floatVC)weakFloatVC = floatVC;
    floatVC.childVC.floatDataSourceChanged = ^(NSArray * _Nonnull arr) {
        if(arr.count != 0) {
            weakFloatVC.topGestureView.rightButton.enabled = YES;
        }
        else {
            weakFloatVC.topGestureView.rightButton.enabled = NO;

        }
    };
    
    [self presentViewController:floatVC animated:YES completion:nil];

}

- (TUIConversationListBaseDataProvider *)dataProvider {
    if (!_dataProvider) {
        _dataProvider = [[TUIConversationListDataProvider_Minimalist alloc] init];
        _dataProvider.delegate = self;
    }
    return (TUIConversationListDataProvider_Minimalist *)_dataProvider;
}

#pragma mark - edit
- (void)openMultiChooseBoard:(BOOL)open
{
    [self.view endEditing:YES];
    self.showCheckBox = open;
    
    if (_multiChooseView) {
        [_multiChooseView removeFromSuperview];
    }
    
    if (open) {
        _multiChooseView = [[TUIConversationMultiChooseView_Minimalist alloc] init];
        _multiChooseView.frame = UIScreen.mainScreen.bounds;
        _multiChooseView.titleLabel.text = @"";
        _multiChooseView.toolView.hidden = YES;

        [_multiChooseView.readButton setTitle:TUIKitLocalizableString(ReadAll) forState:UIControlStateNormal];
        [_multiChooseView.hideButton setTitle:TUIKitLocalizableString(Hide) forState:UIControlStateNormal];
        [_multiChooseView.deleteButton setTitle:TUIKitLocalizableString(Delete) forState:UIControlStateNormal];
        _multiChooseView.readButton.enabled = YES;
        _multiChooseView.hideButton.enabled = NO;
        _multiChooseView.deleteButton.enabled = NO;
        @weakify(self);
        _multiChooseView.readButton.clickCallBack = ^(id  _Nonnull button) {
            @strongify(self);
            [self chooseViewReadAll];
        };
        _multiChooseView.hideButton.clickCallBack = ^(id  _Nonnull button) {
            @strongify(self);
            [self choosViewActionHide];
        };
        _multiChooseView.deleteButton.clickCallBack = ^(id  _Nonnull button) {
            @strongify(self);
            [self chooseViewActionDelete];
        };
        
        if (@available(iOS 12.0, *)) {
            if (@available(iOS 13.0, *)) {
                // > ios 12
                [UIApplication.sharedApplication.keyWindow addSubview:_multiChooseView];
            } else {
                // ios = 12
                UIView *view = self.navigationController.view;
                if (view == nil) {
                    view = self.view;
                }
                [view addSubview:_multiChooseView];
            }
        } else {
            // < ios 12
            [UIApplication.sharedApplication.keyWindow addSubview:_multiChooseView];
        }
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(onCloseConversationMultiChooseBoard)]) {
            [self.delegate onCloseConversationMultiChooseBoard];
        }
        [self enableMultiSelectedMode:NO];
        self.navigationItem.rightBarButtonItems = @[self.moreItem,self.editItem];
    }
}

- (void)chooseViewReadAll {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClearAllConversationUnreadCount)]) {
        [self.delegate onClearAllConversationUnreadCount];
    }
    [self openMultiChooseBoard:NO];
}

- (void)choosViewActionHide{
    NSArray *uiMsgs = [self getMultiSelectedResult];
    if (uiMsgs.count == 0) {
        return;
    }
    for (TUIConversationCellData *data in uiMsgs) {
        [self.dataProvider markConversationHide:data];
    }
    
    [self openMultiChooseBoard:NO];
}

- (void)chooseViewActionRead {
    
    NSArray *uiMsgs = [self getMultiSelectedResult];
    if (uiMsgs.count == 0) {
        return;
    }
    for (TUIConversationCellData *data in uiMsgs) {
        [self.dataProvider markConversationAsRead:data];
    }
    
    [self openMultiChooseBoard:NO];
}

- (void)chooseViewActionDelete {
    
    NSArray *uiMsgs = [self getMultiSelectedResult];
    if (uiMsgs.count == 0) {
        return;
    }
    
    for (TUIConversationCellData *data in uiMsgs) {
        [self.dataProvider removeConversation:data];
    }
    
    [self openMultiChooseBoard:NO];
}

#pragma mark TUIConversationListDataProviderDelegate
- (NSString *)getConversationDisplayString:(V2TIMConversation *)conversation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getConversationDisplayString:)]) {
        return [self.delegate getConversationDisplayString:conversation];
    }
    V2TIMMessage *msg = conversation.lastMessage;
    if (msg.customElem == nil || msg.customElem.data == nil) {
        return nil;
    }
    NSDictionary *param = [TUITool jsonData2Dictionary:msg.customElem.data];
    if (param != nil && [param isKindOfClass:[NSDictionary class]]) {
        NSString *businessID = param[@"businessID"];
        if (![businessID isKindOfClass:[NSString class]]) {
            return nil;
        }

        // whether custom jump message
        if ([businessID isEqualToString:BussinessID_TextLink] || ([(NSString *)param[@"text"] length] > 0 && [(NSString *)param[@"link"] length] > 0)) {
            NSString *desc = param[@"text"];
            if (msg.status == V2TIM_MSG_STATUS_LOCAL_REVOKED) {
                if(msg.isSelf){
                    desc = TUIKitLocalizableString(TUIKitMessageTipsYouRecallMessage);
                } else if (msg.userID.length > 0){
                    desc = TUIKitLocalizableString(TUIkitMessageTipsOthersRecallMessage);
                } else if (msg.groupID.length > 0) {
                    /**
                     * 对于群组消息的名称显示，优先显示群名片，昵称优先级其次，用户ID优先级最低。
                     * For the name display of group messages, the group business card is displayed first, the nickname has the second priority, and the user ID has the lowest priority.
                     */
                    NSString *userName = msg.nameCard;
                    if (userName.length == 0) {
                        userName = msg.nickName?:msg.sender;
                    }
                    desc = [NSString stringWithFormat:TUIKitLocalizableString(TUIKitMessageTipsRecallMessageFormat), userName];
                }
            }
            return desc;
        }

        // whether the tips message of creating group
        else if ([businessID isEqualToString:BussinessID_GroupCreate] || [param.allKeys containsObject:BussinessID_GroupCreate]) {
            return [NSString stringWithFormat:@"\"%@\"%@",param[@"opUser"],param[@"content"]];
        }
    }

    return nil;
}

- (void)insertConversationsAtIndexPaths:(NSArray *)indexPaths {
    if (!NSThread.isMainThread) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf insertConversationsAtIndexPaths:indexPaths];
        });
        return;
    }
    [UIView performWithoutAnimation:^{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];

}

- (void)reloadConversationsAtIndexPaths:(NSArray *)indexPaths {
    if (!NSThread.isMainThread) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadConversationsAtIndexPaths:indexPaths];
        });
        return;
    }
    if (self.tableView.isEditing) {
        self.tableView.editing = NO;
    }
    NSLog(@"更新列表某单独行的数据=该index有新消息过来  reloadConversationsAtIndexPaths indexPaths ---%@",indexPaths);
    
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }];
     
}

- (void)deleteConversationAtIndexPaths:(NSArray *)indexPaths {
    if (!NSThread.isMainThread) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf deleteConversationAtIndexPaths:indexPaths];
        });
        return;
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadAllConversations {
    if (!NSThread.isMainThread) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadAllConversations];
        });
        return;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    
    if (self.dataSourceChanged) {
        self.dataSourceChanged(self.dataProvider.conversationList.count);
    }
    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行
        return  self.dataProvider.conversationList.count + 2;
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        return self.dataProvider.conversationList.count + 1;
    }else  if(self.isHaveShowTopCellWithAddSystemGroup == YES){
        return self.dataProvider.conversationList.count + 1;
    }else{
        return self.dataProvider.conversationList.count;
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行 0行1行工作
        if(indexPath.row == 0 || indexPath.row == 1 ){
            return NO;
        }
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        if(indexPath.row == 0){
            return NO;
        }
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        if(indexPath.row == 0){
            return NO;
        }
    }else{
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    TUIConversationCellData *cellData;
    
    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行
        if(indexPath.row == 0 || indexPath.row == 1 ){
            return @[];
        }
        cellData= self.dataProvider.conversationList[indexPath.row-2];//展示状态 row让一位 原list数据往小取2位
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        if(indexPath.row == 0){
            return @[];
        }
        cellData= self.dataProvider.conversationList[indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
    }else  if(self.isHaveShowTopCellWithAddSystemGroup == YES){
        if(indexPath.row == 0){
            return @[];
        }
        cellData= self.dataProvider.conversationList[indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
    }else{
        cellData= self.dataProvider.conversationList[indexPath.row];
    }
    NSMutableArray *rowActions = [NSMutableArray array];
  
    __weak typeof(self) weakSelf = self;

    // Mark as read action
    UITableViewRowAction *markAsReadAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:(cellData.isMarkAsUnread||cellData.unreadCount > 0)  ? TUIKitLocalizableString(MarkAsRead) : TUIKitLocalizableString(MarkAsUnRead) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (cellData.isMarkAsUnread||cellData.unreadCount > 0) {
            [weakSelf.dataProvider markConversationAsRead:cellData];
            if (cellData.isLocalConversationFoldList) {
                [TUIConversationListDataProvider_Minimalist  cacheConversationFoldListSettings_FoldItemIsUnread:NO];
            }
        }
        else {
            [weakSelf.dataProvider markConversationAsUnRead:cellData];
            if (cellData.isLocalConversationFoldList) {
                [TUIConversationListDataProvider_Minimalist  cacheConversationFoldListSettings_FoldItemIsUnread:YES];
            }
        }
        
    }];
    markAsReadAction.backgroundColor = RGB(20, 122, 255);
        
    // Mark as hide action
    UITableViewRowAction *markHideAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:TUIKitLocalizableString(MarkHide) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.dataProvider markConversationHide:cellData];
        if (cellData.isLocalConversationFoldList) {
            [TUIConversationListDataProvider_Minimalist  cacheConversationFoldListSettings_HideFoldItem:YES];
        }
    }];
    markHideAction.backgroundColor = RGB(242, 147, 64);
    
    // More action
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"more" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        weakSelf.tableView.editing = NO;
        [weakSelf showMoreAction:cellData];
    }];
    moreAction.backgroundColor = [UIColor blackColor];
    
    //config Actions
    if (cellData.isLocalConversationFoldList) {
        [rowActions addObject:markHideAction];
    } else {
        [rowActions addObject:markAsReadAction];
        [rowActions addObject:moreAction];
    }
    return rowActions;
}

// available ios 11 +
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) {
    //左滑删除相关
    
    TUIConversationCellData *cellData;
    
    if (self.showCheckBox) {
        return nil;
    }
    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行
        if(indexPath.row == 0 || indexPath.row == 1 ){
            UISwipeActionsConfiguration *configurationNoInfo = [UISwipeActionsConfiguration configurationWithActions:@[]];
            return configurationNoInfo;
        }
        cellData= self.dataProvider.conversationList[indexPath.row-2];//展示状态 row让一位 原list数据往小取1位
    }else  if(self.isHaveShowTopCellWithGroupApplicationList==YES){
        if(indexPath.row == 0){
            UISwipeActionsConfiguration *configurationNoInfo = [UISwipeActionsConfiguration configurationWithActions:@[]];
            return configurationNoInfo;
        }
        cellData= self.dataProvider.conversationList[indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
    }else  if(self.isHaveShowTopCellWithAddSystemGroup==YES){
        if(indexPath.row == 0){
            UISwipeActionsConfiguration *configurationNoInfo = [UISwipeActionsConfiguration configurationWithActions:@[]];
            return configurationNoInfo;
        }
        cellData= self.dataProvider.conversationList[indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
    }else{
        cellData= self.dataProvider.conversationList[indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
//    TUIConversationCellData *cellData = self.dataProvider.conversationList[indexPath.row];
    NSMutableArray *arrayM = [NSMutableArray array];
    NSString *language = [TUIGlobalization tk_localizableLanguageKey];
    
    // Mark as read action
    UIContextualAction *markAsReadAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        if (cellData.isMarkAsUnread||cellData.unreadCount > 0) {
            [weakSelf.dataProvider markConversationAsRead:cellData];
            if (cellData.isLocalConversationFoldList) {
                [TUIConversationListDataProvider_Minimalist cacheConversationFoldListSettings_FoldItemIsUnread:NO];
            }
        }
        else {
            [weakSelf.dataProvider markConversationAsUnRead:cellData];
            if (cellData.isLocalConversationFoldList) {
                [TUIConversationListDataProvider_Minimalist cacheConversationFoldListSettings_FoldItemIsUnread:YES];
            }
        }
    }];
    BOOL read = (cellData.isMarkAsUnread || cellData.unreadCount > 0);
    markAsReadAction.backgroundColor = read ? RGB(37, 104, 240) : RGB(102, 102, 102);
    NSString *markAsReadImageName = read ? @"icon_conversation_swipe_read" : @"icon_conversation_swipe_unread";
    if ([language containsString:@"zh-"]) {
        markAsReadImageName = [markAsReadImageName stringByAppendingString:@"_zh"];
    }
    markAsReadAction.image = TUIDynamicImage(@"", TUIThemeModuleConversation_Minimalist,[UIImage imageNamed:TUIConversationImagePath_Minimalist(markAsReadImageName)]);
    
    // Mark as hide action
    UIContextualAction *markHideAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:TUIKitLocalizableString(MarkHide) handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        [weakSelf.dataProvider markConversationHide:cellData];
        if (cellData.isLocalConversationFoldList) {
            [TUIConversationListDataProvider_Minimalist  cacheConversationFoldListSettings_HideFoldItem:YES];
        }
    }];
    markHideAction.backgroundColor = [UIColor tui_colorWithHex:@"#0365F9"];

    // More action
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler(YES);
        weakSelf.tableView.editing = NO;
        [weakSelf showMoreAction:cellData];
    }];
    moreAction.backgroundColor = RGB(0, 0, 0);
    NSString *moreImageName = [language containsString:@"zh-"] ? @"icon_conversation_swipe_more_zh" : @"icon_conversation_swipe_more";
    moreAction.image = TUIDynamicImage(@"", TUIThemeModuleConversation_Minimalist,[UIImage imageNamed:TUIConversationImagePath_Minimalist(moreImageName)]);
    
    //config Actions
    if (cellData.isLocalConversationFoldList) {
        [arrayM addObject:markHideAction];
    } else {
        [arrayM addObject:markAsReadAction];
        [arrayM addObject:moreAction];
    }
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:[NSArray arrayWithArray:arrayM]];
    configuration.performsFirstActionWithFullSwipe = NO;
    
    // fix bug:
    // In ios 12, image in SwipeActions will be renderd with template
    // The method is adding an new image to the origin
    // The purpose of using async is to ensure UISwipeActionPullView has been renderd in UITableView
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 12.0, *)) {
            [self reRenderingSwipeView];
        }
    });
    return configuration;
}

- (void)reRenderingSwipeView API_AVAILABLE(ios(12.0)) {
    if (@available(iOS 13.0, *)) {
        return;
    }
    static NSUInteger kSwipeImageViewTag;
    if (kSwipeImageViewTag == 0) {
        kSwipeImageViewTag = [NSStringFromClass(self.class) hash];
    }
    
    for (UIView *view in self.tableView.subviews) {
        if (![view isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            continue;
        }
        for (UIView *subview in view.subviews) {
            if (![subview isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                continue;
            }
            for (UIView *sub in subview.subviews) {
                if (![sub isKindOfClass:[UIImageView class]]) {
                    continue;
                }
                if ([sub viewWithTag:kSwipeImageViewTag] == nil) {
                    UIImageView *addedImageView = [[UIImageView alloc] initWithFrame:sub.bounds];
                    addedImageView.tag = kSwipeImageViewTag;
                    addedImageView.image= [[(UIImageView *)sub image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    [sub addSubview:addedImageView];
                }
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
 
#define  kFreeper_Message_ID   @"Freeper_Message"
#define  kFreeper_Notification_ID   @"Freeper_Notification"
#define  kFreeper_C2C_Freeper       @"c2c_Freeper" //0828判断条件处理


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TUIConversationCellData *data;

    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行
        if(indexPath.row == 0){
            ImMainListTableViewCell_AddSystemGroup *cell = [[ImMainListTableViewCell_AddSystemGroup alloc]init];
            [cell.joinBtn addTarget:self action:@selector(touchCellBtnOfJoinSystemGroupAction ) forControlEvents:UIControlEventTouchUpInside];//加群
            return cell;
        }else if(indexPath.row == 1 ){
            ImMainListTableViewCell_GroupApplicationUseCell *cell =  [[ImMainListTableViewCell_GroupApplicationUseCell alloc]init];//申请加群
            V2TIMGroupApplication *groupApplicationData = self.saveLasetNoDealGrouAppL;//self.getApplicationListArr.lastObject;
            cell.bottomL.text =  groupApplicationData.requestMsg.length>0 ? groupApplicationData.requestMsg :@"";
            return cell;//NSLog(@"");
        }else{
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-2];//展示状态 row让一位 原list数据往小取1位
        }
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        if(indexPath.row == 0){
           ImMainListTableViewCell_GroupApplicationUseCell *cell =  [[ImMainListTableViewCell_GroupApplicationUseCell alloc]init];//申请加群
            V2TIMGroupApplication *groupApplicationData = self.saveLasetNoDealGrouAppL;//self.getApplicationListArr.lastObject;
            cell.bottomL.text =  groupApplicationData.requestMsg.length>0 ? groupApplicationData.requestMsg :@"";
            return cell;
        }else{
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
        }
    }else  if( self.isHaveShowTopCellWithAddSystemGroup == YES ){
        if(indexPath.row == 0){
            ImMainListTableViewCell_AddSystemGroup *cell = [[ImMainListTableViewCell_AddSystemGroup alloc]init];
            [cell.joinBtn addTarget:self action:@selector(touchCellBtnOfJoinSystemGroupAction ) forControlEvents:UIControlEventTouchUpInside];//加群
            return cell;
            
        }else{
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
        }
    }else{
//        NSLog(@"聊天listd点击崩溃问题 list=%d grop=%d",self.isHaveShowTopCellWithGroupApplicationList,self.isHaveShowTopCellWithAddSystemGroup);
//        NSLog(@"聊天listd点击崩溃问题 %ld",indexPath.row);
//        NSLog(@"聊天listd点击崩溃问题 %@ %ld",self.dataProvider.conversationList,indexPath.row);
        data = [self.dataProvider.conversationList objectAtIndex:indexPath.row];

    }
    ImMainListTableViewCell_Minimalist *cell = [tableView dequeueReusableCellWithIdentifier:@"ImMainListTableViewCell_Minimalist" forIndexPath:indexPath];
    data.showCheckBox = self.showCheckBox;
    if (data.isLocalConversationFoldList) {
        data.showCheckBox = NO;
    }
    [cell fillWithData:data];
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        cell.titleLabel.textColor = TUIDynamicColor(@"", TUIThemeModuleCore_Minimalist, @"#000000");
    }else{
        cell.titleLabel.textColor = [UIColor whiteColor];//0816
    }
    if (data.userID.length>0 && (![data.userID isEqualToString:kFreeper_Message_ID]) && (![data.userID isEqualToString:kFreeper_Notification_ID]) && (![[NSString stringWithFormat:@"%@",data.conversationID] containsString:kFreeper_C2C_Freeper])) {//非群 且非系统的user |群的名字 不变 
        cell.titleLabel.text = [self suoDuanAddressStr:cell.titleLabel.text];
    
    }

    if(data.lastMessage.elemType == V2TIM_ELEM_TYPE_CUSTOM && data.lastMessage.customElem.desc.length>0){
        //类型处理
        switch ([data.lastMessage.customElem.desc integerValue]) {
            case Link_Type_AddGroup_1:
            {
                NSDictionary *param = [NSJSONSerialization JSONObjectWithData:data.lastMessage.customElem.data options:NSJSONReadingAllowFragments error:nil];
                NSString * groupId = param[@"groupId"];
                NSString * groupName = param[@"groupName"];
                cell.subTitleLabel.text = [self dealCellShowTextWithGroupId:groupId withGroupName:groupName];
            }
                break;
            case Link_Type_RedEnv_2:
            {
                NSDictionary *param = [NSJSONSerialization JSONObjectWithData:data.lastMessage.customElem.data options:NSJSONReadingAllowFragments error:nil];
                cell.subTitleLabel.text =  Y_LocaleTypeFile_NSLocalString(@"【红包】");// [self dealCellShowTextWithGroupId:groupId withGroupName:groupName];
            }
                break;
            case Link_Type_RedEnv_3:
            {
                NSDictionary *param = [NSJSONSerialization JSONObjectWithData:data.lastMessage.customElem.data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"Link_Type_RedEnv_3 param -- %@",param);
                cell.subTitleLabel.text = Y_LocaleTypeFile_NSLocalString(@"抢【红包】");
            }
                break;
                
            default:
            {  NSDictionary *param = [NSJSONSerialization JSONObjectWithData:data.lastMessage.customElem.data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"Link_Type_ShareActive_4 param -- %@",param);
                NSLog(@"ImMainConversationListVc_Minimalist");
                if([[param allKeys]containsObject:@"activityId"]&&[[param allKeys]containsObject:@"businessID"]){
                    cell.subTitleLabel.text = Y_LocaleTypeFile_NSLocalString(@"[活动分享]");
                }
                
            }
              
                break;
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    DLog(@"主页列表title ---  cell.titleLabel.text %@", cell.titleLabel.text);
    //主页列表title
    if([cell.titleLabel.text isEqualToString:@"服务通知"] || [data.userID isEqualToString:kFreeper_Notification_ID]){
        cell.titleLabel.text = Y_LocaleTypeFile_NSLocalString(@"服务通知");
    }else if([cell.titleLabel.text isEqualToString:@"系统消息"] || [data.userID isEqualToString:kFreeper_Message_ID]){
        cell.titleLabel.text = Y_LocaleTypeFile_NSLocalString(@"系统消息");
    }
    return cell;
    
}

- (NSString *)dealCellShowTextWithGroupId:(NSString *)groupID withGroupName:(NSString *)groupName{
    NSString *groupNameCentStr = [NSString stringWithFormat:@"[%@]",groupName];
    NSString *addGroupCellShowText = [NSString stringWithFormat:Y_LocaleTypeFile_NSLocalString(@"欢迎加入我们%@群"),groupNameCentStr];
    return addGroupCellShowText;
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

//跳转 进群申请 同意拒绝列表
- (void)openPendency {
    TUIGroupPendencyController *vc = [[TUIGroupPendencyController alloc] init];
    @weakify(self);
    vc.cellClickBlock = ^(TUIGroupPendencyCell * _Nonnull cell) {
        if (cell.pendencyData.isRejectd || cell.pendencyData.isAccepted) {
            //选择后不再进详情页了
            return;
        }
        @strongify(self);
        [[V2TIMManager sharedInstance] getUsersInfo:@[cell.pendencyData.fromUser] succ:^(NSArray<V2TIMUserFullInfo *> *profiles) {
            // 显示用户资料 VC
            NSDictionary *param = @{
                TUICore_TUIContactObjectFactory_GetUserProfileControllerMethod_UserProfileKey : profiles.firstObject,
                TUICore_TUIContactObjectFactory_GetUserProfileControllerMethod_PendencyDataKey : cell.pendencyData,
                TUICore_TUIContactObjectFactory_GetUserProfileControllerMethod_ActionTypeKey : @(3)
            };
            UIViewController *vc = [TUICore createObject:TUICore_TUIContactObjectFactory_Minimalist
                                                     key:TUICore_TUIContactObjectFactory_GetUserProfileControllerMethod
                                                   param:param];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } fail:nil];
    };
    if(isNil((self.pendencyViewModel))){
        return;
    }
    vc.viewModel = self.pendencyViewModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TUIConversationCell_Minimalist *cell;
    TUIConversationCellData *data;
     
    
   DLog(@"--点击cell---  ToolsGetWebsite");
    //#import "ToolsGetWebsite.h"
    
    
    if(self.isHaveShowTopCellWithAddSystemGroup==YES && self.isHaveShowTopCellWithGroupApplicationList==YES){//两个类型都存在 +2行
        if(indexPath.row == 0){
            return;
        }else if(indexPath.row == 1 ){
            NSLog(@"跳转去申请进群的list");
            [self openPendency];
            return;
            
        }else{
            cell = [tableView cellForRowAtIndexPath:indexPath];
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-2];//展示状态 row让一位 原list数据往小取2位
        }
    }else  if(self.isHaveShowTopCellWithGroupApplicationList == YES){
        if(indexPath.row == 0){
            NSLog(@"跳转去申请进群的list");
            [self openPendency];
            return;
        }else{
            cell = [tableView cellForRowAtIndexPath:indexPath];
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
        }
        
    }else if(self.isHaveShowTopCellWithAddSystemGroup == YES){
        if(indexPath.row == 0){
            return;
        }else{
            cell = [tableView cellForRowAtIndexPath:indexPath];
            data = [self.dataProvider.conversationList objectAtIndex:indexPath.row-1];//展示状态 row让一位 原list数据往小取1位
        }
    }else{
        cell = [tableView cellForRowAtIndexPath:indexPath];
        data = [self.dataProvider.conversationList objectAtIndex:indexPath.row];
    
    }
    
//    TUIConversationCell_Minimalist *cell = [tableView cellForRowAtIndexPath:indexPath];
//    TUIConversationCellData *data = [self.dataProvider.conversationList objectAtIndex:indexPath.row];
    data.avatarImage = cell.headImageView.image;
    [self.tableView reloadData];
    
    if (self.showCheckBox) {
        if (data.isLocalConversationFoldList) {
            return;
        }
        data.selected = !data.selected;
                
        NSArray *uiMsgs = [self getMultiSelectedResult];
        if (uiMsgs.count == 0) {
            self.multiChooseView.readButton.enabled = NO;
            self.multiChooseView.deleteButton.enabled = NO;
            self.multiChooseView.hideButton.enabled = NO;
            return;
        }
        
        @weakify(self)
        if (uiMsgs.count > 0) {
            self.multiChooseView.hideButton.enabled = YES;
            self.multiChooseView.deleteButton.enabled = YES;
            [self.multiChooseView.readButton setTitle:TIMCommonLocalizableString(MarkAsRead) forState:UIControlStateNormal];
            self.multiChooseView.readButton.clickCallBack = ^(id  _Nonnull button) {
                @strongify(self)
                [self chooseViewActionRead];
            };
            for (TUIConversationCellData *data in uiMsgs) {
                if (data.unreadCount > 0) {
                    self.multiChooseView.readButton.enabled = YES;
                    break;
                }
            }
        }
        return;
    }
    

    

    if (data.isLocalConversationFoldList) {
        [TUIConversationListBaseDataProvider cacheConversationFoldListSettings_FoldItemIsUnread:NO];

        TUIFoldListViewController_Minimalist *foldVC = [[TUIFoldListViewController_Minimalist alloc] init];
        [self.navigationController pushViewController:foldVC animated:YES];

        @weakify(self)
        foldVC.dismissCallback = ^(NSMutableAttributedString * _Nonnull foldStr, NSArray * _Nonnull sortArr , NSArray * _Nonnull needRemoveFromCacheMapArray) {
            @strongify(self)
            data.foldSubTitle  = foldStr;
            data.subTitle = data.foldSubTitle;
            data.isMarkAsUnread = NO;

            if (sortArr.count <= 0 ) {
                data.orderKey = 0;
                if ([self.dataProvider.conversationList  containsObject:data]) {
                    [self.dataProvider hideConversation:data];
                }
            }

            for (NSString * removeId in needRemoveFromCacheMapArray) {
                if ([self.dataProvider.markFoldMap objectForKey:removeId] ) {
                    [self.dataProvider.markFoldMap removeObjectForKey:removeId];
                }
            }

            [TUIConversationListDataProvider_Minimalist cacheConversationFoldListSettings_FoldItemIsUnread:NO];
            [self.tableView reloadData];
        };
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]) {
        [self.delegate conversationListController:self didSelectConversation:data];
    } else {
        NSDictionary *param = @{
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_TitleKey : data.title ?: @"",
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_UserIDKey : data.userID ?: @"",
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_GroupIDKey : data.groupID ?: @"",
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarImageKey : data.avatarImage ?: [UIImage new],
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AvatarUrlKey : data.faceUrl ?: @"",
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_ConversationIDKey : data.conversationID ?: @"",
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_AtMsgSeqsKey : data.atMsgSeqs ?: @[],
            TUICore_TUIChatObjectFactory_GetChatViewControllerMethod_DraftKey: data.draftText ?: @""
        };

        UIViewController *chatVC = (UIViewController *)[TUICore createObject:TUICore_TUIChatObjectFactory_Minimalist key:TUICore_TUIChatObjectFactory_GetChatViewControllerMethod param:param];
        [self.navigationController pushViewController:(UIViewController *)chatVC animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //通过开启或关闭这个开关，控制最后一行分割线的长度
    //Turn on or off the length of the last line of dividers by controlling this switch
    BOOL needLastLineFromZeroToMax = NO;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 5)];
        if (needLastLineFromZeroToMax && indexPath.row == (self.dataProvider.conversationList.count - 1)) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if (needLastLineFromZeroToMax && [cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if (needLastLineFromZeroToMax && [cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.dataProvider loadNexPageConversations];
}

- (void)enableMultiSelectedMode:(BOOL)enable {
    self.showCheckBox = enable;
    if (!enable) {
        for (TUIConversationCellData_Minimalist *cellData in self.dataProvider.conversationList) {
            cellData.selected = NO;
        }
    }
    [self.tableView reloadData];
}

- (NSArray<TUIConversationCellData_Minimalist *> *)getMultiSelectedResult {
    NSMutableArray *arrayM = [NSMutableArray array];
    if (!self.showCheckBox) {
        return [NSArray arrayWithArray:arrayM];
    }
    for (TUIConversationCellData_Minimalist *data in self.dataProvider.conversationList) {
        if (data.selected) {
            [arrayM addObject:data];
        }
    }
    return [NSArray arrayWithArray:arrayM];
}

//MARK: action
- (void)showMoreAction:(TUIConversationCellData *) cellData {
        
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self)weakSelf = self;
    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:TIMCommonLocalizableString(MarkHide) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataProvider markConversationHide:cellData];
        if (cellData.isLocalConversationFoldList) {
            [TUIConversationListDataProvider_Minimalist  cacheConversationFoldListSettings_HideFoldItem:YES];
        }
    }]];

    if (!cellData.isMarkAsFolded){
        [ac tuitheme_addAction:[UIAlertAction actionWithTitle:cellData.isOnTop?TIMCommonLocalizableString(UnPin):TIMCommonLocalizableString(Pin) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.dataProvider pinConversation:cellData pin:!cellData.isOnTop];
        }]];
    }

    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:TIMCommonLocalizableString(ClearHistoryChatMessage) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataProvider markConversationAsRead:cellData];
        [strongSelf.dataProvider clearHistoryMessage:cellData];
    }]];

    
    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:TIMCommonLocalizableString(Delete) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataProvider removeConversation:cellData];
    }]];
    
    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:TIMCommonLocalizableString(Cancel) style:UIAlertActionStyleCancel handler:nil]];
    NSString *coms =  TIMCommonLocalizableString(ClearHistoryChatMessage);
    NSString *ki =  TUIKitLocalizableString(ClearHistoryChatMessage);
    
    NSLog(@" TUIKitLocalizableString(ClearHistoryChatMessage) =%@ ,coms=%@",ki,coms);

    [self presentViewController:ac animated:YES completion:nil];
}

- (void)startCreatGroupNotification:(NSNotification *)noti {
    [self startConversation:V2TIM_GROUP];
}

@end

@interface IUConversationView_Minimalist : UIView
@property(nonatomic, strong) UIView *view;
@end

@implementation IUConversationView_Minimalist

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:self.view];
    }
    return self;
}
@end

 
