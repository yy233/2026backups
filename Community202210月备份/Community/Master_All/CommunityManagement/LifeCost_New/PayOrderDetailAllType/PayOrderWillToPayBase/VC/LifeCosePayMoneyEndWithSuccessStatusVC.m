//
//  LifeCosePayMoneyEndWithSuccessStatusVC.m
//  Community
//
//  Created by 余莹 on 2022/1/14.
//

#import "LifeCosePayMoneyEndWithSuccessStatusVC.h"
#import "LifeCostMainVC.h"
@interface LifeCosePayMoneyEndWithSuccessStatusVC ()

@end

@implementation LifeCosePayMoneyEndWithSuccessStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)finishBtnAction{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LifeCostMainVC class]]) {
            LifeCostMainVC *revise =(LifeCostMainVC *)controller;
            [self.navigationController popToViewController:revise animated:YES]; 
        }
    }
}
@end
