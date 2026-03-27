//
//  RegistViewLast.m
//  Community
//
//  Created by 余莹 on 2021/11/30.
//

#import "RegistViewLast.h"
static NSString *NomalText = @"已阅读并同意以下协议：";
static NSString *UserPolicyTitleText = @"《未来物服用户协议》、";
static NSString *PrivacyPolicyTitleText = @"《隐私协议》";
static NSString *UserPolicyKey = @"App_UserPolicy://";
static NSString *PrivacyPolicyKey = @"App_PrivacyPolicy://";


@interface RegistViewLast() <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


@end

@implementation RegistViewLast

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBackGroundView];
        [self.topBackGroundView addSubview:self.returnBtn];
        [self.topBackGroundView addSubview:self.topTitleLabel];
        [self.topBackGroundView addSubview:self.topDetailTitleLabel];
        //
        [self addSubview:self.bottomBackView];
        [self.bottomBackView addSubview:self.loginGoVcBtn];
        [self.bottomBackView addSubview:self.parvacyLabel];
        [self.bottomBackView addSubview:self.parvacyBtn];
        //
        [self addSubview:self.tableView];//        [footer == self.registOkBtn];

  
        
        [self setUI];
        [self privacyPolicyChangeUI];
  
        
    }
    return self;
}

//0428
- (void)privacyPolicyChangeUI{
    [self.parvacyLabel.superview addSubview:self.agreeBtn];
    [self.parvacyLabel.superview addSubview:self.privacypolicyTextView];
    WEAKSELF
    [_privacypolicyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.parvacyLabel);
        make.top.equalTo(weakSelf.parvacyLabel).offset(-5);
        make.bottom.equalTo(weakSelf.parvacyLabel).offset(5);
    }];
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(weakSelf.parvacyLabel);
        make.right.equalTo(weakSelf.parvacyLabel.mas_left).offset(0);
    }];
    self.parvacyBtn.hidden = YES;
    self.parvacyLabel.text = @"";
    self.privacypolicyTextView.text = @"";
    
    
    NSString *showStr = [NSString stringWithFormat:@"%@%@%@",NomalText,UserPolicyTitleText,PrivacyPolicyTitleText];
    self.privacypolicyTextView.attributedText = [self getThisPrivacyPolicyTextStr:showStr];
    if (  [ShareUserInfo sharedUserInfo].isHavaChooseAgreeBtn ) {//登录过 判断用的数据
        self.agreeBtn.selected = YES;
    }else{//无数据
        self.agreeBtn.selected = NO;
    }
}


//---隐私UI
- (UITextView *)privacypolicyTextView{
    if (!_privacypolicyTextView) {
        _privacypolicyTextView = [[UITextView alloc]init];
        _privacypolicyTextView.backgroundColor = [UIColor clearColor];
        _privacypolicyTextView.editable =  NO;
        _privacypolicyTextView.scrollEnabled = NO;
        _privacypolicyTextView.delegate = self; // 指定代理处理点击方法
    }
    return _privacypolicyTextView;
}
- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"weigouxuan_icon"] selectedImg:[UIImage imageNamed:@"wlw_gouxuan"]];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
- (void)agreeBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

- (NSMutableAttributedString *)getThisPrivacyPolicyTextStr:(NSString *)showAllStr{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showAllStr];
    NSInteger allStrIndexNum = showAllStr.length;
    NSRange nomalRange = [showAllStr rangeOfString:NomalText];
    NSRange userPolicyRange = [showAllStr rangeOfString:UserPolicyTitleText];
    NSRange privacyPolicyRange = [showAllStr rangeOfString:PrivacyPolicyTitleText];
 
    //字体大小
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(0, allStrIndexNum)];
    //字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0xFFFFFF) range:nomalRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:userPolicyRange];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:Y_ColorWith16FromRGB(0x2672F9) range:privacyPolicyRange];
    //link
    [attributedStr addAttribute:NSLinkAttributeName value:UserPolicyKey range:userPolicyRange];
    [attributedStr addAttribute:NSLinkAttributeName value:PrivacyPolicyKey range:privacyPolicyRange];
    return attributedStr;
}

