//
//  LoginRelatedViewModel.m
//  Community
//
//  Created by 余莹 on 2021/6/7.
//

#import "LoginRelatedViewModel.h"

@implementation LoginRelatedViewModel
- (void)saveTokenAndUserInfo:(NSDictionary *)resultsDic{
    if ([[resultsDic allKeys]containsObject:@"token"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[resultsDic objectForKey:@"token"] forKey:@"token"];
        [ShareUserInfo sharedUserInfo].token = [resultsDic objectForKey:@"token"];
    }
    if ([[resultsDic allKeys]containsObject:@"userInfo"]) {
        UserModel *userModel = [UserModel mj_objectWithKeyValues:[resultsDic objectForKey:@"userInfo"]];
        [ShareUserInfo sharedUserInfo].userInfo = userModel;
        [[ShareUserInfo sharedUserInfo] saveDefaultsLoginUserInfo:userModel];
    }
   
}
- (void)saveAccountAndPassWordWithAccountStr:(NSString *)accountStr withPasswordStr:(NSString *)passwordStr{
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setValue:passwordStr forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].account = accountStr;
    [ShareUserInfo sharedUserInfo].password = passwordStr;
}
- (void)saveAccountWithAccountStr:(NSString *)accountStr{
    [[NSUserDefaults standardUserDefaults] setValue:accountStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].account = accountStr;
}

#pragma mark ==  苹果三方登录回调后
- (void)getAppleThirdInfoWithModel:(AppleLoginModel *)model  withType:(Third_LoginOrRegist_Type)appleThirdType{
    switch (appleThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginAppleModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            [self pushBindVcWithAppleModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithAppleModel:(AppleLoginModel *)model{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
//        [self.navigationController pushViewController:bindVc animated:YES];
}
- (void)thirdLoginAppleModel:(AppleLoginModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo":[model.userInfo mj_keyValues]}];
//    self.view.window.rootViewController = [[TabBarController alloc] init];
}

#pragma  mark === 微信登录注册相关

- (void)getWxThirdInfoWithModel:(WeChatLoginUserModel *)model  withType:(Third_LoginOrRegist_Type)wxThirdType{
    switch (wxThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginWxModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            [self pushBindVcWithWxModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithWxModel:(WeChatLoginUserModel *)model{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.wxUsermodel = model;
//        [self.navigationController pushViewController:bindVc animated:YES];
}
- (void)thirdLoginWxModel:(WeChatLoginUserModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo": [model.userInfo mj_keyValues]}];
//    self.view.window.rootViewController = [[TabBarController alloc] init];
}
#pragma mark == 支付宝登录注册相关

- (void)getZFBThirdInfoWithModel:(ZFBLoginModel *)model  withType:(Third_LoginOrRegist_Type)zfbThirdType{
    switch (zfbThirdType) {
        case Third_LoginOrRegist_Type_Login:
        {
            //Login
            [self thirdLoginZFBModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Regist:
        {
            [self pushBindVcWithZFBModel:model];
        }
            break;
        case Third_LoginOrRegist_Type_Err:
        {
            //err
        }
            break;
            
        default:
            break;
    }
}
- (void)pushBindVcWithZFBModel:(ZFBLoginModel *)model{
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.zfbUserModel = model;
//        [self.navigationController pushViewController:bindVc animated:YES];
}
- (void)thirdLoginZFBModel:(ZFBLoginModel *)model{
    [self saveTokenAndUserInfo:@{@"token":model.token}];
    [self saveTokenAndUserInfo:@{@"userInfo": [model.userInfo mj_keyValues]}];
//    self.view.window.rootViewController = [[TabBarController alloc] init];
}

#pragma mark ===
 
@end
