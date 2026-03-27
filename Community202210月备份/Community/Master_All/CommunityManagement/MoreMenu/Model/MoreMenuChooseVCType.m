//
//  MoreMenuChooseVCType.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "MoreMenuChooseVCType.h"

@implementation MoreMenuChooseVCType
//旧
 
 

+ (Menu_Choose_Vc_NumType)getMenuChooseVcWithStr:(NSString *)str{
    Menu_Choose_Vc_NumType num = Menu_choose_No;
    if ([str containsString:Meue_Path_UserInfoRegist]) { //我的房屋
        num = Menu_choose_userInfoRegist;
    }
//    if ([str containsString:Meue_Path_Life]) {
//        num = Menu_choose_liftCost;
//        NSLog(@" center_menu 生活缴费");
//    }
    if ([str containsString:Meue_Path_Guest]) { //访客邀请
        num = Menu_choose_visitorGuest;
    }
   if ([str containsString:Meue_Path_Scan]) {
       num = Menu_choose_scan;
       NSLog(@" center_menu  扫一扫");
   }
   if ([str containsString:Meue_Path_Repair]) {
       num = Menu_choose_repair;
       NSLog(@" center_menu  一键报修");
   }
   if ([str containsString:Meue_Path_Hotline]) {
       num = Menu_choose_hotline;
       NSLog(@" center_menu  服务热线");
   }
   if ([str containsString:Meue_Path_Advice]) {
       num = Menu_choose_advice;
       NSLog(@" center_menu  投诉建议");
   }
    return num;
}
 
/**
 #define Meue_Path_UserInfoRegist          @"home"     // 我的房屋
 #define Meue_Path_Life                    @"cost"     // 生活缴费
 #define Meue_Path_Guest                   @"visitor"  //访客邀请
 #define Meue_Path_Scan                    @"scan"     //扫一扫
 #define Meue_Path_Repair                  @"repair"   //一键报修
 #define Meue_Path_Hotline                 @"hotline"  //服务热线
 #define Meue_Path_Advice                  @"advice"   //投诉建议*/


//新________________________________________________________________________________
/**
 
 #define Meue_Path_Notice                  @"notice"      //社区公告
 #define Meue_Path_Property                @"property"    //物业缴费
 #define Meue_Path_Advice                  @"advice"      //投诉建议
 #define Meue_Path_Activity                @"activity"    //活动报名
 #define Meue_Path_Lease                   @"lease"       //房屋租赁
 #define Meue_Path_Bbazaar                 @"bazaar"      //社区集市
 #define Meue_Path_Vote                    @"vote"        //业主投票
 */
+ (Menu_Choose_Vc_New_NumType)getNewMenuChooseVcWithPathStr:(NSString *)str{
    
    Menu_Choose_Vc_New_NumType num = Menu_choose_NoThing;
    if ([str containsString:Meue_Path_Notice]) {
        num = Menu_choose_Notice;
    }
    if ([str containsString:Meue_Path_Property]) {
        num = Menu_choose_Property;
    }
    if ([str containsString:Meue_Path_Advice]) {
        num = Menu_choose_Advice;
    }
    if ([str containsString:Meue_Path_Activity]) {
        num = Menu_choose_Activity;
    }
    if ([str containsString:Meue_Path_Lease]) {
        num = Menu_choose_Lease;
    }
    if ([str containsString:Meue_Path_Bbazaar]) {
        num = Menu_choose_Bbazaar;
    }
    if ([str containsString:Meue_Path_Vote]) {
        num = Menu_choose_Vote;
    }
    if ([str containsString:Meue_Path_Hotline]) {
        num = Menu_choose_Hotline;
    }
    if ([str containsString:Meue_Path_Shop]) {
        num = Menu_choose_Shop;
    }
    if ([str containsString:Meue_Path_SeniorLifeMainActivity]) {
        num = Menu_choose_SeniorLifeMainActivity;
    }
    if ([str containsString:Meue_Path_MedicalMainActivity]) {
        num = Menu_choose_MedicalMainActivity;
    }

    if ([str containsString:Menu_Path_SmallShop]) {
        num = Menu_choose_SmallShop;
    }
    if ([str containsString:Menu_Path_PakingCar]) {
        num = Menu_choose_PakingCar;
    }
 
    return num;
}
@end
