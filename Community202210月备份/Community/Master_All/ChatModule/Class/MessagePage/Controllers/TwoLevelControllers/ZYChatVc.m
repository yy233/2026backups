//
//  ZYChatVc.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYChatVc.h"
#import "ZYChatInformationVc.h"
#import "ZYChatUserInfoVc.h"
#import "ZYChatView.h"
#import "ChatFriendVcSetTableVc.h"
#import "ChatOneUserAndOwnUserTheRelationWithChatVcUseModel.h"
//
#import "SocketRocketUtility.h"
#import "ChatManagerData.h"
#import "ChatFriendMessageModel.h"
#import "ChatGroupMessageModel.h"
#import "ChatGroupInfoToMeModel.h"
#import "ChatNotReadMsgModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatShowMessageDataDeal.h"
//
#import "ChatBottomViewSubVoicePopView.h"
#import "ChatVoiceDataDealTool.h"
#import "VoiceDownAndSavePlayManage.h"
//
#import "ChatShowLocateAddressVc.h"
//
#import "ZYPositioningManager.h"
#import "ZYLocationInfoTool.h"
//
#import "FBKVOController.h"
#import "ChatVcUseData.h"

#define Tag_ScrollView_Use_BigImg   (999)

static NSString *kpublicimage = @"public.image";
static NSString *kpublicmovie = @"public.movie";

 
@interface ZYChatVc () <ZYChatViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate,ChatBottomViewSubVoicePopViewDelegate,BasePopViewDelegate>

//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) ChatVcMsgViewModel *viewModel;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) ZYChatView *chatView;
//
@property (nonatomic,strong) ChatBottomViewSubVoicePopView *bottomViewSubVoicePopView;

//______

//联系人类型
// ChatVc_Seesion_type;// ==(to user type)  || ==  0 表示不存联系人关系（不可聊天） 1:好友、2、群、3、订阅号 4商家、服务号、5陌生人(可聊天)
/**
 好友类型他方ID 有短的查询类imid 和 长的通讯类uuid (po self.friendUUID zhsj_210cf5172f914d6a92ffa673bd4b2d04@user);
 */
@property (nonatomic,assign) NSInteger poplistVcWillClearnUseId;
@property (nonatomic,strong) NSString *friendNickName;//titleL 使用

@property (nonatomic,strong) NSString *friendUUID;//账户id  account类型（在发送消息类型中使用）
@property (nonatomic,strong) NSString *chatVcWillUseImId;// （在查询接口类型中使用较多）
 
//联系人类型：0 表示不存联系人关系（不可聊天），1:好友、2、群、3、订阅号 4商家、服务号、5陌生人(可聊天)
@property (nonatomic,assign) BOOL isMoShengRenTypeBoolNotShowRightItem;//租客等陌生人时 不显示右上角 不走资料设置 (有租房情况so不用这个键做各种类型的聊天允许判断)  |1213活动类型 不显示右上角 不走资料设置页
@property (nonatomic,assign) BOOL isNotChatPersonNotAllowedSendMsgBool;//0不存联系人关系（不可聊天） 5陌生人(可聊天)
@property (nonatomic,assign) BOOL isDeletPersonNotAllowedSendMsgBool;//好友关系已经删除好友；
//
@property (nonatomic,strong) NSDictionary *groupInfoDic;//群基础信息dic
//
@property (nonatomic,strong) NSString *thisChatVcSessionId;//2022 0323 增入 会话id
@property (nonatomic,assign) ChatVc_Seesion_type thisChatVc_Seesion_type;//会话类型==联系人类型
//______


@property (nonatomic,strong) ChatGroupInfoToMeModel *groupInfoToMeModel;//用户在某群的信息
@property (nonatomic,strong) ChatGroupModel *groupModel;//群基础信息Model
@property (nonatomic,strong) NSMutableArray *dataSourceOfMsgList;//消息数据list
@property (nonatomic,strong) NSMutableArray *dataSourceOfMemberList;//成员数据list
@property (nonatomic,strong) NSMutableDictionary *dataSourceOfMemberImgUrlStrDic;//成员数据 —— sub 以ID为键imgStr为值
@property (nonatomic,strong) NSMutableDictionary *dataSourceOfMemberNickNameStrDic;//成员数据 —— sub 以ID为键nameStr为值
//img用的
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) ChatOneUserAndOwnUserTheRelationWithChatVcUseModel *saveRelationModel;//询一个联系人(getOne接口 ) 得到和当前用户的关系具体数据
//sendMsg发送数据的base部分
@property (nonatomic,strong) NSMutableDictionary *chatMsgWillSendBaseInfoDic;//发送信息时 需要代入的固定信息
//刷新时需要的旧数据
@property (nonatomic,strong) NSMutableArray *saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr;//保存当前socketMsg ｜区别于刷新加载的历史数据｜总msg数据要两种（本arr防止收到信息后再次pageN add 时 数据只有history刷新 缺失新收新发的数剧）

@end

@implementation ZYChatVc


//非群
- (void)fillThisNomalChatVcSubInfoWithClearnUseID:(NSInteger)clearnUseId
                                    withSessionID:(NSString *)thisChatVcSessionId
                            withChatVcToUseType:(ChatVc_Seesion_type)thisChatVc_Seesion_type
                    withNotShowRightItemMSRBool:(BOOL)isMoShengRenTypeBoolNotShowRightItem
                               withWillUseFImId:(NSString *)chatVcWillUseImId
                        withWillUseFAccountUUID:(NSString *)friendUUID
                           withWillUseFNickName:(NSString *)friendNickName
withFriendTypeIsDeletPersonNotAllowedSendMsgBool:(BOOL)isDeletPersonNotAllowedSendMsgBool{
    self.poplistVcWillClearnUseId = clearnUseId;
    self.thisChatVcSessionId = thisChatVcSessionId;
    self.thisChatVc_Seesion_type = thisChatVc_Seesion_type;
    self.isMoShengRenTypeBoolNotShowRightItem = isMoShengRenTypeBoolNotShowRightItem;
    self.chatVcWillUseImId = chatVcWillUseImId;
    self.friendUUID = friendUUID;
    self.friendNickName = friendNickName;
    self.isDeletPersonNotAllowedSendMsgBool = isDeletPersonNotAllowedSendMsgBool;
}


//群
- (void)fillThisGroupTypeChatVcSubInfoWithClearnUseID:(NSInteger)clearnUseId
                                        withSessionID:(NSString *)thisChatVcSessionId
                                withChatVcToUseType:(ChatVc_Seesion_type)thisChatVc_Seesion_type
                                   withGroupInfoDic:(NSDictionary *)groupInfoDic{
    self.poplistVcWillClearnUseId = clearnUseId;
    self.thisChatVcSessionId = thisChatVcSessionId;
    self.thisChatVc_Seesion_type = thisChatVc_Seesion_type;//group
    self.groupInfoDic = groupInfoDic;
}

