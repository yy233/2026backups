//
//  ZYChatView.m
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import "ZYChatView.h"
#import "ZYChatLeftCell.h"
#import "ZYChatRightCell.h"

//
#import "ChatFriendMessageModel.h"
#import "ChatGroupMessageModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatVcSubCellHeader.h"
//
#import "ChatManagerData.h"
//
#import "ChatViewEmojiTool.h"

static NSString * const chatLeftCellID = @"ZYChatLeftCell";
static NSString * const chatRightCellID = @"ZYChatRightCell";
#define kEstimatedRowHeight 100
#define h_funcationBottomView   (150)
#define h_emjBottomView         (150)


@interface ZYChatView () <UITableViewDataSource, UITableViewDelegate,ChatVcSubAllTypeCellsProtocol, ZYChatFunctionViewDelegate, UITextViewDelegate,ZYChatRightCellDelegate>

//ZYChatRightCellDelegate,ChatVcSubRightImgTableViewCellDelegate,ChatVcSubLeftImgTableViewCellDelegate,ChatVcSubRightVoiceTableViewCellDelegate,ChatVcSubLeftVoiceTableViewCellDelegate,ChatVcSubRightMp4TableViewCellDelegate,ChatVcSubLeftMp4TableViewCellDelegate,ChatVcSubRightLocateTableViewCellDelegate,CChatVcSubLeftLocateTableViewCellDelegate>

@property (nonatomic, strong) UIImageView *backImgV;


// 功能视图是否显示
@property (nonatomic, assign) BOOL isFunctionViewShow;
// 表情功能是否显示
@property (nonatomic, assign) BOOL isEmojiViewShow;


// 键盘是否显示
@property (nonatomic, assign) BOOL iskeyboardShow;

//
@property (nonatomic,strong) NSMutableArray *msgDataSourceArr;
@property (nonatomic,strong) NSURL *friendImgAllUrl;
@property (nonatomic,strong) NSURL *myImgAllUrl;
@property (nonatomic,assign) ChatVC_Type chatVC_type;
@property (nonatomic,strong) NSMutableDictionary *dataSourceOfMemberImgUrlStrDic;//以ID为键imgStr为值
@property (nonatomic,strong) NSMutableDictionary *dataSourceOfMemberNickNameStrDic;//以ID为键nameStr为值
//撤回删除键的显隐数据更新源
@property (nonatomic,strong) NSMutableArray *undoAndDeletShowNumDataSourceArr;
//音频动画停止时用的数据源//播放暂不使用这个数组
@property (nonatomic,strong) NSMutableArray *voiceEndPlayTypeArrUseRoladRow;
//
@property (nonatomic,assign) BOOL selfGetMsgDataIsOldVer;//默认no 默认新版本数据
@property (nonatomic,assign) CGSize saveOldContentSizeInfo;

@end


@implementation ZYChatView


//音频数据停止动画 行row刷新
- (void)voiceEndCellRowNum:(NSInteger)index{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index  inSection:0];
    //2203新版
    if ([[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ChatVcSubVoiceTypeTableViewCell class]]) {
        ChatVcSubVoiceTypeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell cellSubImgWithVoiceIsPlay:NO];
        NSLog(@"voiceCell 停止voice动画");
    }
    
}
//
//刷新固定的row 附带新的listdata
- (void)msgListViewloadRowNum:(NSInteger)rowNum withMsgListData:(NSMutableArray *)dataSourceArr{
    self.msgDataSourceArr = dataSourceArr;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowNum  inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}

// 头像处理
- (void)fillFriendImgStr:(NSString *)friendImgStr{
    if([friendImgStr rangeOfString:@"http"].location != NSNotFound){
        self.friendImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,friendImgStr]]; //BASE_Chat_Img_Default_URL 旧有值 新为@“”
    }else{
        self.friendImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,friendImgStr]];
    }
    self.friendImgAllUrl = [UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,friendImgStr]];
    NSString *myImgStr = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl];
    if([myImgStr rangeOfString:@"http"].location != NSNotFound){
        self.myImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,myImgStr]]; //BASE_Chat_Img_Default_URL 旧有值 新为@“”
    }else{
        self.myImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,myImgStr]];
    }
    
}
- (void)fillGroupMemberImgDic:(NSMutableDictionary *)imgDic andNameDic:(NSMutableDictionary *)nameDic{
    NSString *myImgStr = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl];
    if([myImgStr rangeOfString:@"http"].location != NSNotFound){
        self.myImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,myImgStr]]; //BASE_Chat_Img_Default_URL 旧有值 新为@“”
    }else{
        self.myImgAllUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,myImgStr]];
    }
    self.dataSourceOfMemberImgUrlStrDic = [NSMutableDictionary dictionaryWithDictionary:imgDic];
    self.dataSourceOfMemberNickNameStrDic = [NSMutableDictionary dictionaryWithDictionary:nameDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
 
}
//背景图
- (void)fillChatViewBackImgWithUrlStr:(NSString *)backImgUrl{

    NSURL *backImgURL = [UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,backImgUrl]];
    [self.backImgV sd_setImageWithURL:backImgURL];


}
- (void)fillDataWithFriendHistoryMsg:(NSMutableArray *)dataSourceArr{
    self.chatVC_type = ChatVC_FriendsChat;
    [self dealHistoryMsg:dataSourceArr];
    
}
- (void)fillDataWithGroupHistoryMsg:(NSMutableArray *)dataSourceArr{
    self.chatVC_type = ChatVC_GroupChat;
    [self dealHistoryMsg:dataSourceArr];
}

- (void)dealHistoryMsg:(NSMutableArray *)dataSourceArr{
    self.msgDataSourceArr = dataSourceArr;
    [self undoAndDeletShowNumInit];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];//刷新后再滑倒底部移动
    });
    
    
    
    CGFloat now_H = self.tableView.contentSize.height;
    CGFloat now_OneOffestUse_H = (Screen_H-kNavBarHeight-50);
    CGFloat now_UiPage = now_H / now_OneOffestUse_H ;
     
     //总界面内容页数有1以上 && contentOffset 非底部一页 则保持当前状态 || //拉到第一页 的半页处 也回底部 （给个冗余空间）
  
     if (now_UiPage>1.1  && self.tableView.contentOffset.y < ((self.tableView.contentSize.height - now_OneOffestUse_H)  - now_OneOffestUse_H*0.5) ){
         //非初始第一页 则不回到底部 | 或许在拉历史数据（收到他人信息更新data但是不回底部）
         [self headerRefreshMsgWillOneOffset];
    
     }else  if (now_UiPage>1.1  && self.tableView.contentOffset.y < (self.tableView.contentSize.height - now_OneOffestUse_H) ) {
         //去底部
         dispatch_async(dispatch_get_main_queue(), ^{
             [self tableViewScrollToBottom];
         });
      
     }else{
         //去底部
         dispatch_async(dispatch_get_main_queue(), ^{
             [self tableViewScrollToBottom];
         });
     }
    
   
    /**
    CGFloat lastBottomFloat = self.tableView.contentSize.height;
    CGFloat lastPageCenterFloat = self.tableView.contentSize.height - now_OneOffestUse_H*0.5;
    
 
    if (now_UiPage>1.1  && (self.tableView.contentOffset.y >= Screen_H*0.5 ) ){// 在半页内
        //去底部
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tableViewScrollToBottom];
        });
   
    }else  if (now_UiPage>1.1  &&   self.tableView.contentOffset.y < Screen_H*0.5   ) {//在更上边的历史记录位置 则不动作
        //非初始第一页 则不回到底部 | 或许在拉历史数据（收到他人信息更新data但是不回底部）
        [self headerRefreshMsgWillOneOffset];
     
    }else{
        //去底部
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tableViewScrollToBottom];
        });
    }
      */
}

