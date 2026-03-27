//
//  FeedbackProblemsViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "FeedbackProblemsViewController.h"

@interface FeedbackProblemsViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIView *textFiedBackV;
@property (nonatomic,strong)UIView *textViewBackV;
@property (nonatomic,strong)UILabel *addressL;

@property (nonatomic,strong)UITextField *textFiedOfContact;
@property (nonatomic,strong)UITextView *textViewOfContent;
@property (nonatomic,strong)UILabel *sigL;
@property (nonatomic,strong)UIButton *saveBtn;

@property (nonatomic,strong)UILabel *kefuPhoneL;

@end

@implementation FeedbackProblemsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"反馈", nil);
    [self initView];
     
}
- (void)initView{
    self.view.backgroundColor = Y_RGB(240, 240, 240);
    [self.view addSubview:self.textViewBackV];
    [self.view addSubview:self.textFiedBackV];
    [self.view addSubview:self.textViewOfContent];
    [self.view addSubview:self.textFiedOfContact];
    [self.view addSubview:self.sigL];
    [self.view addSubview:self.addressL];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.kefuPhoneL];
    [self getYs];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    ///防止拼音输入时，文本直接获取拼音
    
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];//获取高亮部分
    NSLog(@"newText=%@",newText);
    if (textView.text.length == 0) {
        _sigL.hidden = NO;
        return;
    }else{
        _sigL.hidden = YES;
 
        
        //文字排版
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//
//        NSDictionary *attributes = @{
//
//                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
//
//                                     NSParagraphStyleAttributeName:paragraphStyle
//
//                                     };
//

    }
}
#pragma mark -- 

- (void)saveBtnAction:(UIButton *)sender{
    if (_textViewOfContent.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请输入反馈内容",nil) duration:0.3 position:@"center"];
        return;
    }
    if (_textFiedOfContact.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请输入联系方式",nil) duration:0.3 position:@"center"];
        return;
    }
    if (_textFiedOfContact.text.length <= 6) {
        [self.view makeToast:NSLocalizedString(@"请输入正确的联系方式",nil) duration:0.3 position:@"center"];//7位数座机电话号码
        return;
    }
    if (![ToolOfBasic inputShouldLetterOrNum:_textFiedOfContact.text]) {
        [self.view makeToast:NSLocalizedString(@"联系方式不支持汉字",nil) duration:0.3 position:@"center"];
        return;
    }
   
    //反馈
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
     [parm setObject:_textFiedOfContact.text forKey:@"advicePhone"];
    [parm setValue:_textViewOfContent.text forKey:@"adviceContent"];
    [parm setObject:[ShareUser sharedUserInfo].userMode.userNameNoSuffix forKey:@"adviceUser"];//
    [MBProgressHUD showMessage:NSLocalizedString(@"正在上传",nil)];
    [[ToolOfNetWork sharedTools]YrequestURL:S_advice withParams:parm finished:^(id responsObject, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something..
            dispatch_async(dispatch_get_main_queue(),^{
                [MBProgressHUD hideHUD];
            });
        });
        if (_Success) {

            NSString *msg = NSLocalizedString(@"反馈信息提交成功", nil);
            [self.view makeToast:msg duration:2 position:@"center"];
            [self performSelector:@selector(popVc) withObject:nil afterDelay:2];
        }else{
             NSString *msg = NSLocalizedString(@"反馈信息提交失败", nil);
            
            if(msg.length==0){
                if (error.code == -1009) {
                    
                     msg = NSLocalizedString(@"信息提交失败，请查看网络是否可用",nil);
                }else{
                     msg = NSLocalizedString(@"信息提交失败，请稍后再试",nil);
                }
               
            }
            if (_SuccessOrErrCode==500) {
//                msg = NSLocalizedString(@"服务器错误", nil);
                  msg = NSLocalizedString(@"服务器错误，请稍后重试", nil);
               
            }else{
                if (msg.length==0) {
                  msg = NSLocalizedString(@"反馈信息提交失败", nil);
                }
            }
            [self.view makeToast:msg duration:2 position:@"bottom"];
        }
    }];
}
- (void)popVc{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)getYs{
    //
    [_textViewBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view).multipliedBy(0.35);
    }];
    [_textViewOfContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.width.equalTo(self.view.mas_width).offset(-30);
        make.height.equalTo(self.view).multipliedBy(0.35);
    }];
    [_sigL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textViewOfContent.mas_left).offset(10);
        make.top.equalTo(self.textViewOfContent.mas_top);
        make.width.equalTo(self.view.mas_width).offset(-30);
        make.height.offset(35);;
    }];
    
    //
    [_textFiedBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.textViewOfContent.mas_bottom).offset(30);
        make.height.offset(55);
        make.width.equalTo(self.view.mas_width);
       
    }];
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFiedBackV.mas_left).offset(20);
        make.centerY.equalTo(self.textFiedBackV);
        make.width.offset(160);
        make.height.offset(35);
    }];
    [_textFiedOfContact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textFiedBackV.mas_right).offset(-20);
        make.centerY.equalTo(self.textFiedBackV);
        make.width.equalTo(self.view.mas_width).offset(-200);
        make.height.offset(35);
    }];

    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.textFiedOfContact.mas_bottom).offset(30);
        make.width.equalTo(self.view.mas_width).offset(-100);
        make.height.offset(40);
    }];
    //客服电话 0222新增
    [_kefuPhoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.saveBtn.mas_bottom).offset(20);
        make.width.equalTo(self.view.mas_width).offset(-100);
        make.height.offset(40);
        
    }];
}
#pragma mark --

