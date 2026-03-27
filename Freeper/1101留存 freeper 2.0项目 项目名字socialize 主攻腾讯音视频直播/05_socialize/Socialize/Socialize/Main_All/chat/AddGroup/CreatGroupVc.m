//
//  CreatGroupVc.m
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import "CreatGroupVc.h"
#import "CreatGroupHeaderView.h"
#import "TUIChatConversationModel.h"
#import "ImChatVc.h"
#import <TUIBaseChatViewController_Minimalist.h>
#import <TUIGroupChatViewController_Minimalist.h>
#import <TUIC2CChatViewController_Minimalist.h>

@interface CreatGroupVc () <UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CreatGroupHeaderView *headerView;
@property (nonatomic,strong) UIButton *footerBtn;
@property (nonatomic,strong) NSMutableArray *getAllFriendsList;
@property (nonatomic,strong) NSMutableArray *chooseFriendsList;

@end

@implementation CreatGroupVc
- (NSMutableArray *)getAllFriendsList{
    if(!_getAllFriendsList){
        _getAllFriendsList = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _getAllFriendsList;
}
- (NSMutableArray *)chooseFriendsList{
    if(!_chooseFriendsList){
        _chooseFriendsList = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _chooseFriendsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigator];
    [self initViews];
    [self getFriends];
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

- (void)setupNavigator {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = Y_gray_img;
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self navRemSelfVc];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)tapViewAction{
    [self.view endEditing:YES];

}

#define  kTheme_Type_Key   @"Theme_Type"
- (void)initViews{
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
        
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#000000"];

    }
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
    }
    
    _headerView = [[CreatGroupHeaderView alloc]initWithFrame:CGRectZero];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = self.headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView registerClass:[TUICommonContactCell_Minimalist class] forCellReuseIdentifier:@"TUICommonContactCell_Minimalist"];
    [_tableView registerClass:[CreatGroupVcSubCell class] forCellReuseIdentifier:@"CreatGroupVcSubCell"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self      action:@selector(tapViewAction)];
    [_tableView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.tableView];
    //在编辑状态下允许多选
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    
    NSString *footerBS = Y_LocaleTypeFile_NSLocalString(@"立即创建");
    _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerBtn.bounds = CGRectMake(0,0, Screen_W-40, 50);
    _footerBtn.center = CGPointMake(self.view.center.x,  CGRectGetMaxY(self.view.bounds)-60-KNavBarHeight);
    [_footerBtn newAnBtnWithLayerCorNerNum:22.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    [_footerBtn newAnBtnWithBackColor:Color_Socialize_GreenColor];
    [_footerBtn newAnBtnWithTextColor:Color_51BlackColor];
    [_footerBtn newAnBtnWithTextStr:footerBS];
    [_footerBtn addTarget:self action:@selector(nowAddGroupAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.footerBtn];
}
#pragma mark ===

- (void)getFriends{
    WEAKSELF
      [[V2TIMManager sharedInstance]getFriendList:^(NSArray<V2TIMFriendInfo *> *infoList) {
        if(infoList.count>0){
            [weakSelf.getAllFriendsList removeAllObjects];
            //排序右key?
            [weakSelf.getAllFriendsList addObjectsFromArray:infoList];
            [weakSelf.tableView reloadData];
        }
    } fail:^(int code, NSString *desc) {
        Y_SVP_SHOW_ERR_MES(desc);
    }];
}
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.getAllFriendsList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScale390(52);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    V2TIMFriendInfo *fMod =  self.getAllFriendsList[indexPath.row];
    CreatGroupVcSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreatGroupVcSubCell" forIndexPath:indexPath];
    cell.changeColorWhenTouched = YES;
    cell.separtorView.hidden = YES;
    if(fMod.friendRemark.length>0){
        cell.titleLabel.text = fMod.friendRemark;
    }else{
        cell.titleLabel.text = [self suoDuanAddressStr: fMod.userFullInfo.showName];
    }
    [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:fMod.userFullInfo.faceURL] placeholderImage: [BaseImgTool placeholdHeadImg]];
    
    WEAKSELF
    cell.btnActionBlock = ^(UIButton * _Nonnull sender, NSInteger index) {
        //选中 移除选中
        DLog(@"选中 移除选中 -- %ld",(long)indexPath.row);
        if(sender.selected == YES){
            if([weakSelf.chooseFriendsList containsObject: fMod.userID]){
            }else{
                [weakSelf.chooseFriendsList addObject:fMod.userID];
            }
        }else{
            if([weakSelf.chooseFriendsList containsObject: fMod.userID]){
                [weakSelf.chooseFriendsList removeObject:fMod.userID];
            }
        }
    };
    
    return cell;
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

/**
 FreeGroup+imid+MMddHHMM
 MMddHHMM = (月日时分)+1-1100的随机数
 */
#define  CreatGroup_GId_prefix  @"FreeGroup"

