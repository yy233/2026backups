//
//  ThirdRegistWithSetPasswordVC.m
//  Community
//
//  Created by 余莹 on 2022/5/14.
//

#import "ThirdRegistWithSetPasswordVC.h"

#import "LoginSuccessVC.h"


static NSString *kUrl_ThirdLoginSetPassword = @"proprietor/user/auth/reset/login/password";

@interface ThirdRegistWithSetPasswordVC ()
@property (nonatomic,strong) UIButton *topPushVcBtn;

@end

@implementation ThirdRegistWithSetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initThisView];
     
}
- (void)initThisView{
    [self.firstPasswordSetView.topBackGroundView addSubview:self.topPushVcBtn];
    WEAKSELF
    [self.topPushVcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.firstPasswordSetView.removeSelfBtn);
        make.width.offset(60);
        make.height.offset(30);
        make.right.equalTo(weakSelf.firstPasswordSetView.topBackGroundView);
    }];
    self.firstPasswordSetView.removeSelfBtn.hidden = YES;
    self.firstPasswordSetView.topDetailTitleLabel.text = @"登录后可在[我的-设置-账号与安全]进行设置与修改";

}
- (UIButton *)topPushVcBtn{
    if (!_topPushVcBtn) {
        _topPushVcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topPushVcBtn newAnBtnWithTextStr:@"跳过"];
        [_topPushVcBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_topPushVcBtn newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_topPushVcBtn addTarget:self action:@selector(pushVcAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topPushVcBtn;
}

- (void)passwordSendBtn{
    [self.view endEditing:YES];
    if (self.firstPasswordSetView.passwordOneStr.length == 0 || self.firstPasswordSetView.passwordTwoStr.length == 0) {
        Y_SVP_SHOW_ERR_MES(@"请输入登录密码！")
        return;
    }
     
    //处理登录密码(注册设置密码接口 改成 普通更改密码接口 这是已经三方登录绑定成功后的中转界面 有token了 可不需要code)
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.phoneStr forKey:@"account"];
    [params setValue:self.firstPasswordSetView.passwordOneStr forKey:@"password"];
    [params setValue:self.firstPasswordSetView.passwordTwoStr forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools] YrequestPostURL:kUrl_ThirdLoginSetPassword withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MESSAGE
                [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_ResetPassword_Finish object:nil userInfo:nil];
                //success__
                [weakSelf pushVcAction];
            }else{
                NSLog(@"%@",Y_ResponsObject_dataDic);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            
        }
           
    }];
   
}

//去中转页面
- (void)pushVcAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        LoginSuccessVC *vc = [[LoginSuccessVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    });
}


@end
