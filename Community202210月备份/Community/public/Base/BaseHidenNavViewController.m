//
//  BaseHidenNavViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/14.
//

#import "BaseHiddenNavViewController.h"

@interface BaseHiddenNavViewController ()

@end

@implementation BaseHiddenNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarHiddenStyle];
 }
- (void)setupNavigationBarHiddenStyle{
    self.navigationController.navigationBarHidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
