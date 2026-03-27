//
//  VoiceRoomChuanZhiModel.h
//  Socialize
//
//  Created by 余莹 on 2023/5/27.
//

#import <Foundation/Foundation.h>


/**
 
 
 #define  kVoice_Room_ID                  @"Voice_Room_ID"
 #define  kVoice_Room_Name                @"Voice_Room_Name"
 #define  kVoice_Room_Introduction        @"Voice_Room_Introduction"
 #define  kVoice_Room_BkImg               @"Voice_Room_BkImg"
 #define  kVoice_Room_NeedRequest         @"Voice_Room_NeedRequest"
 #define  kVoice_User_NickName            @"Voice_User_NickName"
 #define  kVoice_User_HeadImg             @"Voice_User_HeadImg"
 
 
 */



NS_ASSUME_NONNULL_BEGIN

@interface VoiceRoomChuanZhiModel : NSObject

@property (nonatomic,strong) NSString *Voice_Room_ID;
@property (nonatomic,strong) NSString *Voice_Room_Name;
@property (nonatomic,strong) NSString *Voice_Room_Introduction;
@property (nonatomic,strong) NSString *Voice_Room_BkImg;
@property (nonatomic,assign) BOOL Voice_Room_NeedRequest;
@property (nonatomic,strong) NSString *Voice_User_NickName;
@property (nonatomic,strong) NSString *Voice_User_HeadImg;
@property (nonatomic,strong) NSString *Voice_Room_ActivityID;
@property (nonatomic,strong) NSString *Voice_Room_rec_passWordStr;
@property (nonatomic,strong) NSDictionary *Voice_Room_OhterDic;

@end

NS_ASSUME_NONNULL_END
