//
//  NewPassWordSetVC.m
//  Community
//
//  Created by 余莹 on 2020/11/14.
//

#import "NewPassWordSetVC.h"

@interface NewPassWordSetVC ()<NewPasswordSetViewDelegate>
@property (nonatomic,strong)NewPassWordSetView *resetNewPasswordView;
@end

@implementation NewPassWordSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView {
    [self.view addSubview:self.resetNewPasswordView];
}

- (void)newPasswordSetViewSubBtnAction:(UIButton *)sender{
    if (sender.tag == REMOVE_SELF_BTN_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag == RESET_PASSWORD_FINISH_BTN_TAG){
        [self setPassWordFinishBtnAction];
    }else if (sender.tag == RESET_PASSWORD_CANCEL_BTN_TAG){
        NSLog(@"取消重置");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (sender.tag == RESET_PASSWORD_PRARVACY_BTN_TAG){
        NSLog(@"隐私协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else{
        
    }
}
- (void)setPassWordFinishBtnAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.phoneStr forKey:@"account"];
    [params setValue:self.resetNewPasswordView.passwordOneStr forKey:@"password"];
    [params setValue:self.resetNewPasswordView.passwordOneStr forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_RESET_PASSWORD withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                /**
                 */
//                NSLog(@"%@",Y_ResponsObject_dataDic);
                Y_SVP_SHOW_SUCCESS_MESSAGE
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NotificationName_ResetPassword_Finish)
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSLog(@"%@",Y_ResponsObject_dataDic);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//暂时不存
- (void)resetPasswordFinishToSaveAccountAndPassWord{
    [[NSUserDefaults standardUserDefaults] setValue:self.phoneStr forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setValue:self.resetNewPasswordView.passwordOneStr forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ShareUserInfo sharedUserInfo].account = self.phoneStr;
    [ShareUserInfo sharedUserInfo].password = self.resetNewPasswordView.passwordOneStr;
}
#pragma mark ===
- (NewPassWordSetView *)resetNewPasswordView{
    if (!_resetNewPasswordView) {
        _resetNewPasswordView = [[NewPassWordSetView alloc]initWithFrame:self.view.frame];
        _resetNewPasswordView.delegate = self;
    }
    return _resetNewPasswordView;
}
@end
