//
//  MySetViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "MySetViewController.h"
#import "IMBase.h"
#import "LoginViewController.h"
#import "LoginWebVC.h"
@interface MySetViewController ()

@end

@implementation MySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor cyanColor];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor whiteColor]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [IMBase imLogoutAction];
//    self.view.window.rootViewController = [[LoginViewController alloc]init];
    self.view.window.rootViewController = [[LoginWebVC alloc]init];
}                                                                                                                     
 
@end
