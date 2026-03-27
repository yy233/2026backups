//
//  PayPasswordThirdStepVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PayPasswordThirdStepVC.h"

#import "LJPayPasswordView.h"
//
#import "SafetyCenterViewModel.h"
#import "MoneyWalletVcLate.h"

@interface PayPasswordThirdStepVC ()<LJPayPasswordViewDelegate>

@property(nonatomic, strong) UILabel *remarkL;

@property (nonatomic, strong) LJPayPasswordView *passwordV;

@property(nonatomic, strong) UIButton *btn;

@end
@implementation PayPasswordThirdStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
        self.title = @"修改支付密码";
    }else {
        self.title = @"设置支付密码";
    }
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(15);
    }];
    
    [self.passwordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkL.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.offset(300);
        make.height.offset(50);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.offset(15);
        make.top.mas_equalTo(self.passwordV.mas_bottom).offset(50);
        make.height.offset(45);
    }];
    
}

#pragma mark - 懒加载

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        _remarkL.text = @"请设置6位数字密码";
        _remarkL.font = FontSize_Vip_Nomail(14);
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_remarkL];
    }
    return _remarkL;
}
- (LJPayPasswordView *)passwordV{
    if (!_passwordV) {
        _passwordV = [[LJPayPasswordView alloc] initWithFrame:CGRectMake(0, 50, 300, 50)];
        _passwordV.passwordNumber = 6;
        _passwordV.squareSize = 50;
        _passwordV.pointRadius = 10;
        _passwordV.pointColor = [UIColor blackColor];
        _passwordV.rectColor = [Tool getColorWithHexString:@"#BBBBBB"];
        _passwordV.delegate = self;
        [self.view addSubview:_passwordV];
        
    }
    return _passwordV;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"完成" forState:UIControlStateNormal];
        _btn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_btn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [_btn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.cornerRadius = 3.5;
        _btn.clipsToBounds = YES;
        _btn.tag = 1;
        [self.view addSubview:_btn];
    }
    return _btn;
}

#pragma mark - LJPayPasswordViewDelegate

- (void)passwordCompleteInput:(LJPayPasswordView *)password{
    [self.btn setBackgroundColor:[Tool getColorWithHexString:@"#2672F9"]];
    [self.btn setTitleColor:[Tool getColorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.btn.userInteractionEnabled = YES;
}

- (void)passwordDidChange:(LJPayPasswordView *)password{
    if (password.saveStore.length< 6) {
        [self.btn setBackgroundColor:[Tool getColorWithHexString:@"#EEEEEE"]];
        [self.btn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = NO;
    }
}


#pragma mark - 按钮点击
- (void)btnClicked: (UIButton *)sender{
    //上一页 密码self.payPasswordStr
    //本页 密码LJPayPasswordView saveStore
    if (![self.payPasswordStr isEqualToString:self.passwordV.saveStore]) {
        Y_SVP_SHOW_ERR_MES(@"密码不一致!");
        return;
    }
//    [SafetyCenterViewModel changePayPasswordToSendPasswordStr:self.payPasswordStr withDicBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            for (UIViewController *vc in self.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:NSClassFromString(@"PersonSetVC")]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.navigationController popToViewController:vc animated:YES];
//                    });
//                }
//            }
//        }
//    }];
    [SafetyCenterViewModel changePayPasswordV2ToSendPasswordStr:self.payPasswordStr andVerifyCode:self.verifyCode withDicBlock:^(NSDictionary *dict, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *hint;
                if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
                    hint = @"支付密码修改成功";
                }else {
                    hint = @"支付密码设置成功";
                }
                [ZYProgressHUDTool showCustomHUDTextMessage:hint toView:self.view.window];
                [ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword = YES;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:NSClassFromString(@"SafetyCenterVC")]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass: [MoneyWalletVcLate class]] ) {//提现无密码时 走的设置，此处 回钱包主界面
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    // 设置签署密码
                    if ([vc isKindOfClass:NSClassFromString(@"ZYContractingPartyInformationEditVc")]) {
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"SIGN_PASSWORD_SETTING_BACK")
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                    if ([vc isKindOfClass:NSClassFromString(@"ContrectAllDetailVc")]) {
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"SIGN_PASSWORD_SETTING_BACK")
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            });
        }
    }];
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