#pragma mark ==
//用户主动 发送数据后 主动回到底部
- (void)sendMsgWillGotoBottomShow{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self tableViewScrollToBottom];
    });
}
#pragma mark ==

//下拉刷新后 内容offset处理 保证消息展示位置在中间
- (void)headerRefreshMsgWillOneOffset{

    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize newContentSize = self.tableView.contentSize;
        CGPoint newContentOffset = CGPointMake(0, newContentSize.height - self.saveOldContentSizeInfo.height);
        [self.tableView setContentOffset:newContentOffset];
    });

}



#pragma mark ==

- (void)undoAndDeletShowNumInit{
    self.undoAndDeletShowNumDataSourceArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.msgDataSourceArr.count; i ++) {
        [self.undoAndDeletShowNumDataSourceArr addObject:@(0)];
    }
}
- (NSMutableArray *)undoAndDeletShowNumDataSourceArr{
    if (!_undoAndDeletShowNumDataSourceArr) {
        _undoAndDeletShowNumDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _undoAndDeletShowNumDataSourceArr;
}
- (NSMutableArray *)msgDataSourceArr{
    if (!_msgDataSourceArr) {
        _msgDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _msgDataSourceArr;
}
//
#pragma mark ====
- (void)bottomHidenFunctionView{
    [self packUpKeyboard];
}

#pragma mark ====
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.chatBarView.textView.delegate = self;//输入框view
        self.chatBarView.textView.returnKeyType = UIReturnKeySend;
        self.chatBarView.textView.enablesReturnKeyAutomatically = YES;
        self.chatFunctionView.delegate = self;
        self.isFunctionViewShow = NO;
        self.isEmojiViewShow = NO;
        self.chatFunctionView.hidden = YES;//菜单
        self.emjBottomView.hidden = YES;//表情
        self.iskeyboardShow = NO;
        [self setUI];
        [self registerForKeyboardNotifications];
    }
    
    return self;
}

- (void)setUI {
    [self addSubview:self.backImgV];
    [self addSubview:self.tableView];
    [self addSubview:self.chatBarView];
    [self addSubview:self.chatFunctionView];
    [self addSubview:self.emjBottomView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_chatBarView.mas_top);
    }];
    [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView);
        make.top.bottom.equalTo(_backImgV.superview);
    }];
    [_chatBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_chatBarView.superview);
        make.bottom.equalTo(_chatFunctionView.mas_top);
        make.height.offset(57);
    }];
    [_chatFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_chatFunctionView.superview);
        make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
        make.height.offset(h_funcationBottomView);
    }];
    
    [_emjBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_emjBottomView.superview);
        make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView - bottom_height);
        make.height.offset(h_emjBottomView);
    }];
    [self tableViewScrollToBottom];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tableViewScrollToBottom];
    });
    WEAKSELF
    self.emjBottomView.chatViewSubFunctionOfEmojiViewTouchBlock = ^(NSInteger touchIndex, NSString * _Nonnull touchEmjImgName) {
        [weakSelf touchEmjWithEmjIndex:touchIndex withEmjName:touchEmjImgName];
    };
}

// 移除键盘监听事件
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 懒加载
- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]init];
        _backImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backImgV.layer.masksToBounds = YES;
//        _backImgV.contentMode = UIViewContentModeScaleAspectFit;
        _backImgV.backgroundColor = Y_ColorWith16FromRGB(0xF2F7FA);
    }
    return _backImgV;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)]];//点击cell\tabview隐藏显示底部栏
        [_tableView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongPressGes:)]];//点击cell\tabview显示长按后的信息删除和撤销键
        // 设置单元格自适应
        _tableView.estimatedRowHeight = kEstimatedRowHeight;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 设置代理
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 设置tableView样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册单元格
        [_tableView registerNib:[UINib nibWithNibName:@"ZYChatLeftCell" bundle:nil] forCellReuseIdentifier:chatLeftCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZYChatRightCell" bundle:nil] forCellReuseIdentifier:chatRightCellID];
    }
    
    return _tableView;
}

