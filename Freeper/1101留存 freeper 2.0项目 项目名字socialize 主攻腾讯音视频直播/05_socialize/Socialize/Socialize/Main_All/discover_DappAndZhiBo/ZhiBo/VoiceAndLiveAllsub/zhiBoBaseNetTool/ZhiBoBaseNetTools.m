//
//  ZhiBoBaseNetTools.m
//  Socialize
//
//  Created by 余莹 on 2023/6/19.
//

#import "ZhiBoBaseNetTools.h"

static   NSString * activity_inset_sub_Url = @"/activity/auth/insertActivity";
static   NSString * activity_ChagneState_sub_Url = @"/activity/auth/updateActivityState";
static   NSString * activity_LookerBaoMin_sub_Url = @"/activity/auth/applyActivity";
static   NSString * activity_auth_updateActivity = @"/activity/auth/updateActivity";//改民字
@implementation ZhiBoBaseNetTools
+ (void)insertActivityData:(ZhiBoBaseInfo *)zhiBoBaseInfo WithBlock:(BaseDicAndSuccessBoolBlock)block{//新增待播直播 多个属性定值

    NSString *activity_inset_Url =  Y_AllURL_Main(activity_inset_sub_Url);
 

    
//    NSString *admissionSymbol = @"0";
//    NSString *admissionFee = @"0";
//    NSString *createConsumeSymbol = @"0";
//    NSString *createConsumeAmount = @"0";
    NSString *type = @"1";//活动类型， 1、闪播， 2、付费直播， 3、线下活动
    NSString *categoryNo = @"account_flash_sowing"; //类编码account_flash_sowing  account_live_sowing
    NSString *categoryTitle = @"直播";
    NSString *category = @"1";
    NSString *description = @"";
    NSString *title = @"";
    NSString *picture = @"";
    NSString *recode = @"";//有值表示私密直播，无值表示公共直播
    NSString *startDatetime = @""; //时间转ti
    
    
  
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1)   forKey:@"type"];
    [parms setValue:@"activity_flash_sowing"   forKey:@"categoryNo"];
    [parms setValue:@"创建闪播"   forKey:@"categoryTitle"];
    [parms setValue:zhiBoBaseInfo.title forKey:@"title"];
    [parms setValue:zhiBoBaseInfo.picture forKey:@"picture"];
    [parms setValue:zhiBoBaseInfo.startDatetime forKey:@"startDatetime"];
    [parms setValue:zhiBoBaseInfo.recode forKey:@"recode"];//有值表示私密直播，无值表示公共直播
    [parms setValue:zhiBoBaseInfo.category  forKey:@"category"];//播类别， 1、video音视频， 2、audio音频， 3、else 其他
    [parms setValue:zhiBoBaseInfo.title  forKey:@"description"];
    [parms setValue:@"0"  forKey:@"admissionFee"];//赏金的
    [parms setValue:@"0"  forKey:@"createConsumeAmount"];//赏金的
    if([ShareUserInfo share].userInfo.address.length <= 0){
        NSLog(@"address 无地址")
        return;
    }
    [parms setValue:[ShareUserInfo share].userInfo.address  forKey:@"account"];
    
    
    

    
    NSLog(@"上传的直播数据 === parm %@",parms);

    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:activity_inset_Url withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
//                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                
                block(dataDic,YES);

            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
    
    /**
     
     JSON: {
        data =     {
            activityId = "1be12c93-c7bf-44de-b827-bde06c44e340";
            address = 0x864c3dd9ee6d3507cc734f72eff18fde5e278471;
            category = 2;
            categoryNo = "activity_flash_sowing";
            categoryTitle = "创建闪播";
            description = "description_test";
            domain = "0000620.free";
            durationSecond = 30;
            id = 383;
            picture = "https://test.freeper.l-z.vip:61125/source//im/2023-06/20/3mEGTD5_668_392_105254_gmi.jpg";
            startDatetime = "2023-06-28 19:20:28";
            state = 2;
            title = Tttttttttttt;
            type = 1;
        };
        message = success;
        status = 200;
        timestamp = 1687776638255;
    } http://192.168.12.122:52001/activity/auth/insertActivity
     
     
     
     data =     {
         activityId = "a018a139-8ea4-4ad4-8412-7e6b93141878";
         address = 0x864c3dd9ee6d3507cc734f72eff18fde5e278471;
         category = 2;
         categoryNo = "activity_flash_sowing";
         categoryTitle = "创建闪播";
         description = "description_t";
         domain = "0000620.free";
         durationSecond = 30;
         id = 384;
         picture = "https://test.freeper.l-z.vip:61125/source//im/2023-06/20/3mEGTD5_668_392_105254_gmi.jpg";
         startDatetime = "2023-08-26 19:30:59";
         state = 2;
         title = Qqqqqqqqqqqqqqqqqqqqqqqqqq;
         type = 1;
     };
     message = success;
     status = 200;
     timestamp = 1687777272790;
     
     */
    
}


//更换状态 方法是在主线程内走通知
+ (void)changeActivityStateParms:(NSDictionary *)parms withBlock:( void (^)(BOOL isSuccessChange,NSDictionary *dataDic) )block{
    NSString *activity_ChangeStatue_Url =  Y_AllURL_Main(activity_ChagneState_sub_Url);

    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:activity_ChangeStatue_Url withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
//                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES,dataDic);
                });
         
            }else{
              
                block(NO,@{});
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(NO,@{});
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}




//观众报名
+ (void)oneLookerBaoMinOneActivityWithParms:(NSDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{ 
    
    NSString *activity_ChangeStatue_Url =  Y_AllURL_Main(activity_LookerBaoMin_sub_Url);
    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:activity_ChangeStatue_Url withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                if([[responsObject allKeys]containsObject:@"status"] && [[responsObject objectForKey:@"status"] integerValue]==10219 ){
                    //已经报名的状态 不提示文本了
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Y_SVP_SHOW_ERR_MESSAGE
                    });
                }
                block(responsObject,NO);
               
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}



//activity_auth_updateActivitybiabin 更改房间名字
+ (void)oneActivityInfoChangeWithParms:(NSDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *activity_ChangeStatue_Url =  Y_AllURL_Main(activity_auth_updateActivity);
    NSLog(@"更改房间名字 -url=%@-- %@",activity_ChangeStatue_Url,parms);

    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:activity_ChangeStatue_Url withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                block(dataDic,YES);
            }else{
                block(@{},NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@{},NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}




@end

#pragma mark ===
@implementation ZhiBoBaseInfo



@end
