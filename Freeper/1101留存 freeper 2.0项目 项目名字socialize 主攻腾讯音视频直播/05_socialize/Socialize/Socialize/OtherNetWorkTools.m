//
//  ZhiBoNetWorkTools.m
//  Socialize
//
//  Created by 余莹 on 2023/10/20.
//

#import "OtherNetWorkTools.h"

static NSString *iosShenheInfoUrl = @"/iosVerify/getIosVerify";

static NSString *iosShenhe_AddUrl = @"/iosVerify/addIosVerify";

static NSString *iosShenhe_updataUrl = @"/iosVerify/updateIosVerify";

#define  Notice_Name_ShenHeInfo        @"Notice_Name_ShenHeInfo"
#define  userDef_Name_ShenHeInfo        @"userDef_Name_ShenHeInfo"


@implementation OtherNetWorkTools


+ (NSString *)softwareVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];// app版本
    NSString *app_build = [infoDic objectForKey:@"CFBundleVersion"];// app build版本
    NSString *currentVersion = [NSString stringWithFormat:@"%@",app_Version];
    NSLog(@"softwareVersion currentVersion == %@",currentVersion);
    return currentVersion;
}


+ (void)getShenHeInfoWithBlock:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    NSString *cur_V = [self softwareVersion];
    [parms setValue:cur_V forKey:@"appVersion"];
    [parms setValue:@"ios" forKey:@"deviceType"];
    NSString *url = Y_AllURL_Main(iosShenheInfoUrl);
    [[Y_NetWorkBaseTool sharedTool] YrequestGetALLURL:url
                                           withParams:parms
                                             finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        NSLog(@"\n \n getShenHeInfoWithBlock  -----responsObject = %@ , err= %@ \n \n",responsObject,error);
        if(Y_IS_Success_status){
            BOOL isShenheType = YES;
            if(![[responsObject allKeys] containsObject:@"data"]){//无对应版本数据 不在审核中 置为（0、审核中， 1、正常） yes
                isShenheType = YES;
            }else{
                isShenheType = (![[Y_ResponsObject_dataDic allKeys] containsObject:@"state"]) ? NO : [[Y_ResponsObject_dataDic objectForKey:@"state"] boolValue];
            }
            NSLog(@"存储到本地 是否在审 %@",@(!isShenheType));//取非 （0、审核中， 1、正常）
            [[NSUserDefaults standardUserDefaults] setValue:@(!isShenheType) forKey:userDef_Name_ShenHeInfo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            block(responsObject,YES);
        }else{
            block(@{},NO);
        }
        //------------------- 审核相关test
//        [self addShenHe];
//        [self updatashenhe];
    }];
 
}
+ (void)getActivityXuNiNumActionWithActivityID:(NSString *)activityId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSLog(@"activityId -- %@",activityId);
    if(activityId.length <=0 ){
        block(@{},NO);
        return;
    }
 
    
}
+ (void)updatashenhe{
    NSString *v_Str = @"2.0.12";
    NSNumber *state_Num = @(1);//0、审核中， 1、正常
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:state_Num forKey:@"state"];
    [parms setValue:v_Str forKey:@"appVersion"];
    [parms setValue:@"ios" forKey:@"deviceType"];
    NSString *url = Y_AllURL_Main(iosShenhe_updataUrl);
    [[Y_NetWorkBaseTool sharedTool] YrequestPostALLURLNoMainQueueWithBodyNotParms:url
                                                                         withBody:parms
                                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        NSLog(@"\n \n addShenHe  -----responsObject = %@ , err= %@ \n \n",responsObject,error);
        if(Y_IS_Success_status){
        }else{
        }
    }];
}
+ (void)addShenHe{
    NSString *v_Str = @"2.0.12";
    NSNumber *state_Num = @(0);//0、审核中， 1、正常
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:state_Num forKey:@"state"];
    [parms setValue:v_Str forKey:@"appVersion"];
    [parms setValue:@"ios" forKey:@"deviceType"];
    NSString *url = Y_AllURL_Main(iosShenhe_AddUrl);
    [[Y_NetWorkBaseTool sharedTool] YrequestPostALLURLNoMainQueueWithBodyNotParms:url
                                                                         withBody:parms
                                                                         finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        NSLog(@"\n \n addShenHe  -----responsObject = %@ , err= %@ \n \n",responsObject,error);
        if(Y_IS_Success_status){
        }else{
        }
    }];
    
}
@end