- (ZYChatBarView *)chatBarView {
    if (!_chatBarView) {
        _chatBarView = [[NSBundle mainBundle] loadNibNamed:@"ZYChatBarView" owner:nil options:nil].lastObject;
        [_chatBarView.voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_chatBarView.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_chatBarView.funButton addTarget:self action:@selector(funButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _chatBarView.textView.delegate = self;
    }
    
    return _chatBarView;
}

- (ZYChatFunctionView *)chatFunctionView {
    if (!_chatFunctionView) {
        _chatFunctionView = [[NSBundle mainBundle] loadNibNamed:@"ZYChatFunctionView" owner:nil options:nil].lastObject;
    }
    
    return _chatFunctionView;
}
- (ChatViewSubFunctionOfEmojiView *)emjBottomView{
    if (!_emjBottomView) {
        _emjBottomView = [[ChatViewSubFunctionOfEmojiView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, h_emjBottomView)];
    }
    return _emjBottomView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.msgDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {//会话行 row数据都是dic在cell转成mode 防止乱序
//   商品cell test
//    if (indexPath.row == [tableView numberOfRowsInSection:0]-1) {
//        ChatCellGoodsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatCellGoodsInfoTableViewCell_I];
//        if (!cell) {
//            cell = [[ChatCellGoodsInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatCellGoodsInfoTableViewCell_I];
//        }
//        [cell fillGoodsCellWithDateStr:@"1999999" withfillGoodsInfo:@""];//test
//        return cell;
//    }
    
    //  //撤回删除类型 不再model.msg_type里 而是单独键值，model.msg_type保留原本类型 || 接收他人的撤回数据 只有revoke_msg键
    NSDictionary *msgDic = self.msgDataSourceArr[indexPath.row];
    
       
    if ([[msgDic allKeys]containsObject:@"msg_ser_id"]) {//----新版本数据
        self.selfGetMsgDataIsOldVer = NO;
        ChatFriendMessageModel *model = [ChatFriendMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
        if (model.is_revoke) {//撤回（群+人）
            return  [self tableView:tableView undoTypeSystemCellForRowAtIndexPath:indexPath withMessagDic:msgDic];
//        }else if (model.){//删除这个功能暂时不做
//            return  [self tableView:tableView deletTypeSystemCellForRowAtIndexPath:indexPath withMessagDic:msgDic];
        }else{
            //公共消息tips
            if ([model.msg_type isEqualToString:kWebSocketMsgTypeKey_Tips]) {
                ChatVcSubStyemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubTipsCell_I];
                if (!cell) {
                    cell = [[ChatVcSubStyemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubTipsCell_I];
                }
                NSDictionary *thisTipData = [Tool dictionaryWithJsonString:model.data];
                NSString *from_Show = [TextShowWithModelStr textShowWithModelStr:[thisTipData objectForKey:@"from_Show"]];
                NSString *other_show =  [TextShowWithModelStr textShowWithModelStr: [thisTipData objectForKey:@"other_show"]];
                if ([model.from_user isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account]) {//发送方是自己
                    [cell fillSystemNoticeCellWithDateStr:model.create_time withGroupAddMemberWithWillShowStr:from_Show];
                }else{//自己不是发送方
                    [cell fillSystemNoticeCellWithDateStr:model.create_time withGroupAddMemberWithWillShowStr:other_show];
                }
                return cell;
            }else
            if (self.chatVC_type==ChatVC_GroupChat) {//群会话

                ChatGroupMessageModel *model = [ChatGroupMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
                if([model.from_user isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]){//自己
                    return [self tableView:tableView groupOwnCellForRowAtIndexPath:indexPath withGroupModel:model];
                }else if ([model.from_user isEqualToString:kWebSocketMsgTypeKey_from_user_sys_notice]) {//系统消息 常见于增减成员的数据
                    return [self tableView:tableView systemCellForRowAtIndexPath:indexPath withGroupMessageModel:model orWithFriendMessageModel:nil];
                }else{//他人
                    return [self tableView:tableView groupOtherCellForRowAtIndexPath:indexPath withGroupModel:model];
                }

            }else{ //好友会话

                ChatFriendMessageModel *model = [ChatFriendMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
                if ([model.from_user isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {//自己
                    return [self tableView:tableView friendOwnCellForRowAtIndexPath:indexPath  withFriendMessageModel:model];
                }else if ([model.from_user isEqualToString:kWebSocketMsgTypeKey_from_user_sys_notice]) {//系统消息 好友会话里面暂未遇到 ｜收到的撤回信息
                    return [self tableView:tableView systemCellForRowAtIndexPath:indexPath withGroupMessageModel:nil orWithFriendMessageModel:model];
                }else {//他人
                    return [self tableView:tableView friendOtherCellForRowAtIndexPath:indexPath withFriendMessageModel:model];

                }
            }
        }
        
    }else{
        self.selfGetMsgDataIsOldVer = YES;
        //____旧版or自己发送的数据（非请求orsocket得到的数据）
        if (([[msgDic allKeys] containsObject:kWebSocketMsgType_Key_Revoke] && [msgDic[kWebSocketMsgType_Key_Revoke] boolValue]==YES) ||[[msgDic allKeys] containsObject:kWebSocketMsgType_Key_RevokeMsg]) {//撤回
            return  [self tableView:tableView undoTypeSystemCellForRowAtIndexPath:indexPath withMessagDic:msgDic];
        }else if([[msgDic allKeys] containsObject:kWebSocketMsgType_Key_Deleted] || [msgDic[kWebSocketMsgType_Key_Deleted] boolValue]==YES){//删除  仅仅显示给用户自己
            return  [self tableView:tableView deletTypeSystemCellForRowAtIndexPath:indexPath withMessagDic:msgDic];

        }else{
            ChatFriendMessageModel *model = [ChatFriendMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
            //公共消息tips
            if ([model.msg_type isEqualToString:kWebSocketMsgTypeKey_Tips]) {
                ChatVcSubStyemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubTipsCell_I];
                if (!cell) {
                    cell = [[ChatVcSubStyemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubTipsCell_I];
                }
                NSDictionary *thisTipData = [Tool dictionaryWithJsonString:model.data];
                NSString *from_Show = [TextShowWithModelStr textShowWithModelStr:[thisTipData objectForKey:@"from_Show"]];
                NSString *other_show =  [TextShowWithModelStr textShowWithModelStr: [thisTipData objectForKey:@"other_show"]];
                if ([model.from_user isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account]) {//发送方是自己
                    [cell fillSystemNoticeCellWithDateStr:model.create_time withGroupAddMemberWithWillShowStr:from_Show];
                }else{//自己不是发送方
                    [cell fillSystemNoticeCellWithDateStr:model.create_time withGroupAddMemberWithWillShowStr:other_show];
                }
                return cell;
            }else
            if (self.chatVC_type==ChatVC_GroupChat) {//群会话

                ChatGroupMessageModel *model = [ChatGroupMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
                if([model.from_user isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]){//自己
                    return [self tableView:tableView groupOwnCellForRowAtIndexPath:indexPath withGroupModel:model];
                }else if ([model.from_user isEqualToString:kWebSocketMsgTypeKey_from_user_sys_notice]) {//系统消息 常见于增减成员的数据
                    return [self tableView:tableView systemCellForRowAtIndexPath:indexPath withGroupMessageModel:model orWithFriendMessageModel:nil];
                }else{//他人
                    return [self tableView:tableView groupOtherCellForRowAtIndexPath:indexPath withGroupModel:model];
                }

            }else{ //好友会话

                ChatFriendMessageModel *model = [ChatFriendMessageModel mj_objectWithKeyValues:self.msgDataSourceArr[indexPath.row]];
                if ([model.from_user isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {//自己
                    return [self tableView:tableView friendOwnCellForRowAtIndexPath:indexPath  withFriendMessageModel:model];
                }else if ([model.from_user isEqualToString:kWebSocketMsgTypeKey_from_user_sys_notice]) {//系统消息 好友会话里面暂未遇到 ｜收到的撤回信息
                    return [self tableView:tableView systemCellForRowAtIndexPath:indexPath withGroupMessageModel:nil orWithFriendMessageModel:model];
                }else {//他人
                    return [self tableView:tableView friendOtherCellForRowAtIndexPath:indexPath withFriendMessageModel:model];

                }
            }
        }
    }
 

}
 
#pragma mark ==== (群会话｜好友会话)  -- 撤回 | 删除信息
//删除
- (UITableViewCell *)tableView:(UITableView *)tableView deletTypeSystemCellForRowAtIndexPath:(NSIndexPath *)indexPath withMessagDic:(NSDictionary *)msgDic{
    NSString *showStr = @"消息已删除";
    return [self tableView:tableView undoAndDeletTypeSystemCellShowText:showStr];
}
//撤回
- (UITableViewCell *)tableView:(UITableView *)tableView undoTypeSystemCellForRowAtIndexPath:(NSIndexPath *)indexPath withMessagDic:(NSDictionary *)msgDic{
    NSString *showStr = @"撤回消息";
    return [self tableView:tableView undoAndDeletTypeSystemCellShowText:showStr];
}
- (UITableViewCell *)tableView:(UITableView *)tableView undoAndDeletTypeSystemCellShowText:(NSString *)showTextStr{
    ChatVcSubStyemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubStyemInfoTableViewCell_Identifier];
    if (!cell) {
        cell = [[ChatVcSubStyemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubStyemInfoTableViewCell_Identifier];
    }
    cell.showSystemInfoLabel.text = showTextStr;
    return cell;
}
#pragma mark ==== (群会话｜好友会话)  -的- (系统消息) cell
- (UITableViewCell *)tableView:(UITableView *)tableView systemCellForRowAtIndexPath:(NSIndexPath *)indexPath withGroupMessageModel:(ChatGroupMessageModel *)gMmodel orWithFriendMessageModel:(ChatFriendMessageModel *)fMmodel {
    if (self.chatVC_type==ChatVC_GroupChat) {//群会话
 
        ChatVcSubStyemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubStyemInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[ChatVcSubStyemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubStyemInfoTableViewCell_Identifier];
        }
        if ([gMmodel.msg_type isEqualToString:kWebSocketMsgTypeObj_group_member_add]) {
        
        // DLog(@"新增成员信息
         NSString *group_member =  [gMmodel.group_member_add objectForKey:@"group_member"];//新成员
         NSString *invite_people =  [gMmodel.group_member_add objectForKey:@"invite_people"];//主动拉人
            if (isNotNil(self.dataSourceOfMemberNickNameStrDic) && [[self.dataSourceOfMemberNickNameStrDic allKeys]containsObject:invite_people]  && [[self.dataSourceOfMemberNickNameStrDic allKeys]containsObject:group_member]) {//带昵称才走具体数据
                NSString *systemInfoAddGroupMember = @"";
                if (![group_member isEqualToString:invite_people]) {
                    systemInfoAddGroupMember = [NSString stringWithFormat:@"%@邀请了%@",[self.dataSourceOfMemberNickNameStrDic objectForKey:invite_people],[self.dataSourceOfMemberNickNameStrDic objectForKey:group_member]];
                }else{//创建人
                    systemInfoAddGroupMember = [NSString stringWithFormat:@"%@创建了本群",[self.dataSourceOfMemberNickNameStrDic objectForKey:invite_people]];
                }
                [cell fillSystemNoticeCellWithDateStr:gMmodel.create_time withGroupAddMemberWithWillShowStr:systemInfoAddGroupMember];
            }else{
                [cell fillSystemNoticeCellWithDateStr:gMmodel.create_time withGroupAddMemberWithWillShowStr:@"新增成员"];
            }
        }else{
            [cell fillSystemNoticeCellWithDateStr:gMmodel.create_time withGroupAddMemberWithWillShowStr:@"系统通知信息"];
        }
        
        return cell;
    }else{
        ChatVcSubStyemInfoTableViewCell *cell = [[ChatVcSubStyemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubStyemInfoTableViewCell_Identifier];
        cell.textLabel.text = @"系统通知信息_好友会话";
        return cell;
    }
   
}

#pragma mark ==== 好友会话cell
//好友会话类型 自己 ( right 的所有cell )

- (UITableViewCell *)tableView:(UITableView *)tableView friendOwnCellForRowAtIndexPath:(NSIndexPath *)indexPath withFriendMessageModel:(ChatFriendMessageModel *)model {
    ChatThisCellShowLeftRightSystemOtherType msgLeftRightSystemType = ChatThisCellShowLeftRightSystemOtherType_Right;
    
    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
        
        ZYChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:chatRightCellID forIndexPath:indexPath];
        //cell.delegate = self;
        cell.iconImageView.userInteractionEnabled = YES;
        cell.iconImageView.tag = 200 + indexPath.row;
        [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
        [cell fillMsgCellWithFriendMsgData:model orGroupModel:nil];
        [cell showOrHiddenCellDeletAndUndoBtnWithNilNumIsHidden:[self.undoAndDeletShowNumDataSourceArr[indexPath.row] boolValue]];
        return cell;
        
    }else{
        //非文本类型
        return [self tableView:tableView friendAllCellForRowAtIndexPath:indexPath withFriendMessageModel:model withRightOrLeftType:msgLeftRightSystemType];
    }
    
}
//好友会话类型 他人 (left 的cell)
- (UITableViewCell *)tableView:(UITableView *)tableView friendOtherCellForRowAtIndexPath:(NSIndexPath *)indexPath  withFriendMessageModel:(ChatFriendMessageModel *)model {
    ChatThisCellShowLeftRightSystemOtherType msgLeftRightSystemType = ChatThisCellShowLeftRightSystemOtherType_Left;
    
    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {//文本类型
        ZYChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:chatLeftCellID forIndexPath:indexPath];
        cell.iconImageView.userInteractionEnabled = YES;
        cell.iconImageView.tag = 200 + indexPath.row;
        [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
        //好友会话——好友
        [cell fillFriendMsgCellWithMsgData:model];
        
        return cell;
    }else{ //非文本类型
        return [self tableView:tableView friendAllCellForRowAtIndexPath:indexPath withFriendMessageModel:model withRightOrLeftType:msgLeftRightSystemType];
    }
}

//好友会话类型  左+右   非文本类型cells
- (UITableViewCell *)tableView:(UITableView *)tableView friendAllCellForRowAtIndexPath:(NSIndexPath *)indexPath withFriendMessageModel:(ChatFriendMessageModel *)model  withRightOrLeftType:(ChatThisCellShowLeftRightSystemOtherType)msgLeftRightSystemType{
    ChatVcSessionType_FriendGroupSystemOtehr friendOrGroupOrSystemOrOtherType = ChatVcSessionType_FriendGroupSystemOtehr_Friend;
    //index  model ForGorOther类型 rightOrleft msg_type
    return [self tableView:tableView alllCellForRowAtIndexPath:indexPath  withFriendOrGroupMessageModel:model withFriendOrGroupOrSystemOtherType:friendOrGroupOrSystemOrOtherType withRightOrLeftType:msgLeftRightSystemType withThisMsgTypeStr:model.msg_type];

    
}

#pragma mark ==== 群会话cell
//群自己发的信息
- (UITableViewCell *)tableView:(UITableView *)tableView groupOwnCellForRowAtIndexPath:(NSIndexPath *)indexPath withGroupModel:(ChatGroupMessageModel *)model {
    ChatThisCellShowLeftRightSystemOtherType msgLeftRightSystemType = ChatThisCellShowLeftRightSystemOtherType_Right;

    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
        
        ZYChatRightCell *cell = [tableView dequeueReusableCellWithIdentifier:chatRightCellID forIndexPath:indexPath];
        cell.iconImageView.userInteractionEnabled = YES;
        cell.iconImageView.tag = 200 + indexPath.row;
        [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
        [cell fillMsgCellWithFriendMsgData:nil orGroupModel:model];
        [cell showOrHiddenCellDeletAndUndoBtnWithNilNumIsHidden:[self.undoAndDeletShowNumDataSourceArr[indexPath.row] boolValue]];
        //cell.delegate = self;
        return cell;
        
    }else{
        return [self tableView:tableView groundAllCellForRowAtIndexPath:indexPath withGroupMessageModel:model withRightOrLeftType:msgLeftRightSystemType];
    }
        

}
//他人  （left的cell）除了自己之外  群
- (UITableViewCell *)tableView:(UITableView *)tableView groupOtherCellForRowAtIndexPath:(NSIndexPath *)indexPath withGroupModel:(ChatGroupMessageModel *)model {
    ChatThisCellShowLeftRightSystemOtherType msgLeftRightSystemType = ChatThisCellShowLeftRightSystemOtherType_Left;

    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
        ZYChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:chatLeftCellID forIndexPath:indexPath];
        cell.iconImageView.userInteractionEnabled = YES;
        cell.iconImageView.tag = 200 + indexPath.row;
        [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap:)]];
        [cell fillFriendMsgCellWithMsgData:model];

        return cell;
    }else{
        return [self tableView:tableView groundAllCellForRowAtIndexPath:indexPath withGroupMessageModel:model withRightOrLeftType:msgLeftRightSystemType];
    }
          
}
//==== 群类型 左+右｜非文本的cell
 
- (UITableViewCell *)tableView:(UITableView *)tableView groundAllCellForRowAtIndexPath:(NSIndexPath *)indexPath withGroupMessageModel:(ChatGroupMessageModel *)model  withRightOrLeftType:(ChatThisCellShowLeftRightSystemOtherType)msgLeftRightSystemType{
    ChatVcSessionType_FriendGroupSystemOtehr friendOrGroupOrSystemOrOtherType = ChatVcSessionType_FriendGroupSystemOtehr_Group;
     //index  model ForGorOther类型 rightOrleft msg_type
    return [self tableView:tableView alllCellForRowAtIndexPath:indexPath  withFriendOrGroupMessageModel:model withFriendOrGroupOrSystemOtherType:friendOrGroupOrSystemOrOtherType withRightOrLeftType:msgLeftRightSystemType withThisMsgTypeStr:model.msg_type];

}

#pragma mark ============ 全部 ___ 的非文本的cell
- (UITableViewCell *)tableView:(UITableView *)tableView alllCellForRowAtIndexPath:(NSIndexPath *)indexPath withFriendOrGroupMessageModel:(id)model withFriendOrGroupOrSystemOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendOrGroupOrSystemOrOtherType withRightOrLeftType:(ChatThisCellShowLeftRightSystemOtherType)msgLeftRightSystemType withThisMsgTypeStr:(NSString *)msg_type{

    if ([msg_type isEqualToString:kWebSocketMsgTypeObj_Image]){
        if ( msgLeftRightSystemType == ChatThisCellShowLeftRightSystemOtherType_Right) {//ChatVcSubImgTypeTableViewCell_Right_I
            ChatVcSubImgTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubImgTypeTableViewCell_Right_I];
            if (!cell) {
                cell = [[ChatVcSubImgTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubImgTypeTableViewCell_Right_I];
                cell.chatVcSubCellsDeletage = self;
                [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
            }
            //基础数据+内容数据
            [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Image withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
            [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
            return cell;
        }else{//hatVcSubImgTypeTableViewCell_Left_I
            ChatVcSubImgTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubImgTypeTableViewCell_Left_I];
            if (!cell) {
                cell = [[ChatVcSubImgTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubImgTypeTableViewCell_Left_I];
                cell.chatVcSubCellsDeletage = self;
                [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
            }
            //基础数据+内容数据
            [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Image withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
            [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
            return cell;
        }
       
    
     
   }else if ([msg_type isEqualToString:kWebSocketMsgTypeObj_Voice]){
       
       if ( msgLeftRightSystemType == ChatThisCellShowLeftRightSystemOtherType_Right) {
           ChatVcSubVoiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubVoiceTypeTableViewCell_Right_I];
           if (!cell) {
               cell = [[ChatVcSubVoiceTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubVoiceTypeTableViewCell_Right_I];
               cell.chatVcSubCellsDeletage = self;
               [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
           }
           //基础数据+内容数据
           [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Voice withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model withRightOrLeft:msgLeftRightSystemType];
           return cell;
       }else{
           ChatVcSubVoiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatVcSubVoiceTypeTableViewCell_Left_I];
           if (!cell) {
               cell = [[ChatVcSubVoiceTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubVoiceTypeTableViewCell_Left_I];
               cell.chatVcSubCellsDeletage = self;
               [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
           }
           //基础数据+内容数据
           [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Voice withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model withRightOrLeft:msgLeftRightSystemType];

           return cell;
       }
     
   
   }else if ([msg_type isEqualToString:kWebSocketMsgTypeObj_Position]){//定位地址类型
       if ( msgLeftRightSystemType == ChatThisCellShowLeftRightSystemOtherType_Right) {
           ChatVcSubAddressTypeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ChatVcSubAddressTypeTableViewCell_Right_I];
           if (!cell) {
               cell = [[ChatVcSubAddressTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubAddressTypeTableViewCell_Right_I];
               cell.chatVcSubCellsDeletage = self;
               [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
           }
           //基础数据+内容数据
           [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Position withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           return cell;
       }else{
           ChatVcSubAddressTypeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ChatVcSubAddressTypeTableViewCell_Left_I];
           if (!cell) {
               cell = [[ChatVcSubAddressTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatVcSubAddressTypeTableViewCell_Left_I];
               cell.chatVcSubCellsDeletage = self;
               [cell fillBeginWithUILeftOrRightOrCenter:msgLeftRightSystemType];//UI
           }
           //基础数据+内容数据
           [cell fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:msgLeftRightSystemType withThisMsgInfoType:kWebSocketMsgTypeObj_Position withFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           [cell fillMsgCellContentInfoWithFriendGroupOtherType:friendOrGroupOrSystemOrOtherType withMsgModel:model];
           return cell;
       }
      
       
   }else{//其他类型
       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OtherCells"];;
       return cell;
   }
}



#pragma mark ============ 协议

#pragma mark == mp4
- (void)cellDelegateWithTouchMp4OpenOrCloseActionwithFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle withTouchIsOpenMp4Bool:(BOOL)isOpenMp4{
    
}

#pragma mark == 定位位置
- (void)cellDelegateWithTouchOpenLocateActionWithAddressStr:(NSString *)addressStr withLatFloat:(CGFloat)lat withLongFloat:(CGFloat)longi andWithFriendMsgWithMsgData:(nullable ChatFriendMessageModel *)fmodel  orGroupModel:(nullable ChatGroupMessageModel *)gmodle;{
    //跳转到地图大的view展示页
   // Y_SVP_SHOW_INFO_MES(@"跳转到地图大的view展示页");
    if (_delegate && [_delegate respondsToSelector:@selector(viewDeletWithShowBigLocateViewWithShowAddressStr:withlati:withLongi:)]) {
        [_delegate viewDeletWithShowBigLocateViewWithShowAddressStr:addressStr withlati:lat withLongi:longi];
    }
}



#pragma mark ====*====*==== 旧版本 end （新旧model区别数据处理）
#pragma mark == cells delegate
#pragma mark === 播放语音
//播放语音 点击后（下载播放 确定动画的cell是0或单个，做播放完后的回调 停止动画）
- (void)cellDelegateWithTouchVoicePlayActionFriendMsgWithMsgData:(ChatFriendMessageModel *)fmodel orGroupModel:(ChatGroupMessageModel *)gmodle{
   // DLog(@"语音播放 源model");
 
    NSString *secret = @"";
    NSString *url = @"";
    NSString *msgId = @"";
 
        if (self.chatVC_type==ChatVC_GroupChat) {//群会话
            NSDictionary *dataDic = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:gmodle.data]];
            secret = [[dataDic allKeys]containsObject:@"secret"] ? dataDic[@"secret"] : @"";
            url =  [[dataDic allKeys]containsObject:@"url"] ? dataDic[@"url"] : @"";
            msgId = gmodle.msg_id;
        }else{//好友会话
//            uuid = fmodel.voice[@"content"];//旧
            NSDictionary *dataDic = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:fmodel.data]];
            secret = [[dataDic allKeys]containsObject:@"secret"] ? dataDic[@"secret"] : @"";
            url =  [[dataDic allKeys]containsObject:@"url"] ? dataDic[@"url"] : @"";
            msgId = fmodel.msg_id;
        }
    if (url.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"音频数据有误！");
        //通知暂停
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatVoicePalyingEnd_NoticeName, msgId);
        return;
    }
    //url地址
    if (_delegate && [_delegate respondsToSelector:@selector(subViewCllVoiceTypeCellPlayVoiceActionWitnMsgId:withFileSecret:withFileSecretFileUrlStr:)]) { 
        [_delegate subViewCllVoiceTypeCellPlayVoiceActionWitnMsgId:msgId withFileSecret:secret withFileSecretFileUrlStr:url];//downVoice openVoice
    }
}

#pragma mark === 大图展示
//0324
- (void)cellDelegateWithTouchImgWithAllUrlStr:(NSString *)imgAllUrlStr{
    if (_delegate && [_delegate respondsToSelector:@selector(subViewCellImgTypeCellWillShowBigImgWithImgAllUrlStr:)]) {
        [_delegate subViewCellImgTypeCellWillShowBigImgWithImgAllUrlStr:imgAllUrlStr];
    }
}
 
#pragma mark === 删除 撤回
//删除
- (void)cellDelegateWithTouchDeletFriendMsgWithMsgData:(ChatFriendMessageModel *)fmodel orGroupModel:(ChatGroupMessageModel *)gmodle{
    Y_SVP_SHOW_ERR_MES(@"删除功能暂未开放！");//这一版暂时屏蔽
    return;
    //
    NSString *uuid = @"";
    NSString *seqID = @"";
    if (self.chatVC_type==ChatVC_GroupChat) {//群会话
        uuid = [TextShowWithModelStr textShowWithModelStr:gmodle.to_group];
        seqID = [TextShowWithModelStr textShowWithModelStr:gmodle.sequence_id];
    }else{//好友会话
        uuid = [TextShowWithModelStr textShowWithModelStr:fmodel.to_user];
        seqID = [TextShowWithModelStr textShowWithModelStr:fmodel.sequence_id];
    }
    [self deletMsgWithSeqId:seqID withUUID:uuid];
}
//撤回
- (void)cellDelegateWithTouchUndoFriendMsgWithMsgData:(ChatFriendMessageModel *)fmodel orGroupModel:(ChatGroupMessageModel *)gmodle{
    Y_SVP_SHOW_ERR_MES(@"撤回功能暂未开放！");//这一版暂时屏蔽
    return;
    NSString *uuid = @"";
    NSString *seqID = @"";
    if (self.chatVC_type==ChatVC_GroupChat) {//群会话
        uuid = [TextShowWithModelStr textShowWithModelStr:gmodle.to_group];
        seqID = [TextShowWithModelStr textShowWithModelStr:gmodle.sequence_id];
    }else{//好友会话
        uuid = [TextShowWithModelStr textShowWithModelStr:fmodel.to_user];
        seqID = [TextShowWithModelStr textShowWithModelStr:fmodel.sequence_id];
    }
    [self undoMsgWithSeqId:seqID withUUID:uuid];
}
- (void)deletMsgWithSeqId:(NSString *)seqID withUUID:(NSString *)uuid{
    WEAKSELF
    [ChatManagerData chatInfoDeletOneMessageWithSequenceId:seqID withFriendId:uuid withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {//删除成功
            STRONGSELF
            [strongSelf messageDeletOrCancelSuccess];
        }
    }];
}
- (void)undoMsgWithSeqId:(NSString *)seqID withUUID:(NSString *)uuid{
    WEAKSELF
    [ChatManagerData chatInfoWithUndoOneMessageWithSequenceId:seqID withFriendId:uuid withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {//撤回成功
            //刷新当前vc数据
            STRONGSELF
            [strongSelf messageDeletOrCancelSuccess];
        }
    }];
}
- (void)messageDeletOrCancelSuccess{
    if (_delegate  && [_delegate respondsToSelector:@selector(messageInfoDeletOrCancelWillGetNewInfoList)]) {
        [_delegate messageInfoDeletOrCancelWillGetNewInfoList];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self packUpKeyboard];
}

#pragma mark - ZYChatFunctionViewDelegate
- (void)collectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        NSLog(@"相册");
//    }else if (indexPath.row == 1) {
//        NSLog(@"拍照");
//    }else if (indexPath.row == 2) {
//        NSLog(@"视频通话");
//    }else if (indexPath.row == 3) {
//        NSLog(@"位置");
//    }else if (indexPath.row == 4) {
//        NSLog(@"语音输入");
//    }else if (indexPath.row == 5) {
//        NSLog(@"我的收藏");
//    }else if (indexPath.row == 6) {
//        NSLog(@"红包");
//    }else if (indexPath.row == 7) {
//        NSLog(@"转账");
//    }
    NSLog(@"ZYChatFunctionViewDelegate touch index %ld",indexPath.row);
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchSubCollectionViewWithIndexFoundation:)]) {
        [_delegate touchSubCollectionViewWithIndexFoundation:indexPath.row];
    }
    [self packUpKeyboard];//收起键盘
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.saveOldContentSizeInfo = scrollView.contentSize;//20220323 记录旧的位置信息
}

#pragma mark - 滑动到tableView底部
- (void)tableViewScrollToBottom { 
    NSInteger tableViewLastRowNum = [self.tableView numberOfRowsInSection:0]-1;
    if (tableViewLastRowNum>1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tableViewLastRowNum inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
}

#pragma mark - 监听键盘
- (void)registerForKeyboardNotifications {

    //使用NSNotificationCenter 键盘弹出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
    self.iskeyboardShow = YES;
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    if (self.isFunctionViewShow == NO) {//菜单不显示
        self.chatFunctionView.hidden = YES;
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_chatFunctionView.superview).with.offset(-keyboardSize.height + h_funcationBottomView);
        }];
    }
    if (self.isEmojiViewShow == NO) {//表情不显示
        self.emjBottomView.hidden = YES;
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(-keyboardSize.height + h_emjBottomView);
        }];
    }else{
        //其他多种情况
    }
   
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
    [self tableViewScrollToBottom];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
    self.iskeyboardShow = NO;
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.isFunctionViewShow) {//显示菜单v ｜不显示表情
        self.isEmojiViewShow = NO;
        self.emjBottomView.hidden = YES;
        
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_chatFunctionView.superview).with.offset(-bottom_height);
        }];
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView - bottom_height);
        }];
        
    }else if (self.isEmojiViewShow){//显示表情v ｜不显示菜单
        self.isFunctionViewShow = NO;
        self.chatFunctionView.hidden = YES;
        
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
        }];
        
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(-bottom_height);
        }];
    }else{
        self.isEmojiViewShow = NO;
        self.isFunctionViewShow = NO;
        self.emjBottomView.hidden = YES;
        self.chatFunctionView.hidden = YES;
        //菜单和表情都不显示
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
        }];
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView - bottom_height);
        }];
        
    }
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {//发送文本动作 可以带[]的字符
        
//        [self sendTextMessage:textView.text];
        NSLog(@"sendaction chtViewSaveTextViewStr ==  %@",self.chtViewSaveTextViewStr);
        [self sendTextMessage:self.chtViewSaveTextViewStr];
        
        return NO;
    }else{
        
        if (!([  self.chtViewSaveTextViewStr containsString:k_emj_tip_start] && [self.chtViewSaveTextViewStr containsString:k_emj_tip_end])) {//无表情图
//            [self.chtViewSaveTextViewStr insertString:[text mutableCopy] atIndex:range.location];
            return YES;
        }else{
            //第一响应
            if (![textView isFirstResponder]) {
                [textView isFirstResponder];
            }
        
            NSLog(@"------ shouldChangeTextInRange chtViewSaveTextViewStr == %@ ",self.chtViewSaveTextViewStr);
            NSLog(@"------ text %@",text);
            if (text.length>0) {//非删除动作
                //有表情的情况下 输入文本 增加处理
                NSMutableString *oldtext = [[NSMutableString alloc]initWithString:self.chtViewSaveTextViewStr];
                NSMutableString *mtext = [[NSMutableString alloc]initWithString:text];
                [oldtext insertString:mtext atIndex: textView.selectedRange.location];
                self.chtViewSaveTextViewStr = [[NSMutableString alloc]initWithString:oldtext ];
            }else{//删除动作
                //有表情的情况下 删除文本或emj 处理
                //拿到光标前文本
                //再处理Str
                UITextPosition *beginning = textView.beginningOfDocument;
                UITextPosition *selectionStart =textView.selectedTextRange.start;
                UITextPosition *selectionEnd = textView.selectedTextRange.end;
                NSInteger location = [textView offsetFromPosition:beginning toPosition:selectionStart];
                NSInteger length = [textView offsetFromPosition:selectionStart toPosition:selectionEnd];
                NSRange selectedRange = NSMakeRange(location,length);
                NSRange range = NSMakeRange(selectedRange.location-1,1);
                NSString *lastChar = [_chtViewSaveTextViewStr substringWithRange:range];

                if ([lastChar isEqualToString:k_emj_tip_end]) {//判断是否表情 删除
                    if ([_chtViewSaveTextViewStr containsString:k_emj_tip_start]) {//包含表情 -- 处理删除表情判断 待定
                         
                    }else{
                        _chtViewSaveTextViewStr = [[NSMutableString alloc]initWithFormat:@"%@%@",[_chtViewSaveTextViewStr substringToIndex:range.location],[_chtViewSaveTextViewStr substringFromIndex:range.location+1]];
                    }
                    
                }else{//删除单个字符
                    _chtViewSaveTextViewStr = [[NSMutableString alloc]initWithFormat:@"%@%@",[_chtViewSaveTextViewStr substringToIndex:range.location],[_chtViewSaveTextViewStr substringFromIndex:range.location+1]];
                }
                
                
                
                NSMutableString *oldtext = [[NSMutableString alloc]initWithString:self.chtViewSaveTextViewStr];
                NSMutableString *mtext = [[NSMutableString alloc]initWithString:text];
                [oldtext insertString:mtext atIndex: textView.selectedRange.location];
                self.chtViewSaveTextViewStr = [[NSMutableString alloc]initWithString:oldtext ];
            }


             return YES;
        }
    }
    
    return YES;
}
//- (void)getAttTextLastImgIndexOfAddNewStr:(NSString *)text{//文本插入到已有数据中 暂时失败
//    NSRange range;
//    NSMutableArray *imgList = [[NSMutableArray alloc]initWithCapacity:0];
//    for (int i = 0; i < _chatBarView.textView.text.length; i++) {
//        NSDictionary *dic = [_chatBarView.textView.attributedText attributesAtIndex:i effectiveRange:&range];
//
//        //文本增入
//        NSAttributedString *newStr = [_chatBarView.textView.attributedText :[[NSAttributedString alloc] initWithString:text attributes:nil]]
//        //图片
//        //NSTextAttachment *img = dic[@"NSTextAttachment"];//
//        NSTextAttachment *img = dic[@"NSAttachment"];//
//        if (img) {
//            NSLog(@"文本框内有图片 位置 %d",i);
////            img.image = i;
//            [imgList addObject:img];
//        }
//
//    }
//
//    NSLog(@" imgList = %@",imgList)
//
//}
- (void)textViewDidChange:(UITextView *)textView {
    //输入文本会和表情图片冲突
    // 获取textView的高度
    // 把该属性放到字典中ƒ
    NSLog(@"------ textViewDidChange chtViewSaveTextViewStr == %@ ",self.chtViewSaveTextViewStr);
    
    if (!([  self.chtViewSaveTextViewStr containsString:k_emj_tip_start] && [self.chtViewSaveTextViewStr containsString:k_emj_tip_end]) &&  !([textView.text containsString:k_emj_tip_start] && [textView.text containsString:k_emj_tip_end])) {//无表情图
        
        self.chtViewSaveTextViewStr = [textView.text mutableCopy];

        
        NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
        // 通过字符串的计算文字所占尺寸方法获取尺寸
        CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width - 10,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:dicAttr context:nil].size;
        NSInteger lines = size.height / textView.font.lineHeight;
        CGFloat labelHeight = 0.0;
        if (lines > 4) {
            textView.bounces = YES;
            textView.showsVerticalScrollIndicator = YES;
            textView.scrollEnabled = YES;
            labelHeight = textView.font.lineHeight * 3;
        }else {
            textView.bounces = NO;
            textView.showsVerticalScrollIndicator = NO;
            textView.scrollEnabled = NO;
            if (lines > 1) {
                labelHeight = textView.font.lineHeight * (lines - 1);
            }
        }
        [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(57 + labelHeight);
        }];
    }else{//有表情图---需要转形态 (在有表情时暂时做不允许继续输入文本操作防止崩溃)
        
        NSString *oldSaveTextStr =  self.chtViewSaveTextViewStr;
        NSLog(@"oldSaveTextStr = %@ \n nowText = %@",oldSaveTextStr,textView.attributedText);
        [ChatViewEmojiTool getEmjIndexArrWithStr:oldSaveTextStr withBlock:^(NSMutableAttributedString * _Nonnull okAttributedString) {//带格式的带总表情的str
            textView.attributedText  = okAttributedString;
            
        }];
 
        [self changeTextViewHeightWhenHaveEmjWithTextView:textView];
    }
}
//有表情时高度处理
- (void)changeTextViewHeightWhenHaveEmjWithTextView:(UITextView *)textView{
//    //第一响应
//    if (![textView isFirstResponder]) {
//        [textView isFirstResponder];
//    }
    //光标位置 无需更改
//    textView.selectedRange = NSMakeRange(textView.attributedText.length, 1);
//    CGSize size = [textView.attributedText boundingRectWithSize:CGSizeMake(textView.frame.size.width - 10,  MAXFLOAT)
//                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
//                                                        context:nil].size;
//
    
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:textView.font,NSFontAttributeName,textView.largeContentImage,NSAttachmentAttributeName, nil];

    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width - 10,  MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                        attributes:dicAttr
                                                        context:nil].size;
    
    NSInteger lines = size.height / textView.font.lineHeight;
    CGFloat labelHeight = 0.0;
    if (lines > 4) {
        textView.bounces = YES;
        textView.showsVerticalScrollIndicator = YES;
        textView.scrollEnabled = YES;
        labelHeight = textView.font.lineHeight * 3;
    }else {
        textView.bounces = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.scrollEnabled = NO;
        if (lines > 1) {
            labelHeight = textView.font.lineHeight * (lines - 1);
        }
    }
    NSLog(@"line = %ld labeH = %f",lines,labelHeight);
    [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(57 + labelHeight);
    }];
 
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - 发送文字信息
- (void)sendTextMessage:(NSString *)text {
    if (text.length<=0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(delegateTouchsSendMsgWithText:)]) {
        [_delegate delegateTouchsSendMsgWithText:text];
    }
    //清空当前文本相关
    self.chtViewSaveTextViewStr = [[NSMutableString alloc]initWithString:@""];
    //收回键盘 处理框内文本
    self.chatBarView.textView.text = @"";
    self.chatBarView.textView.attributedText = [[NSMutableAttributedString alloc]initWithString:@""];
    //处理textview高度 回到原来高度
    [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(57 + 0);
    }];
    if (_isEmojiViewShow) {
        self.emjBottomView.hidden = YES;
        //表情View位置
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView-bottom_height);
        }];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    [self endEditing:YES];

}

