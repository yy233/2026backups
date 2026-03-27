//
//  DigitalCerVC.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "DigitalCerVC.h"
#import "DigitalCerView.h"
@interface DigitalCerVC ()
@property (nonatomic,strong) DigitalCerView *allView;
@end

@implementation DigitalCerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarWhiteStyle];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)footerBtnAction{
    DLog(@"");
    Y_SVP_SHOW_INFO_MES(@"请安装数字证书");
}
 
#pragma mark ==
- (void)initView{
    self.title = @"数字证书";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.allView];
    
}
- (DigitalCerView *)allView{
    if (!_allView) {
        _allView = [[DigitalCerView alloc]init];
        [_allView.goToAuthenticatBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allView;
}
@end
