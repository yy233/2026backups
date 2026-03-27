//
//  PassWordChangeViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/19.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "PassWordChangeViewController.h"

@interface PassWordChangeViewController ()

//新增原密码部分,与本地存的进行比较，再执行后续
@property (nonatomic,strong)UIView *yuanMiMaBackV;
@property (nonatomic,strong)UILabel *yuanMiMaL;
@property (nonatomic,strong)UITextField *textFYuanMiMa;
//
@property (nonatomic,strong)UIView *oneBackV;
@property (nonatomic,strong)UIView *twoBackV;
@property (nonatomic,strong)UILabel *oneL;
@property (nonatomic,strong)UILabel *twoL;
//
@property (nonatomic,strong)UILabel *titleL;//变成顶部的灰色view
@property (nonatomic,strong)UILabel *conternL;//这是6 12的文字部分
@property (nonatomic,strong)UITextField *textFone;
@property (nonatomic,strong)UITextField *textFtwo;
@property (nonatomic,strong)UIButton *savePassBtn;
@end

@implementation PassWordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"修改密码", nil);
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    [self initView];

}
- (void)initView{
    
    //
    [self.view addSubview:self.yuanMiMaBackV];
    [self.view addSubview:self.yuanMiMaL];
    [self.view addSubview:self.textFYuanMiMa];
     [self.view addSubview:self.titleL];
     [self.view addSubview:self.oneBackV];
     [self.view addSubview:self.twoBackV];
     [self.view addSubview:self.oneL];
     [self.view addSubview:self.twoL];
     [self.view addSubview:self.conternL];
     [self.view addSubview:self.textFone];
     [self.view addSubview:self.textFtwo];
     [self.view addSubview:self.savePassBtn];
    [self getViewYs];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getViewYs{
    //背景v
    [_yuanMiMaBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(50);
    }];
    
    [_oneBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yuanMiMaBackV.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(50);
    }];
    [_twoBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneBackV.mas_bottom).offset(1);
        make.width.equalTo(self.view.mas_width);
        make.height.offset(50);
    }];
    
    //label
    [_yuanMiMaL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yuanMiMaBackV);
        make.left.equalTo(self.view.mas_left).offset(20);
//        make.width.offset(80);
          make.width.offset(130);
        make.height.offset(40);
    }];
    [_oneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.oneBackV);
        make.left.equalTo(self.view.mas_left).offset(20);
//        make.width.offset(80);
          make.width.offset(130);
        make.height.offset(40);
    }];
    [_twoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.twoBackV);
        make.left.equalTo(self.view.mas_left).offset(20);
//        make.width.offset(80);
          make.width.offset(130);
        make.height.offset(40);
  
    }];
    //输入框
    [_textFYuanMiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yuanMiMaL);
        make.left.equalTo(self.oneL.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
        //        make.height.offset(40);
        make.height.equalTo(_oneL.mas_height);
    }];
    
    [_textFone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.oneL);
        make.left.equalTo(self.oneL.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.offset(40);
        make.height.equalTo(_oneL.mas_height);
    }];
    
    [_textFtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.twoL);
        make.left.equalTo(self.twoL.mas_right);
        make.right.equalTo(self.view.mas_right).offset(-20);
