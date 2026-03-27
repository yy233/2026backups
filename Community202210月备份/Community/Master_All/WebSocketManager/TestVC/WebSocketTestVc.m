//
//  WebSocketTestVc.m
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import "WebSocketTestVc.h"
#import "WebSocketTestView.h"
#import "WebSocketChatWithFriendVc.h"
#import "WebSocketAllSessionListVc.h"

#import "ChatManagerData.h"//基础数据url等
#import "SocketRocketUtility.h"


static NSString *const  testImToken_One =  @"2a314f0322884e1b927e89a636ac0ec2"; // = @"98805c7d035f44a1be798e65df15f256";==uuid。 18183132010
static NSString *const  testImUUID_Two  =  @"668994c005a1415dbbffcc2cf2446106";//uuid

//static NSString *const  testImToken_One = @"8f4349cfdc7842619869cc1c8a6cb1a2";//utokenIm=8f4349cfdc7842619869cc1c8a6cb1a2 uuid==e5778bdaa9b747d5b6bb1d39c90a9ba7。18580865040
//static NSString *const  testImUUID_Two  =  @"98805c7d035f44a1be798e65df15f256";//uuid

//static NSString *const  testImToken_One = @"9933857fc9c446a692ba97fde7c8c62e";//utokenIm=9933857fc9c446a692ba97fde7c8c62e uuid==668994c005a1415dbbffcc2cf2446106
//static NSString *const  testImUUID_Two  =  @"98805c7d035f44a1be798e65df15f256";//uuid

//static NSString *const  testImToken_One = @"9933857fc9c446a692ba97fde7c88888";//1dcc73a73054429e885ac69372bd3ade uuid
//static NSString *const  testImUUID_Two  =  @"98805c7d035f44a1be798e65df15f256";//uuid


//static NSString *const  testImToken_One =  @"2a314f0322884e1b927e89a636ac0000";//utoken
//static NSString *const  testImUUID_Two  =  @"516449e1674e4220aeacdc350506c9b7";//uuid
//-----------
//= @"c116ceaba26411ebb476002590f3d4a8";//@"be2103f6b74f440c93c4dd8c5d2402b7";//utokenIm=  uuid==
//static NSString *const  testImToken_One =  @"6014d26445f6412a9c13e2e300000000";//=imid  uuid=2fde8c72abcc4175ad6bcfef4ba65e7e
//static NSString *const  testImUUID_Two  =  @"98805c7d035f44a1be798e65df15f256";//uuid

//_____得到imutoken = 0ea7b3fb119c4bb68ce351b976de5b6e   uuid= 2a314f0322884e1b927e89a636ac0ec2  18183132010


//static NSString *const  testImToken_One = @"8f4349cfdc7842619869cc1c8a6cb1a2";//1dcc73a73054429e885ac69372bd3ade uuid
//static NSString *const  testImUUID_Two  =  @"2a314f0322884e1b927e89a636ac0ec2";//uuid


//static NSString *const  testImToken_One =  @"2a314f0322884e1b927e89a636ac0000";//utoken
//static NSString *const  testImUUID_Two  =  @"516449e1674e4220aeacdc350506c9b7";//uuid



@interface WebSocketTestVc ()
@property (nonatomic,strong) NSString *webSocketUrl;
//
@property (nonatomic,strong) WebSocketTestView* selfV;

//
@property (nonatomic,strong) NSMutableArray *saveFriendsListArr;
@end

@implementation WebSocketTestVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WebSocketTestVc";
    self.view.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.5];
    self.webSocketUrl = @"";
    [self initChatWithGetInfo];
    //
    [self initV];
}

- (void)initChatWithGetInfo{
    NSString *imUUID = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.imId];

 
    WEAKSELF
    [ChatManagerData sendUserImId:imUUID andGetWebSocketInfoBlcok:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.webSocketUrl = dic[@"url"];
            [weakSelf beginWebSocket];
        }else{
            Y_SVP_SHOW_ERR_MES(@"未能连接");
        }
   
    }];
}
#pragma mark ===
- (void)SRWebSocketdidReceiveMessageNote_ChatMsg:(NSNotification *)notice{
    //
    [self textMsgInfo:notice.object];
}
- (void)SRWebSocketdidReceiveMessageNote_HaveNewFriendReqInfo:(NSNotification *)notice{
    DLog(@"%@",notice.object);
    [self getFRInfo];
}
- (void)SRWebSocketdidReceiveMessageNote_Friend_AddIsSuccess:(NSNotification *)notice{
    //
}
- (void)SRWebSocketdidReceiveMessageNote_Friend_AddIsRej:(NSNotification *)notice{
    //
}
- (void)beginWebSocket{
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:self.webSocketUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_ChatMsg:) name:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_HaveNewFriendReqInfo:) name:kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_Friend_AddIsSuccess:) name:kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketdidReceiveMessageNote_Friend_AddIsRej:) name:kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsRej object:nil];
}
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
        
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"收到服务端发送过来的消息 %@",message);
}