#pragma mark - 处理点击事件
// 录音
- (void)voiceButtonClicked:(UIButton *)sender {
    
   /**
    NSLog(@"录音");
    NSLog(@"语音输入") indexrow=4;
    */
    
    if (_delegate && [_delegate respondsToSelector:@selector(chooseBottomSubVoiceActionWithFoundation)]) {
        [_delegate chooseBottomSubVoiceActionWithFoundation];
    }
    [self packUpKeyboard];//收起键盘
}

// 添加
- (void)addButtonClicked:(UIButton *)sender {
    
    if (!self.isFunctionViewShow) {
        self.isFunctionViewShow = YES;
        self.chatFunctionView.hidden = NO;
        if (self.iskeyboardShow) {
            // 让输入框失去第一响应者
            [self.chatBarView.textView resignFirstResponder];
        }else {
            [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_chatFunctionView.superview).with.offset(-bottom_height);
            }];
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
            }];
            [self tableViewScrollToBottom];
        }
    }else {
        self.isFunctionViewShow = NO;
        self.chatFunctionView.hidden = YES;
        if (!self.iskeyboardShow) {
            // 让输入框称为第一响应者
            [self.chatBarView.textView becomeFirstResponder];
        }
    }
}

#pragma mark ================================================================================== 表情相关