//从登录页去协议页面
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if (URL.absoluteString == UserPolicyKey) {
        DLog(@"去用户协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_User;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
   
    }else if (URL.absoluteString == PrivacyPolicyKey){
        DLog(@"去隐私协议");
        PrivacyAgreementVCLate *privacyVc = [[PrivacyAgreementVCLate alloc]init];
        privacyVc.selfAgreementsType = Agreements_Type_Privacy;
        privacyVc.isLoginVcPushInToBool = YES;
        if (isNotNil(self.gotoPrivacyAgreementVcBlock)) {
            self.gotoPrivacyAgreementVcBlock(privacyVc);
            return NO;
        }
    }else{
        return YES;
    }
    return YES;
}
 

 
- (void)setUI{
    [_topBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.superview.mas_top).offset(status_height);
        make.width.equalTo(_topBackGroundView.superview.mas_width).offset(-50);
        make.centerX.equalTo(_topBackGroundView.superview.mas_centerX);
        make.height.offset(200);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_bottom).offset(0);
        make.left.right.equalTo(_tableView.superview);
        make.height.offset(Height_Row*4+Height_FooterViewRegistOkBtnView+35);//35的tip
    }];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.right.equalTo(_bottomBackView.superview);
        make.bottom.equalTo(_bottomBackView.superview);
    }];
    //
    [self topUI];
    [self centerUI];
    [self bottomUI];
}
- (void)topUI{
    //top
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackGroundView.mas_top).offset(40);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.width.offset(40);
        make.height.offset(24);
    }];
    [_topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_returnBtn.mas_bottom).offset(30);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.right.equalTo(_topBackGroundView.mas_right);
        make.height.offset(30);
    }];
    [_topDetailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(_topBackGroundView.mas_left);
        make.right.equalTo(_topBackGroundView.mas_right);
        make.height.offset(12);
    }];
}
- (void)centerUI{
    //_tableView
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewRegistOkFooterView addSubview:self.registOkBtn];
    [_registOkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_registOkBtn.superview);
        make.centerX.equalTo(_registOkBtn.superview);
        make.width.offset(Screen_W*0.8);//= LoginViewBtnGradientColor(Screen_W*0.8, 50);
        make.height.offset(50);
    }];
    self.tableView.tableFooterView = self.tableViewRegistOkFooterView;
}
- (void)bottomUI{
    [_loginGoVcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.width.offset(100);
        make.height.offset(20);
        make.centerX.equalTo(_loginGoVcBtn.superview);
    }];
   [_parvacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(_parvacyLabel.superview.mas_bottom).offset(-20);
       make.centerX.equalTo(_parvacyLabel.superview.mas_centerX);
       make.height.offset(35);
       make.width.equalTo(_parvacyLabel.superview.mas_width).multipliedBy(0.8);
   }];
   [_parvacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(_parvacyLabel.superview.mas_bottom).offset(-20);
       make.centerX.equalTo(_parvacyLabel.superview.mas_centerX);
       make.height.offset(35);
       make.width.equalTo(_parvacyLabel.superview.mas_width).multipliedBy(0.8);
   }];
}


#pragma mark ===== getter
#pragma mark = top
- (UIView *)topBackGroundView{
    if (!_topBackGroundView) {
        _topBackGroundView = [[UIView alloc]init];
    }
    return _topBackGroundView;
}

- (UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"login_close_slices"] forState:UIControlStateNormal];
        _returnBtn.tag = REMOVE_SELF_BTN_TAG;
        [_returnBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}
- (UILabel *)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc]init];
        _topTitleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:32];
        _topTitleLabel.text = @"用户注册";
    }
    return _topTitleLabel;
}
- (UILabel *)topDetailTitleLabel{
    if (!_topDetailTitleLabel) {
        _topDetailTitleLabel = [[UILabel alloc]init];
        _topDetailTitleLabel.textColor = [ThemeManager shareManager].loginModuleDetailTextColorIsAlphaEighty;
        _topDetailTitleLabel.font = [UIFont systemFontOfSize:13];
        _topDetailTitleLabel.text = @"未注册用户将自动创建统一账号";
    }
    return _topDetailTitleLabel;
}

#pragma mark = bottom
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
    }
    return _bottomBackView;
}

