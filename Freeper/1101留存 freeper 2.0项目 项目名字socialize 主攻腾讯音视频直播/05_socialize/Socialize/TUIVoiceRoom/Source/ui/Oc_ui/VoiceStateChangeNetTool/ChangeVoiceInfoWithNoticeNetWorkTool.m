//
//  ChangeVoiceInfoWithNoticeNetWorkTool.m
//  AFNetworking
//
//  Created by 余莹 on 2023/6/27.
//

#import "ChangeVoiceInfoWithNoticeNetWorkTool.h"
#import <AFNetworking/AFNetworking.h>

#define VoiceAndLiveNotice_ChangeActivity_Statu_Notice    @"VoiceAndLiveNotice_ChangeActivity_Statu_Notice"
#define VoiceAndLiveNotice_ChangeActivity_Info_Notice    @"VoiceAndLiveNotice_ChangeActivity_Info_Notice"

@implementation ChangeVoiceInfoWithNoticeNetWorkTool

+ (void)changeVoiceInfoWithActivityIdStr:(NSString *)activeIdstr withNowState:(Active_State)state withBlock:(ChangeInfoNetToolBlock)block{//观察者注册通知的线程和收到通知的线程不在一个线程。所以做到一个线程里去
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parm setValue:activeIdstr forKey:@"activityId"];
    [parm setValue:@(state) forKey:@"state"];
    [parm setValue:@"ios" forKey:@"deviceType"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VoiceAndLiveNotice_ChangeActivity_Statu_Notice object:block userInfo:parm];
    });
}

+ (void)changeVoiceInfoWithActivityIdStr:(NSString *)activeIdstr withRoomNewName:(NSString *)roomNewName withBlock:(ChangeInfoNetToolBlock)block{//名字更改
 
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parm setValue:activeIdstr forKey:@"activityId"];
    [parm setValue:roomNewName forKey:@"title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VoiceAndLiveNotice_ChangeActivity_Info_Notice object:block userInfo:parm];
    });

}


//获取在线随机数据
//
//#if      (0)
//#define  URL_Main_URL_Prefix                                                @"https://test.freeper.l-z.vip:61125" //测试接口
//
//#else
//#define  URL_Main_URL_Prefix                                                @"https://abcdef123-api.freeper.cc" //prod
//
//#endif


//#define  URL_Main_URL_Prefix                                                @"https://test.freeper.l-z.vip:61125" //测试接口

#define  URL_Main_URL_Prefix                                                @"https://abcxdef123-api.freeper.cc" //prod正式


+ (void)getActivityXuniNumWithactivityId:(NSString *)activityId withBlock:(void (^)(bool succ, NSInteger numIndex) )block{
// afnetwork
    AFHTTPSessionManager *netWorkTools = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
    netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
    netWorkTools.requestSerializer.timeoutInterval = 20;
    netWorkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",@"image/jpeg", @"image/png", @"application/problem+json", @"application/x-www-form-urlencoded",nil];
    //netWorkTools.requestSerializer = [AFHTTPRequestSerializer serializer];
    netWorkTools.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *suffurl = @"/activity/getVc";
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_Main_URL_Prefix,suffurl];
    NSDictionary *params = @{@"activityId":activityId};
    NSLog(@"url %@,params=%@",url,params);
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [netWorkTools GET:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"__YrequestGetALLURL_\n url=%@____%@",url,[responseObject description]);
                NSInteger okRandNum = [[responseObject allKeys]containsObject:@"data"] ? [responseObject[@"data"] integerValue] : 0;
                block(YES,okRandNum);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___YrequestGetALLURL_\n url=%@___%@",url,[error.localizedDescription description]);
                block(NO,0);
             
            });
        }];
    });
    
}
 
@end
