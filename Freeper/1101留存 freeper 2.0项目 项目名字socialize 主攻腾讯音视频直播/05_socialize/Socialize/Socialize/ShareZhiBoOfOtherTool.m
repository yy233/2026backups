//
//  ShareZhiBoOfOtherTool.m
//  Socialize
//
//  Created by 余莹 on 2023/9/28.
//

#import "ShareZhiBoOfOtherTool.h"
#import "ZhiBoNetTool.h"
#import "Socialize-Swift.h"
 

@implementation ShareZhiBoOfOtherTool

+ (void)getThisZhiBoInfoWithUseActivityId:(NSString *)activityID withMyRoleIsZhuBoBool:(BOOL)isZhuBoBool WithWillUsePushUseVc:(UIViewController *)puVc{
    
    
    [[ZhiBoNetTool share] getOneZhiBoDetailInfoWithActivityID:activityID withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        
        if(succes){
            ZhiBoShowInfoModel *model = [ZhiBoShowInfoModel mj_objectWithKeyValues:dicOfBlock];
            if(model.state == 4){//3开启 4结束
                Y_SVP_SHOW_INFO_MES( Y_LocaleTypeFile_NSLocalString(@"该直播已经结束") );
                return;
            }
            if(model.activityId.length>0 && model.roomId.length>0){//有数据才创建或去看直播
                if(isZhuBoBool){
                    //主播的话 直接创建 或继续
                    [self goZhiBoWithInfoModel:model WithWillUsePushUseVc:puVc];
                }else{
                    //观众 则先报名成功后 才走后续 //去看直播
                    NSMutableDictionary *baoMinDic = @{}.mutableCopy;
                    if(model.recode.length>0){
                        baoMinDic = @{
                            @"activityId" : model.activityId,
                            @"account" : [ShareUserInfo share].userInfo.address,
                            //@"recode" : model.recode,
                        }.mutableCopy;
                    }else{
                        baoMinDic = @{
                            @"activityId" : model.activityId,
                            @"account" : [ShareUserInfo share].userInfo.address,
                        }.mutableCopy;
                    }
                    [ZhiBoBaseNetTools oneLookerBaoMinOneActivityWithParms:baoMinDic withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
                        if(succes){
                            [self goZhiBoWithInfoModel:model WithWillUsePushUseVc:puVc];
                        }else{
                            
                            if([[dicOfBlock allKeys]containsObject:@"status"] && [[dicOfBlock objectForKey:@"status"] integerValue]==10219 ){
                                //已经报名的状态
                                [self goZhiBoWithInfoModel:model WithWillUsePushUseVc:puVc];
                            }
                            
                        }
                    }];
                }
            }
        }
    }];

}

 
+ (void)goZhiBoWithInfoModel:(ZhiBoShowInfoModel *)model  WithWillUsePushUseVc:(UIViewController *)puVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZhiBoMyListVC_Sw *vc = [[ZhiBoMyListVC_Sw alloc]init];
        //在我的列表处理相关跳转和点击事宜
        [puVc.navigationController pushViewController:vc animated:YES];
        if([model.address isEqualToString:[ShareUserInfo share].userInfo.address]){//自己是创建者
            [vc goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];
        }else{//非创建者
            [vc aleatOk_LookerGotoZhiBoWithInfoMode:model];
        }
    });
   
}


@end
