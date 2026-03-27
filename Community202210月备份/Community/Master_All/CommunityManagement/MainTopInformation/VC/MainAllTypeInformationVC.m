//
//  MainAllTypeInformationVC.m
//  Community
//
//  Created by 余莹 on 2021/8/30.
//

#import "MainAllTypeInformationVC.h"
#import "MainAllTypeInformationSubListVC.h"
#import "MainAllTypeInformationSubPayMoneyTypeListVC.h"
#import "ZYChatVc.h"
#import "TopInformationModel.h"
#import "MainAllTypeImInfoData.h"
#import "MainAllTypeInformationListTableViewCell.h"
#define MainAllTypeInformationListTableViewCell_Identifier    @"MainAllTypeInformationListTableViewCell"
#define TopInformationCell_H 72

//static NSString *publicImId_PayMoney = @"zhsj_2cb099683cb44944a9811edced10415c@public";  // 支付类型的通知id

@interface MainAllTypeInformationVC ()
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation MainAllTypeInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"总消息";//消息数据接口待改
    [self initNeedRefreshNotice];
    if (self.infomationVc_type == InfomationVc_Type_smallShopMain){
       //仓储小店
       [self setupNavigationBarWhiteStyle];
   }
    self.pageNum = 1;
    [self initRightNavItem];
    [self addRefresh];

}
- (void)vcSelfBackgroundColorOfThemeColorVcBack{
    if (self.infomationVc_type == InfomationVc_Type_smallShopMain){
       //仓储小店
        self.view.backgroundColor = Y_RGBA(240, 241, 246, 1);
        self.tableView.backgroundColor = Y_RGBA(240, 241, 246, 1);
    }else{
        self.tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;

    }

}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//#pragma mark == 主题色 重写 （聊天vc返回后nav消失问题 Hidden 处理） 后续没得透明色了
    [self initData]; //未读消息刷新
    if (self.infomationVc_type == InfomationVc_Type_commnitMain) {
        [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            self.tableView.backgroundColor = [UIColor whiteColor];
        }

    }else if (self.infomationVc_type == InfomationVc_Type_smallShopMain){
        //仓储小店
        [self setupNavigationBarWhiteStyle];
   
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.infomationVc_type == InfomationVc_Type_commnitMain) {
        [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];

    }else if (self.infomationVc_type == InfomationVc_Type_smallShopMain){
        //仓储小店 白色
        [self setupNavigationBarWhiteStyle];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)initNeedRefreshNotice{//普通信息 + 撤回信息 刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:nil];//仅仅是聊天类型数据数据（多种chat类型）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg object:nil];//聊天类型数据 撤回信息
}
 
- (void)dealloc{
    NSLog(@"总消息列表界面的dealloc ");
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsg);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg);
}
 
