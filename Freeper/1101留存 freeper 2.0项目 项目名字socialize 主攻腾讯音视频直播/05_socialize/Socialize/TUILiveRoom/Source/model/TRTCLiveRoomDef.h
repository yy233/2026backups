//
//  TRTCLiveRoomDef.h
//  TRTCVoiceRoomOCDemo
//
//  Created by abyyxwang on 2020/7/7.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK_Plus/ImSDK_Plus.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const Signal_Business_ID;
extern NSString * const Signal_Business_Live;
extern NSString * const Signal_Platform ;
extern NSString * const Signal_Platform_OS;


typedef NS_ENUM(NSUInteger, TRTCLiveRoomLiveStatus) {
    TRTCLiveRoomLiveStatusNone = 0,
    TRTCLiveRoomLiveStatusSingle = 1,  // Single-person room
    TRTCLiveRoomLiveStatusLinkMic = 2, // Co-anchoring
    TRTCLiveRoomLiveStatusRoomPK = 3,  // Cross-room communication
};

@interface TRTCCreateRoomParam : NSObject
/// **Field description:** Room name
@property(nonatomic, strong)NSString *roomName;
/// **Field description:** Room cover image
@property(nonatomic, strong)NSString *coverUrl;

-(instancetype)initWithRoomName:(NSString *)roomName
                       coverUrl:(NSString *)coverUrl;

@end


@interface TRTCLiveRoomConfig : NSObject
/// **Field description:** The audience member uses CDN for playback
/// **Note:** Valid values: true: CDN will be used for playback by default after room entry; false: Low-latency playback will be used
@property (nonatomic, assign) BOOL useCDNFirst;
/// **Field description:** CDN playback domain address
@property(nonatomic, strong, nullable) NSString *cdnPlayDomain;

-(instancetype)initWithUseCDNFirst:(BOOL)userCDNFirst
                     cdnPlayDomain:(NSString * _Nullable)cdnPlayDomain;

@end

@interface TRTCLiveRoomInfo : NSObject
/// **Field description:** Unique room ID
@property(nonatomic, strong)NSString *roomId;
/// **Field description:** Room name
@property(nonatomic, strong)NSString *roomName;
/// **Field description:** Room cover image
@property(nonatomic, strong)NSString *coverUrl;
/// **Field description:** Room owner ID
@property(nonatomic, strong)NSString *ownerId;
/// **Field description:** Room owner nickname
@property(nonatomic, strong)NSString *ownerName;
/// **Field description:** Playback stream address in CDN mode
@property(nonatomic, strong, nullable)NSString *streamUrl;
/// **Field description:** Number of users in the room
@property (nonatomic, assign) NSInteger memberCount;
/// **Field description:** Room status (single-person, co-anchoring, or cross-room communication)
@property (nonatomic, assign) TRTCLiveRoomLiveStatus roomStatus;

//0627新增 活动ID
@property (nonatomic, strong) NSString *activityIdstr;
@property (nonatomic, strong) NSString *rec_passWordStr;//私密直播时 增加的密码数据
@property (nonatomic, strong) NSDictionary *otherDic;//0908增加的


- (instancetype)initWithRoomId:(NSString *)roomId
                      roomName:(NSString *)roomName
                      coverUrl:(NSString *)coverUrl
                       ownerId:(NSString *)ownerId
                     ownerName:(NSString *)ownerName
                     streamUrl:(NSString * _Nullable)streamUrl
                   memberCount:(NSInteger)memberCount
                    roomStatus:(TRTCLiveRoomLiveStatus)roomStatus;

//带活动ID的
- (instancetype)initWithRoomId:(NSString *)roomId
                      roomName:(NSString *)roomName
                      coverUrl:(NSString *)coverUrl
                       ownerId:(NSString *)ownerId
                     ownerName:(NSString *)ownerName
                     streamUrl:(NSString * _Nullable)streamUrl
                   memberCount:(NSInteger)memberCount
                    roomStatus:(TRTCLiveRoomLiveStatus)roomStatus
                 activityIdstr:(NSString *)activityIdstr;


//带活动ID的 和密码和其他信息
- (instancetype)initWithRoomId:(NSString *)roomId
                      roomName:(NSString *)roomName
                      coverUrl:(NSString *)coverUrl
                       ownerId:(NSString *)ownerId
                     ownerName:(NSString *)ownerName
                     streamUrl:(NSString * _Nullable)streamUrl
                   memberCount:(NSInteger)memberCount
                    roomStatus:(TRTCLiveRoomLiveStatus)roomStatus
                 activityIdstr:(NSString *)activityIdstr
                rec_passWordSt:(NSString *)rec_passWordStr
                      otherDic:(NSDictionary *)otherDic;




@end

@interface TRTCLiveUserInfo : NSObject
/// **Field description:** Unique user ID
@property (nonatomic, copy) NSString *userId;
/// **Field description:** Username
@property (nonatomic, copy) NSString *userName;
/// **Field description:** User profile photo
@property (nonatomic, copy) NSString *avatarURL;
/// **Field description:** Playback stream ID in CDN mode
@property (nonatomic, copy, nullable) NSString *streamId;
/// **Field description:** Whether the current user is the anchor
@property (nonatomic, assign) BOOL isOwner;

- (instancetype)initWithProfile:(V2TIMGroupMemberFullInfo *)profile;

@end

typedef void(^Callback)(int code, NSString * _Nullable message);
typedef void(^ResponseCallback)(BOOL agreed, NSString * _Nullable reason);
typedef void(^RoomInfoCallback)(int code, NSString * _Nullable message, NSArray<TRTCLiveRoomInfo *> * roomList);
typedef void(^UserListCallback)(int code, NSString * _Nullable message, NSArray<TRTCLiveUserInfo *> * userList);

NS_ASSUME_NONNULL_END
