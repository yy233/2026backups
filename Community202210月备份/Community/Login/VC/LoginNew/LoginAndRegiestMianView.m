//
//  LoginAndRegiestMianView.m
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import "LoginAndRegiestMianView.h"
#import "RegistViewLastSubNomalTableViewCell.h"

static NSString *RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_I = @"RegistViewLastSubLeftIsPhoneTextBeginTableViewCell";
static NSString *RegistViewLastSubHaveSendCodeBtnTableViewCell_I = @"RegistViewLastSubHaveSendCodeBtnTableViewCell";
static NSString *RegistViewLastSubNomalTableViewCell_I = @"RegistViewLastSubNomalTableViewCell";
static NSString *RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell_I = @"RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell";
#define Row_TextCell_Height         (70)
#define Row_Num_Phone               (0)
#define Row_Num_PasswordOrCode      (1)

@implementation LoginAndRegiestMianView
#pragma mark === 清空
- (void)cleanAccountAndPasswordTextFiled{
     self.phoneStr = @"";
     self.passWordOneStr = @"";
    [self.tableView reloadData];
}

- (void)setThirdLoginViewIsShow:(BOOL)isShowThirdLoginView{
    if (isShowThirdLoginView) {
        self.thirdLoginView.hidden = NO;
    }else{
        self.thirdLoginView.hidden = YES;
    }
}

- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type{
    self.mainShowType = type;
    [self thisViewSubTypeInfo];
    [self.tableView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainBkImgView];
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self addSubview:self.thirdLoginView];
        [self addSubview:self.tableView];
        [self setThisMainUI];
        [self thisViewSubTypeInfo];
        [self otherAction];
        self.thirdLoginView.hidden = YES;
        [self setTextLabel];
    }
    return self;
}

- (void)setTextLabel{//旧登录信息初始填充
    [[ShareUserInfo sharedUserInfo] getDefaultsLoginUserInfo];
    if ([ShareUserInfo sharedUserInfo].account.length != 0) {
        self.phoneStr = [ShareUserInfo sharedUserInfo].account;
    }
    if ([ShareUserInfo sharedUserInfo].password.length != 0) {
        self.passWordOneStr = [ShareUserInfo sharedUserInfo].password;
    }//没有数据
    
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"account"])) {
        self.phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"password"])) {
        self.passWordOneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    [self.tableView reloadData];
}

#pragma mark == initInfo
- (void)setThisMainUI{
    CGFloat thirdAll_H = KIndicatorHeight > 1 ? (180) : (90);
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_topView.superview);
        make.height.offset(70);
        make.top.equalTo(_topView.superview).offset(100);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bottomView.superview);
        make.height.offset(40);
        make.bottom.equalTo(_bottomView.superview).offset(-20-KIndicatorHeight);
    }];
    [_thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_thirdLoginView.superview);
        make.bottom.equalTo(_bottomView.mas_top).offset(-10);
        make.height.offset(thirdAll_H);
    }];
    //
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(_thirdLoginView.mas_top);
        make.left.right.equalTo(_tableView.superview);
    }];
    self.tableView.tableFooterView = self.loginCenterBtnsView;
    CGFloat tableViewHeaderView_H = KIndicatorHeight > 1 ? (80) : (0);
    UIView *hv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, tableViewHeaderView_H)];
    hv.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = hv;
}
- (void)thisViewSubTypeInfo{
    [_topView setThisViewShowType:self.mainShowType];
    [_loginCenterBtnsView setThisViewShowType:self.mainShowType];

}
- (void)otherAction{
    WEAKSELF
   self.bottomView.gotoPrivacyAgreementVcBlock = ^(PrivacyAgreementVCLate * _Nonnull vc) {
        if (isNil(weakSelf.gotoPrivacyAgreementVcBlock)) {
            return;
        }
        weakSelf.gotoPrivacyAgreementVcBlock(vc);
    };
    [ self.thirdLoginView.wxLoginBtn addTarget:self action:@selector(thridLoginBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [ self.thirdLoginView.zfbLoginBtn addTarget:self action:@selector(thridLoginBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [ self.thirdLoginView.appleLoginBtn addTarget:self action:@selector(thridLoginBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [ self.loginCenterBtnsView.loginBtn addTarget:self action:@selector(centerViewSubBtnsTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [ self.loginCenterBtnsView.forgotPasswordBtn addTarget:self action:@selector(centerViewSubBtnsTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [ self.loginCenterBtnsView.changeLoginTypeBtn addTarget:self action:@selector(centerViewSubBtnsTouchAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ==  touch action
- (void)thridLoginBtnTouchAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(thisViewTouchSubViewItemWithTag:)]) {
        [_delegate thisViewTouchSubViewItemWithTag:sender.tag];
    }
}
- (void)codeBtnSendAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(thisViewTouchSubViewItemWithTag:)]) {
        [_delegate thisViewTouchSubViewItemWithTag:sender.tag];
    }
}
- (void)centerViewSubBtnsTouchAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(thisViewTouchSubViewItemWithTag:)]) {
        [_delegate thisViewTouchSubViewItemWithTag:sender.tag];
    }
}


#pragma mark == UI
- (UIImageView *)mainBkImgView{
    if (!_mainBkImgView) {
        _mainBkImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    }
    return _mainBkImgView;
}
- (LoginAndRegiestViewSubTopView *)topView{
    if (!_topView) {
        _topView = [[LoginAndRegiestViewSubTopView alloc]init];
    }
    return _topView;
}
- (LoginAndRegiestViewSubBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[LoginAndRegiestViewSubBottomView alloc]init];
    }
    return _bottomView;
}
- (LoginAndRegiestViewSubThirdLoginView *)thirdLoginView{
    if (!_thirdLoginView) {
        _thirdLoginView = [[LoginAndRegiestViewSubThirdLoginView alloc]init];
    }
    return _thirdLoginView;
}

//

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;//不可滑动
    }
    return _tableView;
}