#pragma  mark ==  数据部分
- (NSMutableArray *)saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr{
    if (!_saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr) {
        _saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr;
}
- (NSMutableDictionary *)chatMsgWillSendBaseInfoDic{
    if (!_chatMsgWillSendBaseInfoDic) {
        _chatMsgWillSendBaseInfoDic  = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _chatMsgWillSendBaseInfoDic;
}
- (void)viewWillDisappear:(BOOL)animated{//离开本页就关闭音频
    [super viewWillDisappear:animated];
    Y_NSNotificationCenter_PostNotice_NilObject_Name( NoticeName_TakeInitiativeToStopVoice);
}
#pragma mark == refresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(moreHistoryMsgData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onePageHistoryMsgData)];
    self.chatView.tableView.mj_header = headeerRefresh;
    self.chatView.tableView.mj_footer = footerRefresh;
    self.chatView.tableView.mj_header.hidden = YES;

}
- (void)onePageHistoryMsgData{
    [self.viewModel getDataListOnePage];//第一页数据
}
- (void)moreHistoryMsgData{
    [self.viewModel getDataListNextPage];//加载更多历史消息 headerRf
}
#pragma mark --- kvo
- (ChatVcMsgViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ChatVcMsgViewModel alloc]init];
    }
    return _viewModel;
}
- (void)addKvo{
    fbKVO = [FBKVOController controllerWithObserver:self];
    //列表msg
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        [weakSelf getKVoPathStr:fbKvoKeyPath];
    }];
  
}
- (void)getKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){ //success or fail msg
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [weakSelf.chatView.tableView.mj_header endRefreshing];
            [weakSelf.chatView.tableView.mj_footer endRefreshing];
        });
        
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);//成功有提示
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);//请求失败有提示
                if (weakSelf.viewModel.dataOfArr.count<=0) {//失败状态&&当前0count
                }else{
                }
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        //SUCCESS
        weakSelf.dataSourceOfMsgList = [NSMutableArray arrayWithArray: weakSelf.viewModel.dataOfArr];
        if (weakSelf.dataSourceOfMsgList.count >= Y_PAGE_SIZE_10) {
            weakSelf.chatView.tableView.mj_header.hidden = NO;//顶部为更多历史消息
        }
        //来回刷新中途有socket信息时 的展示消息处理
        if (weakSelf.viewModel.pageNum <= 2) {//这是第一页 可直接用获取的历史数据,(success后会pagesize变成2的将要使用的数值) (这里需要 清空旧的socketMsgArr 下页不需要加入已经有了的msg数据 )
            self.saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr = [[NSMutableArray alloc]initWithCapacity:0];
        }else if(self.saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr.count>0){//加上当前页发送接收的socket数据
            [weakSelf.dataSourceOfMsgList addObjectsFromArray:self.saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr];
        }
        
        //付给view
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
                [weakSelf.chatView fillDataWithGroupHistoryMsg:weakSelf.dataSourceOfMsgList];
            }else{
                [weakSelf.chatView fillDataWithFriendHistoryMsg:weakSelf.dataSourceOfMsgList];
            }
        });
        [weakSelf historyGetMsgSetReadType];//历史消息 作已读
        [weakSelf setThisSeestionIdOfMessageListVcIsReadedTypeWitGetMessage];
    }else{
    }
}

#pragma mark --- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefresh];
    [self addKvo];
    //vm
    self.viewModel.chatVc_Seesion_type = self.thisChatVc_Seesion_type;
    //init
    self.saveRelationModel  = [[ChatOneUserAndOwnUserTheRelationWithChatVcUseModel alloc]init];
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        //当前群 自己的权限信息 自己设置的背景信息等；
       self.groupInfoToMeModel = [[ChatGroupInfoToMeModel alloc]init];
        //未读消息列表跳转所带群信息
        ChatNotReadMsgModel *notReadModel = [ChatNotReadMsgModel mj_objectWithKeyValues:self.groupInfoDic];
        self.groupModel = [[ChatGroupModel alloc]init];
        self.groupModel.avatarMediaId = notReadModel.head_img_max_url;
        self.groupModel.groupName = notReadModel.nike_name;
        self.groupModel.groupUuid = notReadModel.to_group;
        self.groupModel.createUserId = @"";
        self.titleLabel.text = [TextShowWithModelStr textShowWithModelStr:self.groupModel.groupName];
        //群列表消息所带群信息
        if (self.groupModel.groupUuid.length==0) {
            self.groupModel =  [ChatGroupModel mj_objectWithKeyValues:self.groupInfoDic];
            self.titleLabel.text = [TextShowWithModelStr textShowWithModelStr:self.groupModel.groupName];
        }
        self.viewModel.gID = self.groupModel.groupUuid;
//        self.chatInfoDic = @{@"session_id":self.chatVcWillUseImId}.mutableCopy;
        self.thisChatVcSessionId = self.chatVcWillUseImId;//会话id 存下来
        self.saveRelationModel.sessionId = self.thisChatVcSessionId;
    }else{//好友类型
        self.titleLabel.text = self.friendNickName;
        [self initFriendAndOwnRelationGetOneInfo];//初始数据
        if (self.isMoShengRenTypeBoolNotShowRightItem) {
            self.moreButton.hidden = YES;
        }
    }
    [self setUI];
    [self initNotice];
    
}
#pragma mark --- 数据初始
- (void)initFriendAndOwnRelationGetOneInfo{
    if (self.chatVcWillUseImId.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"当前好友imid异常！");
        return;
    }
    WEAKSELF
    if (self.thisChatVc_Seesion_type > 1) {//非好友会话
        weakSelf.viewModel.fID = weakSelf.friendUUID;
        weakSelf.saveRelationModel = [[ChatOneUserAndOwnUserTheRelationWithChatVcUseModel alloc]init];
        weakSelf.saveRelationModel.sessionId = weakSelf.thisChatVcSessionId;
        weakSelf.chatMsgWillSendBaseInfoDic = @{@"session_id":weakSelf.saveRelationModel.sessionId}.mutableCopy;
        //weakSelf.thisChatVcSessionId //会话id 已经导入
        [weakSelf initData];//  新加载列表数据即可 历史数据
        return;
    }
    
    [ChatManagerData chatOtherUserGetOneInfoWithImId:self.chatVcWillUseImId withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.saveRelationModel  = [ChatOneUserAndOwnUserTheRelationWithChatVcUseModel mj_objectWithKeyValues:dic];
            
            NSString *friendUUIDStr = [TextShowWithModelStr textShowWithNotNullStr:  weakSelf.saveRelationModel.otherAccount];
            if (![friendUUIDStr isEqualToString:  weakSelf.friendUUID]) {     ///上页面页暂无touser账号id  可以在chatvc内用imid做查询 用账号id结果重新赋值
                weakSelf.friendUUID = friendUUIDStr;
            }
            weakSelf.viewModel.fID = weakSelf.friendUUID;
            weakSelf.chatMsgWillSendBaseInfoDic = @{@"session_id":weakSelf.saveRelationModel.sessionId}.mutableCopy;
            weakSelf.thisChatVcSessionId = weakSelf.saveRelationModel.sessionId;//会话id 存下来
            [weakSelf initData];//  新加载列表数据即可 历史数据
            
            if (weakSelf.saveRelationModel.friendRemark.length>0 ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.titleLabel.text  = weakSelf.saveRelationModel.friendRemark;
                });
            }
        }
    }];
}
#pragma mark ================================================================================== 基础数据 initData

