//
//  ChangeVoiceInfoWithNoticeNetWorkTool.h
//  AFNetworking
//
//  Created by 余莹 on 2023/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//    3开启 4结束
typedef enum : NSUInteger {
    Active_State_KaiQi = 3,
    Active_State_JieSu = 4,
} Active_State;

typedef void(^ChangeInfoNetToolBlock)( BOOL isChangeSuccess,NSDictionary *dataDic);
@interface ChangeVoiceInfoWithNoticeNetWorkTool : NSObject

+ (void)changeVoiceInfoWithActivityIdStr:(NSString *)activeIdstr withNowState:(Active_State)state withBlock:(ChangeInfoNetToolBlock)block;
+ (void)changeVoiceInfoWithActivityIdStr:(NSString *)activeIdstr withRoomNewName:(NSString *)roomNewName withBlock:(ChangeInfoNetToolBlock)block;//名字更改
+ (void)getActivityXuniNumWithactivityId:(NSString *)activityId withBlock:(void (^)(bool succ, NSInteger numIndex) )block;
@end



NS_ASSUME_NONNULL_END
