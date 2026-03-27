//
//  ViewController.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
}
- (void)test{
    NSString *u = @"1";
    NSDictionary *p = @{};
     
    [[NetWorkSwiftTool share]managerNetGetMethodWithUrl:u
                                                    parm:p
                                                 header:nil 
                                                   succ:^(NSDictionary * _Nonnull dic) {
    } fail:^(NSError * _Nonnull err) {
    }];
    
}


@end
