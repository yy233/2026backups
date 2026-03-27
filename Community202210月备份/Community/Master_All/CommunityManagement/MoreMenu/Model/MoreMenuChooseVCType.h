//
//  MoreMenuChooseVCType.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Menu_choose_userInfoRegist,
    Menu_choose_liftCost,
    Menu_choose_visitorGuest,
    Menu_choose_scan,
    Menu_choose_repair,
    Menu_choose_hotline,
    Menu_choose_advice,
    //
    Menu_choose_No,
} Menu_Choose_Vc_NumType;
/**
 #define Meue_Path_UserInfoRegist          @"home"     // 我的房屋
 #define Meue_Path_Life                    @"cost"     // 生活缴费
 #define Meue_Path_Guest                   @"visitor"  //访客邀请
 #define Meue_Path_Scan                    @"scan"     //扫一扫
 #define Meue_Path_Repair                  @"repair"   //一键报修
 #define Meue_Path_Hotline                 @"hotline"  //服务热线
 #define Meue_Path_Advice                  @"advice"   //投诉建议*/
typedef enum : NSUInteger {
    Menu_choose_Notice,
    Menu_choose_Property,
    Menu_choose_Advice,
    Menu_choose_Activity,
    Menu_choose_Lease,
    Menu_choose_Bbazaar,
    Menu_choose_Vote,
    Menu_choose_Hotline,
    Menu_choose_Shop,
    Menu_choose_SeniorLifeMainActivity,
    Menu_choose_MedicalMainActivity,
    Menu_choose_SmallShop,
    Menu_choose_PakingCar,
    //
    Menu_choose_NoThing,
} Menu_Choose_Vc_New_NumType;

@interface MoreMenuChooseVCType : NSObject
+ (Menu_Choose_Vc_NumType)getMenuChooseVcWithStr:(NSString *)str;

+ (Menu_Choose_Vc_New_NumType)getNewMenuChooseVcWithPathStr:(NSString *)str;
/**
 
 #define Meue_Path_Notice                  @"notice"      //社区公告
 #define Meue_Path_Property                @"property"    //物业缴费
 #define Meue_Path_Advice                  @"advice"      //投诉建议
 #define Meue_Path_Activity                @"activity"    //活动报名
 #define Meue_Path_Lease                   @"lease"       //房屋租赁
 #define Meue_Path_Bbazaar                 @"bazaar"      //社区集市
 #define Meue_Path_Vote                    @"vote"        //业主投票
 #define Meue_Path_Shop                    @"shop"        //周边店铺
 #define Meue_Path_SeniorLifeMainActivity            @"SeniorLifeMainActivity"    //社区养老
 #define Meue_Path_MedicalMainActivity            @"MedicalMainActivity"    //社区医疗
 */
 
@end

NS_ASSUME_NONNULL_END
