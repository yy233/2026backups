//
//  RegistVC.m
//  Community
//
//  Created by 余莹 on 2020/11/9.
//

#import "RegistVC.h"

@interface RegistVC ()<RegistViewDelegate>
@property (nonatomic,strong) RegistView *registView;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView{
    [self.view addSubview:self.registView];
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
- (void)codeBtnAction{
    
    if (self.registView.phoneStr.length==11 || self.registView.phoneStr.length>8) {
        //
    }else{
        Y_SVP_SHOW_ERR_MES(@"请输入正确的账号");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.registView.phoneStr forKey:@"account"];
    if (self.isUseCodeLoginBool == YES) {
        [params setValue:@(CodeRequestType_Login) forKey:@"type"];
    }else{
        [params setValue:@(CodeRequestType_Regist) forKey:@"type"];
    }
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.registView countdown];//验证码btn
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

- (void)nextBtnAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.registView.phoneStr forKey:@"account"];
    [params setValue:self.registView.codeStr forKey:@"code"];
    NSString *strOfRandom  = [Tool toolCreateRandomUuid];
    [params setValue:strOfRandom forKey:@"regId"];//待改 极光后台推送ID数据 //0331去掉 极光id用于登录成功后 用新接口传入
    
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_REGISTER withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                /**
                 {
                     code = 500;
                     data = 0;
                     message = "服务器错误";
                 }
                 {
                   "code": 0,
                   "message": null,
                   "data": {
                     "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI3ODYiLCJpYXQiOjE2MDUzNDM4MDksImV4cCI6MTYwNTk0ODYwOX0.m15AdUY35BnnrBr2TIiyyr8TAhlOX1DlL00nCPGgAL-_epolRh1clxoaPsCRRXPFfZfFvl-Gw2SXXDsbe95q4w",
                     "expiredTime": "2020-11-21 16:50:09",
                     "userInfo": {
                       "id": 786,
                       "nickname": null,
                       "avatarUrl": null,
                       "sex": 0,
                       "realName": null,
                       "idCard": null,
                       "isRealAuth": 0,
                       "province": null,
                       "city": null,
                       "area": null,
                       "detailAddress": null
                     }
                   }
                 }*/
                [ShareUserInfo sharedUserInfo].token = [Y_ResponsObject_dataDic objectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults]setValue:[Y_ResponsObject_dataDic objectForKey:@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"%@",Y_ResponsObject_dataDic);
                FirstPassWordSetVC *passwordSetVc = [[FirstPassWordSetVC alloc]init];
                [self.navigationController pushViewController:passwordSetVc animated:YES];
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
- (RegistView *)registView{
    if (!_registView) {
        _registView = [[RegistView alloc]initWithFrame:self.view.frame];
        _registView.delegate = self;
    }
    return _registView;
}
@end