- (void)initData{//基础的非msg数据
    WEAKSELF
    Y_SVP_SHOW_MES_IsLoading_15Delay
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        //群成员列表
        [self initGroupMemberList];
        //历史消息
        [self.viewModel getDataListOnePage];
        //当前群自己设置的信息
        [ChatManagerData chatGroupOwnSetInfoWithGroupId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withlistBlock:^(NSDictionary * dic, BOOL success) {
            Y_SVP_DISMISS
            if (success) { 
                STRONGSELF
               self.groupInfoToMeModel = [ChatGroupInfoToMeModel mj_objectWithKeyValues:dic];
                //当前群背景有值
                NSString *willSetBackImgUrlStr = [TextShowWithModelStr textShowWithModelStr:self.groupInfoToMeModel.personalBackground].length>0   ? [TextShowWithModelStr textShowWithModelStr:self.groupInfoToMeModel.personalBackground] : [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.personalBackground;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.chatView fillChatViewBackImgWithUrlStr:willSetBackImgUrlStr];
                });
            }
        }];
    }else{
        
        //昵称和图片地址处理后给view
        [self.chatView fillChatViewBackImgWithUrlStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.personalBackground];
        //历史消息
        [self.viewModel getDataListOnePage];
    }
    
}
- (void)initGroupMemberList{
    //群成员列表
    WEAKSELF
    [ChatManagerData chatGroupAllMemberListWithGroupId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withlistBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            DLog(@"%@",arr);
            STRONGSELF
            strongSelf.dataSourceOfMemberList = [[NSMutableArray alloc]initWithArray:arr];
            strongSelf.dataSourceOfMemberNickNameStrDic = [[NSMutableDictionary alloc]init];
            strongSelf.dataSourceOfMemberImgUrlStrDic = [[NSMutableDictionary alloc]init];
            for ( NSDictionary *memberInfoDic  in arr) {
                [strongSelf dealMemberDic:memberInfoDic];
            }
            //昵称和图片地址处理后给view
            [strongSelf.chatView fillGroupMemberImgDic:strongSelf.dataSourceOfMemberImgUrlStrDic andNameDic:strongSelf.dataSourceOfMemberNickNameStrDic];
        }
    }];
}
//成员数据
- (void)dealMemberDic:(NSDictionary *)getMemberDic{
    NSString *userUuid = [[getMemberDic allKeys]containsObject:@"userUuid"] ? getMemberDic[@"userUuid"] :@"";
    NSString *avatar = [[getMemberDic allKeys]containsObject:@"avatar"] ? getMemberDic[@"avatar"] :@"";
    NSString *remarks = [[getMemberDic allKeys]containsObject:@"remarks"] ? getMemberDic[@"remarks"] :@"";
    [self.dataSourceOfMemberImgUrlStrDic setValue:avatar forKey:userUuid];
    [self.dataSourceOfMemberNickNameStrDic setValue:remarks forKey:userUuid];
 
}
#pragma mark ================================================================================== 信息相关
#pragma mark === notice init dealoc
- (void)initNotice{
    [self initMsgNotice];
    [self initOtherNotice];
}
- (void)initMsgNotice{
  //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
  //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_RevokeChatMsg:) name:kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_ChatMsg:) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:nil];//多类型会话消息
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_Group_MemberAdd:) name:kWebSocketdidReceiveMessage_NoticeName_Group_MemberAdd object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_ChatMsgResponse_SendOk:) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendOk object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_ChatMsgResponse_SendFail:) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendFail object:nil];
 
}
- (void)initOtherNotice{
 
    Y_NSNotificationCenter_Creat_NameAction(kWebSocketdidReceiveMessage_NoticeName_ChatMsg_ReadedInfo, chatVcGetReadedNotice:);//已读回执
    Y_NSNotificationCenter_Creat_NameAction(ChatVcChangeBackImg_NoticeName, chatVcChangeBackImg:);
    Y_NSNotificationCenter_Creat_NameAction(ChatSetFriendRemarkName_NoticeName, friendRemarkNameChangedNotice:);
    Y_NSNotificationCenter_Creat_NameAction(ChatGroupAddOrDeletMember_NoticeName, groupMemberChangedNotice:); //成员数据更新
    //音频文件
    Y_NSNotificationCenter_Creat_NameAction(ChatVoicePalyingEnd_NoticeName, chatVoicePalyingEndNotice:); //音频动画数据更新
}

 
- (void)dealloc{
    //chatmsginfo聊天数据
    Y_NSNotificationCenter_RemoveNotice_Name(ChatVcChangeBackImg_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsg);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsg_ReadedInfo);
    //other 其他
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_Group_MemberAdd);
    Y_NSNotificationCenter_RemoveNotice_Name(ChatSetFriendRemarkName_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(ChatGroupAddOrDeletMember_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendOk);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendFail);

}
#pragma mark ==  other notice action
#pragma mark == 已读回执
 
- (void)chatVcGetReadedNotice:(NSNotification*)notice{
    NSDictionary *thisReadedMsgAllKeyDic = notice.object;
    NSLog(@"已读回执  =  %@",thisReadedMsgAllKeyDic);
    NSDictionary *subReadInfoDic = [thisReadedMsgAllKeyDic objectForKey:kWebSocketMsgTypeKey_MsgReadNotify];
    NSString *thisReadedSeesionIdStr =  [[subReadInfoDic allKeys]containsObject:@"sessionId"] ?  [TextShowWithModelStr textShowWithModelStr:[subReadInfoDic objectForKey:@"sessionId"]] : @"";
    if ( ![thisReadedSeesionIdStr isEqualToString: self.thisChatVcSessionId ]) {
        return;//非本会话的 已读回执 不需要更新UI
    }
    NSArray *thisReadMsgIdArr = [[subReadInfoDic allKeys]containsObject:@"msgIds"] ? [NSArray arrayWithArray:[subReadInfoDic objectForKey:@"msgIds"]] : @[];
    NSInteger readChagneCount = thisReadMsgIdArr.count;//数量控制循环暂停 减少循环次数
    for (int i = 0; i < self.dataSourceOfMsgList.count; i++) {
        ChatFriendMessageModel *model =  [ChatFriendMessageModel mj_objectWithKeyValues: self.dataSourceOfMsgList[i]];
        for (int j = 0; j < thisReadMsgIdArr.count; j++) {
            if ([thisReadMsgIdArr[j] isEqualToString: model.msg_id]) {
                model.read_count+=1;
                NSDictionary *oneObj = [model mj_keyValues];
                [self.dataSourceOfMsgList replaceObjectAtIndex:i withObject: oneObj];
                readChagneCount -= 1;//改变数量
                if (readChagneCount==0) {
                    break;
                }
            }
        }
    }
    //新readCount改变了的数据刷新UI
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        [self.chatView fillDataWithGroupHistoryMsg:self.dataSourceOfMsgList];
    }else{
        [self.chatView fillDataWithFriendHistoryMsg:self.dataSourceOfMsgList];
    }

}
#pragma mark == 群成员数据更新
- (void)groupMemberChangedNotice:(NSNotification*)notice{
    [self initGroupMemberList];;
}
#pragma mark === 好友备注
- (void)friendRemarkNameChangedNotice:(NSNotification*)notice{
    NSString *remarkStr =  notice.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = remarkStr;
    });
}
#pragma mark === 背景图
- (void)chatVcChangeBackImg:(NSNotification *)notice{
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONGSELF
            [strongSelf.chatView fillChatViewBackImgWithUrlStr:[NSString stringWithString:notice.object]];
        });
    }else{
        //好友会话 暂时使用用户信息里面的背景图数据 需要要更新
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONGSELF
            [strongSelf.chatView fillChatViewBackImgWithUrlStr:[NSString stringWithString:notice.object]];
        });
    }
}
#pragma mark ======================================================================
#pragma mark == 检查是否为本会话
- (BOOL)isThisSeestionIdBoolWithGetMsgNotice:(NSNotification *)notice{
    BOOL isThisSesstionIdBool = NO;
    NSDictionary *getMsgDic = notice.object;
    ChatFriendMessageModel *willCheckMsgIsThisSeesionModel = [ChatFriendMessageModel mj_objectWithKeyValues:getMsgDic];
    if ( [[TextShowWithModelStr textShowWithModelStr:willCheckMsgIsThisSeesionModel.session_id] isEqualToString:self.thisChatVcSessionId] ) {
        isThisSesstionIdBool = YES;
    }
    
    DLog(@" *********  检查是否为本会话 ********  %d",isThisSesstionIdBool);
    return isThisSesstionIdBool;
}

