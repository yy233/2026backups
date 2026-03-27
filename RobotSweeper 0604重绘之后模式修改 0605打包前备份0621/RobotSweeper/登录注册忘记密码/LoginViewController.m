//
//  LoginViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/26.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *acccountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiels;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic ,assign) BOOL isCanLoginAction;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [[ToolOfNetWork sharedTools]endXml];//防止xml格式
   
 //主题色
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [DataManager shareDataManager].appNowProductTypeNumStr =  [def objectForKey:MainTypeNumStr];
    [ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZoneWithFirstRobotId:[DataManager shareDataManager].appNowProductTypeNumStr];
    
   //data
    _isCanLoginAction = YES;

    _acccountTextFiled.text = [def objectForKey:AccountNum];
    _passWordTextFiels.text = [def objectForKey:PasswordNum];
    _acccountTextFiled.delegate = self;
    _passWordTextFiels.delegate = self;
    _acccountTextFiled.returnKeyType = UIReturnKeyNext;
    _passWordTextFiels.returnKeyType = UIReturnKeyDone;
    _acccountTextFiled.keyboardType = UIKeyboardTypeDefault;
    _passWordTextFiels.keyboardType = UIKeyboardTypeDefault;
    
    [ShareUser sharedUserInfo].accountNum = _acccountTextFiled.text;
    [ShareUser sharedUserInfo].accPasswordNum = _passWordTextFiels.text;
    
    if (_passWordTextFiels.text.length>0&&_acccountTextFiled.text.length>0) {
        [self loginDo];
    }else{
        //缺数据时不做登录操作
    }
    
}
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeyNext){
        [_passWordTextFiels becomeFirstResponder];
    }else{
        [textField resignFirstResponder];//取消第一响应者
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self logoutxmpp];
    //退出xmpp
     [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    
    [self.view endEditing:YES];//取消键盘
    [_acccountTextFiled resignFirstResponder];
    [_passWordTextFiels resignFirstResponder];
    //view
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _acccountTextFiled.tintColor = [DataManager shareDataManager].colorOfMainType;
    _passWordTextFiels.tintColor = [DataManager shareDataManager].colorOfMainType;
    _imgV.contentMode = UIViewContentModeScaleAspectFit;
    _imgV.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];//在view出现时更新imgv
    
    //可用，手指范围合适
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
 
    self.navigationController.navigationBarHidden = YES;
    self.passWordTextFiels.secureTextEntry = YES;
  
   if (@available(iOS 11.0, *)) {//11和10版本的返回图标出现不一样的情况
           [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:Y_IMAGE_ORIGINAL(@"返回按钮透明")];
           [[UINavigationBar appearance] setBackIndicatorImage:Y_IMAGE_ORIGINAL(@"返回按钮透明")];
   }else{
           [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
           [[UINavigationBar appearance] setBackIndicatorImage:Y_IMAGE_ORIGINAL(@"返回按钮")];
   }
 
    /**是否清空密码的处理*/
    //退出“” “”置空
    //更改密码“xxxx” “”置空一部分
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString* acccountDefstr = [def objectForKey:AccountNum];
    NSString* passWordDefstr = [def objectForKey:PasswordNum];
    if (acccountDefstr.length!=0&&passWordDefstr.length==0) {
         //更改密码
        _passWordTextFiels.text = @"";
    }else{
        //
    }
}

#pragma mark --  wifiStatus

