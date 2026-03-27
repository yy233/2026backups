//
//  SetPassWordViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "SetPassWordViewController.h"

@interface SetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UITextField *setPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *setTwoPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation SetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    //
    _setPassWordTextField.tintColor = [DataManager shareDataManager].colorOfMainType;
    _setTwoPasswordTextField.tintColor = [DataManager shareDataManager].colorOfMainType;
    UIImage *biyanImg = [UIImage imageNamed:@"biyan"];
    UIImage *zhengyanImg = [SkinManager skin_imageWithTypeAndNameWithImageName:@"zhengyan"];
    [_eyeBtn setImage:biyanImg forState:UIControlStateNormal];
    [_eyeBtn setImage:zhengyanImg forState:UIControlStateNormal];
    _eyeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ShowOrNotShowBtnAction:(UIButton *)sender {
     sender.selected = !sender.selected;
 
    if (sender.selected) {
        _setPassWordTextField.secureTextEntry = YES;
    
    }else{
        _setPassWordTextField.secureTextEntry = NO;
    }
     _setTwoPasswordTextField.secureTextEntry = _setPassWordTextField.secureTextEntry;
    
   
}
- (IBAction)sendBtnAction:(UIButton *)sender {
    if (_setPassWordTextField.text.length > 12 || _setPassWordTextField.text.length < 6) {
        [self showCodeAction:sender];
    }else{
        
        
        [self sendPassword];
    }
    
}

- (void)showCodeAction:(UIButton *)sender{
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //标题
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"温馨提示", nil)];
    //    [title addAttribute:NSForegroundColorAttributeName value:_searchColor range:NSMakeRange(0, 2)];
    [alert setValue:title forKey:@"attributedTitle"];
    //内容
    
    NSString * strMessage = [NSString stringWithFormat:NSLocalizedString(@"请输入6～12位登录密码", nil) ];
    NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:strMessage];
    [alert setValue:message forKey:@"attributedMessage"];

    //BTN
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)  style:UIAlertActionStyleCancel handler:nil];
    
    
    
    [noAction setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
 
    
    [alert addAction:noAction];
 
    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.permittedArrowDirections  =UIPopoverArrowDirectionDown;
    //页面设置
 
    alert.view.layer.cornerRadius = 10;
    alert.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)sendPassword{
//    [ToolOfNetWork sharedTools]YrequestURL:<#(NSString *)#> withParams:<#(NSMutableDictionary *)#> finished:<#^(id responsObject, NSError *error)finished#>

    [self.view endEditing:YES];
  
    NSString *oneStr = [_setPassWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString*twoStr = [_setTwoPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![ToolOfBasic inputShouldLetterOrNum:oneStr]){
        [self.view makeToast:NSLocalizedString(@"密码必须是数字或字母请重输", nil) duration:4 position:@"center"];
        _setPassWordTextField.text = @"";
        _setTwoPasswordTextField.text = @"";
        return;
    }
    if (![oneStr isEqualToString:twoStr]) {
        [self.view makeToast:NSLocalizedString(@"两次密码不同请重输", nil)  duration:3 position:@"center"];
        _setPassWordTextField.text = @"";
        _setTwoPasswordTextField.text = @"";
        return;
    }
    
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
   
    [pram setObject:oneStr forKey:@"userPassWord"];
    [pram setObject:_strOfphone  forKey:@"userPhone"];
    
    //存信息
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:_strOfphone forKey:AccountNum];
    [def setObject:oneStr forKey:PasswordNum];
    [def synchronize];
    
    NSString *url = S_userForgetPassword;
    if (_isForgetPass) {//S_userForgetPassword
        url = S_userForgetPassword; //忘记密码
    }else{
        url = S_userRegist; //注册账号
   
    }
      [[ToolOfNetWork sharedTools]YrequestURL:url withParams:pram finished:^(id responsObject, NSError *error) {
        if (_Success) {
            //回到登陆还是直接进入程序
            //分为注册 忘密码
            [self goAction];
            
        }else{
             //失败
            NSString *msg = @"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"网络请求失败", nil);
                }
                
            }
            if (_isForgetPass) {  //忘记密码
            
                if (_SuccessOrErrCode == 400) {
                    //
                    msg = NSLocalizedString(@"用户名，密码不能为空", nil);
                }else if(_SuccessOrErrCode == 401){
                    //
                    msg = NSLocalizedString(@"修改失败，请稍后重试", nil);
                }else if(_SuccessOrErrCode == 402){
                    //1218新增
                    msg = NSLocalizedString(@"用户名不存在，请先注册", nil);
                }else{
//                    msg = NSLocalizedString(@"修改失败，请稍后重试", nil);//0201
                }
                
            }else{ //注册
             
                if (_SuccessOrErrCode == 400) {
                    //
                    msg = NSLocalizedString(@"用户名，密码不能为空", nil);
                }else if(_SuccessOrErrCode == 401||_SuccessOrErrCode == 402){
                    //
                    msg = NSLocalizedString(@"注册失败，请稍后再试", nil);
                }else if(_SuccessOrErrCode == 403){
                    //
                    msg = NSLocalizedString(@"该用户已存在", nil);
                }else{
//                     msg = NSLocalizedString(@"注册失败，请稍后再试", nil);
                }
            }

            [self.view makeToast:msg duration:2 position:@"bottom"];
         
        }
    }];

}

- (void)goAction{
     
    [ShareUser sharedUserInfo].accountNum = _strOfphone;
    [ShareUser sharedUserInfo].accPasswordNum = [_setPassWordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
    [self.navigationController popToRootViewControllerAnimated:YES];
    //
//    [self goAddVc];//进主页
    
    
}
- (void)goAddVc{
    
    AddNewViewController *addNewVc = Y_storyBoard_id(@"AddNewViewController");
    //    [self.navigationController pushViewController:addNewVc animated:YES];
    //    self.navigationController.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBarHidden = NO;
    
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:addNewVc];
    self.view.window.rootViewController = nav;
}

#pragma mark --
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
@end