- (UIButton *)loginGoVcBtn{
    if (!_loginGoVcBtn) {
        _loginGoVcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginGoVcBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginGoVcBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        [_loginGoVcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _loginGoVcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _loginGoVcBtn.tag = REGIST_GOLOGINVC_BTN_TAG;
     }
    return _loginGoVcBtn;
}
- (UILabel *)parvacyLabel{
    if (!_parvacyLabel) {
        _parvacyLabel = [[UILabel alloc]init];
        _parvacyLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _parvacyLabel.font = [UIFont systemFontOfSize:11];
//        _parvacyLabel.text = @"登录/注册即为已经阅读并同意《隐私政策》";
        _parvacyLabel.textAlignment = NSTextAlignmentCenter;
        _parvacyLabel.numberOfLines = 2;
    }
    return _parvacyLabel;
}
- (UIButton *)parvacyBtn{
    if (!_parvacyBtn) {
        _parvacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_parvacyBtn setTitle:@"登录/注册即为已经阅读并同意《隐私政策》" forState:UIControlStateNormal];
        [_parvacyBtn setTitleColor:[ThemeManager shareManager].loginModuleTextColor forState:UIControlStateNormal];
        _parvacyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _parvacyBtn.titleLabel.numberOfLines = 2;
        _parvacyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _parvacyBtn.tag = REGIST_PRARVACY_BTN_TAG;
        [_parvacyBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _parvacyBtn;
}
#pragma mark = tabview footerBtn== registBtnOk and back
- (UIView *)tableViewRegistOkFooterView{
    if (!_tableViewRegistOkFooterView) {
        _tableViewRegistOkFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Height_FooterViewRegistOkBtnView)];
    }
    return _tableViewRegistOkFooterView;
}
- (UIButton *)registOkBtn{
    if (!_registOkBtn) {
        _registOkBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _registOkBtn.titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _registOkBtn.layer.cornerRadius = 25;
        _registOkBtn.layer.masksToBounds = YES;
        [_registOkBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _registOkBtn.tag = REGIST_OK_BTN_TAG;
        [_registOkBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _registOkBtn.backgroundColor = LoginViewBtnGradientColor(Screen_W*0.8, 50);
    }
    return _registOkBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#pragma mark =====  tableView  D
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;//20220415 增加一个秘码格式行
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [tableView numberOfRowsInSection:0]-1 ) {
        return 35.0;
    }else{
     
        return Height_Row;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case Row_Num_Phone:
        {
            RegistViewLastSubLeftIsPhoneTextBeginTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_Identifier];
            if (!cell) {
                cell = [[RegistViewLastSubLeftIsPhoneTextBeginTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_Identifier];
            }
            cell.textF.tag = Tag_TextFiled_Base + indexPath.row;
            cell.textF.text = self.phoneStr;
            cell.textF.delegate = self;
            [cell setTextPStr:self.textFiledPStrArr[indexPath.row]];
            return cell;
        }
            break;
        case Row_Num_Code:
        {
            RegistViewLastSubHaveSendCodeBtnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubHaveSendCodeBtnTableViewCell_Identifier];
            if (!cell) {
                cell = [[RegistViewLastSubHaveSendCodeBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubHaveSendCodeBtnTableViewCell_Identifier];
            }
            cell.textF.tag = Tag_TextFiled_Base + indexPath.row;
            cell.textF.text = self.codeStr;
            cell.textF.delegate = self;
            [cell.rightSendCodeBtn addTarget:self action:@selector(selfSubBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell setTextPStr:self.textFiledPStrArr[indexPath.row]];
            return cell;
        }
            break;
        case 4 ://([tableView numberOfRowsInSection:0]-1):
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nomalCellPassWordTip"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nomalCellPassWordTip"];
                cell.textLabel.text = @"6-12个字符,至少包含大写字母或小写字母或数字两种!";
                cell.textLabel.numberOfLines = 2;
                cell.textLabel.textColor = Y_ColorWith16FromRGB(0xc5c9d4);
                cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                cell.indentationLevel = 1;
                cell.indentationWidth = 16;
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
            }

            return cell;
        }
            break;
            
        default:
        {
            RegistViewLastSubNomalTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubNomalTableViewCell_Identifier];
            if (!cell) {
                cell = [[RegistViewLastSubNomalTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubNomalTableViewCell_Identifier];
            }
            cell.textF.tag = Tag_TextFiled_Base + indexPath.row;
            cell.textF.delegate = self;
            if (indexPath.row==Row_Num_PasswordOne) {
                cell.textF.text = self.passWordOneStr;
            }else{
                cell.textF.text = self.passWordTwoStr;
            }
            [cell setTextPStr:self.textFiledPStrArr[indexPath.row]];
            return cell;
        }
            break;
    }
}

