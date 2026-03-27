//
//  ChangeLiveInfoWithNoticeNetWorkTool.m
//  TUILiveRoom
//
//  Created by 余莹 on 2023/6/28.
//

#import "ChangeLiveInfoWithNoticeNetWorkTool.h"

#define VoiceAndLiveNotice_ChangeActivity_Statu_Notice    @"VoiceAndLiveNotice_ChangeActivity_Statu_Notice"
@implementation ChangeLiveInfoWithNoticeNetWorkTool

+ (void)changeLiveInfoWithActivityIdStr:(NSString *)activeIdstr withNowState:(Active_State)state withBlock:(ChangeInfoNetToolBlock)block{//观察者注册通知的线程和收到通知的线程不在一个线程。所以做到一个线程里去
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parm setValue:activeIdstr forKey:@"activityId"];
    [parm setValue:@(state) forKey:@"state"];
    [parm setValue:@"ios" forKey:@"deviceType"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VoiceAndLiveNotice_ChangeActivity_Statu_Notice object:block userInfo:parm];
    });
}

@end
 
