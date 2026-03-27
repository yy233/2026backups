//
//  CodeSendOkViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "CodeSendOkViewController.h"
static int timeValueOfLabel = 60;

@interface CodeSendOkViewController ()

@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *codeOkBtn;

@property (weak, nonatomic) IBOutlet UIButton *requestAgainBtn;

//0104
@property (weak, nonatomic) IBOutlet UILabel *oneCantGetCodeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoCantGetCodeTextLabel;

@end

@implementation CodeSendOkViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.phoneTextF.enabled = NO;
    _phoneTextF.text = _strOfPhone;
    _timeLable.text = @"";
    
    if (_isForgetPass) {
        self.title = NSLocalizedString(@"忘记密码",nil);
    }else{
        self.title = NSLocalizedString(@"注册",nil);
    }
 
     [self timerChange];
     [self viewOfCantGetCode];
}
- (void)viewOfCantGetCode{
    if (![_countryNum isEqualToString:@"86"]) {
        _oneCantGetCodeTextLabel.hidden = NO;
        _twoCantGetCodeTextLabel.hidden = NO;
        
          NSString * oneLstr = @"由于你的手机号码,不是中国大陆地区的号码,暂时无法接收到短信验证码";
          NSString * twoLstr = @"请在验证码框输入'0000'";
        if (self.title.length>4) {//英文 注册+忘记密码都要匹配
            oneLstr = @"Due to your mobile number, not the number in mainland China, you can't receive SMS verification code temporarily.";
            twoLstr = @"Please enter '0000' in the verification code box";
        }else{
            oneLstr = @"由于你的手机号码,不是中国大陆地区的号码,暂时无法接收到短信验证码";
            twoLstr = @"请在验证码框输入'0000'";
        }
        _oneCantGetCodeTextLabel.text = oneLstr;
        _twoCantGetCodeTextLabel.text = twoLstr;
    }else{
        _oneCantGetCodeTextLabel.hidden = YES;
        _twoCantGetCodeTextLabel.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[ToolOfNetWork sharedTools]endXml];//防止xml格式
    [self initSelfView];
    [self initTimerAndLabelAndAgainBtn];
    
}
- (void)initSelfView{
    _codeOkBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _codeOkBtn.layer.cornerRadius = 5;
    //
    _codeTextField.tintColor = [DataManager shareDataManager].colorOfMainType;
    _phoneTextF.tintColor = [DataManager shareDataManager].colorOfMainType;
    
    //
    _requestAgainBtn.backgroundColor = [DataManager shareDataManager].colorOfMainType;
    _requestAgainBtn.layer.cornerRadius = 5;
    _requestAgainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_requestAgainBtn setTitle:NSLocalizedString(@"再次发送验证码",nil) forState:UIControlStateNormal];
    [_requestAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
- (void)initTimerAndLabelAndAgainBtn{
    timeValueOfLabel = 120;
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
    _requestAgainBtn.hidden = YES;
}

- (void)showAgainBtn{
    _requestAgainBtn.hidden = NO;
     [_requestAgainBtn setTitle:NSLocalizedString(@"再次发送验证码",nil) forState:UIControlStateNormal];
}
//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
    _timeLable.text = @"";
    _requestAgainBtn.hidden = YES;
}
#pragma mark -- ok 提交验证码
- (IBAction)sendBtnAction:(UIButton *)sender {
    
    if ([_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self.view makeToast:NSLocalizedString(@"请输入验证码", nil) duration:2 position:@"center"];
    }else{

        [self sendCodeDo];
       
    }
}


#pragma mark -- label
- (void)timerChange{
  _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(chagerLable) userInfo:nil repeats:YES];

}
- (void)chagerLable{

    if (timeValueOfLabel == 0) {
        _timeLable.text = @"";
        [_timer setFireDate:[NSDate distantFuture]];
        [self showAgainBtn];
    }else{
//        NSString *oneWite = @"接收短信大约还需";
         NSString *oneWite = @"重新发送";
        NSString *twoWite = @"秒";
        _timeLable.text = [NSString stringWithFormat:@"%@%d%@",oneWite,timeValueOfLabel,twoWite];
        if (self.title.length>4) {//英文
            NSString *oneWite = @"It will take ";
            NSString *twoWite = @" seconds to resend";
            _timeLable.text = [NSString stringWithFormat:@"%@%d%@",oneWite,timeValueOfLabel,twoWite];
            _timeLable.numberOfLines = 0;
        }
        timeValueOfLabel -=1;
    }
    
    
}
#pragma mark -- 再次请求验证码

- (IBAction)requestAgainBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    //请求验证码
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[_phoneTextF.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"userPhone",nil];
    
    //YrequestURL YrequestGetURL
    [[ToolOfNetWork sharedTools]YrequestGetURL:S_smsSend withParams:parm finished:^(id responsObject, NSError *error) {
        
        
        if (_Success) {
            //label和btn的初始状态
            [self initTimerAndLabelAndAgainBtn];
        }else{
            //失败 code非两百
//            NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];msg不用换成code取值国际化
            
            NSString *msg =@"";
            if (error.code == -1009) {
                msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil);
            }else if(error.code==160038){
                msg = NSLocalizedString(@"获取验证码过于频繁，请稍后重试", nil);
            }else if(error.code==160039 || error.code==160040  || error.code==160041 ){
                msg = NSLocalizedString(@"获取验证码过于频繁，请明天重试", nil);
            }else{
                msg = NSLocalizedString(@"获取验证码失败，请稍后重试", nil);
            }
                
            if (_SuccessOrErrCode == 400) {
                msg = NSLocalizedString(@"手机号为空", nil);
            }
            [self.view makeToast:msg duration:3 position:@"center"];
            
        }
        
    }];
   
    
}
#pragma mark -- ok提交验证码

- (void)sendCodeDo{
    [self.view endEditing:YES];
    NSString *url = S_smsConfirm; //提交验证码
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]initWithObjectsAndKeys: _strOfPhone,@"userPhone",[_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],@"smsCode",_countryNum,@"userArea",nil];
    NSLog(@"提交验证码parm = %@",parm);//userArea 0104新增
    [[ToolOfNetWork sharedTools]YrequestGetURL:url withParams:parm finished:^(id responsObject, NSError *error) {
         
        
        if (_Success) {
           [self sendCodeAction];
        }else{
            
            //失败
//            NSString *msg = [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]];
            NSString *msg =@"";
            if(msg.length==0){
                if (error.code == -1009) {
                    msg = NSLocalizedString(@"网络请求失败，请查看网络是否可用", nil) ;
                }else{
                    msg = NSLocalizedString(@"网络请求失败，请稍后重试", nil) ;
                }
                
            }
            
            if (_SuccessOrErrCode == 400) {
                msg = NSLocalizedString(@"手机号或者验证码不能为空", nil);
            }else if (_SuccessOrErrCode == 401) {
                msg = NSLocalizedString(@"您输入的验证码有误，请重新输入", nil);
            }else if (_SuccessOrErrCode == 402) {
                msg = NSLocalizedString(@"验证码已失效，请重新获取", nil);
            }
            [self.view makeToast:msg duration:2 position:@"center"];
            
        }
        
    }];
}

- (void)sendCodeAction{
        _timeLable.text = @"";//清空短信来信时间xx秒
        SetPassWordViewController *setPassWordVc = Y_storyBoard_id(@"SetPassWordViewController");
        self.title = @"";
    setPassWordVc.strOfphone = _strOfPhone;
        setPassWordVc.isForgetPass = self.isForgetPass;
        [self.navigationController pushViewController:setPassWordVc animated:YES];
       
  
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
