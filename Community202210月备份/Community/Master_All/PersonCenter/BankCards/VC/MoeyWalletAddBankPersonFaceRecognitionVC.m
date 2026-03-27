//
//  MoeyWalletAddBankPersonFaceRecognitionVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "MoeyWalletAddBankPersonFaceRecognitionVC.h"
#import "MoeyWalletAddBankPersonFaceRecognitionView.h"
@interface MoeyWalletAddBankPersonFaceRecognitionVC ()
@property (nonatomic,strong) MoeyWalletAddBankPersonFaceRecognitionView *subView;
@end

@implementation MoeyWalletAddBankPersonFaceRecognitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    [self.view addSubview:self.subView];
}
#pragma mark ==
- (void)showAgreeAction{
    DLog(@"");
    Y_SVP_SHOW_INFO_MES(@"showAgreeAction");
}
#pragma mark ==
- (MoeyWalletAddBankPersonFaceRecognitionView *)subView{
    if (!_subView) {
        _subView = [[MoeyWalletAddBankPersonFaceRecognitionView alloc]initWithFrame:self.view.frame];
        [_subView.bottomTipShowAgreementBtn addTarget:self action:@selector(showAgreeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subView;
}

@end
