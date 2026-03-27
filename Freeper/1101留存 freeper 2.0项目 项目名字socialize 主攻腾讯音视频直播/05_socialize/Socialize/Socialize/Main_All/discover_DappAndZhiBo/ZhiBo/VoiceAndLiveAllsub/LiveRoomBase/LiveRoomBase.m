//
//  LiveRoomBase.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "LiveRoomBase.h"
#define  cover_U  @"https://img1.baidu.com/it/u=2162230553,1962430118&fm=253&fmt=auto&app=138&f=JPEG?w=643&h=365"

@implementation LiveRoomBase

+ (void)liveRoomLoginInfoUserID:(NSString *)userid
                        userSig:(NSString *)sig
                     withBlockk:(void(^)(BOOL loginStue))loginStuesBlock{
    WEAKSELF
    // 1.组件登录
    [TUILogin login:SDKAppID userID:userid userSig:sig succ:^{
        loginStuesBlock(YES);
        NSLog(@"登录 ok");
        [self setIdNickAndHeadImg];

    } fail:^(int code, NSString *msg) {
        loginStuesBlock(NO);
        NSLog(@"登录失败 %d  %@",code,msg);
    }];

     

}
+ (void)setIdNickAndHeadImg{
    //TUILiveRoomProfileManager.sharedManager().setProfileInfo(SDKAPPID: sdkAppID, avatar: (TUILogin.getFaceUrl() ?? ""), userId: userId, name: (TUILogin.getNickName() ?? ""))
    NSString *imgStr = @"";
    if([ShareUserInfo share].userInfo.profileImageUrl.length>0){
        imgStr = [ShareUserInfo share].userInfo.profileImageUrl;
    }
    NSString *nowNickStr  = [self nowUserNickStr];
    [[TUILiveRoomProfileManager sharedManager] setProfileInfoWithSDKAPPID:SDKAppID avatar:imgStr userId:[ShareUserInfo share].userInfo.imId name:nowNickStr];
    V2TIMUserFullInfo *useF = [[V2TIMUserFullInfo alloc]init];
//    useF.userID = [ShareUserInfo share].userInfo.imId;
    useF.nickName = nowNickStr;
    useF.faceURL = imgStr;
    [[V2TIMManager sharedInstance]setSelfInfo:useF succ:^{
        NSLog(@"设置昵称和头像 -- ok")
    } fail:^(int code, NSString *desc) {
        NSLog(@"设置昵称和头像 -code %d - des %@",code,desc)
    }];
    
}
+ (NSString *)nowUserNickStr{
    NSString *nickStr;
    if ([ShareUserInfo share].userInfo.saveMydomain.length>0){
        nickStr = [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];
        return nickStr;
    }else if([ShareUserInfo share].userInfo.useDomain.length>0){//已经设置过的
        nickStr = [self suoDuanAddressStr:[ShareUserInfo share].userInfo.useDomain];
        return nickStr;
    }else if([ShareUserInfo share].userInfo.username.length>0){//已经设置过的
        nickStr = [self suoDuanAddressStr: [ShareUserInfo share].userInfo.username];
        return nickStr;
    }else{
        nickStr = [self suoDuanAddressStr: [ShareUserInfo share].userInfo.address];
        return nickStr;
    }
    return nickStr;
}

+ (void)chatTypeDeletCom{
    
//    [TUIChatConfig defaultConfig].enableLink = NO;//不显示自定义消息类型
//    TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
 
//    [mLiveRoom getRoomList:0 cnt:200 withCompletion:^(int errCode, NSString *errMsg, NSArray<RoomInfo *> *roomInfoArray) {
//        if (roomInfoArray.count > 0){
//     }];

}


