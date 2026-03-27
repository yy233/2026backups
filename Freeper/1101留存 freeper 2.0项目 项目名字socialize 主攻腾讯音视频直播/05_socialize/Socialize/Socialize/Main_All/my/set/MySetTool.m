//
//  MySetTool.m
//  Socialize
//
//  Created by 余莹 on 2023/7/20.
//

#import "MySetTool.h"
#import "IMBase.h"
#import "LoginViewController.h"
#import "LoginWebVC.h"
#import "MainTabbarControll.h"
#import "LiveRoomBase.h"
#import "VoiceRoomBase.h"
#import "BaoHuoWebViewVc.h"
#import "SceneDelegate.h"

@implementation MySetTool
+ (void)logOutAction{
    
    [IMBase imLogoutAction];//各个退出-chat
    [LiveRoomBase liveroomExitRoom];//视频
    [[VoiceRoomBase shareVoice] VoiceRoomLogOutAction];//语音
  
    
    //数据清空
    UserModel* nUserModel =  [[UserModel alloc]init];
    [ShareUserInfo share].userInfo = nUserModel;
    [[ShareUserInfo share] saveDefaultsLoginUserInfo:nUserModel];
    DLog(@"登出 [ShareUserInfo share].userInfo = %@",[ShareUserInfo share].userInfo);
    //界面退出重载
    //通知各个主页刷新界面数据和登录各模块 -- rootvc 更新
    //self.view.window.rootViewController = [[MainTabbarControll alloc]init];
    UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
    SceneDelegate *sceDelge = (SceneDelegate *)scene.delegate;
    [self iOS13ShowCustomWindowWithsceDelge:sceDelge WithWindow:sceDelge.window];

}

 
+ (void)iOS13ShowCustomWindowWithsceDelge:(SceneDelegate *)sceDelge WithWindow:(UIWindow *)window {
    if (@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        //iOS 13以上 window不再由AppDelegate来管理，所以通过AppDelegate来设置keyWindowAndVisable无效；需通过connectedScenes来获取处于活跃状态的Scene，并将window的windowScene设置为活跃状态的Scene，完成windowScene的注册。此时该window则由该Scene来管理，才能显示
        //iOS13以下 window 的 windowScene 属性有值；iOS13以上 window 的 windowScene 属性无值，需要手动赋值
        if (!window.windowScene) {
            for (UIWindowScene *windowScene in array) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window.windowScene = windowScene;
                    
                    NSLog(@"333 window   %@ ",window);
                    NSLog(@"333 window  subviews %@ ",window.subviews);
                    NSLog(@"333 screen  %@",window.screen);
                    [sceDelge addNoticeAndBaoHuoViewsWithwindowScene:window.windowScene ];
                    return;
                }
            }
        }else{
            NSLog(@"window.windowScene 存在");
            [sceDelge addNoticeAndBaoHuoViewsWithwindowScene:window.windowScene];

        }
        
    }
}


@end