// 表情
- (void)funButtonClicked:(UIButton *)sender {
    
    NSLog(@"表情");
    CGFloat  h_ChatBarSubTextViewView = 0.0;
     // 获取textView的高度
     // 把该属性放到字典中ƒ
     NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:self.chatBarView.textView.font,NSFontAttributeName, nil];
     // 通过字符串的计算文字所占尺寸方法获取尺寸
     CGSize size = [self.chatBarView.textView.attributedText.string boundingRectWithSize:CGSizeMake(self.chatBarView.textView.frame.size.width - 10,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:dicAttr context:nil].size;
     NSInteger lines = size.height / self.chatBarView.textView.font.lineHeight;
   
     if (lines > 4) {
         self.chatBarView.textView.bounces = YES;
         self.chatBarView.textView.showsVerticalScrollIndicator = YES;
         self.chatBarView.textView.scrollEnabled = YES;
         h_ChatBarSubTextViewView = self.chatBarView.textView.font.lineHeight * 3;
     }else {
         self.chatBarView.textView.bounces = NO;
         self.chatBarView.textView.showsVerticalScrollIndicator = NO;
         self.chatBarView.textView.scrollEnabled = NO;
         if (lines > 1) {
             h_ChatBarSubTextViewView = self.chatBarView.textView.font.lineHeight * (lines - 1);
         }
     }

    
    
    if (!self.isEmojiViewShow) {//表情view 未显示状态
        self.isEmojiViewShow = YES;
        self.emjBottomView.hidden = NO;
        //输入框保持是第一响应
        if (self.iskeyboardShow) {
            // 让输入框失去第一响应者
            [self.chatBarView.textView resignFirstResponder];
        }
   
        //表情View位置
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(-bottom_height);
        }];
        //输入框BarView位置
        [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(57 + h_ChatBarSubTextViewView);
        }];
        //隐藏菜单|（菜单和textV有关联 --- 需要和_emjBottomView等高才能使_chatBarView升到合适位置)
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
            make.bottom.equalTo(_emjBottomView.superview).with.offset(-bottom_height);
        }];
        
    
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
        [self tableViewScrollToBottom];
        
    }else {//有表情view显示状态 做隐藏动作
        self.isEmojiViewShow = NO;
        self.emjBottomView.hidden = YES;
        if (self.iskeyboardShow) {
            // 让输入框失去第一响应者
            [self.chatBarView.textView resignFirstResponder];
        }
        
        //表情View位置
        [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView-bottom_height);
        }];
        //输入框BarView位置
        [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(57 + h_ChatBarSubTextViewView);
        }];
        //隐藏菜单|（菜单和textV有关联 --- 需要等高才能使_chatBarView升到合适位置)
        [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
        }];
    }
    
}

