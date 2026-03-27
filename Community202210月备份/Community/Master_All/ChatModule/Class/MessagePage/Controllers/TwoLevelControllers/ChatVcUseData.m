//
//  ChatVcUseData.m
//  Community
//
//  Created by 余莹 on 2022/3/25.
//

#import "ChatVcUseData.h"
#import "ChatManagerData.h"

static NSString *MsgSetReadType_Url = @"/zhsj/im/message/msgReadConfirm/readConfirm"; //要在2s以上 才请求一次 否则 存起来
//
static NSString *saveInfoSubDicKey_sessionId = @"sessionId";
static NSString *saveInfoSubDicKey_msgIds = @"msgIds";
static NSString *saveInfoSubDicKey_fromUser= @"fromUser";
static NSString *saveInfoSubDicKey_toUser = @"toUser";

static NSInteger sendMinSecond  = 2.0;//发送 最快可调用的时长

@interface ChatVcUseData ()
@property (nonatomic,strong) NSMutableDictionary *saveWillSendAllSeessionsDic;//会话数据
@property (nonatomic,strong) NSTimer *sendUseTimer;
@property (nonatomic,assign) BOOL isBeginBool;
@property (nonatomic,assign) NSInteger nowSaveTimerNum;
@property (nonatomic,strong) NSString *thisNewSaveSessionIdStr;//最近收到的保存的dic_key
@end

@implementation ChatVcUseData

singleton_implementation(share)