#pragma mark === 收 | 服务器的回复response 用户发送成功或发送失败
//response
- (void)SRWebSocketdidReceiveMessageNote_ChatMsgResponse_SendOk:(NSNotification *)notice{//替换后更新单行 根据msgid 替换掉 seqid 防止seqid错位
    if (![self isThisSeestionIdBoolWithGetMsgNotice:notice]) {//检查是否为本会话
        return;
    }
    [ChatShowMessageDataDeal chatMsgListDic:self.dataSourceOfMsgList wtihGetRespondOkDic:notice.object withReplaceSendDicSubSeqIdOkArr:^(NSMutableArray * _Nonnull okArr) {
        self.dataSourceOfMsgList  = [NSMutableArray arrayWithArray:okArr];
    }];
}
//response
- (void)SRWebSocketdidReceiveMessageNote_ChatMsgResponse_SendFail:(NSNotification *)notice{//替换成失败提示用户后更新列表
    if (![self isThisSeestionIdBoolWithGetMsgNotice:notice]) {//检查是否为本会话
        return;
    }
     [ChatShowMessageDataDeal chatMsgListDic:self.dataSourceOfMsgList wtihGetRespondFailDic:notice.object withReplaceSendDicSubSeqIdOkArr:^(NSMutableArray * _Nonnull okArr) {
        self.dataSourceOfMsgList  = [NSMutableArray arrayWithArray:okArr];
        Y_SVP_SHOW_INFO_MES(@"信息发送失败");
        if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
            [self.chatView fillDataWithGroupHistoryMsg:self.dataSourceOfMsgList];
        }else{
            [self.chatView fillDataWithFriendHistoryMsg:self.dataSourceOfMsgList];
        }
    }];
}
#pragma mark === 收 ｜撤回消息数据
- (void)SRWebSocketdidReceiveMessageNote_RevokeChatMsg:(NSNotification *)notice{//替换后更新单行
    if (![self isThisSeestionIdBoolWithGetMsgNotice:notice]) {//检查是否为本会话
        return;
    }
    DLog(@"收到啦。-------   撤回消息数据 %@",notice.object);
    NSInteger seqId = 0;
    if (![[notice.object allKeys]containsObject:@"revoke_msg"]) {
        return;
    }else{
        seqId = [[notice.object[@"revoke_msg"] objectForKey:@"sequence_id"] integerValue];
    }
    for (int i = 0; i < self.dataSourceOfMsgList.count; i ++) {
        ChatFriendMessageModel *msgModel  = [ChatFriendMessageModel mj_objectWithKeyValues: self.dataSourceOfMsgList[i]];
        NSInteger msgSeqId =  [msgModel.sequence_id integerValue];
        if (msgSeqId==seqId) {
            [self.dataSourceOfMsgList replaceObjectAtIndex:i withObject:notice.object];
            [self.chatView msgListViewloadRowNum:i withMsgListData:self.dataSourceOfMsgList];
        
            return;
        }
    }
    
}
#pragma mark === 收 ｜ 群消息类型 ｜群
- (void)SRWebSocketdidReceiveMessageNote_Group_MemberAdd:(NSNotification *)notice{
    if (![self isThisSeestionIdBoolWithGetMsgNotice:notice]) {//检查是否为本会话
        return;
    }
    DLog(@"收到啦。-------   新增了群成员 消息数据 %@",notice.object);//更新当前信息列表里msgid相同的dic 刷新列 成员列表刷新后给view数据

    [self initGroupMemberList];//成员列表数据更新
    [self getMsgInfo:notice.object];//消息更新
}

#pragma mark === 收 ｜文本类型|图.....｜好友会话or群

- (void)SRWebSocketdidReceiveMessageNote_ChatMsg:(NSNotification *)notice{
    if (![self isThisSeestionIdBoolWithGetMsgNotice:notice]) {//检查是否为本会话
        return;
    }
    //文本类型|图片类型｜包含系统类型
    [self getMsgInfo:notice.object];
    [self socketGetMsgSetReadTypeWithMsgDic:notice.object];
    [self setThisSeestionIdOfMessageListVcIsReadedTypeWitGetMessage];
}
#pragma mark ======================================== 已读处理
#pragma mark === 收  ________  | 信息收到后的已读UI处理 (当前cell內 已读状态)+ （0408列表有未读时 调取历史列表已读处理时 也要调此回执）
- (void)socketGetMsgSetReadTypeWithMsgDic:(NSMutableDictionary *)getMsgDic{

    ChatFriendMessageModel *model  = [ChatFriendMessageModel mj_objectWithKeyValues:getMsgDic];
    NSLog(@"已读回执用到的 ,%@ [自己= %@] 他人= %@ 。sid= %@",model.msg_id,self.friendUUID,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account,model.session_id);
    //已读处理
    [[ChatVcUseData share]chatMsgSetReadedTypeWithMsgId:[TextShowWithModelStr textShowWithModelStr:model.msg_id]
//                                             withToUser:[TextShowWithModelStr textShowWithModelStr:model.to_user]
//                                           withFromUser:[TextShowWithModelStr textShowWithModelStr:model.from_user]
                                             withToUser:[TextShowWithModelStr textShowWithModelStr: self.friendUUID]//用对方
                                           withFromUser:[TextShowWithModelStr textShowWithModelStr: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account] //用自己
                                          withSessionId:[TextShowWithModelStr textShowWithModelStr:model.session_id]];
    

}
#pragma mark === 收  ________  |历史消息 未读部分的 已读熟悉处理
- (void)historyGetMsgSetReadType{
    NSString *myAccount = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account;
    NSString *seessionId = @"";
    NSString *fromUser = @"";
    NSString *toUser = @"";
    NSMutableArray *msgIdArr =  [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 0 ; i < self.dataSourceOfMsgList.count;  i++  ) {
        ChatFriendMessageModel *model  = [ChatFriendMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList[i]];
        //基础数据
        if (i == 0) {
            seessionId = [TextShowWithModelStr textShowWithModelStr:model.session_id];
        }
        //自己接收的数据(touser==own) 才做已读状态提交 ｜ 自己发送的数据 由对方处理。
        if ([myAccount isEqualToString: [TextShowWithModelStr textShowWithModelStr:model.to_user] ] ) {
            fromUser = [TextShowWithModelStr textShowWithModelStr:model.from_user];
            toUser = [TextShowWithModelStr textShowWithModelStr:model.to_user];
            //未读状态的msg
            if (model.read_count<=0) {
                [msgIdArr addObject:[TextShowWithModelStr textShowWithModelStr:model.msg_id]];
            }
        }else{
            
        }
        
        
    }
    if (msgIdArr.count <= 0) {
        return;//无未读 则不需要做状态更改
    }
    NSLog(@"历史消息 拉取的数据内 的 已读回执用到的数据｜（ps列表页不做已读清空了） ,%@ [自己= %@] 他人= %@ 。sid= %@",msgIdArr,self.friendUUID,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account,seessionId);
    //拉的历史消息 内数据msgid对应置 已读回执
    [[ChatVcUseData share]chatMsgSetReadedTypeWithHistoryInfoMsgIdStrArr:msgIdArr
//                                                              withToUser:toUser
//                                                            withFromUser:fromUser
                                                              withToUser:[TextShowWithModelStr textShowWithModelStr: self.friendUUID]//用对方
                                                            withFromUser:[TextShowWithModelStr textShowWithModelStr: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account] //用自己
                                                           withSessionId:seessionId];
    
}