//- (void)SRWebSocketdidReceiveMessageNote:(NSNotification *)note {
//    //收到数据
//    NSString * message = note.object;
//    NSDictionary *mesgDic = [Tool dictionaryWithJsonString:message];
//
//    NSString *aesDecStr = [ChatManagerData useMessageDicGetDecStr:mesgDic];
//    NSDictionary *dataDic = [Tool dictionaryWithJsonString:aesDecStr];
//    NSLog(@"收到的数据=========  %@",dataDic);
//    if ([[dataDic allKeys]containsObject:kWebSocketMsgType_Key]){
//        [self getMsgDic: dataDic WithType:[NSString stringWithString:dataDic[kWebSocketMsgType_Key]]];
//    }
//
//}
 //___________________________ type
//- (void)getMsgDic:(NSDictionary *)getMsgDic WithType:(NSString *)msgType{
//    if ([msgType isEqualToString: kWebSocketMsgTypeObj_Response]) {//服务器已到该信息
//        if ([[getMsgDic allKeys]containsObject:kWebSocketMsgTypeKey_Response]) {
//            NSDictionary *resP = [getMsgDic objectForKey:kWebSocketMsgTypeKey_Response];
//            NSInteger errCode = [[resP objectForKey:kWebSocketMsgResponse_err_code] integerValue];
//            if (errCode==0) {//成功的数据
//            }else if(errCode==200){
//                Y_SVP_SHOW_SUCCESS_MES(@"connect success");
//            }else{
//                NSString *errInfo = [NSString stringWithString:[resP objectForKey:kWebSocketMsgResponse_err_info]];
//                DLog(@"%@",errInfo);
//                Y_SVP_SHOW_ERR_MES(errInfo);
//            }
//        }
//    }else{
//        //非kWebSocketMsgTypeObj_Response 需要回复ask信息
//        [self sendAskInfoWithGetMsgDic:getMsgDic];
//        if ([msgType isEqualToString: kWebSocketMsgTypeObj_Text]) {//文本消息
//            [self textMsgInfo:getMsgDic];
//        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Have_add_friend_info]){//好友请求
//            DLog(@"收到好友请求");
//            [self getFRInfo];//获取新数据 刷新列表
//        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Friend_add_Success]){//新增好友通知
//            DLog(@"新增好友success");
//        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Friend_rej_info]){//好友请求被拒绝
//            DLog(@"新增好友 被拒绝");
//        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_revoke_msg]){//撤销操作
//            DLog(@"撤销操作");
//        } else {
//            DLog(@"----- 收到类型 %@",msgType);
//        }
//    }
//}

- (void)textMsgInfo:(NSDictionary *)getMsgDic{
    DLog(@"%@",getMsgDic);
    NSDictionary *textDic = [NSDictionary dictionaryWithDictionary: getMsgDic[kWebSocketMsgTypeObj_Text]];
    NSString *textConStr = [textDic objectForKey:@"content"];
    Y_SVP_SHOW_SUCCESS_MES(textConStr);
}


- (void)sendAskInfoWithGetMsgDic:(NSDictionary *)getMsgDic{
    NSLog(@"_______________________________________________________回复ack信息");
    [ChatManagerData chatWillSnedReceiveAckwithGetMsgDic:getMsgDic withBlock:^(NSDictionary * dic) {
        NSString *jsons = [Tool jsonStrWithDic:dic];
        [[SocketRocketUtility instance]sendData: jsons];
    }];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self addF];
}
#pragma  mark ==
- (void)addF{
    NSString *fImUUID = testImUUID_Two;
//    NSString *fImId = testImToken_Y;//wd
//    [ChatManagerData addFriendWithFriendUUID:fImUUID];
}
- (void)cancelF{
    DLog(@"");
}
//好友请求列表
/**
 "create_time" = 1619143381870;
 friendRemark = "\U597d\U53cb\U5907\U6ce8";
 fromAvatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 fromNickname = "\U9ed8\U8ba4\U6635\U79f0";
 "from_user" = 1dcc73a73054429e885ac69372bd3ade;
 "open_id" = dd7186834b30422984643cb446ba0055;
 origin = "\U4e8c\U7ef4\U7801";
 rejStatus = 0;
 "sequence_id" = 1;
 status = 0;
 toAvatarMediaId = "2021-02-10/9ac8268a449443c4bff6c3f88775d147-1612951479379.jpg";
 toNickname = "\U9ed8\U8ba4\U6635\U79f0";
 "to_user" = 98805c7d035f44a1be798e65df15f256;
 verifyMessage = "\U6211\U7684\U7559\U8a00";
}
 */