#pragma mark ==  设置某消息 已读
- (NSMutableDictionary *)saveWillSendAllSeessionsDic{
    if (!_saveWillSendAllSeessionsDic) {
        _saveWillSendAllSeessionsDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _saveWillSendAllSeessionsDic;
}


/**
 
 session key xxxxxx
willSend   obj
 {
     "msgIds":[" "," "]
     ,"sessionId":" "
     ,"fromUser":" @user"
     ,"toUser":" @user"
 }
 */

- (void)chatMsgSetReadedTypeWithHistoryInfoMsgIdStrArr:(NSMutableArray *)msgIdArr withToUser:(NSString *)toUser withFromUser:(NSString *)fromUser withSessionId:(NSString *)sessionId{
    NSLog(@"收到 msgIdArr = %@",msgIdArr);
    BOOL haveThisSessionId = [[self.saveWillSendAllSeessionsDic allKeys] containsObject:sessionId];
    if (haveThisSessionId) {
        NSMutableDictionary *thisSessionInfoDic = [self.saveWillSendAllSeessionsDic objectForKey:sessionId];
        if ([sessionId isEqualToString: [thisSessionInfoDic objectForKey:saveInfoSubDicKey_sessionId]]) {
            NSMutableArray *thisSeesionMsgArr = [NSMutableArray arrayWithArray:[thisSessionInfoDic objectForKey:saveInfoSubDicKey_msgIds]];
            [thisSeesionMsgArr addObjectsFromArray:msgIdArr];//msg增objs
            [thisSessionInfoDic setValue:thisSeesionMsgArr forKey:saveInfoSubDicKey_msgIds];//msg替换
            [self.saveWillSendAllSeessionsDic setValue:thisSessionInfoDic forKey:sessionId];//willsend替换
        }
    }else{
        NSMutableDictionary *thisSessionInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [thisSessionInfoDic setValue:sessionId forKey:saveInfoSubDicKey_sessionId];
        [thisSessionInfoDic setValue:toUser forKey:saveInfoSubDicKey_toUser];
        [thisSessionInfoDic setValue:fromUser  forKey:saveInfoSubDicKey_fromUser];
        [thisSessionInfoDic setValue:msgIdArr forKey:saveInfoSubDicKey_msgIds];
        [self.saveWillSendAllSeessionsDic setValue:thisSessionInfoDic forKey:sessionId];//willsend 新增
    }
    self.thisNewSaveSessionIdStr = sessionId;//记录最新的会话 在可以发送时 就能最新提交
    [self timeBeginAddOfThread];
}

- (void)chatMsgSetReadedTypeWithMsgId:(NSString *)msgIdStr withToUser:(NSString *)toUser withFromUser:(NSString *)fromUser withSessionId:(NSString *)sessionId{
    NSLog(@"收到 msgid = %@",msgIdStr);
    //判断当前save是否有同一个会话
    //有则替换 msgIdArr内加入msgid
    //无则加入
    
    BOOL haveThisSessionId = [[self.saveWillSendAllSeessionsDic allKeys] containsObject:sessionId];
    if (haveThisSessionId) {
        NSMutableDictionary *thisSessionInfoDic = [self.saveWillSendAllSeessionsDic objectForKey:sessionId];
        if ([sessionId isEqualToString: [thisSessionInfoDic objectForKey:saveInfoSubDicKey_sessionId]]) {
            NSMutableArray *thisSeesionMsgArr = [NSMutableArray arrayWithArray:[thisSessionInfoDic objectForKey:saveInfoSubDicKey_msgIds]];
            [thisSeesionMsgArr addObject:msgIdStr];//msg增obj
            [thisSessionInfoDic setValue:thisSeesionMsgArr forKey:saveInfoSubDicKey_msgIds];//msg替换
            [self.saveWillSendAllSeessionsDic setValue:thisSessionInfoDic forKey:sessionId];//willsend替换
        }
    }else{
        NSMutableDictionary *thisSessionInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [thisSessionInfoDic setValue:sessionId forKey:saveInfoSubDicKey_sessionId];
        [thisSessionInfoDic setValue:toUser forKey:saveInfoSubDicKey_toUser];
        [thisSessionInfoDic setValue:fromUser  forKey:saveInfoSubDicKey_fromUser];
        [thisSessionInfoDic setValue:@[msgIdStr] forKey:saveInfoSubDicKey_msgIds];
        [self.saveWillSendAllSeessionsDic setValue:thisSessionInfoDic forKey:sessionId];//willsend 新增
    }
    self.thisNewSaveSessionIdStr = sessionId;//记录最新的会话 在可以发送时 就能最新提交
    [self timeBeginAddOfThread];

}

#pragma mark == 子线程调用
- (void)timeBeginAddOfThread{
    if (self.isBeginBool || isNotNil(self.sendUseTimer)) {
        return;
    }
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(beginTimeRun) object:nil];
    [thread start];
}

 #pragma mark == 子线程内run 不然就卡了
 - (void)beginTimeRun{
     if (isNil(self.sendUseTimer) && !self.isBeginBool ) {//(空 或 初始) 则创建 && 直接已读
         self.nowSaveTimerNum = 0;
         @autoreleasepool {
             self.sendUseTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(sendAction) userInfo:nil repeats:YES];
             [[NSRunLoop currentRunLoop] addTimer:self.sendUseTimer forMode:NSDefaultRunLoopMode];
             [[NSRunLoop currentRunLoop] run];
             self.isBeginBool = YES;
         }
         [self sendAction];
     }else{
         //否则 无需要创建 直接等待timer内执行即可
     }
 }
 #pragma mark ==
 - (void)sendAction{//暂定2秒
     WEAKSELF
     if (self.nowSaveTimerNum >= sendMinSecond) {//大于限制 才可去请求
         if (isNotNil(self.saveWillSendAllSeessionsDic) &&   self.thisNewSaveSessionIdStr.length>0) {//有数据 则调用

             NSString *willSendSessionIdStr = self.thisNewSaveSessionIdStr;
             NSMutableDictionary *saveSessionInfoDic = [self.saveWillSendAllSeessionsDic objectForKey: willSendSessionIdStr];
             NSMutableArray *willSendMsgIdArr = [saveSessionInfoDic  objectForKey:saveInfoSubDicKey_msgIds];
          
             [self chatMsgSetReadedTypeWithInfoDic:saveSessionInfoDic withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
                 if (success) {//这里删除已经成功的msgid  如果同session 内的msgid都清空 则删除本sessionDic | 防止在请求过程中 新增的未读 被误删
                     NSMutableDictionary *nowSaveSessionInfoDic = [self.saveWillSendAllSeessionsDic objectForKey: willSendSessionIdStr];
                     NSArray *msgArrAll = [nowSaveSessionInfoDic objectForKey:saveInfoSubDicKey_msgIds];
                     if ( msgArrAll.count == willSendMsgIdArr.count ) {
                         [weakSelf.saveWillSendAllSeessionsDic removeObjectForKey: willSendSessionIdStr];//删除
                         if(weakSelf.saveWillSendAllSeessionsDic.count <= 0){
                             weakSelf.thisNewSaveSessionIdStr = @"";
                         }else{
                             weakSelf.thisNewSaveSessionIdStr = [weakSelf.saveWillSendAllSeessionsDic allKeys].firstObject;//下一个
                         }
                        
                     }
                 }
             }];
             
         }
         self.nowSaveTimerNum = 0;//重新计时
    
     }else{
         self.nowSaveTimerNum += 1;
     }
   
 }


 - (void)dealloc{
     [self.sendUseTimer invalidate];
     self.sendUseTimer = nil;
 }





#pragma mark ==
//发送请求
- (void)chatMsgSetReadedTypeWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    if (isNil(infoDic) || [infoDic allKeys].count <=0) {
        return;
    }else{
        NSLog(@" 聊天 已读状态设置 %@",infoDic);
        [ChatManagerData chatInfoSetReadedTypeWithDic:infoDic withBlock:block];
    }
}


#pragma mark ==

//收到已读回执设置成功的消息类型 删除本saveSession
- (void)chatMsgSetReadedTypeOfSetOkWithDeletDicSessionMsgIds:(NSString *)msgIdStr withToUser:(NSString *)toUser withFromUser:(NSString *)fromUser withSessionId:(NSString *)sessionId{
    
}






@end
