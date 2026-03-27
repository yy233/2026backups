//
//  BindingPhoneVC.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "BindingPhoneVC.h"

@interface BindingPhoneVC ()
@property (nonatomic,strong)BindingPhoneView *bindingPhoneView;
@end

@implementation BindingPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView{
    [self.view addSubview:self.bindingPhoneView];
}


#pragma mark ===
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    if (self.bindingPhoneView.phoneStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"错误的手机号");
        return;
    }
    [self sendCodeBtnAction];//获取验证码
}

//三方登录 绑定手机vc 获取验证码 跳转下一页
- (void)sendCodeBtnAction{
//    //test
//    [self pushToCodeVc];
//    return;
    NSString *exT = [ToolOfTimeChangeFormat getTimeStrWithString: [ShareUserInfo sharedUserInfo].expiredTime];
    NSString *nowT = [ToolOfTimeChangeFormat currentTimeStr];
    // token非过期时间
    if ([exT integerValue] > [nowT integerValue]){
    }else if ([exT integerValue]<=0 || [exT isEqualToString:@""]){
        Y_SVP_SHOW_ERR_MES(@"当前token数据有误,请重新登录");
        return;
    }else{
        Y_SVP_SHOW_ERR_MES(@"当前token已过期,请重新登录");
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:0];
    [params setValue:self.bindingPhoneView.phoneStr forKey:@"account"];
    [params setValue:@(CodeRequestType_ThirdRegistBangDingPhone) forKey:@"type"];//三方注册的type
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //验证码vc
                Y_SVP_SHOW_SUCCESS_MESSAGE
                [self pushToCodeVc];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)pushToCodeVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });

    //逾期时间待处理
    if ([ShareUserInfo sharedUserInfo].expiredTime) { 
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        InputCodeVC *codeVc = [[InputCodeVC alloc]init];
        codeVc.phoneStr = self.bindingPhoneView.phoneStr;
        codeVc.wxUserModel = self.wxUsermodel;
        codeVc.zfbUserModel = self.zfbUserModel;
        codeVc.appleUserModel = self.appleUserModel;
        
        [self.navigationController pushViewController:codeVc animated:YES];
    });
   
}
- (void)removeSelfBtnTouchAction:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];

    });
}

#pragma mark ===
- (BindingPhoneView *)bindingPhoneView{
    if (!_bindingPhoneView) {
        _bindingPhoneView = [[BindingPhoneView alloc]initWithFrame:self.view.frame];
        [_bindingPhoneView.okBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bindingPhoneView.removeSelfBtn addTarget:self action:@selector(removeSelfBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindingPhoneView;
}
@end
