//
//  IsLoginTool.h
//  Community
//
//  Created by 余莹 on 2021/6/8.
//

#import <Foundation/Foundation.h>
@class LoginVC;
@class LoginAndRegiestVC;  //2022新版登录页

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    IS_Login_NotLogin,     //未登录
    IS_Login_Tourists,     //游客
    IS_Login_UnboundPhone, //未绑定手机 例如苹果登录
    IS_Login_Nomal,        //普通登录
} IS_Login_Type;

typedef void(^PresentLoginVcActionBlock)(UINavigationController *navc);
@interface IsLoginTool : NSObject
singleton_interface(share);
@property (nonatomic,assign) IS_Login_Type save_Login_Type;
@property (nonatomic,strong) NSString *appleLoginSaveThridIdWillUseToBindPhone;//未绑定手机的时候
- (void)willPresentLoginViewControllerWithLoginVCBlock:(PresentLoginVcActionBlock)block;
@end

NS_ASSUME_NONNULL_END
