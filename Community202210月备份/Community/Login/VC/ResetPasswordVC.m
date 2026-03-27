//
//  ResetPasswordVC.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "ResetPasswordVC.h"

@interface ResetPasswordVC () <RestPasswordViewDelegate>
@property (nonatomic,strong)ResetPasswordView *restPasswordView;
@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView{
    [self.view addSubview:self.restPasswordView];
}

- (void)restPasswordViewSubBtnAction:(UIButton *)sender{
    if(sender.tag == RESET_PASSWORD_NEXT_BTN_TAG){
        [self codeCheck];
    }else if(sender.tag == RESET_PASSWORD_CODE_BTN_TAG){
        [self sendCodeBtnAction];//发送code请求
    }else if(sender.tag == REMOVE_SELF_BTN_TAG){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == RESET_PASSWORD_PRARVACY_BTN_TAG){
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        [self.navigationController pushViewController:privacyVc animated:YES];
    }else{
    }
}
- (void)sendCodeBtnAction{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.restPasswordView.phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_ForgetPassword) forKey:@"type"];
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.restPasswordView countdown];//验证码btn
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

- (void)codeCheck{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.restPasswordView.phoneStr forKey:@"account"];
    [params setValue:self.restPasswordView.codeStr forKey:@"code"];
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_FORGET_PASSWORD_CODE_CHECK withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
//                NSLog(@"%@",Y_ResponsObject_dataDic);//[1]    (null)    @"data" : YES    
                /** po responsObject
                 */
                //新增token字段 更新本地的数据
//                if ([Y_ResponsObject_dataDic isKindOfClass:[NSDictionary class]]) {
                if ([responsObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    if ([[Y_ResponsObject_dataDic allKeys] containsObject:@"authToken"]) {
                        [ShareUserInfo sharedUserInfo].token = [Y_ResponsObject_dataDic objectForKey:@"authToken"];
                        [[NSUserDefaults standardUserDefaults]setValue:[Y_ResponsObject_dataDic objectForKey:@"authToken"] forKey:@"token"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                }
                NSLog(@"%@",Y_ResponsObject_dataDic);
                NewPassWordSetVC *newPasswordSetVc = [[NewPassWordSetVC alloc]init];
                newPasswordSetVc.phoneStr = self.restPasswordView.phoneStr;
                [self.navigationController pushViewController:newPasswordSetVc animated:YES];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
//    NewPassWordSetVC *newPasswordSetVc = [[NewPassWordSetVC alloc]init];
//    newPasswordSetVc.phoneStr = self.restPasswordView.phoneStr;
//    [self.navigationController pushViewController:newPasswordSetVc animated:YES];
//   
}
#pragma mark ====
- (ResetPasswordView *)restPasswordView{
    if (!_restPasswordView) {
        _restPasswordView = [[ResetPasswordView alloc]initWithFrame:self.view.frame];
        _restPasswordView.delegate = self;
    }
    return _restPasswordView;
}
@end
