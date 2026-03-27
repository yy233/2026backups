//
//  LiveRoomBase.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <Foundation/Foundation.h>

@import TUICore;
@import TUILiveRoom;
//@import TUIChat;

NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomBase : NSObject

+ (void)liveRoomLoginInfoUserID:(NSString *)userid
                        userSig:(NSString *)sig
                     withBlockk:(void(^)(BOOL loginStue))loginStuesBlock;

+ (void)liveroomCreateWithRoomIdStr:(NSString *)roomIdStr withActivityIdstr:(NSString *)activityIdStr withTitle:(NSString *)titleStr withFengMianUrlStr:(NSString *)fengMianStr withIsPublicBool:(BOOL)isPublic;
//0908
+ (void)liveroomCreateWithRoomIdStr:(NSString *)roomIdStr withActivityIdstr:(NSString *)activityIdStr withTitle:(NSString *)titleStr withFengMianUrlStr:(NSString *)fengMianStr withIsPublicBool:(BOOL)isPublic withResPasswordStr:(NSString *)recPassword withOtherDic:(NSDictionary *)otherDic;

+ (void)liveTypeLookerGotoVcWithRoomNameStr:(NSString *)roomNameStr withActivityId:(NSString *)activityIdstr withThisLiveRoomEnterRoomID:(int)roomidInt;
//去看live直播 活动ID和其他数据 0908
+ (void)liveTypeLookerGotoVcWithRoomNameStr:(NSString *)roomNameStr withActivityId:(NSString *)activityIdstr withThisLiveRoomEnterRoomID:(int)roomidInt withResPasswordStr:(NSString *)recPassword withOtherDic:(NSDictionary *)otherDic;
//退出当前房间
+ (void)liveroomExitRoom;
//销毁
+ (void)liveroomDestroyRoom;

//+ (NSString *)suoDuanAddressStr:(NSString *)addressStr;
+ (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr;

+ (void)setIdNickAndHeadImg;
@end

NS_ASSUME_NONNULL_END
