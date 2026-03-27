//
//  PassWordViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/26.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PassWordViewController.h"
#import "PrivacyPolicyViewController.h"
#import "XWCountryCodeController.h"

@interface PassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIView *privacyPolicyView;
@property (weak, nonatomic) IBOutlet UIButton *txtBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

//0104
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIButton *countryselectBtn;
@property (nonatomic,strong)NSString *countryNumstr;

@end

@implementation PassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_isForgetPassWord) {
        self.title = NSLocalizedString(@"忘记密码", nil);
        _privacyPolicyView.hidden = YES;
    }else{
        self.title = NSLocalizedString(@"注册账号",nil);
        _privacyPolicyView.hidden = NO;
        _agreeBtn.layer.borderColor = [UIColor blackColor].CGColor;
//        _agreeBtn.layer.borderWidth = 0.6;
        _agreeBtn.layer.borderWidth = 1;
    }
   
      self.navigationController.navigationBarHidden = NO;
    [self initCountryView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    _phoneTextField.tintColor = [DataManager shareDataManager].colorOfMainType;
    _sendBtn.layer.cornerRadius = 5;
    _sendBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    //
    if (_isForgetPassWord) {
        self.title = NSLocalizedString(@"忘记密码", nil);
        _privacyPolicyView.hidden = YES;
    }else{
         self.title = NSLocalizedString(@"注册账号",nil);
        _privacyPolicyView.hidden = NO;
        _agreeBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _agreeBtn.layer.borderWidth = 1;
        
        
//        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"用户许可使用协议和隐私政策"]];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _txtBtn.titleLabel.text]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [_txtBtn setAttributedTitle:content  forState:UIControlStateNormal];
        [_txtBtn setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
        [_txtBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        _txtBtn.titleLabel.numberOfLines = 2;//国际化显示不完全问题
        //
        UIImage *agreeBtnSelectedBackImg = [UIImage imageNamed:@"蓝色勾"];
        agreeBtnSelectedBackImg =  [agreeBtnSelectedBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_agreeBtn setBackgroundImage:agreeBtnSelectedBackImg forState:UIControlStateSelected];
        [_agreeBtn setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
        [_agreeBtn setTintColor:[DataManager shareDataManager].colorOfMainType];
        
    }
    
}

- (void)initCountryView{
    //0104 初始化
    if (self.title.length>4) {
        [self setLabelTextOfCountry:@"China" num:@"86"];
    }else{
        [self setLabelTextOfCountry:@"中国" num:@"86"];
    }
    
    [_countryselectBtn addTarget:self action:@selector(countryselectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)countryselectBtnAction:(UIButton *)sender{
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    //    countryCodeVC.deleagete = self;
    
    __weak __typeof(self)weakSelf = self;
    countryCodeVC.returnCountryCodeBlock = ^(NSString *countryName, NSString *code) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@", [NSString stringWithFormat:@"国家: %@  代码: %@",countryName,code]);
        [strongSelf setLabelTextOfCountry:countryName num:code];
    };
    
    [self.view endEditing:YES];
    [self.navigationController pushViewController:countryCodeVC animated:YES];
    
}
- (void)setLabelTextOfCountry:(NSString *)country
                          num:(NSString *)num{
     NSString *strOne = @"Country/Region ";
    if (self.title.length>4) {
        strOne = @"Country/Region ";
    }else{
        strOne = @"国家／地区 ";
    }
     _countryNumstr = num;
    NSString *strOfAllText = [NSString stringWithFormat:@"%@%@ (+%@)",strOne,country,num];
    NSMutableAttributedString* mstrOfAllText = [[NSMutableAttributedString alloc]initWithString:strOfAllText];
    UIColor *mainColor = [DataManager shareDataManager].colorOfMainType;
    [mstrOfAllText setAttributes:@{NSForegroundColorAttributeName:mainColor} range:NSMakeRange(strOne.length, strOfAllText.length-strOne.length)];
    _countryLabel.attributedText = mstrOfAllText;
}
#pragma mark --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)agreeBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
   
}
- (IBAction)txtBtnAction:(UIButton *)sender {
    //用户隐私政策跳转
    PrivacyPolicyViewController *privacyPolicyVc = [[PrivacyPolicyViewController alloc]init];
    [self.view endEditing:YES];
    [self.navigationController pushViewController:privacyPolicyVc animated:YES];
}
- (IBAction)okBtnAcion:(UIButton *)sender {
    if (_phoneTextField.text.length == 0) {
        NSString * strMsgOne = NSLocalizedString(@"请输入手机号", nil);
        [self.view makeToast:strMsgOne duration:2 position:@"center"];
        return;
    }
    //去空格
    if (![ToolOfBasic deptNumInputShouldNumber:[_phoneTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] || _phoneTextField.text.length>=20 || _phoneTextField.text.length<=6) {
        
        NSString * strMsgOne = NSLocalizedString(@"请输入有效的手机号", nil);
        [self.view makeToast:strMsgOne duration:2 position:@"center"];
        return;
    }
    
    if((_agreeBtn.selected == NO) && (_isForgetPassWord == NO)){//注册界面的隐私同意按钮
          NSString * strMsgTwo = NSLocalizedString(@"使用协议和隐私政策未同意", nil);
        [self.view makeToast:strMsgTwo duration:2 position:@"center"];
        return;
    }
   //通过验证
        [self.view endEditing:YES];
        [self showPassWordActionn:sender];
    
    
}
//普通的弹出框
- (void)showPassWordActionn:(UIButton *)sender{
    
     NSString *strMessageOne = NSLocalizedString(@"我们将发送验证码到这个手机号码", nil);
    NSString * strMessage = [NSString stringWithFormat:@"%@：%@",strMessageOne,_phoneTextField.text];
    //非中国大陆0104
    if (![_countryNumstr isEqualToString:@"86"]) {
        strMessage = _phoneTextField.text;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"确认手机号码", nil) message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendMe];
    }];
    [alert addAction:noAction];
    [alert addAction:okAction];
   
    alert.view.layer.cornerRadius = 10;
    alert.view.backgroundColor = [UIColor whiteColor];
    alert.view.tintColor = [DataManager shareDataManager].colorOfMainType;
    [self presentViewController:alert animated:YES completion:nil];
    
}
//白色的按钮黑色的文字
- (void)showPassWordAction:(UIButton *)sender{
    
    
    //初始化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //标题
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"确认手机号码"];
//    [title addAttribute:NSForegroundColorAttributeName value:_searchColor range:NSMakeRange(0, 2)];
    [alert setValue:title forKey:@"attributedTitle"];
    //内容
    
    NSString * strMessage = [NSString stringWithFormat:@"我们将发送验证码到这个手机号码：%@",_phoneTextField.text];
    NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:strMessage];
    [alert setValue:message forKey:@"attributedMessage"];
    
    //_UIAlertControllerTextFieldViewController
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.textAlignment = NSTextAlignmentCenter;
//        textField.placeholder = @"审核备注";
//        textField.tintColor = _searchColor;
//        [textField addTarget:self action:@selector(shenheActionEditingChanged:) forControlEvents:UIControlEventEditingChanged];
//        
//    }];
    
    //BTN
  
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendMe];
    }];
    
    [noAction setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
    [okAction setValue:[UIColor darkGrayColor] forKey:@"titleTextColor"];
    
    
//    [alert addAction:refuseAction];
   
    [alert addAction:noAction];
    [alert addAction:okAction];
    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.permittedArrowDirections  =UIPopoverArrowDirectionDown;
    //页面设置
//    alert.view.layer.borderWidth = 3;
//    alert.view.layer.borderColor= [_searchColor CGColor];
    alert.view.layer.cornerRadius = 10;
    alert.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)sendMe{
    //非中国大陆0104
    if (![_countryNumstr isEqualToString:@"86"]) {
       [self successSend];
        return;
    }
    //大陆
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[_phoneTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"userPhone",nil];
    //YrequestURL YrequestGetURL
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_smsSend withParams:parm finished:^(id responsObject, NSError *error) {
       
        if (_Success) {
           [self successSend];
        }else{
            NSString *msg =@"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg =  NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil) ;
                }else if(error.code==160038){
                    msg = NSLocalizedString(@"获取验证码过于频繁，请稍后重试", nil);
                }else if(error.code==160039 || error.code==160040  || error.code==160041 ){
                    msg = NSLocalizedString(@"获取验证码过于频繁，请明天重试", nil);
                }else{
                    msg =  NSLocalizedString(@"获取验证码失败，请稍后重试", nil);
                }

            }
            if (_SuccessOrErrCode == 400) {
                msg = NSLocalizedString(@"手机号为空", nil);
            }
            if(msg.length==0){
                  msg =  NSLocalizedString(@"获取验证码失败，请稍后重试", nil);
            }
            [self.view makeToast:msg duration:3 position:@"bottom"];
           
        }
        
    }];
}


- (void)successSend{
    
    NSString *phoneStr = [NSString stringWithFormat:@"%@",[_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [ShareUser sharedUserInfo].accountNum = phoneStr;
    
    CodeSendOkViewController *codeVc = Y_storyBoard_id(@"CodeSendOkViewController");
 
    self.title = @"";
    codeVc.isForgetPass = self.isForgetPassWord;
    codeVc.strOfPhone = phoneStr;
    codeVc.countryNum = _countryNumstr;
    [self.view endEditing:YES];
    [self.navigationController pushViewController:codeVc animated:YES];
}

#pragma mark --
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
@end
