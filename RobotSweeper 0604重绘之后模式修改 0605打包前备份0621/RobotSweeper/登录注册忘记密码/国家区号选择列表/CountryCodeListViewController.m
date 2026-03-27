//
//  CountryCodeListViewController.m
//  RobotSweeper
//
//  Created by Joey on 2019/1/4.
//  Copyright © 2019年 余莹. All rights reserved.
//

#import "CountryCodeListViewController.h"
#import "XWCountryCodeController.h"

@interface CountryCodeListViewController ()<XWCountryCodeControllerDelegate> {
    
    __weak IBOutlet UILabel *showCodeLB;
}

@end

@implementation CountryCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
