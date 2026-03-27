//
//  IsLoginTool.m
//  Community
//
//  Created by 余莹 on 2021/6/8.
//

#import "IsLoginTool.h"



@implementation IsLoginTool
singleton_implementation(share);
- (void)willPresentLoginViewControllerWithLoginVCBlock:(PresentLoginVcActionBlock)block{
//    LoginVC *loginVC = [[LoginVC alloc]init];
    LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc]init];
    loginVC.isPopVcType = YES; //做返回按钮的判断用的type 
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        block(nav);
    });

//    [self presentViewController:nav animated:YES completion:^{
//        NSLog(@"弹出登录");
//    }];
}
@end
