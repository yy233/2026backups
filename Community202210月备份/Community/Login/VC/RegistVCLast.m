//
//  RegistVCLast.m
//  Community
//
//  Created by 余莹 on 2021/11/30.
//

#import "RegistVCLast.h"
#import "RegistViewLast.h"
#define  NoticeName_Regist_SecnCodeTimeChangeYes                             @"Regist_SecnCodeTimeChangeYes"
//注册和忘记密码都在用本view
@interface RegistVCLast () <RegistViewLastDelegate>
@property (nonatomic,strong) RegistViewLast *registView;
@end

@implementation RegistVCLast

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView{
    [self.view addSubview:self.registView];
    WEAKSELF
    self.registView.gotoPrivacyAgreementVcBlock = ^(PrivacyAgreementVCLate * _Nonnull vc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    };
}

- (void)registViewViewSubBtnAction:(UIButton *)sender{
    if (sender.tag == REGIST_OK_BTN_TAG) {
        [self nextBtnAction];
    }else if(sender.tag == REGIST_VerificationCode_BTN_TAG){
        [self codeBtnAction];
    }else if(sender.tag == REMOVE_SELF_BTN_TAG){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else if(sender.tag == REGIST_GOLOGINVC_BTN_TAG){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == REGIST_PRARVACY_BTN_TAG){//未使用本tag 0429
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else{
        
    }
}

#pragma mark ===
- (void)codeBtnAction{
    if (!self.registView.agreeBtn.selected) {
        Y_SVP_SHOW_INFO_MES(@"请同意协议！");
        return;
    }
    if (self.registView.phoneStr.length<=11 && self.registView.phoneStr.length>8) {
        //
        [self.view endEditing:YES];
    }else{
        Y_SVP_SHOW_ERR_MES(@"请输入正确的账号");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.registView.phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_Regist) forKey:@"type"];

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

- (void)nextBtnAction{//立即注册
    if (!self.registView.agreeBtn.selected) {
        Y_SVP_SHOW_INFO_MES(@"请同意协议！");
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:self.registView.phoneStr forKey:@"account"];
    [params setValue:self.registView.codeStr forKey:@"code"];
    [params setValue:self.registView.passWordOneStr forKey:@"password"];
    [params setValue:self.registView.passWordTwoStr forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_REGISTER withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSLog(@"%@",Y_ResponsObject_dataDic);
                [ShareUserInfo sharedUserInfo].token = [Y_ResponsObject_dataDic objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setValue:[Y_ResponsObject_dataDic objectForKey:@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                Y_SVP_SHOW_SUCCESS_MESSAGE
                [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_ResetPassword_Finish object:nil userInfo:nil];
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
- (RegistViewLast *)registView{
    if (!_registView) {
        _registView = [[RegistViewLast alloc]initWithFrame:self.view.frame];
        _registView.delegate = self;
    }
    return _registView;
}

@end
