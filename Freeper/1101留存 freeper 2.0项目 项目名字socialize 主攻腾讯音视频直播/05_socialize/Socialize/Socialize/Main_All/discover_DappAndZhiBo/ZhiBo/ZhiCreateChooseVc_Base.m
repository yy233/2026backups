//
//  ZhiCreateChooseVc_Base.m
//  Socialize
//
//  Created by 余莹 on 2023/9/2.
//

#import "ZhiCreateChooseVc_Base.h"

@interface ZhiCreateChooseVc_Base ()

@end

@implementation ZhiCreateChooseVc_Base

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//离开-- 去直播页时需要透明的nav （语音直播）
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];

}
//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{//本页面颜色保持黑色bk 黑色nav 白色状态栏
    return UIStatusBarStyleLightContent;//白色内容
}


- (BOOL)isEmpty:(NSString *) str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
        
    }
    
}
 
@end
