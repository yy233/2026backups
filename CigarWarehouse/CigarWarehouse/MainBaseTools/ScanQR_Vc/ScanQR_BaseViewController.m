//
//  ScanQR_BaseViewController.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import "ScanQR_BaseViewController.h"
#import "WebViewController.h"
@interface ScanQR_BaseViewController ()

@end

@implementation ScanQR_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)goTowebVcWithQRResult:(NSString *)result{
    WebViewController *jumpVC = [[WebViewController alloc] init];
    jumpVC.comeFromVC = ComeFromWC;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    if ([result hasPrefix:@"http"]) {
        jumpVC.jump_URL = result;
    } else {
        jumpVC.jump_bar_code = result;
    }
}
 

@end