//- (void)getYs{
//    [_textFiedOfContact mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.view.mas_top).offset(100);
//        make.width.equalTo(self.view.mas_width).offset(-30);
//        make.height.offset(35);
//
//    }];
//    [_textViewOfContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.textFiedOfContact.mas_bottom).offset(50);
//        make.width.equalTo(self.view.mas_width).offset(-30);
//        make.height.equalTo(self.view.mas_height).offset(-150-100-35);
//
//    }];
//    [_sigL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.textViewOfContent.mas_left).offset(10);
//        make.top.equalTo(self.textFiedOfContact.mas_bottom).offset(50);
//        make.width.equalTo(self.view.mas_width).offset(-30);
//        make.height.offset(35);;
//    }];
//
//    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.textViewOfContent.mas_bottom).offset(10);
//        make.width.equalTo(self.view.mas_width).offset(-200);
//        make.height.offset(35);
//    }];
//
//
//}
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}
#pragma mark --
- (UITextField *)textFiedOfContact{
    if (!_textFiedOfContact) {
        _textFiedOfContact = [[UITextField alloc]init];
        _textFiedOfContact.placeholder = NSLocalizedString(@"请输入联系方式",nil);
        _textFiedOfContact.borderStyle = UITextBorderStyleNone;
        _textFiedOfContact.font = [UIFont systemFontOfSize:16];
        [_textFiedOfContact setTextAlignment:NSTextAlignmentRight];//水平左对齐
        _textFiedOfContact.delegate = self;
        _textFiedOfContact.returnKeyType = UIReturnKeyDone;//改变为完成键，如果在项目中导入了YYText框架那么原生的就被替换掉了，变为returnKeyType = UIKeyboardTypeTwitter;
        _textFiedOfContact.text = [ShareUser sharedUserInfo].userMode.userNameNoSuffix;
        _textFiedOfContact.tintColor = [DataManager shareDataManager].colorOfMainType;
    }
    return _textFiedOfContact;
}
- (UITextView *)textViewOfContent{
    if (!_textViewOfContent) {
        _textViewOfContent = [[UITextView alloc]init];
        _textViewOfContent.delegate = self;
        _textViewOfContent.font = [UIFont systemFontOfSize:16];
        _textViewOfContent.tintColor = [DataManager shareDataManager].colorOfMainType;
//        _textViewOfContent.returnKeyType = UIReturnKeyDone;//改变为完成键，如果在项目中导入了YYText框架那么原生的就被替换掉了，变为returnKeyType = UIKeyboardTypeTwitter;

            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            _textViewOfContent.attributedText = [[NSAttributedString alloc] initWithString:_textViewOfContent.text attributes:attributes];
    
    }
    return _textViewOfContent;
}
- (UILabel *)sigL{
    if (!_sigL) {
        _sigL = [[UILabel alloc]init];
        _sigL.textColor = [UIColor lightGrayColor];
        _sigL.font = [UIFont systemFontOfSize:16];
        _sigL.text = NSLocalizedString(@"请输入您的反馈详情",nil);
    }
    return _sigL;
}
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundColor:[DataManager shareDataManager].colorOfMainType];
       
        [_saveBtn setTitle:NSLocalizedString(@"提交",nil) forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.layer.cornerRadius = 5;
    }
    return _saveBtn;
}
- (UIView *)textFiedBackV{
    if (!_textFiedBackV) {
        _textFiedBackV = [[UIView alloc]init];
        _textFiedBackV.backgroundColor = [UIColor whiteColor];
    }
    return _textFiedBackV;
}
- (UIView *)textViewBackV{
    if (!_textViewBackV) {
        _textViewBackV = [[UIView alloc]init];
        _textViewBackV.backgroundColor = [UIColor whiteColor];
    }
    return _textViewBackV;
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.text = NSLocalizedString(@"联系方式", nil);
        _addressL.font = [UIFont systemFontOfSize:16];
    }
    return _addressL;
}

#pragma mark -- 客服电话
- (UILabel *)kefuPhoneL{
    if (!_kefuPhoneL) {
        _kefuPhoneL = [[UILabel alloc]init];
        _kefuPhoneL.text = NSLocalizedString(@"客服电话:400 1280 466", nil);
        _kefuPhoneL.font = [UIFont systemFontOfSize:16];
        _kefuPhoneL.textAlignment = NSTextAlignmentCenter;
    }
    
    return _kefuPhoneL;
}
@end