- (void)getFRInfo{
    DLog(@"");
    [ChatManagerData getImFriendReqInfoListWithBlcok:^(NSArray * arr, BOOL success) {
        if(success){
            DLog(@"_____请求数据__%@",arr);
            NSString *willArrStr =   [NSString stringWithString:arr.firstObject];
            NSArray *getReFriendArr = [Tool arrWithJson:willArrStr];
            NSLog(@"%@",getReFriendArr);
            
            //
            [self.selfV fFriendReqLiesArr:getReFriendArr.mutableCopy];
        }
    }];
}
- (void)getFList{
    DLog(@"查询好友列表");//查询好友列表
        [ChatManagerData getFriendInfoListWithBlcok:^(NSArray * arr, BOOL success) {
            if(success){
         
                NSString *willArrStr =   [NSString stringWithString:arr.firstObject];
                NSArray *getUserFriendsListArr = [Tool arrWithJson:willArrStr];
                NSLog(@"查询好友列表 === %@",getUserFriendsListArr);
                [self.selfV fFriendListArr:getUserFriendsListArr.mutableCopy];
                self.saveFriendsListArr = [NSMutableArray arrayWithArray:getUserFriendsListArr];//用来加群test
            }
        }];
        
}
//请求加好友的第一个数据uuid 做
- (void)agreActionWithUUID:(NSString *)otherUUID{
    NSLog(@"------------同意加好友----------------------");
    //同意
//    [ChatManagerData agreeAddWithFriendUUID:otherUUID];

}
- (void)regAgreActionWithUUID:(NSString *)otherUUID{
    NSLog(@"------------拒绝加好友----------------------");
    //拒绝
//    [ChatManagerData rejectAddWithFriendUUID:otherUUID];
}

//调转后聊天
- (void)chatWithUUID:(NSString *)otherUUID{
    NSLog(@"------------聊天----------------------");
 
//    [ChatManagerData chatWillSendTextTypeWithStr:@"聊天文本类型内容数据哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈123" withFriendUUId:otherUUID withBlock:^(NSDictionary * dic) {
//        NSString *jsons = [Tool jsonStrWithDic:dic];
//        [[SocketRocketUtility instance]sendData: jsons];
//        Y_SVP_SHOW_SUCCESS_MES(@"发送聊天消息");
//    }];
    
    WebSocketChatWithFriendVc *vc = [[WebSocketChatWithFriendVc alloc]init];
    vc.friendUUID = otherUUID;
    [self pushVc:vc];
}


#pragma mark ==
- (void)initV{
    [self.view addSubview:self.selfV];
    self.selfV.friendList.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.3];
    self.selfV.friendReInfoList.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
//    self.selfV.
    WEAKSELF
    STRONGSELF
    self.selfV.btnNNNNNN = ^(int i) {
        if (i==1) {
            [strongSelf addF];
        }
        if (i==10) {
            [strongSelf getFRInfo];
        }
        if (i==100) {
            [strongSelf getFList];
        }
        if (i==0) {//allSectionMsgList btn
//            [strongSelf cancelF];
            [strongSelf getAllFriendsSectionMsgListData];//得到全部会话列表
        }
    };
    //好友相关
    self.selfV.agreeFBlock = ^(NSString * uuid) {
        DLog(@"%@",uuid);
        [strongSelf agreActionWithUUID:uuid];
    };
    self.selfV.regagreeFBlock = ^(NSString * uuid) {
        DLog(@"%@",uuid);
        [strongSelf regAgreActionWithUUID:uuid];
    };
    self.selfV.chatFBlock = ^(NSString * uuid) {
        DLog(@"%@",uuid);
        [strongSelf chatWithUUID:uuid];
    };
    //删除一个好友会话
    self.selfV.deletSecceion = ^(NSString * uuid) {
        DLog(@"%@",uuid);
        [strongSelf deletOneSecctionWithFriendUUID:uuid];
    };
    //-----------------------------------------群
    self.selfV.creatGroupBlock = ^{
        DLog(@"");
//        [strongSelf creatGroup];//建群就自己一个群主
        [strongSelf creatGroupHaveFriends];//带人建群
    };
    self.selfV.addFriendsToGroupBlock = ^{
        DLog(@"");
        [strongSelf addfsToGroup];//加人入群
    };
    self.selfV.getAllGroupBlock = ^{
        DLog(@"");
        [strongSelf getAllGroupList];//全部群
    };
    self.selfV.changeUserInfo = ^(NSInteger idx) {
        if (idx==1) {
            //name
            DLog(@"");
//            [strongSelf changeNickName];//nick
            //getinfo
//            [strongSelf getUserInfo];
//            [strongSelf getOtherInfo];
            [strongSelf getSearch];
        }
       
    };

    
}
#pragma mark--------kkkkkkkk
- (WebSocketTestView *)selfV{
    if (!_selfV) {
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"WebSocketTestView" 
                                                             owner:nil
                                                           options:nil];
         
        _selfV = (WebSocketTestView*)[nibViews objectAtIndex:0];
        _selfV.frame = self.view.frame;
    }
    return _selfV;
}