//        make.height.offset(40);
         make.height.equalTo(_twoL.mas_height);
    }];
    
    [_conternL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(60);
        make.top.equalTo(_twoBackV.mas_bottom).offset(10);
    }];
    [_savePassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).offset(-100);
        make.height.offset(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
    }];
    /**
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(30);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
    [_textFone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(40);
        make.top.equalTo(_titleL.mas_bottom).offset(30);
    }];
    [_textFtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(40);
        make.top.equalTo(_textFone.mas_bottom).offset(20);
    }];
    [_conternL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(50);
        make.top.equalTo(_textFtwo.mas_bottom).offset(30);
    }];
    [_savePassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.offset(50);
        make.top.equalTo(_conternL.mas_bottom).offset(30);
    }];
    */
}
#pragma mark -- 
- (void)savePassBtnAction:(UIButton *)sender{
    
    //原密码
 
    NSString *yuanmmstr =  [ShareUser sharedUserInfo].accPasswordNum;
    NSString *yuanmmTextFieldStr = [_textFYuanMiMa.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([yuanmmstr isEqualToString:yuanmmTextFieldStr]) {
        
    }else{
        if (yuanmmTextFieldStr.length==0) {
             [self.view makeToast:NSLocalizedString(@"请输入原密码", nil)  duration:3 position:@"center"];
        }else{
             [self.view makeToast:NSLocalizedString(@"原密码错误", nil)  duration:3 position:@"center"];
        }
       
        return;
    }
    
    //新密码 去前后空格后比较
     NSUInteger oneI = [_textFone.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
     NSUInteger twoI = [_textFtwo.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    
    if (oneI==0||twoI==0) {
        
        [MBProgressHUD showError:NSLocalizedString(@"请输入新密码",nil)];
        return;
    }
    if (oneI > 12 || oneI < 6) {
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
    
    NSString * strMessage = [NSString stringWithFormat:NSLocalizedString(@"请输入6～12位登录密码",nil)];
    NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:strMessage];
    [alert setValue:message forKey:@"attributedMessage"];
    
    //BTN
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleCancel handler:nil];
    
    
    
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
    
    
    NSString *oneStr = [_textFone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString*twoStr = [_textFtwo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![oneStr isEqualToString:twoStr]) {
        [MBProgressHUD showError:NSLocalizedString(@"两次密码不同请重输",nil)];
        _textFone.text = @"";
        _textFtwo.text = @"";
        
        return;
    }
//    if ([ToolOfBasic haveChinese:oneStr]) {
//          [MBProgressHUD showError:@"密码不能含有中文字符"];
//        return;
//    }
    if(![ToolOfBasic inputShouldLetterOrNum:oneStr]){
        [self.view makeToast:NSLocalizedString(@"密码必须是数字或字母请重输",nil) duration:4 position:@"center"];
        _textFone.text = @"";
        _textFtwo.text = @"";
        return;
    }
    
    NSMutableDictionary *pram = [NSMutableDictionary dictionary];
    NSString *strOfphone = [NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].accountNum ];
    
    [pram setObject:oneStr forKey:@"userPassWord"];
    [pram setObject:strOfphone forKey:@"userPhone"];
    
    //存信息
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:strOfphone forKey:AccountNum];
    [def setObject:oneStr forKey:PasswordNum];
    [def synchronize];
    
    NSString *url = S_userForgetPassword;
    //        NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
    
    [[ToolOfNetWork sharedTools]YrequestURL:url withParams:pram finished:^(id responsObject, NSError *error) {
        
        if (_Success) {
            //回到登陆还是直接进入程序
            
            [self.view makeToast:NSLocalizedString(@"修改密码成功", nil) duration:2 position:@"center"];
            [self showSuccessAndPoP];
            
            
        }else{
            NSString *msg = @"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil);
                }else{
                    msg = NSLocalizedString(@"网络请求失败", nil);
                }
                
            }
            if (_SuccessOrErrCode == 400) {
                //
                msg = NSLocalizedString(@"用户名，密码不能为空", nil);
            }else if(_SuccessOrErrCode == 401){
                //
                msg = NSLocalizedString(@"修改失败，请稍后重试", nil);
            }else if(_SuccessOrErrCode == 402){
                //
                msg = NSLocalizedString(@"用户名不存在，请先注册", nil);
            }else{
                if(msg.length==0){
                    msg = NSLocalizedString(@"修改失败，请稍后重试", nil);
                }
            }
        }
    }];
    
}
#pragma mark --
- (void)showSuccessAndPoP{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改密码成功",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          [self goAction];
    }];
    [alert addAction:noAction];
    //页面设置
    
    alert.view.layer.cornerRadius = 10;
    alert.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:alert animated:YES completion:nil];
    
    
  
}
- (void)goAction{
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[XmppManager shareXmppManager]logoutWithCompletion:^(BOOL finish) {
        
        if (finish) {
            //账号密码清空 防止推出后再点开的自动登录
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//            [def setObject:@"" forKey:AccountNum];
            [def setObject:@"" forKey:PasswordNum];
            
            //登出
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.view.window.rootViewController = appDelegate.nav;
            
        } else {
            [self.view makeToast:NSLocalizedString(@"登出失败,密码已改",nil) duration:2 position:@"center"];
            
        }
    }];
    
    
}