- (NSMutableArray *)textFiledPStrArr{
    if (!_textFiledPStrArr) {
        _textFiledPStrArr = [NSMutableArray arrayWithObjects:@"请输入手机号码",@"请输入验证码",@"请输入登录密码",@"请再次输入密码",@"", nil];//占位
    }
    return _textFiledPStrArr;
}

#pragma mark ===== action
 
 
- (void)selfSubBtnTouchAction:(UIButton *)sender{
    /**
     //注册
     #define REGIST_VerificationCode_BTN_TAG 210
     #define REGIST_OK_BTN_TAG 211
     #define REGIST_GOLOGINVC_BTN_TAG 212
     #define REGIST_PRARVACY_BTN_TAG 213
     */
    if (sender.tag == REGIST_OK_BTN_TAG) {
        if (self.phoneStr.length <= 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (self.codeStr.length <= 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_code_number)
            return;
        }
        if (self.passWordOneStr.length <= 0 || self.passWordTwoStr.length <= 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_password_number)
            return;
        }
        if (![self.passWordOneStr isEqualToString: self.passWordTwoStr]) {
            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_IS_DIFFERENT_STR)
            return;
        }
        //
//        if (![ValidateUtil isMachPasswordJudgeBeforeSendingAgainWithString:self.passWordOneStr]) {
//            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_FORMAT_STR)
//            return;
//        }
//        if (![ValidateUtil isMachPasswordJudgeBeforeSendingAgainWithString:self.passWordTwoStr]) {
//            Y_SVP_SHOW_ERR_MES(PASSWORD_ERR_FORMAT_STR)
//            return;
//        }
        //
        if (_delegate && [_delegate respondsToSelector:@selector(registViewViewSubBtnAction:)]) {
            [_delegate registViewViewSubBtnAction:sender];
        }
    }else if(sender.tag == REGIST_GOLOGINVC_BTN_TAG){
        
        if (_delegate && [_delegate respondsToSelector:@selector(registViewViewSubBtnAction:)]) {
            [_delegate registViewViewSubBtnAction:sender];
        }
    }else if(sender.tag == REGIST_VerificationCode_BTN_TAG){
        if (self.phoneStr.length <= 0) {
            Y_SVP_SHOW_ERR_MES(Please_enter_phone_number)
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(registViewViewSubBtnAction:)]) {
            [_delegate registViewViewSubBtnAction:sender];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(registViewViewSubBtnAction:)]) {
            [_delegate registViewViewSubBtnAction:sender];
        }
    }
    
}

  
#pragma mark === str
- (NSString*)phoneStr{
    if (!_phoneStr) {
        _phoneStr = @"";
    }
    return _phoneStr;
}
- (NSString *)codeStr{
    if (!_codeStr) {
        _codeStr = @"";
    }
    return _codeStr;
}
- (NSString *)passWordOneStr{
    if (!_passWordOneStr) {
        _passWordOneStr = @"";
    }
    return _passWordOneStr;
}

- (NSString *)passWordTwoStr{
    if (!_passWordTwoStr) {
        _passWordTwoStr = @"";
    }
    return _passWordTwoStr;
}


#pragma mark ==

#pragma mark === UITextFieldDelegate
 
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self getTextSave:textField];

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    [self getTextSave:textField];
}

- (void)getTextSave:(UITextField *)textField{
    NSInteger tagIndex = textField.tag-Tag_TextFiled_Base;
    switch (tagIndex) {
        case Row_Num_Phone:
        {
            self.phoneStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
        }
            break;
        case Row_Num_Code:
        {
            self.codeStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
        }
            break;
        case Row_Num_PasswordOne:
        {
            self.passWordOneStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
        }
            break;
        case Row_Num_PasswordTwo:
        {
            self.passWordTwoStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
        }
            break;
            
        default:
            break;
    }
    
}
@end