- (void)initRightNavItem{
    UIButton *cleanItem = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanItem.titleLabel.font = [UIFont systemFontOfSize:12];
    [cleanItem setTitle:@"清除未读" forState:UIControlStateNormal];
    [cleanItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    cleanItem.bounds = CGRectMake(0 , 0, 24, 24);
    [cleanItem addTarget:self action:@selector(cleanItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cleanItemBar = [[UIBarButtonItem alloc]initWithCustomView:cleanItem];
    [self.navigationItem setRightBarButtonItem:cleanItemBar animated:YES];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}

- (void)initData{//消息类型列表
    self.pageNum = 1;
    WEAKSELF
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [MainAllTypeImInfoData initImMessageListWithArrBlcok:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (arr.count >0 ) {
            weakSelf.pageNum += 1;
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[MainAllTypeImInfoModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                if (arr.count>=Y_PAGE_SIZE) {
                    weakSelf.tableView.mj_footer.hidden = NO;
                }else{
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
            });
        }
    }];
}
- (void)footerLoadMoreNewsData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    WEAKSELF
    [MainAllTypeImInfoData upDataImMessageListWithPageNum:self.pageNum withArrBlcok:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (arr.count >0 ) {
            weakSelf.pageNum += 1;
            [weakSelf.dataSourceArr addObjectsFromArray:[MainAllTypeImInfoModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
}
#pragma mark ---cleanItemAction
- (void)cleanItemAction:(UIBarButtonItem *)sender{
    DLog(@"清除未读");
    //全清空
    if (self.dataSourceArr.count<=0) {
        Y_SVP_SHOW_INFO_MES(@"暂无可以清空的数据");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"clearAll"];
    [self clearnWithParms:parms];
}

//清空部分
- (void)clearnWithSessionId:(NSInteger)sessionId{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(0) forKey:@"clearAll"];
    [parms setValue:@[@(sessionId)] forKey:@"sessionIds"];
    [self clearnWithParms:parms];
}
- (void)clearnWithParms:(NSMutableDictionary *)parms{
    WEAKSELF
    [MainAllTypeImInfoData deleImMessageWithParms:parms withBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            [weakSelf initData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainAllTypeInformationListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationListTableViewCell_Identifier];
    if (!cell) {
        cell = [[MainAllTypeInformationListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MainAllTypeInformationListTableViewCell_Identifier];
    }
    [cell fillDataWithModel:self.dataSourceArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TopInformationCell_H;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"");
    MainAllTypeImInfoModel *model = self.dataSourceArr[indexPath.row];
   // [self clearnWithSessionId:model.ID];//清除未读 session_id(会话内部需要使用此做回执 在会话内调用两种已读处理，不在列表做已读处理)（指 会话信息类型）
    WEAKSELF
    if (model.type == 2) {// 支付类型的通知
        MainAllTypeInformationSubListVC *vc = [[MainAllTypeInformationSubListVC alloc]init];
        vc.model = self.dataSourceArr[indexPath.row];
        [self clearnWithSessionId:model.ID];//支付消息的清空泡泡
        [self pushVc:vc];
    }else{//总消息类型带入后跳转 1 文本类型 其他暂定文本类型
        
        //--------------------------------------------------------好友类型 商户类型 陌生人类型 的会话
        
        NSString *toUserNickName  = @"";
        NSString *toUserimidStr = @"";
        NSString *toUserAccountUUID = @"";
        if(model.contact_type){//有子数据contact
            toUserNickName  = model.contact.friendRemark.length>0 ? model.contact.friendRemark : model.contact.nickName;
            toUserimidStr  = model.contact.imId;
            toUserAccountUUID = model.contact.otherAccount;
        }else{//无contact
            toUserNickName = model.nike_name;
            toUserimidStr = model.im_id;
            toUserAccountUUID = model.to_user;
        }
        //空
        if (toUserNickName.length==0) {//有第二级别数据备注和昵称都@“”的情况 还是需要第一级别的名字字段
            toUserNickName = model.nike_name;
        }
        if (toUserimidStr.length<0) {
            Y_SVP_SHOW_ERR_MES(@"ID异常，暂不能通信。");
            return;
        }
        //to_user_type
        if (model.to_user_type == 0) {
            Y_SVP_SHOW_ERR_MES(@"非联系人！不可聊天");
            return;
        }else if (model.to_user_type == 1){//好友聊天
            dispatch_async(dispatch_get_main_queue(), ^{
                ZYChatVc *vc = [[ZYChatVc alloc] init];
                ChatVc_Seesion_type thishatVc_Seesion_type = ChatVc_Seesion_type_Friend;
                BOOL isMoShengRenTypeBoolNotShowRightItemBool = NO;//好友类型 非陌生人
                NSString *fImid = toUserimidStr;
                NSString *fAccountUUID = @"";
                NSString *fNickName = toUserNickName.length>0 ? toUserNickName  : @"未知昵称";
                BOOL isFriendTypeIsDeletNotAllowSendMsgBool = NO;
                [vc fillThisNomalChatVcSubInfoWithClearnUseID:model.ID  withSessionID:@"" withChatVcToUseType:thishatVc_Seesion_type withNotShowRightItemMSRBool:isMoShengRenTypeBoolNotShowRightItemBool withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:isFriendTypeIsDeletNotAllowSendMsgBool];
                [weakSelf pushVc:vc];
            });
        }else if(model.to_user_type == 2){//群聊天
            dispatch_async(dispatch_get_main_queue(), ^{
                ZYChatVc *vc = [[ZYChatVc alloc] init];
                [vc fillThisGroupTypeChatVcSubInfoWithClearnUseID:model.ID withSessionID:toUserAccountUUID  withChatVcToUseType:ChatVc_Seesion_type_Group withGroupInfoDic:weakSelf.dataSourceArr[indexPath.row]];
                [weakSelf pushVc:vc];
            });
        }else if(model.to_user_type == 3){//3公众号
            //test 支付助手类型测试数据2
            /**
             if (indexPath.row == 0) {
                 model.type = 2;//更改主类型
                 MainAllTypeInformationSubListVC *vc = [[MainAllTypeInformationSubListVC alloc]init];
                 vc.model = self.dataSourceArr[indexPath.row];
                 vc.model.type = 2;
                 [self clearnWithSessionId:model.ID];//非支付消息类型的其他公众号的清空泡泡
                 [self pushVc:vc];
                 return;
             }
             
             */

            MainAllTypeInformationSubListVC *vc = [[MainAllTypeInformationSubListVC alloc]init];
            vc.model = self.dataSourceArr[indexPath.row];
            [self clearnWithSessionId:model.ID];//非支付消息类型的其他公众号的清空泡泡
            [self pushVc:vc];
        }else if(model.to_user_type == 4){//4商户聊天
            [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:model.ID  withImIdStr:toUserimidStr withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf pushVc:willPushVc];
                    });
                }
            }];
            
        }else{//  5陌生人 stranger聊天
            [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:model.ID  withImIdStr:toUserimidStr withThisStrangerChatType:ChatVc_Stranger_Chat_Application_houserOrstranger withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf pushVc:willPushVc];
                    });
                }
            }];
            
            
        }
        
    }
    //1012 重新判断类型 
}

//删除

//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MainAllTypeImInfoModel *model = self.dataSourceArr[indexPath.row];
        [self clearnWithSessionId:model.ID];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"清除";
}
@end