#pragma mark ====== 已读 每条收到的信息都置为已读 (列表的已读展示数据)
- (void)setThisSeestionIdOfMessageListVcIsReadedTypeWitGetMessage{
    if (self.poplistVcWillClearnUseId == 0) {
        NSLog(@"没有列表清空用的ID");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(0) forKey:@"clearAll"];
    [parms setValue:@[@(self.poplistVcWillClearnUseId)] forKey:@"sessionIds"];//self.thisChatVcSessionId 不是这个id
    [ChatManagerData chatHistoryNotReadChangeToReadedWithUnRedDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
        }else{
            DLog(@"列表清空失败");
        }
    }];
}
#pragma mark ======================================================================

#pragma mark == 是否能够发送信息
- (BOOL)isNotAllowedSendMsgBool{
    if (  self.saveRelationModel.otherPullBlackMe ) {
        Y_SVP_SHOW_ERR_MES(@"已被拉黑，暂不能发送信息");
        return YES;
    }
    if (self.isNotChatPersonNotAllowedSendMsgBool) {//type=0非联系人
        Y_SVP_SHOW_ERR_MES(@"非联系人，不能发送信息");
        return YES;
    }
    if (self.isDeletPersonNotAllowedSendMsgBool) {//type=0非联系人
        Y_SVP_SHOW_ERR_MES(@"已经删除好友，不能发送信息");
        return YES;
    }
    return NO;
}
#pragma mark == 发 ｜文本类型 ｜好友会话or群 (旧接口数据发送 新data刷新时使用)
- (void)delegateTouchsSendMsgWithText:(NSString *)TextStr{//直接发送已有数据 之后获取时 对应seqid为空 待解决
    if ([self isNotAllowedSendMsgBool]) {
        return;
    }
    NSLog(@"发送文本 %@",TextStr);
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        [ChatManagerData chatWillSendTextTypeWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic withStr:TextStr withGroupUUId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
            //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }else{
        WEAKSELF
        [ChatManagerData chatWillSendTextTypeWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic  withStr:TextStr withFriendUUId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
             //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }
    
}
#pragma mark == 发 | 图片类型 ｜ 好友会话群会话
//
/**
 1025
url 旧版本 dic 新版本
 */
- (void)sendImgUrlWithSendFileGetDic:(NSDictionary *)imgDic{
    if ([self isNotAllowedSendMsgBool]) {
        return;
    }
    NSLog(@"发 | 图片类型 dic 新版本 已经上传 待发送数据 = %@",imgDic);
 
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        [ChatManagerData chatWillSendImgUrlWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic withDic:imgDic withGroupUUId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid]  withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
            //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }else{
        WEAKSELF
        [ChatManagerData chatWillSendImgUrlWithChatMsgBaseInfo: self.chatMsgWillSendBaseInfoDic  withDic:imgDic withFriendUUId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
             //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }
}
/**
 1025
url 旧版本 dic 新版本
 */
- (void)sendImgUrlWithStr:(NSString *)imgUrlStr{
    if ([self isNotAllowedSendMsgBool]) {
        return;
    }
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        [ChatManagerData chatWillSendImgUrlWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic WithStr:imgUrlStr withGroupUUId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
            //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }else{
        WEAKSELF
        [ChatManagerData chatWillSendImgUrlWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic  withStr:imgUrlStr withFriendUUId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
             //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }
}
#pragma mark == 发 | 语音类型 ｜ 好友会话群会话
//- (void)sendVoiceFileUpDic:(NSString *)voiceFileUUIDStr{//当前用文件的URL 后续用文件的ID
- (void)sendVoiceFileUpDic:(NSDictionary *)voiceUpFileDic{
    if ([self isNotAllowedSendMsgBool]) {
        return;
    }
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        [ChatManagerData chatWillSendVoiceTypeWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic  withVoiceFileDic:voiceUpFileDic withGroupUUId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
            //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }else{
        WEAKSELF
        [ChatManagerData chatWillSendVoiceTypeWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic withFileDic:voiceUpFileDic withFriendUUId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * arr) {
             //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }
}
#pragma mark == 收到和发送后的UI处理
- (void)getMsgInfo:(NSDictionary *)getMsgDic{
  
    DLog(@"\n ********* chatVc  getMsgInfo *******  %@ \n ",getMsgDic);
    //1027适配安卓的非jsonstr数据
    NSMutableDictionary *newGetMsgMDic = [NSMutableDictionary dictionaryWithDictionary:getMsgDic];
    if ([[getMsgDic allKeys]containsObject:@"data"]) {
        if ( [[getMsgDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            //转型为jsonStr
            NSString *dataObjJsonStr = [Tool jsonStrWithDic:[getMsgDic objectForKey:@"data"]];
            [newGetMsgMDic setValue:dataObjJsonStr forKey:@"data"];
        }
    }
    //
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {//群信息
        ChatGroupMessageModel *model  = [ChatGroupMessageModel mj_objectWithKeyValues:newGetMsgMDic];
        if (isNil(model.sequence_id)) {//发送时的seqid空时 后续删除撤回不可操做 赋值
            ChatGroupMessageModel *lastM = [ChatGroupMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList.lastObject];
            NSInteger seqIdInt = [lastM.sequence_id integerValue] + 1;
            if (seqIdInt==0) {
                [newGetMsgMDic setValue:@"0" forKey:@"sequence_id" ];
            }else{
                [newGetMsgMDic setValue:[NSString stringWithFormat:@"%ld",seqIdInt] forKey:@"sequence_id" ];
            }
        }else{//sequence_id 非空 则是收到的数据 ，如果ask回复出问题 则会收到同个数据 则需要 排除同个msgid的数据 (仅用最后一条数据判断 不做全部数据循环判断)
            ChatGroupMessageModel *lastM =  [ChatGroupMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList.lastObject];
            NSString *lastMsgInfoId = [TextShowWithModelStr textShowWithModelStr:lastM.msg_id];
            if ( [model.msg_id isEqualToString:lastMsgInfoId] ) {
                DLog(@"ask 未回复 得到了 重复数据")
                return;//不做add dic
            }
        }
        if ( [[TextShowWithModelStr textShowWithModelStr:model.to_group] isEqualToString:self.groupModel.groupUuid]) {//当前群组 收发的信息
            [self.dataSourceOfMsgList addObject:newGetMsgMDic];
            [self.saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr addObject:newGetMsgMDic];//保存socket的msg
            [self.chatView fillDataWithGroupHistoryMsg:self.dataSourceOfMsgList];
        }else{
            DLog(@"getMsgInfo 数据有误");
        }
    }else{   //好友
        ChatFriendMessageModel *model  = [ChatFriendMessageModel mj_objectWithKeyValues:newGetMsgMDic];
        if (isNil(model.sequence_id)) {
            ChatFriendMessageModel *lastM = [ChatFriendMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList.lastObject];
            NSInteger seqIdInt = [lastM.sequence_id integerValue] + 1;
            if (seqIdInt==0) {
                [newGetMsgMDic setValue:@"0" forKey:@"sequence_id" ];//第一条数据
            }else{
                [newGetMsgMDic setValue:[NSString stringWithFormat:@"%ld",seqIdInt] forKey:@"sequence_id" ];//发送数据
            }
        }else{//sequence_id 非空 则是收到的数据 ，如果ask回复出问题 则会收到同个数据 则需要 排除同个msgid的数据 (仅用最后一条数据判断 不做全部数据循环判断)
            ChatFriendMessageModel *lastM = [ChatFriendMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList.lastObject];
            NSString *lastMsgInfoId = [TextShowWithModelStr textShowWithModelStr:lastM.msg_id];
            if ( [model.msg_id isEqualToString:lastMsgInfoId] ) {
                DLog(@"ask 回复失败 ， 得到了 重复数据")
                return;//不做add dic
            }
        }
        
        DLog(@"_chatvc____得到key iv  %@   %@",  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Key,  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv);
        DLog(@"_chatvc___得到imutoken = %@   uuid= %@",  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken,  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid);
        [self.dataSourceOfMsgList addObject:newGetMsgMDic];
        [self.saveGetSendTypeSocketMsgOfNotReqHistoryMsgArr addObject:newGetMsgMDic];//保存socket的msg
        [self.chatView fillDataWithFriendHistoryMsg:self.dataSourceOfMsgList];
    }
  
}
 
#pragma mark ====  下载存储播放语音voice
- (void)subViewCllVoiceTypeCellPlayVoiceActionWitnMsgId:(NSString *)MsgId withFileSecret:(NSString *)fileSecret withFileSecretFileUrlStr:(NSString *)voiceFileUrlStr{
    [[VoiceDownAndSavePlayManage share]chatVoiceDownSavePlayWithMsgId:MsgId withFileSecret:fileSecret withUrlStr:voiceFileUrlStr];//停止的通知由VoiceDownAndSavePlayManage 发出 在本类处理view的数据刷新
}
#pragma mark === 语音播放完或者被停止的通知
- (void)chatVoicePalyingEndNotice:(NSNotification *)notice{
    NSString *thisVoiceMsgID = notice.object;
    //更新对应的cell 停止动画 (找到index)
    for ( int i = 0; i <self.dataSourceOfMsgList.count; i++) {
        if ([[self.dataSourceOfMsgList[i] allKeys]containsObject:@"msg_id"] &&   [[self.dataSourceOfMsgList[i] objectForKey: @"msg_id"] isEqualToString:thisVoiceMsgID]) {
            NSLog(@"语音播放完或者被停止的通知 更新对应的cell row = %d",i);
            [self.chatView voiceEndCellRowNum:i];
        }
    }
    
}
#pragma mark ================================================================================== 基础UI
#pragma mark ==== UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    
    [self.naviView addSubview:self.moreButton];
    [self.contentView addSubview:self.chatView];
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moreButton.superview);
        make.right.equalTo(_moreButton.superview).with.offset(-10);
        make.width.height.offset(44);
    }];
    [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_chatView.superview);
    }];
 
}


#pragma mark - 懒加载
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreButton;
}

- (ZYChatView *)chatView {
    if (!_chatView) {
        _chatView = [[ZYChatView alloc] init];
        _chatView.backgroundColor = [UIColor whiteColor];
        _chatView.delegate = self;
    }
    
    return _chatView;
}
#pragma mark ================================================================================== view协议
#pragma mark - ZYChatViewDelegate
#pragma mark ==
//撤销键和删除后的刷新 当前刷新全部数据以后根据seqID刷新 用户主动删除撤回时的协议
- (void)messageInfoDeletOrCancelWillGetNewInfoList{
    [self initData];
}
//点到图片消息的內图片
- (void)subViewCellImgTypeCellWillShowBigImgWithImgAllUrlStr:(NSString *)imgAllUrlStr{
    [self showBigImgWithImgMsgUrlStr:imgAllUrlStr];
}
//点到头像-去对应的信息页
- (void)iconImageViewSelectedAtIndex:(NSInteger)index {
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Friend || self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
    }else{
        return;//非好友 非群友 不可点头像去个人中心页
    }
    NSLog(@"%ld", index);
    ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
 
    ChatFriendMessageModel *model = [ChatFriendMessageModel mj_objectWithKeyValues:self.dataSourceOfMsgList[index]];
    if ([model.from_user isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {//自己
        vc.imId = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken;
//        vc.uuidStr = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid;
    }else{
        DLog(@"imIdimIdimIdimIdimIdimIdimIdimIdimIdimIdimId  !!!! 缺失");
        if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
//            vc.imId = model.from_user;
//            vc.uuidStr =  [TextShowWithModelStr textShowWithModelStr:model.from_user];
        }else{
            vc.imId = self.chatVcWillUseImId;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSubCollectionViewWithIndexFoundation:(NSInteger)index{
    DLog(@"touchSubCollectionViewWithIndexFoundation");
    //20220614改
    switch (index) {
        case ZYChatFunctionViewDelegate_Touch_photo:
        {
            NSLog(@"0相册");
            [self chooseImageWithType:Photo_Choose_Type_Album];
        }
            break;
        case ZYChatFunctionViewDelegate_Touch_camera:
        {
            NSLog(@"1拍照");
            [self chooseImageWithType:Photo_Choose_Type_Grapht];
        }
            break;
        case ZYChatFunctionViewDelegate_Touch_position:
        {
            NSLog(@"位置");
            [self sendAddressWithPopAlert];
        }
            break;
        case ZYChatFunctionViewDelegate_Touch_heimingdan:
        {
            NSLog(@"黑名单");
            [self setHeiMingDanAction];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
   // Y_SVP_SHOW_ERR_MES(@"当前功能暂未开放！");
   // return;
    /**
     //________1025放开限制
     if (index == 0) {
         NSLog(@"0相册");
         //图片相册选择
         [self chooseImageWithType:Photo_Choose_Type_Album];
     }else if (index == 1) {
         NSLog(@"1拍照");
         //图片拍照
         [self chooseImageWithType:Photo_Choose_Type_Grapht];
     }else if (index == 2) {
         NSLog(@"视频通话");
         [self sendMp4Action];
     }else if (index == 3) {
         NSLog(@"位置");
         [self sendAddressWithPopAlert];
     }else if (index == 4) {
         NSLog(@"语音输入");
         [self chooseBottomSubVoiceAction];//
     }else if (index == 5) {
         NSLog(@"我的收藏");
     }else if (index == 6) {
         NSLog(@"红包");
     }else if (index == 7) {
         NSLog(@"转账");
     }
     */
   
}
#pragma mark = 语音输入
//20220620新协议
- (void)chooseBottomSubVoiceActionWithFoundation{
    NSLog(@"语音输入");
    [self chooseBottomSubVoiceAction];//
}
#pragma mark - 处理点击事件
// 更多
- (void)moreButtonClicked {
    
    NSLog(@"更多");
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {//群
        ZYChatInformationVc *vc = [[ZYChatInformationVc alloc] init];
        vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_Group;
        vc.groupUUID = self.groupModel.groupUuid;
        vc.groupMemberList  = self.dataSourceOfMemberList;  //成员
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{//好友资料相关设置
        ChatFriendVcSetTableVc *vc = [[ChatFriendVcSetTableVc alloc]init];
        vc.friendImId = self.chatVcWillUseImId; 
        vc.friendNickName = self.friendNickName;
 
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
        backBtn.title = @"资料设置";
        [self.navigationItem setBackBarButtonItem:backBtn];
        
        [self.navigationController pushViewController:vc animated:YES];
       
    }

 
}

// 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ================================================================================== 文件处理相关
#pragma mark == == 黑名单
- (void)setHeiMingDanAction{
    if (  self.saveRelationModel.otherPullBlackMe ) {
        Y_SVP_SHOW_ERR_MES(@"已被拉黑，暂不能发送信息");
    }else{
        Y_SVP_SHOW_INFO_MES(@"可在资料详情界面对改用户进行拉黑或取消拉黑操作。");
    }
}
#pragma mark ===  定位地址
- (void)viewDeletWithShowBigLocateViewWithShowAddressStr:(NSString *)addressShowStr withlati:(CGFloat)lati withLongi:(CGFloat)longi{
    
    ChatShowLocateAddressVc *vc = [[ChatShowLocateAddressVc alloc]init];
    vc.lati = lati;
    vc.longi = longi;
    vc.showAddressStr = addressShowStr;
    vc.title = @"位置信息";
    self.navigationController.navigationBarHidden = NO;//混的vc 处理返回后的
    [self.navigationController pushViewController:vc animated:YES];
 
 
}
#pragma mark === 发送位置信息
- (void)sendAddressWithPopAlert{
    WEAKSELF
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"发送用户当前位置信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendUserAddress];
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:yesAction];
    [alertC addAction:alertActionCancel];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)sendUserAddress{
 
    //初始发送
    WEAKSELF
    __block NSString *willSnedAddressStr = @"";
    __block double lati = 29.0;
    __block double longi = 106.0;
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (!error) {
            NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@ %@",model.locality,model.subLocality,model.thoroughfare,model.thoroughfare,model.name];
            lati = model.latitude;
            longi = model.longitude;
            if (addressStr.length<=0) {
                [ZYLocationInfoTool getLocatonInfoWithLat:model.latitude AndLon:model.longitude LocatonInfoBlock:^(NSString * _Nonnull locationStr) {
                    willSnedAddressStr = locationStr;
                    [weakSelf sendAddressWithLat:lati withLong:longi withShowAddressStr:willSnedAddressStr];
                }];
            }else{
                willSnedAddressStr = addressStr;
                [weakSelf sendAddressWithLat:lati withLong:longi withShowAddressStr:willSnedAddressStr];
            }
          
        }else{
            Y_SVP_SHOW_ERR_MES(@"当前");
        }
    }];
}
- (void)sendAddressWithLat:(double)lati withLong:(double)longi withShowAddressStr:(NSString *)willSnedAddressStr{
    if ([self isNotAllowedSendMsgBool]) {
        return;
    }
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        WEAKSELF
        
        [ChatManagerData chatWillSendLocateAddressWithChatMsgBaseInto:self.chatMsgWillSendBaseInfoDic withlat:lati withLongi:longi withaddressTextStr:willSnedAddressStr wtihGroupId:[TextShowWithModelStr textShowWithModelStr:self.groupModel.groupUuid] withDicBlockAndWillSendDataDicBlock:^(NSArray * _Nonnull arr) {
            //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];
    }else{
        WEAKSELF
        [ChatManagerData chatWillSendLocateAddressWithChatMsgBaseInfo:self.chatMsgWillSendBaseInfoDic  withLati:lati withLongi:longi withaddressTextStr:willSnedAddressStr wtihFriendId:self.friendUUID withDicBlockAndWillSendDataDicBlock:^(NSArray * _Nonnull arr) {
           //添加到UI
            [weakSelf getMsgInfo:arr.firstObject];//dic键值
            //发送
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            [[SocketRocketUtility instance]sendData: jsons];
            [weakSelf.chatView sendMsgWillGotoBottomShow];//主动发送信息时 回底部展示当前发送信息
        }];

    }
}

#pragma mark == == == == == == == == == == == == == 【图片  拍照  视频】类
#pragma mark == 图片 拍照 发送类型

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
#pragma mark ==  视频发送类型
- (void)sendMp4Action{
    Y_SVP_SHOW_INFO_MES(@"暂不支持视频类型");
    return;
    //1026暂时没有资格证书 视频类型暂时不做
    [self choosevideo];
}
//选择本地视频
- (void)choosevideo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    NSLog(@"本地视频 availableMedia = %@",availableMedia);
     /**
      "public.image",
      "public.movie"*/
    if ([availableMedia[1] isEqualToString:kpublicmovie]) {
        ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    }else{
        ipc.mediaTypes = [NSArray arrayWithObject:kpublicmovie];//设置媒体类型为public.movie
    }
    ipc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托
}
#pragma mark - UIImagePickerControllerDelegate 图片 视频 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    NSString *strOfUIImagePickerControllerMediaType = info[UIImagePickerControllerMediaType];
    if ([strOfUIImagePickerControllerMediaType isEqualToString:kpublicimage]) {
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self imgDetalWithPhoto:photo];
    }else if ([strOfUIImagePickerControllerMediaType isEqualToString:kpublicmovie]){
        DLog(@"kmovie视频选了后的回调信息 ===  %@",info);
        NSURL *movieUrl = info[UIImagePickerControllerMediaURL];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self voideDetalWithMovieBaseUrl:movieUrl];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
  
}
#pragma mark - UIImagePickerControllerDelegate 图片 视频 回调——end
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    if (isNil(photo)) {
        Y_SVP_SHOW_ERR_MES(@"空图片！");
        return;
    }
    WEAKSELF
 
    NSString *willUseSessionId = self.thisChatVcSessionId;
//    1025新版本
    [ChatManagerData chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:willUseSessionId andWithImg:photo withGetDicBlick:^(NSDictionary * dic, BOOL success) {
        STRONGSELF
        if (success) {
            [strongSelf sendImgUrlWithSendFileGetDic:dic];
        }else{
            Y_SVP_SHOW_ERR_MES(@"图片文件上传出错!");
        }
    }];
    
    /**
     1025版本之前 旧版本
     */
    /**
    [ChatManagerData chatWillSendImgFileWithImg:photo withGetDicBlock:^(NSDictionary * dic,  BOOL success) {
        if (success) {
            DLog(@"");
            STRONGSELF
            if ([[dic allKeys]containsObject:@"url"]) {
                NSString *getUrl = [NSString stringWithString:dic[@"url"]];
                [strongSelf sendImgUrlWithStr:getUrl];
            }else{
     Y_SVP_SHOW_ERR_MES(@"图片文件上传出错!");
            }
        }
    }];
     */
}
#pragma mark === 提交movie信息的 //视频上传 (本地地址)
- (void)voideDetalWithMovieBaseUrl:(NSURL *)movUrl{

    WEAKSELF
    [ChatManagerData chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:[TextShowWithModelStr textShowWithModelStr:self.saveRelationModel.sessionId] andWithMovieBaseUrl:movUrl withGetDicBlick:^(NSDictionary * dic, BOOL success) {
        STRONGSELF
        if (success) {
            DLog(@"视频文件 up = %@",dic);
//            [strongSelf sendImgUrlWithSendFileGetDic:dic];
        }else{
            Y_SVP_SHOW_ERR_MES(@"视频文件上传出错!");
        }
    }];
    
    
}

#pragma mark === 提交voice信息的 //文件上传（在语音管理类里录完音即可上传）
#pragma mark === 语音相关

- (void)chooseBottomSubVoiceAction{
    [self.bottomViewSubVoicePopView showInSuperviewWithSendSuperV:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
#pragma mark ==
- (ChatBottomViewSubVoicePopView *)bottomViewSubVoicePopView{
    //此pop 在dismiss时有做nil处理
    if (isNil(_bottomViewSubVoicePopView)) {
        _bottomViewSubVoicePopView = [[ChatBottomViewSubVoicePopView alloc]init];
        _bottomViewSubVoicePopView.delegate = self;
        _bottomViewSubVoicePopView.basePopViewDelegate = self;
    }else{
        NSLog(@"bottomViewSubVoicePopView 存在");
    }
    return _bottomViewSubVoicePopView;
}
- (void)subPopViewVoiceBtnLongPressActionType:(LongPressActionType)longPressActionType{
    if (longPressActionType == LongPressActionType_Begin) {
        //开始录音[]
        [[ChatVoiceDataDealTool share] voiceStartRecordWithChatSessionId:[TextShowWithModelStr textShowWithModelStr:self.saveRelationModel.sessionId]];
    }else if (longPressActionType == LongPressActionType_End){
        [[ChatVoiceDataDealTool share] voiceEndRecordWithIsSendInfoBool: YES];
        //结束录音存储音频  处理数据 转码 发送 音频数据    //回调后发送dic + 隐藏语音pop
        WEAKSELF
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.bottomViewSubVoicePopView dismissThePopView];
        });
        //1026语音
        [ChatVoiceDataDealTool share].voiceGetWillSendDicBlock = ^(NSDictionary * dic) {
            [weakSelf sendVoiceFileUpDic:dic];
        };
//        [ChatVoiceDataDealTool share].voiceGetWillSendDicBlock = ^(NSString * voiceFileUUIDStr) {
//            [weakSelf sendVoiceFileUUIDWithFileUUIDStr:voiceFileUUIDStr];
//        };
    }else if (longPressActionType == LongPressActionType_Cancel){
        [[ChatVoiceDataDealTool share] voiceEndRecordWithIsSendInfoBool: NO];
        WEAKSELF
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.bottomViewSubVoicePopView dismissThePopView];
        });
    }else if (longPressActionType == LongPressActionType_Other){
        
    }else{
        //录音
    }
}
- (void)basePopViewDelegateWithDissmissEndInfo{
    self.bottomViewSubVoicePopView = nil;//置空 为下一次使用 做基础
}