#pragma mark === 点击表情
- (void)touchEmjWithEmjIndex:(NSInteger)touchIndex withEmjName:(NSString *)touchEmjNameStr{
    NSLog(@"点击了表情 %ld,   %@",touchIndex,touchEmjNameStr);
    //输入框内填充约定表情文本符号并且换成图片显示
    [self addImgWithEmjNameStr:touchEmjNameStr];
}
- (NSMutableString *)chtViewSaveTextViewStr{
    if (!_chtViewSaveTextViewStr) {
        _chtViewSaveTextViewStr = [[NSMutableString alloc]initWithString:@""];
    }
    return _chtViewSaveTextViewStr;
}

- (void)addImgWithEmjNameStr:(NSString *)nameStr{

    //表情数据处理 用于chatVc发送的数据——

    NSArray *arrayOfEmjName = [nameStr componentsSeparatedByString:@"/"];
    NSString *emjNameStr = [NSString stringWithString:arrayOfEmjName.lastObject];
    NSArray *arrayOfEmjNameNotPng = [emjNameStr componentsSeparatedByString:@"."];
    NSString *emjNameNotPngStr = [NSString stringWithString:arrayOfEmjNameNotPng.firstObject];
    NSCharacterSet *setString = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString *vcWillUseEmjStr = [[emjNameNotPngStr  componentsSeparatedByCharactersInSet:setString] componentsJoinedByString:@""];
    NSString *vcSendEmjString = [NSString stringWithFormat:@"[%@]",vcWillUseEmjStr];
    
//    NSString *textViewHaveEmjAllString = [self.chtViewSaveTextViewStr stringByAppendingString:vcSendEmjString];//添加表情数据
//    NSMutableString *textViewHaveEmjAllString = [self.chtViewSaveTextViewStr insertString:vcSendEmjString atIndex:self.chatBarView.textView.selectedTextRange.start];
//    [self.chtViewSaveTextViewStr insertString:vcSendEmjString atIndex:self.chatBarView.textView.selectedTextRange.start];
//    self.chtViewSaveTextViewStr = textViewHaveEmjAllString;
//    NSLog(@"表情数据处理 \n 用于chatVc发送的表情数据—— %@ \n 总字符串_ %@",vcSendEmjString,textViewHaveEmjAllString );
    
//    [self.chtViewSaveTextViewStr insertString:[vcSendEmjString mutableCopy] atIndex:self.chatBarView.textView.text.length];
//    [self.chtViewSaveTextViewStr insertString:[vcSendEmjString mutableCopy] atIndex:self.chatBarView.textView.selectedRange.location];//插入
    
    self.chtViewSaveTextViewStr = [self.chtViewSaveTextViewStr stringByAppendingString:[vcSendEmjString mutableCopy]];//添加表情数据 放到最后

    [self changeToHaveImgAndTextWithSaveAllTextViewStr];//转化
    
    
    //
    //高度————————
    //输入框BarView位置
    
    CGFloat  h_ChatBarSubTextViewView = 0.0;
     // 获取textView的高度
     // 把该属性放到字典中ƒ
     NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:self.chatBarView.textView.font,NSFontAttributeName, nil];
     // 通过字符串的计算文字所占尺寸方法获取尺寸
     CGSize size = [self.chatBarView.textView.attributedText.string boundingRectWithSize:CGSizeMake(self.chatBarView.textView.frame.size.width - 10,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:dicAttr context:nil].size;
     NSInteger lines = size.height / self.chatBarView.textView.font.lineHeight;
   
     if (lines > 4) {
         self.chatBarView.textView.bounces = YES;
         self.chatBarView.textView.showsVerticalScrollIndicator = YES;
         self.chatBarView.textView.scrollEnabled = YES;
         h_ChatBarSubTextViewView = self.chatBarView.textView.font.lineHeight * 3;
     }else {
         self.chatBarView.textView.bounces = NO;
         self.chatBarView.textView.showsVerticalScrollIndicator = NO;
         self.chatBarView.textView.scrollEnabled = NO;
         if (lines > 1) {
             h_ChatBarSubTextViewView = self.chatBarView.textView.font.lineHeight * (lines - 1);
         }
     }
    [_chatBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(57 + h_ChatBarSubTextViewView);
    }];


}

