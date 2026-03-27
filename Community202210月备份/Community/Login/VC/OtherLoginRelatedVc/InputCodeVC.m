//
//  CodeViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "InputCodeVC.h"
#import "ThirdRegistWithSetPasswordVC.h"


@interface InputCodeVC () <UITextFieldDelegate>
@property (nonatomic,strong) InputCodeView *codeAllView;
@property (nonatomic,assign) BindThrid_Type bindThridType;
@end

@implementation InputCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
     
}
- (void)initView{
    [self.view addSubview:self.codeAllView];
}
- (void)okBtnAction:(UIButton *)sender{
//    //test
//    [self goToMainVcWithTokenStr:@""];//登录相关操作
//    return;
    //
    if (_codeAllView.codeView.textField.text.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请输入验证码")
        return;
    }
//    sender.selected = !sender.selected;
    NSString *codeStr =  _codeAllView.codeView.textField.text;
    
    [self chooseThirdTypeWithWillSendCode:codeStr];
   //____
}
#pragma mark == 判断当前是哪个的绑定
- (void)chooseThirdTypeWithWillSendCode:(NSString *)codeStr{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:self.phoneStr forKey:@"mobile"];
    [parms setValue:codeStr forKey:@"code"];
    //
    NSString * wxId = self.wxUserModel.thirdPlatformId;
    NSString * zfbId = self.zfbUserModel.thirdPlatformId;
    NSString * appleThridLoginId = self.appleUserModel.thirdPlatformId;//1213数据被弃用 现为绑定页处理类型的占位符

   //______
    NSString *useUrl = @"";
    if (wxId.length>0) {
        useUrl = @"proprietor/WeChat/bindingMobile";
        //[parms setValue:self.wxUserModel.thirdPlatformId forKey:@"thirdPlatformId"];
        self.bindThridType = BindThrid_Type_WX;
    }
    if (zfbId>0) {
        useUrl = @"proprietor/user/auth/third/binding";
        [parms setValue:@(1) forKey:@"thirdPlatformType"];//支付宝
        self.bindThridType = BindThrid_Type_ZFB;
    }
    if (appleThridLoginId>0) {
        useUrl = @"proprietor/Ios/bindingMobile";
        self.bindThridType = BindThrid_Type_Apple;
    }
    //_____
    [self bingPhoneWithUrl:useUrl andWithParms:parms];
}
- (void)bingPhoneWithUrl:(NSString *)urlStr andWithParms:(NSMutableDictionary *)parms{
    if (urlStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"绑定失败");
        return;
    }
    Y_SVP_SHOW_MES_IsDealing_15Delay

     [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:urlStr withParams:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
         
                Y_SVP_SHOW_SUCCESS_MES(@"绑定成功!");
                NSDictionary * resDataDic = [[responsObject allKeys]containsObject:@"data"] ? [[NSDictionary alloc]initWithDictionary:responsObject[@"data"]] : @{};
                NSString     * tokenStr = @"";
                if (self.bindThridType == BindThrid_Type_WX) {
                        tokenStr =  [[resDataDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",resDataDic[@"token"]] : @"";
                }else if (self.bindThridType == BindThrid_Type_ZFB){ 
                        tokenStr =  [[resDataDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",resDataDic[@"token"]] : @"";
                }else if (self.bindThridType == BindThrid_Type_Apple){
                        tokenStr =  [[resDataDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",resDataDic[@"token"]] : @"";
                }else{
                    
                }
          
                [self saveTokenAndUserInfo:@{@"token":tokenStr}];//token信息存储
                [self saveTokenAndUserInfo:resDataDic];//用户信息存储
                NSString *expiredTimeStr = [[resDataDic allKeys]containsObject:kLogin_ExpiredTime_Key] ? [NSString stringWithFormat:@"%@",resDataDic[kLogin_ExpiredTime_Key]] : @"";
                [self saveTokenAndUserInfo:@{kLogin_ExpiredTime_Key:expiredTimeStr}];//token过期时间信息存储0927
                NSLog(@"saveToken  %@ %@",tokenStr,[ShareUserInfo sharedUserInfo].token);
                NSLog(@"saveExpiredTime  %@ %@",expiredTimeStr,[ShareUserInfo sharedUserInfo].expiredTime);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self goToMainVcWithTokenStr:tokenStr];//登录相关操作
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
   /**
   
   url=http://192.168.12.60:9527/api/v1/proprietor/Ios/bindingMobile____{
      code = 0;
      data =     {
          expiredTime = "2021-06-08 11:40:07";
          token = 6e6e08584b1b451eaa945e18a2d170a2;
          userInfo =         {
              isBindMobile = 1;
              uid = b6ec78698a1846a995d2a5d7b0c33b6a;
          };
      };
      message = "<null>";
  }
   
   data =     {
   expiredTime = "2021-03-17 17:05:12";
   token = f587fe6e75d6412ba277772d7d8efde0;
   userInfo =         {
       isBindMobile = 1;
       uid = test123;
   };
};*/
- (void)goToMainVcWithTokenStr:(NSString *)tokenStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        //20220514新版 去密码设置中转页
        ThirdRegistWithSetPasswordVC *vc = [[ThirdRegistWithSetPasswordVC alloc]init];
        vc.phoneStr = self.phoneStr;
        [self.navigationController pushViewController:vc animated:YES];
    });
}
- (void)saveTokenAndUserInfo:(NSDictionary *)resultsDic{
    //防止被清空 做if
    if ([[resultsDic allKeys]containsObject:kLogin_ExpiredTime_Key]) {//token的有效期
        [[NSUserDefaults standardUserDefaults] setValue:[resultsDic objectForKey:kLogin_ExpiredTime_Key] forKey:kLogin_ExpiredTime_Key];
        [ShareUserInfo sharedUserInfo].expiredTime = [resultsDic objectForKey:kLogin_ExpiredTime_Key];
    }
    if ([[resultsDic allKeys]containsObject:@"token"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[resultsDic objectForKey:@"token"] forKey:@"token"];
        [ShareUserInfo sharedUserInfo].token = [resultsDic objectForKey:@"token"];
    }
    if ([[resultsDic allKeys]containsObject:@"userInfo"]) {
        UserModel *userModel = [UserModel mj_objectWithKeyValues:[resultsDic objectForKey:@"userInfo"]];
        [ShareUserInfo sharedUserInfo].userInfo = userModel;
        [[ShareUserInfo sharedUserInfo] saveDefaultsLoginUserInfo:userModel];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"saveTokenAndUserInfo resultsDic2 =%@",resultsDic);
}

#pragma mark == 重获验证码
- (void)resendCode{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parm setValue:self.phoneStr forKey:@"account"];//account
    [parm setValue:@(CodeRequestType_ThirdRegistBangDingPhone) forKey:@"type"];
    
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:parm finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    Y_SVP_SHOW_SUCCESS_MES(@"");//重新获取验证码成功
                } else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            } else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
    }];
}
- (void)removeSelfBtnAction:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma  mark ===
- (InputCodeView *)codeAllView{
    if (!_codeAllView) {
        _codeAllView = [[InputCodeView alloc]initWithFrame:self.view.frame];
        _codeAllView.topDetailTitleLabel.text = [NSString stringWithFormat:@"验证码已发送到+86 %@",self.phoneStr];
//        [_codeAllView.okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_codeAllView.removeSelfBtn addTarget:self action:@selector(removeSelfBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_codeAllView.onceCgainGetCodeBtn addTarget:self action:@selector(resendCode) forControlEvents:UIControlEventTouchUpInside];
        _codeAllView.codeView.textField.delegate = self;

    }
    return _codeAllView;
}
 

#pragma mark ==
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 4) {
        [self okBtnAction:nil];
    }
}
@end