- (LoginAndRegiestViewSubLoginBtnAndOtherBtnView *)loginCenterBtnsView{
    if (!_loginCenterBtnsView) {
        _loginCenterBtnsView = [[LoginAndRegiestViewSubLoginBtnAndOtherBtnView alloc]initWithFrame:CGRectZero];
    }
    return _loginCenterBtnsView;
}

#pragma mark ===
#pragma mark =====  tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Row_TextCell_Height;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == Row_Num_Phone) {
        RegistViewLastSubLeftIsPhoneTextBeginTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_I];
        if (!cell) {
            cell = [[RegistViewLastSubLeftIsPhoneTextBeginTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubLeftIsPhoneTextBeginTableViewCell_I];
        }
        cell.textF.tag = Tag_LoginAndRegiest_Base + indexPath.row;
        cell.textF.text = self.phoneStr;
        cell.textF.delegate = self;
        [cell setTextPStr:@"请输入手机号码"];
        return cell;
        
    }else{//Row_Num_PasswordOrCode
        if (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) {
            RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell_I];
            if (!cell) {
                cell = [[RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubPasswordTextLeftIsSuoBtnAndRightIsEyeBtnTableViewCell_I];
            }
            cell.textF.tag = Tag_LoginAndRegiest_Base + indexPath.row;
            cell.textF.delegate = self;
            cell.textF.text = self.passWordOneStr;
            [cell setTextPStr:@"请输入密码"];
            return cell;
            
        }else{
            RegistViewLastSubHaveSendCodeBtnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RegistViewLastSubHaveSendCodeBtnTableViewCell_I];
            if (!cell) {
                cell = [[RegistViewLastSubHaveSendCodeBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RegistViewLastSubHaveSendCodeBtnTableViewCell_I];
            }
            cell.textF.tag = Tag_LoginAndRegiest_Base + indexPath.row;
            cell.textF.text = self.codeStr;
            cell.textF.delegate = self;
            cell.rightSendCodeBtn.tag = Tag_LoginAndRegiest_CodeSendBtn + Tag_LoginAndRegiest_Base;
            [cell.rightSendCodeBtn addTarget:self action:@selector(codeBtnSendAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell setTextPStr:@"请输入验证码"];
            return cell;
        }
    }
 
}



#pragma mark === data
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
 

#pragma mark ==

#pragma mark === UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
  [self getTextSave:textField];

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
  [self getTextSave:textField];
}

- (void)getTextSave:(UITextField *)textField{
  NSInteger tagIndex = textField.tag-Tag_LoginAndRegiest_Base;
  switch (tagIndex) {
      case Row_Num_Phone:
      {
          self.phoneStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
          if (self.phoneStr.length == 0) {//清空账号重新输入新账号时 密码也清空
              if (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) {
                  self.passWordOneStr = @"";
                  //会导致键盘的退出
//                  [self.tableView reloadData];
                  //会更改UI不能更新数据
//                  [self.tableView beginUpdates];
//                  [self.tableView endUpdates];
                  
                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:Row_Num_PasswordOrCode inSection:0];
                      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];//可以刷新数据并且键盘依旧显示
                  
              }
          }
      }
          break;
          
      case Row_Num_PasswordOrCode:
      {
          if (self.mainShowType == LoginAndRegiestVC_Show_Type_PasswordLogin) {
              self.passWordOneStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
          }else{
              self.codeStr = [TextShowWithModelStr textShowWithModelStr:textField.text];
          }
      }
          break;
          
      default:
          break;
  }
  
}


 
@end
