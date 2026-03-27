//
//  SocketRocketUtility.m
//  SUN
//
//  Created by y on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
// 

#import "SocketRocketUtility.h"
#import "ChatManagerData.h"
#define  offLineView_Tag   (66666)

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

NSString * const kNeedPayOrderNote               = @"kNeedPayOrderNote";
NSString * const kWebSocketDidOpenNote           = @"kWebSocketDidOpenNote";
NSString * const kWebSocketDidCloseNote          = @"kWebSocketDidCloseNote";
NSString * const kWebSocketdidReceiveMessageNote = @"kWebSocketdidReceiveMessageNote";//全部数据notice

@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}

//@property (nonatomic,strong) SRWebSocket *socket;

@property (nonatomic,copy) NSString *urlString;

@end

@implementation SocketRocketUtility 

+ (SocketRocketUtility *)instance {
    static SocketRocketUtility *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[SocketRocketUtility alloc] init];
    });
    return Instance;
}

#pragma mark - **************** public methods
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString {

    //如果是同一个url return
    if (self.socket) {
        return;
    }

    if (!urlString || urlString.length <= 0) {
        return;
    }

    self.urlString = urlString;

    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);


    //SRWebSocketDelegate 协议
    self.socket.delegate = self;

    //开始连接
    [self.socket open];
}

- (void)SRWebSocketClose {
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        //断开连接时销毁心跳
        [self destoryHeartBeat];
    }
}

#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(id)data {
   // NSLog(@"socketSendData --------------- %@",data);
    NSLog(@" --- socketSendData --- " );
    WeakSelf(ws);
    dispatch_queue_t queue =  dispatch_queue_create("com.zhsj.community.im.websocket.queue", NULL);

    dispatch_async(queue, ^{
        if (weakSelf.socket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.socket.readyState == SR_OPEN) {
                [weakSelf.socket send:data];    // 发送数据

            } else if (weakSelf.socket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
                // 代码有点长，我就写个逻辑在这里好了
                [self reConnect];

            } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连

                NSLog(@"___重连");
                [self reConnect];
            }
        } else {
            NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
            NSLog(@"其实最好是发送前判断一下网络状态比较好，socket==nil来表示断网");
        }
    });
}

#pragma mark - **************** private mothodes
//重连机制
- (void)reConnect {
    [self SRWebSocketClose];

    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        Y_SVP_SHOW_INFO_MES_5Delay(@"用户通讯功能 您的网络状况不是很好，请检查网络后重试")
        //您的网络状况不是很好，请检查网络后重试
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self SRWebSocketOpenWithURLString:self.urlString];
        NSLog(@"重连");
    });

    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    } else {
        reConnectTime *= 2;
    }
}


