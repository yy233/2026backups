//
//  ResetPasswordVCLast.m
//  Community
//
//  Created by 余莹 on 2021/12/10.
// 重置密码换成1个界面

#import "ResetPasswordVCLast.h"

#import "ResetPasswordViewLast.h"//父类为新的注册页 通知等沿用其名
#define  NoticeName_Regist_SecnCodeTimeChangeYes                             @"Regist_SecnCodeTimeChangeYes"

@interface ResetPasswordVCLast () <RegistViewLastDelegate>
@property (nonatomic,strong) ResetPasswordViewLast *resetPasswordView;
@end

@implementation ResetPasswordVCLast


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView{
    [self.view addSubview:self.resetPasswordView];
}

- (void)registViewViewSubBtnAction:(UIButton *)sender{
    if (sender.tag == REGIST_OK_BTN_TAG) {
        [self nextBtnAction];
    }else if(sender.tag == REGIST_VerificationCode_BTN_TAG){
        [self codeBtnAction];
    }else if(sender.tag == REMOVE_SELF_BTN_TAG){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == REGIST_GOLOGINVC_BTN_TAG){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == REGIST_PRARVACY_BTN_TAG){
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else{
        
    }
}

#pragma mark ===
- (void)codeBtnAction{ //发送验证码
    
    if (self.resetPasswordView.phoneStr.length<=11 || self.resetPasswordView.phoneStr.length>8) {
        //
        [self.view endEditing:YES];
    }else{
        Y_SVP_SHOW_ERR_MES(@"请输入正确的账号");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.resetPasswordView.phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_ForgetPassword) forKey:@"type"];

    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
               //验证码btn开始倒计时
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_Regist_SecnCodeTimeChangeYes);
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

- (void)nextBtnAction{//更改密码 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.resetPasswordView.phoneStr forKey:@"account"];
    [params setValue:self.resetPasswordView.codeStr forKey:@"code"];
    [params setValue:self.resetPasswordView.passWordOneStr forKey:@"password"];
    [params setValue:self.resetPasswordView.passWordTwoStr forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_RESET_PASSWORD withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
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

#pragma mark ===
- (ResetPasswordViewLast *)resetPasswordView{
    if (!_resetPasswordView) {
        _resetPasswordView = [[ResetPasswordViewLast alloc]initWithFrame:self.view.frame];
        _resetPasswordView.delegate = self;
    }
    return _resetPasswordView;
}

@end
