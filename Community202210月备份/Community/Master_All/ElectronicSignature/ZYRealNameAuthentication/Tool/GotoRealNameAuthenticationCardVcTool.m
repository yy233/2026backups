//
//  GotoRealNameAuthenticationCardVcTool.m
//  Community
//
//  Created by 余莹 on 2022/4/29.
//

#import "GotoRealNameAuthenticationCardVcTool.h"

@implementation GotoRealNameAuthenticationCardVcTool
+ (void)needGotoRealNameAuthenticationCardVcWithNowVcType:(GotoRealNameAuthenticationCardVc_NowVcType)nowVcType
                                                withBlock:(void(^)(BOOL needGotoRealNameVcBool ,ZYElectroniNewRealNameAuthenticationCardVcLate *realNameVc))bolck{
    ZYElectroniNewRealNameAuthenticationCardVcLate *vc = [[ZYElectroniNewRealNameAuthenticationCardVcLate alloc]init];
    vc.hidesBottomBarWhenPushed = YES;

    //是否实名 0428 去掉
    if (ZY_IsRealName) {
        //已经实名 可继续后面的判定
        dispatch_async(dispatch_get_main_queue(), ^{
            bolck(NO,vc);
        });
    }else {
        //没有实名 跳转去实名  不走房屋界面
     
        if (nowVcType == GotoRealNameAuthenticationCardVc_NowVcType_Nomal) {
            
        }else if (nowVcType == GotoRealNameAuthenticationCardVc_NowVcType_OneType){
            
        }else{
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            bolck(YES,vc);
        });
    }
}
@end
