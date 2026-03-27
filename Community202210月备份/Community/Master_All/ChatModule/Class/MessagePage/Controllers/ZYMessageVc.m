//
//  ZYMessageVc.m
//  Community
//
//  Created by ZY on 2021/4/19.
//

#import "ZYMessageVc.h"
#import "ZYChatVc.h"
#import "ZYMessageCell.h"
#import "ZYMessageTopCell.h"

//
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatNotReadMsgModel.h"
//

static NSString * const messageTopCellID = @"ZYMessageTopCell";
static NSString * const messageCellID = @"ZYMessageCell";
//#define kMessageTopCellHeight ((kScreenW - 160) / 4) * 90 / 60 + 110
#define kMessageTopCellHeight ((kScreenW - 160) / 4) * 90 / 60 + 110 +10

#define kMessageCellHeight 70

@interface ZYMessageVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYMessageTopCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

//
@property (nonatomic,strong) NSMutableArray *topDataSourceArr;

@end

@implementation ZYMessageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"聊天列表";
    [self customTableView];
    [self setUI];
    //
   
    [self initData];
    //
    [self initNotice];
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
#pragma mark ==== initNotice
- (void)initNotice{
    [self initChatInfoNotice];
    [self initOtherNotice];
}
- (void)initChatInfoNotice{
    //收到好友同意拒绝时 好友列表刷新?
    /**
     *
     //---------------------------------------------------------------------
     #define kWebSocketdidReceiveMessage_NoticeName_ChatMsg                   @"kWebSocketdidReceiveMessage_NoticeName_ChatMsg"        //仅仅是聊天类型数据数据（多种chat类型）
     #define kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg            @"kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg" //聊天类型数据 撤回信息
     //好友相关数据类型
     #define kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq       @"kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq"     //新的好友 请求
     #define kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess        @"kWebSocketdidReceiveMessageNote_NoticeName_Friend_AddSuccess"    //新增好友成功 通知
     #define kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsRej            @"kWebSocketdidReceiveMessageNote_NoticeName_Friend_AddRej"      //新增好友失败 被拒绝通知
     *--------------------------------------------------------------------
     * */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewInfoWithNoRedList) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewInfoWithNoRedList) name:kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriendsList) name:kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess object:nil];
}
- (void)initOtherNotice{
    Y_NSNotificationCenter_Creat_NameAction(ChatDeletFriend_NoticeName, initData);
    Y_NSNotificationCenter_Creat_NameAction(ChatSetFriendRemarkName_NoticeName, initData);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(ChatSetFriendRemarkName_NoticeName);
    Y_NSNotificationCenter_RemoveNotice_Name(ChatDeletFriend_NoticeName);
    //chatmsginfo
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess);
    //
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_ChatMsg);
    Y_NSNotificationCenter_RemoveNotice_Name(kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg);

    
}
#pragma mark === 
- (void)SRWebSocketdidReceiveMessageNote_HaveAnNewFriend{
    [self initData];
    
}

#pragma mark ==== initData
- (void)initData{
    [self getUserInfo];//个人信息
    [self getFriendsList];
    [self getNewInfoWithNoRedList];
}
#pragma mark == 个人信息
- (void)getUserInfo{
    WEAKSELF
    STRONGSELF
    [ChatManagerData chatUserInfoGetWithMyInfoWithBlock:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            DLog(@"");
            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn = [ChatUserModel mj_objectWithKeyValues:dic];
        }
    }];
}