#pragma mark =======
- (void)deletOneSecctionWithFriendUUID:(NSString *)friendUUID{
    DLog(@"____   删除当前好友会话7数据   __");
    [ChatManagerData chatInfoDeletOneConversationWithFriendId:friendUUID withBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            DLog(@"____  删除当前好友会话7数据  end dic  __%@",dic);
        }
    }];
}
- (void)getAllFriendsSectionMsgListData{//好友相关会话
    DLog(@"____  请求全部回话7天数据  __");
    WEAKSELF
    [ChatManagerData getAllConversationFor7DaysWithBlock:^(NSArray * arr, BOOL success) {
        if(success){
            DLog(@"____ 请求全部回话7天数据 getAllSectionMsgListData  全部好友会话列表 __%@",arr);
            dispatch_async(dispatch_get_main_queue(), ^{
                WebSocketAllSessionListVc *vc = [[WebSocketAllSessionListVc alloc]init];\
                vc.friendsArr = [NSMutableArray arrayWithArray:arr];
                vc.isAllGroupSectionList = NO;
                [weakSelf pushVc:vc];
            });
        }
    }];
}

#pragma mark =======
- (void)getAllGroupList{
    WEAKSELF
    [ChatManagerData chatGetAllGroupListWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            DLog(@"____ 请求全部组group __%@",arr);
            dispatch_async(dispatch_get_main_queue(), ^{
                WebSocketAllSessionListVc *vc = [[WebSocketAllSessionListVc alloc]init];\
                vc.groupsArr = [NSMutableArray arrayWithArray:arr];
                vc.isAllGroupSectionList = YES;
                [weakSelf pushVc:vc];
            });
        }
    }];
}
//建群
- (void)creatGroup{
    [ChatManagerData chatCreatGroupWithOnlyMeInfoWithGroupName:@"" withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
        }
    }];
}
//带人建群
- (void)creatGroupHaveFriends{
    NSMutableArray *friendsList = [self getFListUUidArr];
    if (friendsList.count==0) {
        NSLog(@"数据没有 不加群");
        return;
    }
    NSString *fu = [NSString stringWithString:friendsList.firstObject];//带了一个人创建群
   
    [ChatManagerData chatCreatGroupWithGroupName:@"" withFriendsUuidArr:@[fu] withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
        }
    }];
    
}
//加人入群
- (void)addfsToGroup{
    NSMutableArray *friendsList = [self getFListUUidArr];
    if (friendsList.count==0) {
        NSLog(@"数据没有 不加群");
        return;
    }
//    NSString *fu = [NSString stringWithString:friendsList.lastObject];//加了一个人
    NSString *fu = [NSString stringWithString:friendsList.firstObject];//加了一个人
//    inviteFriendsToPayGroup
    [ChatManagerData chatGroupAddFriendWithGroupId:@"038fda00283642e4b6ce950f1494102c" withFriendIdArr:@[fu].mutableCopy withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            
        }
    }];
        
 
}

//f uuid
- (NSMutableArray *)getFListUUidArr{
    NSMutableArray *fuuidArr = [[NSMutableArray alloc]init];
    if (isNotNil( self.saveFriendsListArr) &&  self.saveFriendsListArr.count>0) {
        for (int i = 0 ; i < self.saveFriendsListArr.count; i++) {
            NSDictionary *fDic =[NSDictionary dictionaryWithDictionary: self.saveFriendsListArr[i]];
            NSString *fuuid = fDic[@"userUuid"];
            [fuuidArr addObject:fuuid];
        }
    }
    return fuuidArr;
}
#pragma mark ==
- (void)getUserInfo{
    [ChatManagerData chatUserInfoGetWithMyInfoWithBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"");
        }
    }];
}
- (void)changeNickName{
//    [ChatManagerData chatUserInfoChangeNickName:@"106的新昵称" withBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            Y_SVP_SHOW_SUCCESS_MES(@"修改昵称成功");
//        }
//    }];
}
- (void)getOtherInfo{
    [ChatManagerData  chatOtherUserInfoWithOthterImId:testImUUID_Two withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"");
        }
    }];
}
- (void)getSearch{
    NSString *nickNameStr = @"昵称";
    [ChatManagerData  chatSeatchPersonWithNickName:nickNameStr withBlock:^(NSArray * arr, BOOL success) {
    
        if (success) {
            DLog(@"");
        }
    }];
 
    
}
@end
