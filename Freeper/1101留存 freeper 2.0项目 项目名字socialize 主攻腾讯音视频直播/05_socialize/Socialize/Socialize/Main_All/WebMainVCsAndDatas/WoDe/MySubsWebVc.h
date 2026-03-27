//
//  MyWebVc.h
//  Socialize
//
//  Created by 余莹 on 2023/6/6.
//

#import <UIKit/UIKit.h>
#import "BaseWebVc.h"





#define MySubVc_Url_Suix_MyWallet        @"/pages/wallet/index"
#define MySubVc_Url_Suix_MyFriends       @"/pages/user/circle?category=friend"
#define MySubVc_Url_Suix_MyFans          @"/pages/user/circle?category=fans"
#define MySubVc_Url_Suix_MyFreeIds       @"/pages/user/freeIdList"
#define MySubVc_Url_Suix_MyTransactions  @"/pages/user/transfer"
#define MySubVc_Url_Suix_MyCollect       @"/pages/user/favorites"
#define MySubVc_Url_Suix_MySettleIN      @"/pages/project/apply"
#define MySubVc_Url_Suix_MySet           @"/pages/user/setting"
//某人的粉友freeperid界面
#define MySubVc_Url_Suix_userPersonal    @"/pages/user/personal"

//点击头像后跳转的修改个人信息页面
#define MySubVc_Url_Suix_UserInfo        @"/pages/user/info"




NS_ASSUME_NONNULL_BEGIN

@interface MySubsWebVc : BaseWebVc
@property (nonatomic,strong) NSString *subTypeUrlSuix;
@property (nonatomic,strong) NSString *userPersonalImIdStr;
@end

NS_ASSUME_NONNULL_END

