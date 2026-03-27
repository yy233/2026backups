//
//  PassWordSetVC.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "FirstPassWordSetVC.h"

@interface FirstPassWordSetVC () <FirstPasswordSetViewDelegate>
@end

@implementation FirstPassWordSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}
- (void)initView {
    [self.view addSubview:self.firstPasswordSetView];
}

- (void)firstPasswordSetViewSubBtnAction:(UIButton *)sender{
    if (sender.tag == REMOVE_SELF_BTN_TAG) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag == REGIST_GOLOGINVC_BTN_TAG){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (sender.tag == REGIST_SET_PASSWORD_FINISH_BTN_TAG){
        [self passwordSendBtn];
    }else{
        
    }
}
- (void)passwordSendBtn{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.firstPasswordSetView.passwordOneStr forKey:@"password"];
    [params setValue:self.firstPasswordSetView.passwordTwoStr forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools] YrequestPostURL:URL_USER_SET_PASSWORD withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MESSAGE
                [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_ResetPassword_Finish object:nil userInfo:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSLog(@"%@",Y_ResponsObject_dataDic);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            
        }
           
    }];
}
#pragma mark ===
- (FirstPassWordSetView *)firstPasswordSetView{
    if (!_firstPasswordSetView) {
        _firstPasswordSetView = [[FirstPassWordSetView alloc]initWithFrame:self.view.frame];
        _firstPasswordSetView.delegate = self; 
    }
    return _firstPasswordSetView;
}
@end
