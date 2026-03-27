//
//  VoiceRoomBase.m
//  Socialize
//
//  Created by 余莹 on 2023/5/27.
//

#import "VoiceRoomBase.h"

@import ImSDK_Plus;
@import TUIVoiceRoom;
@import Toast_Swift;
#import "Socialize-Swift.h"

@interface VoiceRoomBase ()
@property (nonatomic,strong) TRTCVoiceRoomEnteryControl *dependencyContainer;
@end


@implementation VoiceRoomBase

singleton_implementation(shareVoice);

- (TRTCVoiceRoomEnteryControl *)dependencyContainer{
    if(!_dependencyContainer){
        _dependencyContainer = [[TRTCVoiceRoomEnteryControl alloc]initWithSdkAppId:SDKAppID userId:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")];
    }
    return _dependencyContainer;
}

#pragma mark === 登录
- (void)voiceRoomLoginAction{
    NSString *userID = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");//IM_userID;
    NSString *sig = ([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"");//IM_sig;
    [[TRTCVoiceRoom sharedInstance] login:SDKAppID userId:userID userSig:sig callback:^(int code, NSString * _Nonnull message) {
        if (code == 0) {
            NSLog(@"voiceRoomLoginAction 初始化voice 登录成功 ____________________________ %@",message);
            NSString *avatarU = [ShareUserInfo share].userInfo.profileImageUrl.length>0 ? [ShareUserInfo share].userInfo.profileImageUrl :@"";
            NSString *names = [self nowUserNickStr];
            [[TRTCVoiceRoom sharedInstance]setSelfProfile:names avatarURL:avatarU callback:^(int code, NSString * _Nonnull message) {
                NSLog(@"voice setSelfProfile   _________________________code %d___ %@",code,message);
            }];
        }else{
            NSLog(@"voiceRoomLoginAction 初始化voice 登录err ____________________________ %d %@" ,code,message);
        }
    }];
}
- (NSString *)nowUserNickStr{
    NSString *nickStr;
    if ([ShareUserInfo share].userInfo.saveMydomain.length>0){
        nickStr =  [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];
        return nickStr;
    }else if([ShareUserInfo share].userInfo.useDomain.length>0){//已经设置过的
        nickStr =  [self suoDuanAddressStr: [ShareUserInfo share].userInfo.useDomain];
        return nickStr;
    }else if([ShareUserInfo share].userInfo.username.length>0){//已经设置过的
        nickStr = [self suoDuanAddressStr: [ShareUserInfo share].userInfo.username];
        return nickStr;
    }else{
        nickStr = [self suoDuanAddressStr: [ShareUserInfo share].userInfo.address ] ;
        return nickStr;
    }
    return nickStr;
}

#pragma mark === 退出
- (void)VoiceRoomLogOutAction{
    NSString *userID = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");//IM_userID;
    NSString *sig = ([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"");//IM_sig;'
    
    [[TRTCVoiceRoom sharedInstance] logout:^(int code, NSString * _Nonnull message) {
        if (code == 0) {
            NSLog(@"voiceRoomLoginAction 初始化voice 登录成功 ____________________________ %@",message);
        }else{
            NSLog(@"voiceRoomLoginAction 初始化voice 登录err ____________________________ %d %@" ,code,message);
        }
    }];
 
}
#pragma mark == 头像图片昵称
- (void)voiceSetNickName:(NSString *)userNik andUserHeaderImg:(NSString *)headerImgStr{
    [[TRTCVoiceRoom sharedInstance] setSelfProfile:userNik avatarURL:headerImgStr callback:^(int code, NSString * _Nonnull message) {
        if (code == 0) {
            NSLog(@"voiceSetNick 头像图片昵称 成功 ____________________________ %@",message);
        }else{
            NSLog(@"voiceSetNick  头像图片昵称 err ____________________________ %d %@" ,code,message);
        }
    }];
}

#pragma mark === 观众
- (void)enterVoiceRoomWithRootVc:(UIViewController *)rootVc withInfo:(VoiceRoomChuanZhiModel *)enterVoiceRoominfo withVcBlock:(VcBlock)vcBlock{
  
    
    [self getListAndUseRootVc:rootVc withGoToVoiceRoomIdStr:enterVoiceRoominfo.Voice_Room_ID withRoleIsAnchorBool:false withCreateVoiceRoominfo:enterVoiceRoominfo withVcBlock:vcBlock];
 
    
    
}




#pragma mark === 名字缩短

- (NSString *)suoDuanAddressStr{
    if([ShareUserInfo share].userInfo.saveMydomain.length>0){
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];

    }else{
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.address];

    }
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

#pragma mark === 主播
//创建接口a
- (void)creatVoiceRoomWithRootVc:(UIViewController *)rootVc withVoiceXiangGuanInfo:(VoiceRoomChuanZhiModel *)createVoiceRoominfo  withVcBlock:(VcBlock)vcBlock{
        
    //用户信息----暂时用
    VoiceRoomUserInfo *voiceRoomUserInfo = [[VoiceRoomUserInfo alloc]init];
//    voiceRoomUserInfo.userName = createVoiceRoominfo.Voice_User_NickName;
//    voiceRoomUserInfo.userName = [self suoDuanAddressStr];//创建者address缩短做名字
    voiceRoomUserInfo.userName = [self nowUserNickStr];//创建者address缩短做名字
    voiceRoomUserInfo.userAvatar = createVoiceRoominfo.Voice_User_HeadImg;

    
    //房间信息Parm
    NSString *roomActivityIdStr = createVoiceRoominfo.Voice_Room_ActivityID;
    NSString *room_rec_passwordStr = createVoiceRoominfo.Voice_Room_rec_passWordStr;
    NSDictionary *room_otherDic = createVoiceRoominfo.Voice_Room_OhterDic;

    NSString *roomNameStr = createVoiceRoominfo.Voice_Room_Name;
    NSString *roomBkImgStr = createVoiceRoominfo.Voice_Room_BkImg;
    BOOL roomNeedRequestBool = createVoiceRoominfo.Voice_Room_NeedRequest;//BOOL roomNeedRequestBool = YES;//定值 // 听众上麦是否需要房主同意
    
    //vRoomID
    int thisCreatRoomId =  [createVoiceRoominfo.Voice_Room_ID intValue];// [self getRoomId];
    createVoiceRoominfo.Voice_Room_ID = [NSString stringWithFormat:@"%d",thisCreatRoomId];
    
    VoiceRoomParam *rParam = [[VoiceRoomParam alloc]init];
    rParam.roomName = roomNameStr;
    rParam.coverUrl = roomBkImgStr;
    rParam.needRequest = roomNeedRequestBool;
//    rParam.seatCount = 7;// 房间座位数，这里最少7个座位 少于会崩溃，房主占了一个后听众剩下6个座位
    rParam.seatCount = 9;//1个主播 8个观众（当前UI暂时为9个麦位）
    rParam.seatInfoList = @[];
    rParam.activityIdStr = roomActivityIdStr;
    rParam.rec_passWordStr = room_rec_passwordStr;
    rParam.otherDic = room_otherDic;
    //麦序
    NSMutableArray *seatListArr = @[].mutableCopy;
    for (int i = 0; i < rParam.seatCount; i++) {
        VoiceRoomSeatInfo *oneSeatInfo = [[VoiceRoomSeatInfo alloc]init];
        [seatListArr addObject:  oneSeatInfo];
    }
    rParam.seatInfoList = seatListArr;
 
    [[TRTCVoiceRoom sharedInstance] createRoom:thisCreatRoomId roomParam:rParam callback:^(int code, NSString * _Nonnull message) {
        DLog("voiceRoomBase 创建房间接口--- createRoom msg= %@ \n code == %d",message,code);
        if(code == 0){
            [self  getListAndUseRootVc:rootVc withGoToVoiceRoomIdStr:createVoiceRoominfo.Voice_Room_ID withRoleIsAnchorBool:true withCreateVoiceRoominfo:createVoiceRoominfo withVcBlock:vcBlock];
        }else if (code == -1){//创建失败 但是已经存在这个房间 可以直接去该房间
            
            [self getListAndUseRootVc:rootVc withGoToVoiceRoomIdStr:createVoiceRoominfo.Voice_Room_ID withRoleIsAnchorBool:true withCreateVoiceRoominfo:createVoiceRoominfo withVcBlock:vcBlock];
            //0907 改成switchRoom
//            TRTCSwitchRoomConfig *switchRoomConfig = [[TRTCSwitchRoomConfig alloc]init];
//            switchRoomConfig.strRoomId = createVoiceRoominfo.Voice_Room_ID;
//            switchRoomConfig.roomId = thisCreatRoomId;
//            switchRoomConfig.userSig = [ShareUserInfo share].userInfo.imSignature;
//            [[TRTCCloud sharedInstance] switchRoom:switchRoomConfig ];

        }else{
            if(code == 10036){//您当前使用的云通讯账号未开通音视频聊天室功能，创建聊天室数量超过限额，请前往腾讯云官网开通【IM音视频聊天室】
                Y_SVP_SHOW_ERR_MES(message);
//              

            }else{
                Y_SVP_SHOW_ERR_MES(message);//其他登录信息
            }
            
            DLog();
        }
        
        
        
        
    }];
 
}



#pragma mark === 麦序
//获取接口_b makevc_c 设置麦序接口_d
- (void)getListAndUseRootVc:(UIViewController *)rootVc
     withGoToVoiceRoomIdStr:(NSString *)roomIdStr
                withRoleIsAnchorBool:(BOOL)isAnchor
             withCreateVoiceRoominfo:(VoiceRoomChuanZhiModel *)createVoiceRoominfo
                         withVcBlock:(VcBlock)vcBlock{
    __block  UIViewController* b_rootVc = rootVc;
    //用户信息
    //房间信息Parm
    __block   NSString *userThisRoomNikName = createVoiceRoominfo.Voice_User_NickName;
    __block   NSString *roomNameStr = createVoiceRoominfo.Voice_Room_Name;
    __block   NSString *roomBkImgStr = createVoiceRoominfo.Voice_Room_BkImg;
    __block   BOOL roomNeedRequestBool = createVoiceRoominfo.Voice_Room_NeedRequest;
    __block   NSString *roomActivityStr = createVoiceRoominfo.Voice_Room_ActivityID;
    __block   NSString *room_res_passwordStr = createVoiceRoominfo.Voice_Room_rec_passWordStr;
    __block   NSDictionary *room_otherDic = createVoiceRoominfo.Voice_Room_OhterDic;;

    
    __block   BOOL isAnchorBool =  isAnchor;
    __block   int roomId = [roomIdStr intValue];
    __block   NSString *userHeaderImgStr = createVoiceRoominfo.Voice_User_HeadImg;



    WEAKSELF
    [V2TIMManager.sharedInstance getGroupsInfo:@[roomIdStr] succ:^(NSArray<V2TIMGroupInfoResult *> *groupResultList) {
        V2TIMGroupInfoResult *firstGroupInfo = groupResultList.firstObject;
        if(groupResultList.count <= 0 || firstGroupInfo.resultCode != 0 ){
            DLog(" ----GoToVoiceRoom errrrrrr 不存在|没找到");//10010_resultMsg  @"this group does not exist"
            vcBlock(false,nil);
            Y_SVP_SHOW_INFO_MES(@"房间不存在");
            return;
        }else{
            //当前房间正常到达_______处理数据
            DLog("将进入直播  groupInfo first groupName === %@",firstGroupInfo.info.groupName);
            NSLog(@"将进入直播  groupInfo first groupID === %@",firstGroupInfo.info.groupID);
            NSLog(@"将进入直播  groupInfo first faceURL === %@",firstGroupInfo.info.faceURL);
            NSLog(@"将进入直播  groupInfo first introduction === %@",firstGroupInfo.info.introduction);
            NSLog(@"将进入直播  groupInfo first groupType === %@",firstGroupInfo.info.groupType);
            NSLog(@"将进入直播  groupInfo first firstGroupInfo.info.memberCount === %d",firstGroupInfo.info.memberCount);
            
            VoiceRoomInfo *roomInfo;
            if (isAnchorBool) {//主播需要传入的数据
//                roomInfo= [[VoiceRoomInfo alloc]initWithRoomID:roomId ownerId:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"") memberCount:firstGroupInfo.info.memberCount];//已加入的群成员数量
                NSString *creatOwnId = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");
                roomInfo= [[VoiceRoomInfo alloc]initWithRoomID:roomId ownerId:creatOwnId memberCount:9]; //换成9 0是自己 1-8是观众
               
             
                roomInfo.needRequest = roomNeedRequestBool;//连麦相关
                roomInfo.ownerName = userThisRoomNikName;
                roomInfo.ownerId = creatOwnId;
                roomInfo.ownHeaderImgStr = userHeaderImgStr;//创建者头像

            }else{
               
//                roomInfo = [[VoiceRoomInfo alloc]initWithRoomID:roomId ownerId:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"") memberCount:0];//观众传0
                roomInfo = [[VoiceRoomInfo alloc]initWithRoomID:roomId ownerId:@"" memberCount:0];//观众传0
                roomInfo.needRequest = YES;//观众
                roomInfo.ownerName = userThisRoomNikName;
                roomInfo.ownerId = firstGroupInfo.info.owner;
                roomInfo.ownerName = firstGroupInfo.info.introduction;//简介和主播名字
        
            }
            
            DLog(@"roomInforoomInforoomInforoomInforoomInfo ==== %@",roomInfo);
            roomInfo.roomName = roomNameStr; //firstGroupInfo.info.groupName
            roomInfo.coverUrl = roomBkImgStr;
            roomInfo.activityIdStr = roomActivityStr;
            //观众主播都需要传入的房间名字背景活动信息
            roomInfo.rec_passWordStr = room_res_passwordStr;
            roomInfo.otherDic = room_otherDic;
            
            
            roomInfo.memberCount = 9;//0625
            
            DLog("将进入直播 makeVoiceRoom groupInfo  roomName === %@", roomInfo.roomName);
            DLog("将进入直播 makeVoiceRoom groupInfo  coverUrl === %@", roomInfo.coverUrl);
            DLog("将进入直播 makeVoiceRoom groupInfo  roomId === %ld", (long)roomInfo.roomID);
            DLog("将进入直播 makeVoiceRoom groupInfo  ownerName === %@", roomInfo.ownerName);
            DLog("将进入直播 makeVoiceRoom groupInfo  roomName === %@", roomInfo.roomName);
            
            //创建直播vc
 
            dispatch_async(dispatch_get_main_queue(), ^{
                VoiceRoomBaseTool *tool = [[VoiceRoomBaseTool alloc]init];
                UIViewController *voiceRoomVc = [tool makeVoiceVcActionWithRootVcWithRootVc:b_rootVc roomInfo:roomInfo isAnchorBool:isAnchorBool];
                
                if(isNotNil(voiceRoomVc)){
                    vcBlock(true,voiceRoomVc);
                    if (isAnchorBool) {//主播 防止未连主麦 //成功后 延时设置麦序
                        DLog(" ------------ 创建了房间 需要上麦 takeMainSeat 主播 防止未连主麦 //成功后 延时设置麦序");
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            DLog(" ------------ 创建了房间 需要上麦 takeMainSeat enterSeat");
                            [[TRTCVoiceRoom sharedInstance] enterSeat:0 callback:^(int code, NSString * _Nonnull message) {
                                
                                DLog(" 创建房间接口 设置麦序 enterSeat enterSeat--vc ok-- ok enterSeat ---- %d %@" ,code,message);
                                if (  code == 0  ) {
                                    DLog(" takeMainSeat enterSeat--vc ok-- ok enterSeat ---- %d %@" ,code,message);
                                }else  if (  code == -1  ) {
                                    DLog(" takeMainSeat enterSeat--vc ok--enterSeat 设置麦序失败 已经上麦了 errrrrrr enterSeat --- \n %d %@" ,code,message);
                                    
                                    
                                    //已经在麦上 //创建者再次进到房间时 无上麦回调 ，用moveSeat试看看 移动麦位 （seat(0) is used问题 试看看多次移动 再移动到0） ---- -10001多次移动报告错误 -- leaveSeat试看看下了在上
                                    
                                    [[TRTCVoiceRoom sharedInstance] leaveSeat:^(int code, NSString * _Nonnull message) {
                                        DLog(" takeMainSeat leaveSeat ----下麦位 code=%d message=%@" ,code,message);
                                        if(code == 0){
                                            [[TRTCVoiceRoom sharedInstance] enterSeat:0 callback:^(int code, NSString * _Nonnull message) {
                                                DLog("下麦位后 takeMainSeat enterSeat-- 上0麦位--- code=%d message=%@" ,code,message);
                                            }];
                                        }
                                                                            
                                    }];

                                }else{

                                    DLog(" takeMainSeat enterSeat--vc ok--enterSeat 设置麦序失败 需要重新设置 errrrrrr enterSeat --- \n %d %@" ,code,message);
                                }
                            }];
                        });
                    }
                }else{
                    vcBlock(false,nil);
                }
            });
           
            
        }
        
        
        
    } fail:^(int code, NSString *desc) {
        DLog(" ----GoToVoiceRoom errrrrrr fail");
    }];
}

/**
 [[TRTCVoiceRoom sharedInstance] moveSeat:1 callback:^(int code, NSString * _Nonnull message) {
     DLog(" takeMainSeat moveSeat 1位 --vc   ----移动麦位 %d %@" ,code,message);
     if (  code == 0  ) {
         [[TRTCVoiceRoom sharedInstance] moveSeat:0 callback:^(int code, NSString * _Nonnull message) {
             DLog(" takeMainSeat moveSeat  0位--vc ok ----移动麦位 %d %@" ,code,message);
             if (  code == 0  ) {
                 
             }else  if (  code == -1  ) {
                 
             }
             
         }];
     }else  if (  code == -1  ) {
         
     }
     
 }];
 
 */


#pragma mark ===
- (int)getRoomId{
    NSString *userId = ([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"");
    NSString *willUseStr = [NSString stringWithFormat:@"%@_voice_room",userId];
    int roomId = willUseStr.hash & 0x7FFFFFFF;
    return roomId;
}
@end