#pragma mark -- getter
//原密码
- (UIView *)yuanMiMaBackV{
    if (!_yuanMiMaBackV) {
        _yuanMiMaBackV = [[UIView alloc]init];
        _yuanMiMaBackV.backgroundColor = [UIColor whiteColor];
    }
    return _yuanMiMaBackV;
}
- (UILabel *)yuanMiMaL{
    if (!_yuanMiMaL) {
        _yuanMiMaL = [[UILabel alloc]init];
        _yuanMiMaL.text = [NSString stringWithFormat:NSLocalizedString(@"当前密码",nil)];
    }
    return _yuanMiMaL;
}
- (UITextField *)textFYuanMiMa{
    if (!_textFYuanMiMa) {
        _textFYuanMiMa = [[UITextField alloc]init];
        _textFYuanMiMa.placeholder = NSLocalizedString(@"请输入当前密码",nil);
        _textFYuanMiMa.tintColor = [DataManager shareDataManager].colorOfMainType;
        _textFYuanMiMa.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textFYuanMiMa;
}

//
- (UIView *)oneBackV{
    if (!_oneBackV) {
        _oneBackV = [[UIView alloc]init];
        _oneBackV.backgroundColor = [UIColor whiteColor];
    }
    return _oneBackV;
    
}
- (UIView *)twoBackV{
    if (!_twoBackV) {
        _twoBackV = [[UIView alloc]init];
        _twoBackV.backgroundColor = [UIColor whiteColor];
    }
    return _twoBackV;
    
}


- (UILabel *)oneL{
    if (!_oneL) {
        _oneL = [[UILabel alloc]init];
        _oneL.text = [NSString stringWithFormat:NSLocalizedString(@"新密码",nil)];
    }
    return _oneL;
}
- (UILabel *)twoL{
    if (!_twoL) {
        _twoL = [[UILabel alloc]init];
        _twoL.text = [NSString stringWithFormat:NSLocalizedString(@"确认密码",nil)];
    }
    return _twoL;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
//        _titleL.text = [NSString stringWithFormat:@"请设置新的登录密码"];
        _titleL.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
        _titleL.frame = CGRectMake(0, 0, Y_mainW, 100);
    }
    return _titleL;
}
- (UILabel *)conternL{
    if (!_conternL) {
        _conternL = [[UILabel alloc]init];
        _conternL.font = [UIFont systemFontOfSize:13];
        _conternL.text = NSLocalizedString(@"密码长度6～12位,必须是字母或数字,区分大小写",nil);
        _conternL.textAlignment = NSTextAlignmentRight;
        _conternL.numberOfLines = 0;
        _conternL.textColor = [UIColor lightGrayColor];
    }
    return _conternL;
}

- (UITextField *)textFone{
    if (!_textFone) {
        _textFone = [[UITextField alloc]init];
        _textFone.placeholder = NSLocalizedString(@"请输入新密码",nil);
        _textFone.tintColor = [DataManager shareDataManager].colorOfMainType;
        _textFone.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textFone;
}
- (UITextField *)textFtwo{
    if (!_textFtwo) {
        _textFtwo = [[UITextField alloc]init];
        _textFtwo.placeholder = NSLocalizedString(@"确认新密码",nil);
        _textFtwo.tintColor = [DataManager shareDataManager].colorOfMainType;
        _textFtwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textFtwo;
}
- (UIButton *)savePassBtn{
    if (!_savePassBtn) {
        _savePassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_savePassBtn addTarget:self action:@selector(savePassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_savePassBtn setTitle:NSLocalizedString(@"确认",nil) forState:UIControlStateNormal];
        [_savePassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_savePassBtn setBackgroundColor:[DataManager shareDataManager].colorOfMainType];
        _savePassBtn.layer.cornerRadius = 5;
    }
    return _savePassBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