#pragma mark === 总文本内符合格式部分转图片
- (void)changeToHaveImgAndTextWithSaveAllTextViewStr{
    if ( self.chtViewSaveTextViewStr.length == 0) {//无数据
        return;
    }else if ( [self.chtViewSaveTextViewStr containsString:k_emj_tip_start] && [self.chtViewSaveTextViewStr containsString:k_emj_tip_end]){//有类似emj格式
        //做循环置换成表情
        WEAKSELF
        [ChatViewEmojiTool getEmjIndexArrWithStr:self.chtViewSaveTextViewStr withBlock:^(NSMutableAttributedString * _Nonnull okAttributedString) {
            weakSelf.chatBarView.textView.attributedText = okAttributedString;//展示数据
           // [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:weakSelf.chatBarView.textView]; //需要刷新 textview 无效果
            [weakSelf changeTextViewHeightWhenHaveEmjWithTextView:weakSelf.chatBarView.textView];//高度

//            [weakSelf textViewDidChange:weakSelf.chatBarView.textView];

            

        }];
    }else{//有普通文本数据
        self.chatBarView.textView.attributedText = [[NSMutableAttributedString alloc]initWithString:self.chtViewSaveTextViewStr];
    }
    

}


#pragma mark ===

// 点击会话头像
- (void)iconImageViewTap:(UITapGestureRecognizer *)tap {
    
    NSInteger index = tap.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(iconImageViewSelectedAtIndex:)]) {
        [self.delegate iconImageViewSelectedAtIndex:index - 200];
    }
}
#pragma mark ===  点击tableView
#pragma mark ==  cell撤销删除
// 点击tableView
- (void)tableViewLongPressGes:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath == nil){
        //非cell区域
    }else{
     return;      //1020暂时隐藏掉（显示撤销删除）功能
  
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            NSLog(@"显示撤销删除  ---- index == %ld",indexPath.row);
            [self.undoAndDeletShowNumDataSourceArr replaceObjectAtIndex:indexPath.row withObject:@(1)];
        }
       //显示撤销删除
        [UIView performWithoutAnimation:^{
              [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
 

    }
}
// 点击tableView
- (void)tableViewTap {
    //隐藏掉撤销删除按钮
    [self packUpKeyboard];//隐藏底部barview
}

#pragma mark - 收起键盘
- (void)packUpKeyboard {
    
    self.isFunctionViewShow = NO;
    self.chatFunctionView.hidden = YES;
    self.iskeyboardShow = NO;
    // 让输入框失去第一响应者
    [self.chatBarView.textView resignFirstResponder];
    [_chatFunctionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_chatFunctionView.superview).with.offset(h_funcationBottomView - bottom_height);
    }];
    
    self.isEmojiViewShow = NO;
    self.emjBottomView.hidden = YES;
    // 让输入框失去第一响应者
    [self.chatBarView.textView resignFirstResponder];
    [_emjBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_emjBottomView.superview).with.offset(h_emjBottomView - bottom_height);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark ==
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
@end