- (void)wifiStatus{
    if ([ToolOfBasic currentNetworkStatus]) {
   
    }else{
        _isCanLoginAction = YES;
        NSLog(@"=========没网");
        [MBProgressHUD hideHUD];
        [self.view makeToast: NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil)  duration:2 position:@"center"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAction:(UIButton *)sender {
    
    
    if ([_passWordTextFiels.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0&&[_acccountTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        
        [ShareUser sharedUserInfo].accountNum = [_acccountTextFiled.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [ShareUser sharedUserInfo].accPasswordNum = [_passWordTextFiels.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //去前后多余空格后登录
        [self loginDo];
    }else{
        [self.view makeToast:NSLocalizedString(@"请输入账号和密码", nil)  duration:2 position:@"center"];
    }
 
 
}


- (void)loginDo{
//   [self loginOk];
    if ([ToolOfBasic currentNetworkStatus]) {
        
    }else{
        _isCanLoginAction = YES;
        NSLog(@"=========没网");
        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"请检查网络连接是否正常"];
          [self.view makeToast:NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil)  duration:2 position:@"center"];
        return;
    }
    
//    if (![ToolOfBasic currentNetworkStatus]) {
//         [self.view showToast:[YBassViewController failOfMessage:@"请连接网络"] duration:3 position:@"center"];
//        return;
//    }

//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_acccountTextFiled.text,@"userPhone",_passWordTextFiels.text ,@"userPassWord",nil];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[ShareUser sharedUserInfo].accountNum forKey:AccountNum];
    [def setObject:[ShareUser sharedUserInfo].accPasswordNum forKey:PasswordNum];
    [def synchronize];
    
    
     NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[ShareUser sharedUserInfo].accountNum,@"userPhone",[ShareUser sharedUserInfo].accPasswordNum ,@"userPassWord",nil];
 
 
    
    if (!_isCanLoginAction) {//已点过？
//        [self.view makeToast:@"正在登录请稍后..." duration:1 position:@"center"];
        return;
    }
    _isCanLoginAction = NO;//防止双点击
    [MBProgressHUD showMessage:NSLocalizedString(@"正在登录，请稍后", nil) ];
    
    [self performSelector:@selector(hid) withObject:@"hid" afterDelay:10.0];

    [[ToolOfNetWork sharedTools]YrequestURL:S_userLogin withParams:parm finished:^(id responsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        //防止mbp还在转的情况
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something..
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUD];
            });
        });
        if ([responsObject isKindOfClass:[NSXMLParser class]]) {
           NSString* msg = NSLocalizedString(@"登录失败", nil) ;
            [self.view makeToast:msg duration:1 position:@"center"];
            return ;
        }
        NSLog(@"login------%@",responsObject);
        NSLog(@"login----error--%@",error.description);
        if (_Success) {
 
            //存储数据userName和 passWord
            [ShareUser sharedUserInfo].userMode = [UserModel objectWithKeyValues:responsObject];
            [ShareUser sharedUserInfo].userMode.userNameNoSuffix = [ShareUser sharedUserInfo].accountNum;
            
            [self loginOk];
        }else{
            
//            NSString *msg = [responsObject objectForKey:@"msg"];
            NSString *msg = NSLocalizedString(@"登录失败", nil) ;
            
            if(error.code==-1009){
                msg = NSLocalizedString(@"网络请求失败,请稍后再试", nil);
            } else if(error.code==-1004){
                msg = NSLocalizedString(@"网络请求失败,请稍后再试", nil);
            }else{
                msg = NSLocalizedString(@"登录失败,请稍后再试", nil);
            }
          
            if (_SuccessOrErrCode == 400) {
                msg = NSLocalizedString(@"用户名，密码不能为空", nil);
            }else if(_SuccessOrErrCode == 401){
//                msg = NSLocalizedString(@"登录失败，请重新登录", nil);
                msg = NSLocalizedString(@"用户名不存在，请先注册", nil);
            }else if(_SuccessOrErrCode == 402){
                msg = NSLocalizedString(@"用户名或密码错误", nil);
            }else if(_SuccessOrErrCode == 403){
                msg = NSLocalizedString(@"登录失败，请稍后重试", nil);
            }else{
                
            }
            if (msg.length==0) {
                msg = NSLocalizedString(@"登录失败，请稍后重试", nil);
            }
            [self.view makeToast:msg duration:2 position:@"center"];
         
        }
        
        _isCanLoginAction = YES;
        
    }];
    
    
}
- (void)hid{
     _isCanLoginAction = YES;
   
    [MBProgressHUD hideHUD];
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    //防止mbp还在转的情况
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something..
        dispatch_async(dispatch_get_main_queue(),^{
            [MBProgressHUD hideHUD];
        });
    });
}


- (void)loginOk{
    
    
//    SetMachineNameViewController *setNameVc = Y_VCInSB(@"SetMachineNameViewController", @"SucceedSearchGetWifiViewController");
////    [self.navigationController pushViewController:setNameVc animated:YES];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:setNameVc];
//    self.view.window.rootViewController = nav;
    
    //UINavigationController UINavigationBar UINavigationItem
    //在appdelegate中也有，这里复写试试
//
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:Y_IMAGE_ORIGINAL(@"返回按钮透明")];
//    [[UINavigationBar appearance] setBackIndicatorImage:Y_IMAGE_ORIGINAL(@"返回按钮透明")];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance]setBackButtonBackgroundVerticalPositionAdjustment:-32 forBarMetrics:UIBarMetricsDefault];
//
    
    
    //1
    AddNewViewController *addNewVc = Y_storyBoard_id(@"AddNewViewController");
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:addNewVc];
 
    self.view.window.rootViewController = nav;
}
//忘记密码//注册r
- (IBAction)forgerPassWordAction:(UIButton *)sender {
    
    
    PassWordViewController *forgetVc = Y_storyBoard_id(@"PassWordViewController");
    forgetVc.isForgetPassWord = YES;
    [self.navigationController pushViewController:forgetVc animated:YES];
    
}

- (IBAction)registAction:(UIButton *)sender {
//    
//    RegistViewController *registVc = Y_storyBoard_id(@"RegistViewController");
//    [self.navigationController pushViewController:registVc animated:YES];
    
    PassWordViewController *registVc = Y_storyBoard_id(@"PassWordViewController");
    registVc.isForgetPassWord = NO;
    [self.navigationController pushViewController:registVc animated:YES];
}


#pragma mark -- 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.acccountTextFiled resignFirstResponder];
    [self.passWordTextFiels resignFirstResponder];

    
}


- (void)logoutxmpp{
    {
        [[XmppManager shareXmppManager]logoutWithCompletion:^(BOOL finish) {
            
            if (finish) {
                
                
            } else {
                
                
            }
        }];
        
        
    }
}
 @end
