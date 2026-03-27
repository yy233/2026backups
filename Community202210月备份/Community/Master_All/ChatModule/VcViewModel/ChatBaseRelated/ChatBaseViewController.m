//
//  ChatBaseViewController.m
//  Community
//
//  Created by 余莹 on 2021/5/8.
//

#import "ChatBaseViewController.h"

@interface ChatBaseViewController ()

@end

@implementation ChatBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
    [self navBarBackBtnShow];
    [self setupNavigationBarWithBackItemNoTitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarTransparentStyle];
    [self navBarBackBtnHidden];
}

- (void)navBarBackBtnHidden{
    self.navigationController.navigationBarHidden = YES;
}

- (void)navBarBackBtnShow{
    self.navigationController.navigationBarHidden = NO;
}
@end
