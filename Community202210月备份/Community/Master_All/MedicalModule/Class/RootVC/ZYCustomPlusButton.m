//
//  ZYCustomPlusButton.m
//  Community
//
//  Created by ZY on 2021/11/30.
//

#import "ZYCustomPlusButton.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "ZYMedicalRootTabBarVC.h"
#import "ZYIntelligentInquiryVC.h"
#import "ZYPensionRootTabBarVC.h"

@implementation ZYCustomPlusButton

+ (id)plusButton {
    UIImage *buttonImage = [UIImage imageNamed:@"yl_zhinwz"];
    ZYCustomPlusButton *button = [ZYCustomPlusButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)clickPublish {
    NSLog(@"智能问诊");
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    for (UINavigationController *naviVc in tabBarController.viewControllers) {
        for (UIViewController *tempVc in naviVc.viewControllers) {
            if ([tempVc isKindOfClass:[ZYMedicalRootTabBarVC class]]) {
                UITabBarController *subTabBarVC = (ZYMedicalRootTabBarVC *)tempVc;
                UINavigationController *mNavi = subTabBarVC.selectedViewController;
                ZYIntelligentInquiryVC *vc = [[ZYIntelligentInquiryVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [mNavi pushViewController:vc animated:YES];
            }else if ([tempVc isKindOfClass:[ZYPensionRootTabBarVC class]]) {
                UITabBarController *subTabBarVC = (ZYPensionRootTabBarVC *)tempVc;
                for (UINavigationController *navi1 in subTabBarVC.viewControllers) {
                    for (UIViewController *tempVc1 in navi1.viewControllers) {
                        if ([tempVc1 isKindOfClass:[ZYMedicalRootTabBarVC class]]) {
                            UITabBarController *subTabBarVC = (ZYMedicalRootTabBarVC *)tempVc1;
                            UINavigationController *pNavi = subTabBarVC.selectedViewController;
                            ZYIntelligentInquiryVC *vc = [[ZYIntelligentInquiryVC alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [pNavi pushViewController:vc animated:YES];
                        }
                    }
                }
            }
        }
    }
}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    
    return 0.05;
}

//+ (NSUInteger)indexOfPlusButtonInTabBar {
//
//    return 1;
//}
//
//+ (UIViewController *)plusChildViewController {
//    ZYIntelligentInquiryVC *vc = [[ZYIntelligentInquiryVC alloc] init];
//
//    return vc;
//}

@end