+ (NSString *)suoDuanAddressStr{
    if([ShareUserInfo share].userInfo.saveMydomain.length>0){
        NSLog(@"%@",[ShareUserInfo share].userInfo.saveMydomain); 
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];

    }else{
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.address];

    }
    
}
//长度0816
#define Free_SubStr @".free"
+ (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr{
    
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
#pragma mark ===
//创建live直播
+ (void)liveroomCreateWithRoomIdStr:(NSString *)roomIdStr withActivityIdstr:(NSString *)activityIdStr withTitle:(NSString *)titleStr withFengMianUrlStr:(NSString *)fengMianStr withIsPublicBool:(BOOL)isPublic{
    
//    NSString *userNameStr = [ShareUserInfo.share].userInfo.username.address;
//    NSString *userHeaderStr = [ShareUserInfo.share].userInfo.imId;
    
    NSString *userNameStr = [self nowUserNickStr];
    NSString *userHeaderStr = [ShareUserInfo share].userInfo.profileImageUrl.length >0 ? [ShareUserInfo share].userInfo.profileImageUrl : @"" ;
    
    //创建者 需要带入头像昵称
    [[TUILiveRoomProfileManager sharedManager]setProfileInfoWithSDKAPPID:SDKAppID avatar:userHeaderStr userId:[ShareUserInfo share].userInfo.imId name:userNameStr];

    
    // 2.初始化TUILiveRoom实例
    
    NSUInteger roomId = [roomIdStr intValue];//[self thisBaseRoomId];//88888888;
    if(roomIdStr.length>0){
        roomId = [roomIdStr intValue];
    }
    //会有随机房间roomId = [Y_ToolOfOthers getRandomInt:1 to:2147483640];//1178544947
    NSLog(@"liveroomCreate   创建live直播 IDDDD ----  %lu",(unsigned long)roomId);
    NSLog(@"liveroomCreate   创建live直播 其他 ---- titleStr= %@ fengMianStr= %@  isPublic=%d",titleStr,fengMianStr,isPublic);
    TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
    [mLiveRoom createRoomWithRoomId:roomId activityiddd:activityIdStr roomName:titleStr coverUrl:fengMianStr];
    
}

+ (void)liveroomCreateWithRoomIdStr:(NSString *)roomIdStr withActivityIdstr:(NSString *)activityIdStr withTitle:(NSString *)titleStr withFengMianUrlStr:(NSString *)fengMianStr withIsPublicBool:(BOOL)isPublic withResPasswordStr:(NSString *)recPassword withOtherDic:(NSDictionary *)otherDic{
    NSString *userNameStr = [self nowUserNickStr];
    NSString *userHeaderStr = [ShareUserInfo share].userInfo.profileImageUrl.length >0 ? [ShareUserInfo share].userInfo.profileImageUrl : @"" ;
    //创建者 需要带入头像昵称
    [[TUILiveRoomProfileManager sharedManager]setProfileInfoWithSDKAPPID:SDKAppID avatar:userHeaderStr userId:[ShareUserInfo share].userInfo.imId name:userNameStr];
    NSUInteger roomId = [roomIdStr intValue];
    if(roomIdStr.length>0){
        roomId = [roomIdStr intValue];
    }
    NSLog(@"liveroomCreate   创建live直播 IDDDD ----  %lu",(unsigned long)roomId);
    NSLog(@"liveroomCreate   创建live直播 其他 ---- titleStr= %@ fengMianStr= %@  isPublic=%d",titleStr,fengMianStr,isPublic);
    TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
    if (isNil(otherDic)){
        otherDic = @{};
    }
    if(isNil(recPassword)){
        recPassword = @"";
    }
    [mLiveRoom createRoomWithRoomId:roomId activityiddd:activityIdStr roomName:titleStr coverUrl:fengMianStr rec_PassWord:recPassword otherDic:otherDic];
    
}

#pragma mark ===
//去看live直播 活动ID暂时不需要
+ (void)liveTypeLookerGotoVcWithRoomNameStr:(NSString *)roomNameStr withActivityId:(NSString *)activityIdstr withThisLiveRoomEnterRoomID:(int)roomidInt{
    TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
//    [mLiveRoom enterRoomWithRoomId:roomidInt];
    [mLiveRoom enterRoomWithRoomId:roomidInt roomNmaeStr:roomNameStr activityIdStr:activityIdstr];
}


//去看live直播 活动ID和其他数据 0908
+ (void)liveTypeLookerGotoVcWithRoomNameStr:(NSString *)roomNameStr withActivityId:(NSString *)activityIdstr withThisLiveRoomEnterRoomID:(int)roomidInt withResPasswordStr:(NSString *)recPassword withOtherDic:(NSDictionary *)otherDic{
    TUILiveRoom *mLiveRoom = [TUILiveRoom sharedInstance];
    if (isNil(otherDic)){
        otherDic = @{};
    }
    if(isNil(recPassword)){
        recPassword = @"";
    }
    [mLiveRoom enterRoomWithRoomId:roomidInt roomNmaeStr:roomNameStr activityIdStr:activityIdstr rec_PassWord:recPassword otherDic:otherDic];
}
#pragma mark ===

//退出当前房间
+ (void)liveroomExitRoom{
 
     [[TRTCCloud sharedInstance] exitRoom];
    NSLog(@"退出当前房间  -- ");
    
}


//销毁
+ (void)liveroomDestroyRoom{

    TUILiveRoomProfileManager *m = [TUILiveRoomProfileManager sharedManager];
    //销毁
    [m destroyRoomWithRoomID:@"" success:^{
        NSLog(@"销毁 Success  -- ");
    } failed:^(int32_t code, NSString * _Nonnull errmsg) {
        NSLog(@"销毁 failed  --%d %@",code, errmsg);
    }];
    
}


//+ (NSUInteger)thisBaseRoomId{
//    NSString *userId = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");
//    NSString *allWillUseStr = [NSString stringWithFormat:@"%@_live_room",userId];
//    NSUInteger okLiveId =  allWillUseStr.hash & 0x7FFFFFFF; //NSUInteger是无符号整形，即只能大于等于0。
//
//    return okLiveId;
//}
@end
