//
//  ChatSever.m
//  Community
//
//  Created by 余莹 on 2021/4/26.
//

#import "ChatSeverConnectionBegin.h"
#import "ChatManagerData.h"
#import "SocketRocketUtility.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

static NSInteger jianGeSectionMaxNum = 200;//毫秒
@interface ChatSeverConnectionBegin ()
@property (nonatomic,strong) NSTimer *needInfoDataGetJianGeTimerr;
@property (nonatomic,assign) NSInteger needInfoDataGetJianGeTimeNum;//间隔时间
 
 
@end

@implementation ChatSeverConnectionBegin
singleton_implementation(share)
#pragma mark ==================================================================================== 得到数据
- (void)initChatWithSocketNeedInfoAndOpenSocket{
    
    //————————————————————
    //游客身份无即时通讯id
    NSString *imUUID = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.imId];
    if (imUUID.length==0) {
        return;
    }
    //————————————————————
    /**
     SR_CONNECTING   = 0,//正在连接中
     SR_OPEN         = 1,
     SR_CLOSING      = 2,
     SR_CLOSED       = 3,
     */
    //连接状态 不做大的重新获取和连接操作
    /**
     1020下午
     被踢离线情况时 并没有收到离线socket相关信息 属性还是连接状态 无法用属性来reutrn掉部分情况
     网络断了再连上 也会收到连接成功的socket信息 键值也会变成在线 但是后台的普通请求的接口会err=1003的离线状态 —————所以 隐藏属性判断行 只使用间隔时间防治频繁请求 （在主页 + 1003 时 会被调用本方法）
    */
    /**
     if (isNotNil([SocketRocketUtility instance].socket) && ([SocketRocketUtility instance].socketReadyState == SR_OPEN || [SocketRocketUtility instance].socketReadyState == SR_CONNECTING)) {//socket非nil 并且在线或正在登录状态
         NSLog(@"ChatSeverConnectionBegin———— socket非nil 并且在线状态或正在登录状态");
         return;
     }
     
     if (isNil([SocketRocketUtility instance].socket) || ([SocketRocketUtility instance].socketReadyState == SR_CLOSING) || ([SocketRocketUtility instance].socketReadyState == SR_CLOSED)) {//socket是nil 或者离线状态
         NSLog(@"ChatSeverConnectionBegin———— socket是nil 或者离线状态");
         //可以进行重新请求和重连接操作
     }
     */
  
    //——————————————————————
    //间隔时间判断
    if (self.needInfoDataGetJianGeTimeNum > 0) {
        NSLog(@"ChatSeverConnectionBegin———— 间隔时间内 不做请求 ");
        return;
    }else{//间隔定时开始
        NSLog(@"ChatSeverConnectionBegin———— 间隔定时开始");
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(timeJianGeThradAdd) object:nil];
        [thread start];

    }
    //——————————————————————
    NSLog(@"ChatSeverConnectionBegin————   **************   调取请求");
    WEAKSELF
    self.needInfoDataGetJianGeTimeNum += 1;
    [ChatManagerData sendUserImId:imUUID andGetWebSocketInfoBlcok:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSString *webSocketUrl = dic[@"url"];
            [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:webSocketUrl]; //连接
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getUserInfo];
            });
        }else{
            //socket所需要的数据 tokenip等信息获取失败 需要循环本请求（定20秒一次）。 有了数据后 并在失败清除timer循环 成功里面可去连接socket SRWebSocketOpenWithURLString
           // Y_SVP_SHOW_ERR_MES(@"未能拿到信息获取失败");
          [NSTimer scheduledTimerWithTimeInterval:20.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
              if (isNil( [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token) ||  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token.length <= 0) {
                  [weakSelf initChatWithSocketNeedInfoAndOpenSocket];
              }else{
                  [timer invalidate];
                  timer = nil;
              }
          }];
         
        }
   
    }];
}
#pragma mark ====================================================================================
 
#pragma mark == 个人信息
- (void)getUserInfo{

    [ChatManagerData chatUserInfoGetWithMyInfoWithBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"ChatSeverConnectionBegin———— 通讯功能 个人信息OK");
            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn = [ChatUserModel mj_objectWithKeyValues:dic];
        }
    }];
}

#pragma mark == 子线程
- (void)timeJianGeThradAdd{
    @autoreleasepool {
//        self.needInfoDataGetJianGeTimerr = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jianGeTimeNumDeletAction) userInfo:nil repeats:YES];//立即执行占了主
        self.needInfoDataGetJianGeTimerr = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(jianGeTimeNumDeletAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.needInfoDataGetJianGeTimerr forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}
#pragma mark == 间隔时间
 
- (void)jianGeTimeNumDeletAction{//暂定10秒
    if (self.needInfoDataGetJianGeTimeNum > jianGeSectionMaxNum) {//
        //重新清空间隔定时相关数据
        if (isNotNil(self.needInfoDataGetJianGeTimerr)) {
            [self.needInfoDataGetJianGeTimerr invalidate];
            self.needInfoDataGetJianGeTimerr = nil;
        }
        self.needInfoDataGetJianGeTimeNum = 0;
        NSLog(@"ChatSeverConnectionBegin———— 间隔时间 end ____ %@",[NSThread currentThread]);
        
    }else{
        self.needInfoDataGetJianGeTimeNum += 1;
       // NSLog(@"ChatSeverConnectionBegin———— 间隔时间 add %ld ____ %@",self.needInfoDataGetJianGeTimeNum ,[NSThread currentThread]);
    }
  
}
@end