//取消心跳
- (void)destoryHeartBeat {
    __weak typeof(self) ws = self;
    dispatch_main_async_safe(^{
        __strong typeof(ws) ss = ws;
        if (ss->heartBeat) {
            if ([ss->heartBeat respondsToSelector:@selector(isValid)]){
                if ([ss->heartBeat isValid]){
                    [ss->heartBeat invalidate];
                    ss->heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat {
    __weak typeof(self) ws = self;

    dispatch_main_async_safe(^{
        __strong typeof(ws) ss = ws;

        [self destoryHeartBeat];
        //心跳设置为
        ss->heartBeat = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:ss->heartBeat forMode:NSRunLoopCommonModes];
    })
}

- (void)sentheart {
    //发送心跳 和后台可以约定发送什么内容  一般可以调用ping  我这里根据后台的要求 发送了data给他

    WEAKSELF
    [ChatManagerData chatWithSendPingTypeWithBlock:^(NSArray * _Nonnull arr) {
        if (arr.count>=1) {
            //发送lastObj
            NSString *jsons = [Tool jsonStrWithDic:[[NSDictionary alloc]initWithDictionary:arr.lastObject] ];//data键值
            //NSLog(@"发送心跳  dic= %@ \n| %@  jsons= %@",arr.firstObject ,arr.lastObject ,jsons);
            NSLog(@"----- 发送心跳 ----");
            [weakSelf sendData:jsons];
        }
    }];
    //发送
    
}

//pingPong
- (void)ping {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

#pragma mark - **************** SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳
    [self initHeartBeat];
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接成功************************** ");
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidOpenNote object:nil];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接失败************************** ");
        _socket = nil;
        //连接失败就重连
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self SRWebSocketClose];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidCloseNote object:nil];
    }
}

/*
 该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
 在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
 用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
 我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {

    if (webSocket == self.socket) {
        NSLog(@"************************** socket收到数据了************************** ");
//        NSLog(@"我这后台约定的 message 是 json 格式数据收到数据，就按格式解析吧，然后把数据发给调用层");
       // NSLog(@" 是 json 格式数据收到数据 :message==== \n %@",message);

        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessageNote object:message];
        
        [self dealMessage:message];
    }
}
- (void)dealMessage:(NSString *)message{
    //收到数据_处理类型
    NSDictionary *mesgDic = [Tool dictionaryWithJsonString:message];
    NSString *aesDecStr = [ChatManagerData useMessageDicGetDecStr:mesgDic];
    NSDictionary *dataDic = [Tool dictionaryWithJsonString:aesDecStr];
//    NSLog(@"-------- socket 收到的数据 ------- %@",dataDic);
    if ([[dataDic allKeys]containsObject:kWebSocketMsgType_Key]){//带msgType类型的
        [self getMsgDic: dataDic WithType:[NSString stringWithString:dataDic[kWebSocketMsgType_Key]]];
       // NSLog(@"**** dealMessage Deal  msgType == %@ || mesgDic=%@ dataDic =%@",[NSString stringWithString:dataDic[kWebSocketMsgType_Key]],mesgDic,dataDic);
    }else{
        NSLog(@"**** dealMessage noDeal == mesgDic=%@ dataDic =%@",mesgDic,dataDic);
    }
   
}
 //___________________________ type
- (void)getMsgDic:(NSDictionary *)getMsgDic WithType:(NSString *)msgType{
    if ([msgType isEqualToString: kWebSocketMsgTypeObj_Response]) {//服务器已到该信息 (pong没有 是走的response)
        if ([[getMsgDic allKeys]containsObject:kWebSocketMsgTypeKey_Response]) {
            NSDictionary *resP = [getMsgDic objectForKey:kWebSocketMsgTypeKey_Response];
            NSInteger errCode = [[resP objectForKey:kWebSocketMsgResponse_err_code] integerValue];
            if (errCode==200) {//连接成功
                DLog(@"************************** 200 connect success ************************** 用户通讯功能 连接成功");
                //Y_SVP_SHOW_SUCCESS_MES(@"用户通讯功能 连接成功");0408隐藏本提示
 
            }else if(errCode==0){
                    //成功的数据 区别于其他数据 fromuser=在这里得到的是自己的imtokenid touser=自己的uuid
                    //服务器已到该信息的回复 //失败状态 待处理 提醒用户发送失败 //成功状态 用msgid做替换防止seqid错位
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendOk object:getMsgDic];
            }else{
                NSString *errInfo = [NSString stringWithString:[resP objectForKey:kWebSocketMsgResponse_err_info]];
                DLog(@"—————kWebSocketMsgTypeKey_Response 一个失败的发送—————%@ %@",errInfo,getMsgDic);// Y_SVP_SHOW_ERR_MES(errInfo);
                if (errCode==405) {
                    Y_SVP_SHOW_ERR_MES(@"不是好友关系 暂不可通信!");
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_ChatMsgResponse_SendFail object:getMsgDic];

            }
        }
    }else{
        //****************************************************************************************************非kWebSocketMsgTypeObj_Response 需要回复ask信息  --- 被踢离线类型除外
        
        if ([msgType isEqualToString: kWebSocketMsgTypeObj_OffLine]) {
            Y_SVP_SHOW_INFO_MES(@"用户通讯功能已离线");
            NSLog(@"************************** 200 connect fail _______用户已离线_ %@",getMsgDic);
//            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token = @""; //当没有心跳时 没做重连 则需要保证在主页刷新登录操作时可用于判断
            //0927不能做空处理 在杀了app后点击通知横条 推送数据要能拉取列表 需要本token
            //socketReadyState 只读属性= SR_CLOSED;
            [self SRWebSocketClose];//1020
            [self showOffLineView];

            
            return;
        }
        NSLog(@"_______________________________________________________回复ack信息 getMsgDic %@",getMsgDic);
        [ChatManagerData chatWillSnedReceiveAckwithGetMsgDic:getMsgDic withBlock:^(NSDictionary * dic) {
            NSString *jsons = [Tool jsonStrWithDic:dic];
            [[SocketRocketUtility instance]sendData: jsons];
        }];
        //分类——————————
        if ([msgType isEqualToString: kWebSocketMsgTypeObj_Text] || [msgType isEqualToString: kWebSocketMsgTypeObj_Image] || [msgType isEqualToString: kWebSocketMsgTypeObj_Voice] || [msgType isEqualToString: kWebSocketMsgTypeObj_Position] || [msgType isEqualToString: kWebSocketMsgTypeObj_Video]  || [msgType isEqualToString:kWebSocketMsgTypeKey_Tips]) {//文本消息 ｜image类型 ｜ 其他类型chat数据 增加chat类型的时候 这里要增
            NSLog(@" 消息*************socket*************消息 %@",getMsgDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_ChatMsg object:getMsgDic];//只做撤回的通知 删除的通知待定删除不会出现在未读列表数据且消息列表会清空 本条只在主动删除的人的信息列表存在对方依旧是原数据
        }else if([msgType isEqualToString: kWebSocketMsgTypeKey_MsgReadNotify]){//已读回执
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_ChatMsg_ReadedInfo object:getMsgDic];
            
        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_revoke_msg]){//撤销操作
            NSLog(@"消息被撤消");
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_Revoke_ChatMsg object:getMsgDic];
        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_group_member_add]){//群 成员新增
            NSLog(@"群 成员新增");
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_Group_MemberAdd object:getMsgDic];
        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Have_An_friendAddReq]){//好友请求
            NSLog(@"收到新的好友请求");
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_Have_NewAddFriendReq object:getMsgDic];
        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Friend_add_Success]){//新增好友通知
            NSLog(@"新增好友success");
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsSuccess object:getMsgDic];
        }else if([msgType isEqualToString: kWebSocketMsgTypeObj_Friend_rej_info]){//好友请求被拒绝
            NSLog(@"新增好友 被拒绝");
            [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketdidReceiveMessage_NoticeName_Friend_AddIsRej object:getMsgDic];
        }else if ( [msgType isEqualToString:kWebSocketMsgTypeObj_PONG]){
            //心跳ping的回复 (pong没有 是走的response)
            NSLog(@"----- 收到心跳ping的回复pong ----- ");

        } else {
            NSLog(@"-----———————— *************  收到类型 没定义的 ************* %@",msgType);
        }
    }
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState {
    return self.socket.readyState;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - showOffLineView
- (void)showOffLineView{
    SocketOffLineShowView *offLineView =  [[SocketOffLineShowView alloc]initWithFrame:CGRectZero];
    offLineView.tag = offLineView_Tag;
    // 当前顶层窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    for (UIView *windowSubView in window.subviews) {
        if (windowSubView.tag == offLineView_Tag) {//防止重复添加
            return;
        }
    }
    // 添加到窗口
    [window addSubview:offLineView];
    
}
@end