#pragma mark == 常用列表 好友数据
- (void)getFriendsList{
    
    /**
     0907 去掉顶部cell
     */
    /**
     WEAKSELF
     STRONGSELF
     [ChatManagerData getFriendInfoListWithBlcok:^(NSArray * arr, BOOL success) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [strongSelf.tableView.mj_header endRefreshing];
         });
         if (success) {
             strongSelf.topDataSourceArr = [NSMutableArray arrayWithArray:arr];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [strongSelf.tableView reloadData];
             });
         }
     }];
     */
    
    
}
#pragma mark == 未读消息列表 区分分好友
- (void)getNewInfoWithNoRedList{
    WEAKSELF
    STRONGSELF
    [ChatManagerData getAllSessionsNotReadFor7DaysWithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
        DLog(@"未读消息列表  好友会话 + 群会话%@",arr);
        if (success) {
            strongSelf.dataArray = [NSMutableArray arrayWithArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ====

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewInfoWithNoRedList];//未读消息
}

- (void)viewDidAppear:(BOOL)animated {

   [super viewDidAppear:animated];
   
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {

   [super viewWillDisappear:animated];

    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)topDataSourceArr{
    if (!_topDataSourceArr) {
        _topDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _topDataSourceArr;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
         _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView= [[UIView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_tableView.superview);
    }];
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMessageTopCell" bundle:nil] forCellReuseIdentifier:messageTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMessageCell" bundle:nil] forCellReuseIdentifier:messageCellID];
    

}

#pragma mark - 加载数据
- (void)loadData {
    
}
//0907改UI top去掉。搜索=聊天数据搜索。top好友列表暂时为空？
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section == 0) {
//
//        return 1;
//    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    ZYMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellID forIndexPath:indexPath];
    [cell fillDataWithDic:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//
//        return kMessageTopCellHeight;
//    }
    
    return kMessageCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//_______ 未读消息
 
        
    
        NSDictionary *cellIndexDic = [[NSDictionary alloc]initWithDictionary:self.dataArray[indexPath.row]];
        ChatNotReadMsgModel *notRedModel = [ChatNotReadMsgModel mj_objectWithKeyValues:cellIndexDic];
      
        NSString *toUserNickName  = @"";
        NSString *toUserimidStr = @"";
        NSString *toUserAccountUUID = @"";
        BOOL willClearnThisSesstionBool = notRedModel.un_read_count>0 ? YES : NO;
        NSInteger willClearnOfUseID = notRedModel.ID;
        if(notRedModel.contact_type){//有子数据contact
            toUserNickName  = notRedModel.contact.friendRemark.length>0 ? notRedModel.contact.friendRemark : notRedModel.contact.nickName;
            toUserimidStr  = notRedModel.contact.imId;
            toUserAccountUUID = notRedModel.contact.otherAccount;
        }else{//无contact
            toUserNickName = notRedModel.nike_name;
            toUserimidStr = notRedModel.im_id;
            toUserAccountUUID = notRedModel.to_user;
        }
        //空
        if (toUserNickName.length==0) {//有第二级别数据备注和昵称都@“”的情况 还是需要第一级别的名字字段
            toUserNickName = notRedModel.nike_name;
        }
        if (toUserimidStr.length<0) {
            Y_SVP_SHOW_ERR_MES(@"ID异常，暂不能通信。");
            return;
        }
        //to_user_type
        WEAKSELF
        if (notRedModel.to_user_type == 0) {
            Y_SVP_SHOW_ERR_MES(@"非联系人！不可聊天");
            return;
        }else if (notRedModel.to_user_type == 1){//好友
            
            dispatch_async(dispatch_get_main_queue(), ^{
             
                
                ZYChatVc *vc = [[ZYChatVc alloc] init];
                if (willClearnThisSesstionBool) {
                    //[weakSelf clearnOneNotReadInfoWithSessionIds:willClearnOfUseID];//    (会话内部需要使用此做回执 在会话内调用两种已读处理，不在列表做已读处理)
                }
                
                ChatVc_Seesion_type thishatVc_Seesion_type = ChatVc_Seesion_type_Friend;
                BOOL isMoShengRenTypeBoolNotShowRightItemBool = NO;//好友类型 非陌生人
                NSString *fImid = toUserimidStr;
                NSString *fAccountUUID = @"";
                NSString *fNickName = toUserNickName.length>0 ? toUserNickName  : @"未知昵称";
                BOOL isFriendTypeIsDeletNotAllowSendMsgBool = NO;
                
                [vc fillThisNomalChatVcSubInfoWithClearnUseID:notRedModel.ID  withSessionID:@"" withChatVcToUseType:thishatVc_Seesion_type withNotShowRightItemMSRBool:isMoShengRenTypeBoolNotShowRightItemBool withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:isFriendTypeIsDeletNotAllowSendMsgBool];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            });
        }else if(notRedModel.to_user_type == 2){//群
            dispatch_async(dispatch_get_main_queue(), ^{
                ZYChatVc *vc = [[ZYChatVc alloc] init];
                if (willClearnThisSesstionBool) {
                    //[weakSelf clearnOneNotReadInfoWithSessionIds:willClearnOfUseID]; //(会话内部需要使用此做回执 在会话内调用两种已读处理，不在列表做已读处理)
                }
                [vc fillThisGroupTypeChatVcSubInfoWithClearnUseID:notRedModel.ID withSessionID:toUserAccountUUID  withChatVcToUseType:ChatVc_Seesion_type_Group withGroupInfoDic: cellIndexDic ] ;
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
            
        }else if (notRedModel.to_user_type == 3){//公众号
            Y_SVP_SHOW_ERR_MES(@"公众号！不可聊天");
            return;
          
        }else if (notRedModel.to_user_type == 4){//商户
            [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:notRedModel.ID  withImIdStr:toUserimidStr withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
                if (success) {
                    if (willClearnThisSesstionBool) {
                        //[weakSelf clearnOneNotReadInfoWithSessionIds:willClearnOfUseID];// (会话内部需要使用此做回执 在会话内调用两种已读处理，不在列表做已读处理)
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        willPushVc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:willPushVc animated:YES];
                    });
                }
            }];
            
        }else{//  5陌生人 stranger
            [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:notRedModel.ID withImIdStr:toUserimidStr withThisStrangerChatType:ChatVc_Stranger_Chat_Application_houserOrstranger withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
                if (success) {
                    if (willClearnThisSesstionBool) {
                        //[weakSelf clearnOneNotReadInfoWithSessionIds:willClearnOfUseID];// (会话内部需要使用此做回执 在会话内调用两种已读处理，不在列表做已读处理)
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        willPushVc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:willPushVc animated:YES];
                    });
                }
            }];
            
        }
    }
        
        /**
         if (notRedModel.to_user_type == 1 ||  notRedModel.to_user_type == 3) { //3类型
             vc.thisChatVc_Seesion_type = notRedModel.to_user_type;
             vc.friendUUID =  notRedModel.to_user;//对方ID数据。
             vc.friendNickName = [TextShowWithModelStr textShowWithModelStr:notRedModel.friend_remark].length>0 ?[TextShowWithModelStr textShowWithModelStr:notRedModel.friend_remark] : [TextShowWithModelStr textShowWithModelStr:notRedModel.nike_name];//备注或昵称
              vc.chatVcWillUseImId =  [TextShowWithModelStr textShowWithModelStr:notRedModel.im_id];
             if ( (notRedModel.contact.type == 5) || (notRedModel.contact.type == 0) || (notRedModel.contact_type == 0) || (notRedModel.contact_type == 5) ) {//联系人类型：0 表示不存联系人关系（不可聊天），1:好友、2、群、3、订阅号、服务号、5陌生人(可聊天)
                 vc.isMoShengRenTypeBoolNotShowRightItem = YES;
                 if ( (notRedModel.contact.type == 0) || (notRedModel.contact_type == 0) ) {
                     vc.isNotChatPersonNotAllowedSendMsgBool = YES;//非联系人 不可聊天
                 }else{
                     vc.isNotChatPersonNotAllowedSendMsgBool = NO;//5 陌生人 可以聊天
                 }
             }
             if (notRedModel.is_del == YES) {
                 vc.isDeletPersonNotAllowedSendMsgBool = YES;
             }else{
                 vc.isDeletPersonNotAllowedSendMsgBool = NO;
             }
             if ([notRedModel.from_user isEqualToString:notRedModel.to_user]) {//自己和自己的对话
                 vc.friendNickName  =  @"我";//[TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOw
             }
             if (notRedModel.un_read_count>0) {
                 //转成已读==新清空未读消息数量 ==和 推送总消息一样数据和清楚接口
                 NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
                 [parms setValue:@(0) forKey:@"clearAll"];
                 [parms setValue:@[@(notRedModel.id)] forKey:@"sessionIds"];
                  [ChatManagerData chatHistoryNotReadChangeToReadedWithUnRedDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
                      if (success) {
                      }else{
                          DLog(@"转成已读 请求失败");
                      }
                 }];
             }
         }else if (notRedModel.to_user_type == 4 ){//商户
             NSLog(@"联系商家");
             WEAKSELF
             NSString *thisMsgOfShopIMId = [TextShowWithModelStr textShowWithModelStr:notRedModel.im_id];
             [ChatVcWillGoOneChatVcTool chatVcPushInfoWithImIdStr:thisMsgOfShopIMId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
                 if (success) {
                     //转成已读==新清空未读消息数量 ==和 推送总消息一样数据和清楚接口
                     NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
                     [parms setValue:@(0) forKey:@"clearAll"];
                     [parms setValue:@[@(notRedModel.id)] forKey:@"sessionIds"];
                     [ChatManagerData chatHistoryNotReadChangeToReadedWithUnRedDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
                     }];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         willPushVc.hidesBottomBarWhenPushed = YES;
                         [weakSelf.navigationController pushViewController:willPushVc animated:YES];//请求数据后 配好熟悉的chatVC
                     });
                 }
             }];
             return;
             
         }else  if (notRedModel.to_user_type == 2) {
             DLog(@"/群未读消息");
             vc.groupInfoDic = dic;
             vc.thisChatVc_Seesion_type = notRedModel.to_user_type;;
              //
             if (notRedModel.un_read_count>0) {
                 //转成已读==新清空未读消息数量 ==和 推送总消息一样数据和清楚接口
                 NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
                 [parms setValue:@(0) forKey:@"clearAll"];
                 [parms setValue:@[@(notRedModel.id)] forKey:@"sessionIds"];
                  [ChatManagerData chatHistoryNotReadChangeToReadedWithUnRedDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
                 }];
             }
         }else{
             // 3是公众号
             return;
         }
         vc.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:vc animated:YES];
         */
       
 
}
- (void)clearnOneNotReadInfoWithSessionIds:(NSInteger )clearnSessionUseId{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(0) forKey:@"clearAll"];
    [parms setValue:@[ @(clearnSessionUseId) ] forKey:@"sessionIds"];
    [ChatManagerData chatHistoryNotReadChangeToReadedWithUnRedDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
        }else{
            DLog(@"转成已读 请求失败 sessionId = %ld",clearnSessionUseId);
        }
    }];
}
//以下删除
// 单元格编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

//Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    if (indexPath.section == 0) {
        return YES;
    }
    
    return NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return @"删除"; //删除整个会话 清楚未读是didselected
    }
    
    return nil;
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataArray[indexPath.row]];
        ChatNotReadMsgModel *notRedModel = [ChatNotReadMsgModel mj_objectWithKeyValues:dic];
        WEAKSELF
        //好友会话
        if (notRedModel.to_user_type == 1 || notRedModel.to_user_type == 4) {
            //新
            NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
            [bodyDic setValue:@(notRedModel.ID) forKey:@"id"];
            [bodyDic setValue:notRedModel.session_id forKey:@"sessionId"];
            [ChatManagerData chatSessionDeleteWithBodyDic:bodyDic  withBlock:^(NSDictionary * dic, BOOL success) {
                if(success){
                    [weakSelf  getNewInfoWithNoRedList];//未读消息;
                }
            }];
        }else   if (notRedModel.to_user_type == 2) {
            DLog(@"/群未读消息");
 
            NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
            [bodyDic setValue:@(notRedModel.ID) forKey:@"id"];
            [bodyDic setValue:notRedModel.session_id forKey:@"sessionId"];
            [ChatManagerData chatSessionDeleteWithBodyDic:bodyDic  withBlock:^(NSDictionary * dic, BOOL success) {
                if(success){
                    [weakSelf  getNewInfoWithNoRedList];//未读消息;
                }
            }];
        }else{
            
        }
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"%@", textField.text);
}

#pragma mark - ZYMessageTopCellDelegate
- (void)messageTopCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //常用聊天 暂用好友列表数据 已经被隐藏
    NSLog(@"%ld", indexPath.row);
    /**
     ChatFriendModel *model = [ChatFriendModel mj_objectWithKeyValues:self.topDataSourceArr[indexPath.row]];
     //
     ZYChatVc *vc = [[ZYChatVc alloc] init];
  
     vc.friendNickName = [TextShowWithModelStr textShowWithModelStr:model.friendRemark].length>0 ?[TextShowWithModelStr textShowWithModelStr:model.friendRemark] : [TextShowWithModelStr textShowWithModelStr:model.nickName];//好友备注
     vc.friendUUID = [TextShowWithModelStr textShowWithModelStr:model.otherAccount];
     vc.chatVcWillUseImId = [TextShowWithModelStr textShowWithModelStr:model.imId];
     vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_Friend;;
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     */
   
  
}

#pragma mark - 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