#pragma mark ================================================================================== 基础数据getter
#pragma mark == 数据getter
- (NSMutableArray *)dataSourceOfMsgList{
    if (!_dataSourceOfMsgList) {
        _dataSourceOfMsgList = [[NSMutableArray alloc]init];
    }
    return _dataSourceOfMsgList;
}
- (NSMutableArray *)dataSourceOfMemberList{
    if (!_dataSourceOfMemberList) {
        _dataSourceOfMemberList = [[NSMutableArray alloc]init];
    }
    return _dataSourceOfMemberList;
}
- (NSMutableDictionary *)dataSourceOfMemberImgUrlStrDic{
    if (!_dataSourceOfMemberImgUrlStrDic) {
        _dataSourceOfMemberImgUrlStrDic = [[NSMutableDictionary alloc]init];
    }
    return _dataSourceOfMemberImgUrlStrDic;
}
- (NSMutableDictionary *)dataSourceOfMemberNickNameStrDic{
    if (!_dataSourceOfMemberNickNameStrDic) {
        _dataSourceOfMemberNickNameStrDic = [[NSMutableDictionary alloc]init];
    }
    return _dataSourceOfMemberNickNameStrDic;
}
#pragma mark ================================================================================== 图片类型放大展示功能
#pragma mark ==  图片放大的
- (void)showBigImgWithImgMsgUrlStr:(NSString *)imgUrlStr{
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.tag = Tag_ScrollView_Use_BigImg;
    _scrollView.maximumZoomScale=5.0;//图片的放大倍数
    _scrollView.minimumZoomScale=1.0;//图片的最小倍率
    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);//可以左右滑
//    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);//禁止左右滑
    _scrollView.delegate=self;
    _scrollView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [_imageView sd_setImageWithURL:[UrlWithString getURLWithStr:imgUrlStr]];
    [_scrollView addSubview:_imageView];
    [self.view addSubview:_scrollView];
    _imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [_imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [_imageView addGestureRecognizer:doubleTap];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    if (scrollView.tag == Tag_ScrollView_Use_BigImg) {
        return _imageView;//要放大的视图
    }else{
        NSLog(@"------viewForZoomingInScrollView");
        return nil;
    }
}

-(void)doubleTap:(id)sender
{
    if (_scrollView.tag == Tag_ScrollView_Use_BigImg) {
        _scrollView.zoomScale=2.0;//双击放大到两倍
    }
    
}
- (void)tapImage:(id)sender
{
    if (_scrollView.tag == Tag_ScrollView_Use_BigImg) {
        //    [self dismissViewControllerAnimated:YES completion:nil];//单击图像,关闭图片详情(当前图片页面)
        [_scrollView removeFromSuperview];
    }
    
}

@end