- (NSString *)creatOneGroupId{
    NSString *timeIvStr = [YTimeStamp getNowTimeTimesMDHMStr];
    NSString *subFixStr = [NSString stringWithFormat:@"%d",  [Y_ToolOfOthers getRandomInt:1 to:1100]];
    NSString *okStr = [NSString stringWithFormat:@"%@%@%@%@",CreatGroup_GId_prefix,[ShareUserInfo share].userInfo.imId,timeIvStr,subFixStr];
    return okStr;
}
#pragma mark == nowAddGroupAction
- (void)nowAddGroupAction{
    
    if(self.headerView.textFied.text.length<=0){
        NSString *titlePS = Y_LocaleTypeFile_NSLocalString(@"请输入群名称");
        Y_SVP_SHOW_ERR_MES(titlePS);
        return;
    }
    BOOL isNeedAgreeType = self.headerView.verSwitch.isOn;//加群需群主或管理员审批Public  或者自由进出Meeting
    NSString *groupTypeStr = isNeedAgreeType ? @"Public" : @"Meeting";
    NSString *cgroupId = [self creatOneGroupId];
    NSLog(@"%@",cgroupId);

    WEAKSELF
    if(self.chooseFriendsList.count<=0){
        [[V2TIMManager sharedInstance] createGroup:groupTypeStr
                                           groupID:cgroupId
                                         groupName:self.headerView.textFied.text succ:^(NSString *groupID) {
            NSLog(@"创建成功！%@",groupID);//创建成功！@TGS#2STKLFENX
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf goGroupChatvcWihtGid:groupID];
        } fail:^(int code, NSString *desc) {
            NSLog(@"创建失败 code=%d,desc= %@",code,desc);
            Y_SVP_SHOW_ERR_MES(desc);

        }];
    }else{
        V2TIMGroupInfo *ginfo = [[V2TIMGroupInfo alloc]init];
        ginfo.groupType = groupTypeStr;
        ginfo.groupName = self.headerView.textFied.text;
        ginfo.groupID = cgroupId;
//        info.faceURL = @"";
        NSMutableArray *mArr = [[NSMutableArray alloc]init];
        for (NSString *uid in self.chooseFriendsList) {
            V2TIMCreateGroupMemberInfo *mInfo = [[V2TIMCreateGroupMemberInfo alloc]init];
            mInfo.userID = uid;
            [mArr addObject:mInfo];
        }
        [[V2TIMManager sharedInstance] createGroup:ginfo memberList:[NSArray arrayWithArray:mArr] succ:^(NSString *groupID) {
            NSLog(@"创建成功！%@",groupID);
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf goGroupChatvcWihtGid:groupID];
        } fail:^(int code, NSString *desc) {
            NSLog(@"创建失败 code=%d,desc= %@",code,desc);
            Y_SVP_SHOW_ERR_MES(desc);
        }];
    }
}
#pragma mark ===

- (void)navRemSelfVc{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"CreatGroupVc")]) {
                [tempArray removeObject:vc];
            }
        }
    self.navigationController.viewControllers = tempArray;
}


- (void)goGroupChatvcWihtGid:(NSString *)groupID{
    
    TUIChatConversationModel *conversationModel = [[TUIChatConversationModel alloc] init];
    conversationModel.groupID = groupID;
    conversationModel.title = self.headerView.textFied.text;

//    ImChatVc *vc = [[ImChatVc alloc]init];
//    vc.converInfo  = data;
//    vc.isGroupType =  YES;
//    vc.groupId = groupID;
//    vc.title = self.headerView.textFied.text;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    TUIBaseChatViewController_Minimalist *chatVC = nil;
    if (conversationModel.groupID.length > 0) {
        chatVC = [[TUIGroupChatViewController_Minimalist alloc] init];
    } else if (conversationModel.userID.length > 0) {
        chatVC = [[TUIC2CChatViewController_Minimalist alloc] init];
    }
    chatVC.conversationData = conversationModel;
    chatVC.title = conversationModel.title;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
 
        
       
   
    
  
}
 
@end


#pragma mark ==== CreatGroupVcSubCell

@implementation CreatGroupVcSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(20.0);
            make.left.equalTo(_leftBtn.superview).offset(10);
            make.centerY.equalTo(_leftBtn.superview);
        }];
         
    }
    return self;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarView.frame = CGRectMake(kScale390(16)+40, (self.bounds.size.height - kScale390(40) )*0.5, kScale390(40), kScale390(40));//40
     
    
    if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRounded) {
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2;
    } else if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRadiusCorner) {
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = [TUIConfig defaultConfig].avatarCornerRadius;
    }
    
    self.titleLabel.mm_left(self.avatarView.mm_maxX+12).mm_height(20).mm__centerY(self.avatarView.mm_centerY).mm_flexToRight(0);
    
    self.onlineStatusIcon.mm_width(kScale * 15).mm_height(kScale * 15);
    self.onlineStatusIcon.mm_x = CGRectGetMaxX(self.avatarView.frame) - 0.5 * self.onlineStatusIcon.mm_w - 3 * kScale;
    self.onlineStatusIcon.mm_y = CGRectGetMaxY(self.avatarView.frame) - self.onlineStatusIcon.mm_w;
    self.onlineStatusIcon.layer.cornerRadius = 0.5 * self.onlineStatusIcon.mm_w;

    self.separtorView.frame = CGRectMake(self.avatarView.mm_maxX, self.contentView.mm_h - 1, self.contentView.mm_w, 1);
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *round_white = [[UIImage imageNamed:@"round_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];// 始终根据Tint Color绘制图片，忽略图片的颜色信息。
        _leftBtn.tintColor = Color_Socialize_GreenColor;
        [_leftBtn newAnBtnWithNomalImg:round_white selectedImg:[UIImage imageNamed:@"选中_gColor"]];
        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (void)leftBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(isNotNil(self.btnActionBlock)){
        self.btnActionBlock(sender, sender.tag);
    }
}

@end
