//
//  AppDelegate.h
//  Community
//
//  Created by 余莹 on 2020/11/9.
//02028仓储小店开始

#import <UIKit/UIKit.h>

static NSString *kWindowType_Logout = @"logout";

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *nav;
- (void)showWindowHome:(NSString *)windowTypeStr;
@end
 
