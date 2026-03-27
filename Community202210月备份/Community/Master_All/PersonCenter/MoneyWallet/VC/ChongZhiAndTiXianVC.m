//
//  ChongZhiAndTiXianVC.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "ChongZhiAndTiXianVC.h"
#import "MoneyOfThridBangDingListVc.h"
#import "PersonMoneyModelData.h"
#define  ChongzhiTixianVcTextFieldTableViewCell_Identifier @"ChongzhiTixianVcTextFieldTableViewCell"
#import "PopViewWithTiXianAndChongZhi.h"
#import "ZYSignPasswordView.h"
#import "ZYPayPasswordInputView.h"
#import "ZYWalletWithdrawalModel.h"
// 绑定相关
#import "WeiXinAuthorizationManager.h"
#import "MoneyOfThridBangDingWeiXinEditVc.h"
#import "MoneyOfThridBangDingZFBEditVc.h"

static NSString *weiXinImgStr = @"BalanceWeiXinLogo";
static NSString *zhiFuBaoImgStr = @"Balance_zhifubao";
 
@interface ChongZhiAndTiXianVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PopViewWithTiXianAndChongZhiDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) PopViewWithTiXianAndChongZhi *popViewChooseType;//支付宝 微信 等选择项

@property (nonatomic, strong) ZYSignPasswordView *signPasswordView; //设置支付密码视图

@property (nonatomic, strong) ZYPayPasswordInputView *payPasswordInputView; //输入支付密码视图

// 设置密码
@property (nonatomic, assign) BOOL isShowPWView;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *pwVerifyStr;

// 支付密码
@property (nonatomic, assign) BOOL isShowPayPWView;

@property (nonatomic, copy) NSString *payPWStr;

@property (nonatomic,strong) PersonMoneyModel *moneyAndOtherModel;
@property (nonatomic,assign) ChooseType chooseType; 
@property (nonatomic,strong) NSString *saveTextFMoneyStr;
@end

@implementation ChongZhiAndTiXianVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveTextFMoneyStr = @"";
    if (self.type==TiXianAndChongZhi_Type_chognzhi) {
        self.title = @"余额充值";
    }else{
        self.title = @"余额提现";
        [self initMoneyShowData];
    }
    
    self.isShowPWView = NO;
    self.isShowPayPWView = NO;
    [self setUI];
    // 注册键盘通知
    [self registerForKeyboardNotifications];
    // 注册绑定成功回调
    Y_NSNotificationCenter_Creat_NameAction(@"BANG_DING_WECHAT_BACK", bandDingWechatBack)
    Y_NSNotificationCenter_Creat_NameAction(@"BANG_DING_ALIPAY_BACK", bandDingAlipayBack)
}

// 通知回调
- (void)bandDingWechatBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chooseType = ChooseType_WeiXin;
        [self.tableView reloadData];
    });
}

- (void)bandDingAlipayBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chooseType = ChooseType_ZhiFuBao;
        [self.tableView reloadData];
    });
}

// 销毁通知
- (void)dealloc {
    
    Y_NSNotificationCenter_RemoveNotice_Name(@"BANG_DING_WECHAT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"BANG_DING_ALIPAY_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    
    [self.view addSubview:self.signPasswordView];
    [_signPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_signPasswordView.superview);
    }];
    
    [self.view addSubview:self.payPasswordInputView];
    [_payPasswordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_payPasswordInputView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
        _tableView.tableFooterView = self.footerView;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (PopViewWithTiXianAndChongZhi *)popViewChooseType{
    _popViewChooseType = [[PopViewWithTiXianAndChongZhi alloc]init];
    _popViewChooseType.chooseTypeDelegate = self;
    return _popViewChooseType;
}

- (ZYPayPasswordInputView *)payPasswordInputView {
    if (!_payPasswordInputView) {
        _payPasswordInputView = [[NSBundle mainBundle] loadNibNamed:@"ZYPayPasswordInputView" owner:nil options:nil].lastObject;
        _payPasswordInputView.hidden = YES;
        _payPasswordInputView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
        _payPasswordInputView.pwTF.tag = 1000;
        _payPasswordInputView.pwTF.delegate = self;
        [_payPasswordInputView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payPasswordInputViewTap)]];
        [_payPasswordInputView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payPasswordInputView;
}

- (ZYSignPasswordView *)signPasswordView {
    if (!_signPasswordView) {
        _signPasswordView = [[NSBundle mainBundle] loadNibNamed:@"ZYSignPasswordView" owner:nil options:nil].lastObject;
        _signPasswordView.hidden = YES;
        _signPasswordView.pwViewBottomConstraint.constant = 0;
        _signPasswordView.titleLabel.text = @"设置支付密码";
        _signPasswordView.pwTF.delegate = self;
        _signPasswordView.pwTF.tag = 2000;
        _signPasswordView.okButton.hidden = YES;
        [_signPasswordView.okButton addTarget:self action:@selector(pwOkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _signPasswordView;
}

#pragma mark ====
- (PersonMoneyModel *)moneyAndOtherModel{
    if (!_moneyAndOtherModel) {
        _moneyAndOtherModel = [[PersonMoneyModel alloc]init];
    }
    return _moneyAndOtherModel;
}
- (void)initMoneyShowData{
    WEAKSELF
    [PersonMoneyModelData getPersonMoneyDataWithBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.moneyAndOtherModel = [PersonMoneyModel mj_objectWithKeyValues:dic];
            //@(model.bankCard)银行卡 @(model.balance)余额 @(model.tickets)现金券
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - 设置支付密码数据
- (void)initSetPayPasswordData {
    NSDictionary *parms = @{@"payPassword" : self.pwStr, @"confirmPayPassword" : self.pwVerifyStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Set_Password] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self.signPasswordView clearText];
                [ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword = YES;
                [self showPayPWView];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 加载验证支付密码数据
- (void)initPayPasswordVerification {
    NSDictionary *parms = @{@"payPassword" : self.payPWStr};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Get_Pay_Password_Verification] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.chooseType == ChooseType_WeiXin) {
                    [self initWeChatWithdrawalData];
                }else if (self.chooseType == ChooseType_ZhiFuBao) {
                    [self initWeAlipayWithdrawalData];
                }
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 加载用户余额提现至微信数据
- (void)initWeChatWithdrawalData {
    NSDictionary *parms = @{@"amount" : self.saveTextFMoneyStr, @"payPassword" : self.payPWStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_WeChat_Withdrawal] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        [self.view endEditing:YES];
        [self.payPasswordInputView clearText];
        self.payPasswordInputView.hidden = YES;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYWalletWithdrawalModel *model = [ZYWalletWithdrawalModel yy_modelWithJSON:Y_ResponsObject_dataDic];
                if (model.success) {
                    NSString *msg;
                    if (self.type == TiXianAndChongZhi_Type_tixian) {
                        msg = @"提现成功";
                    }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
                        msg = @"充值成功";
                    }
                    [ZYProgressHUDTool showCustomHUDTextMessage:msg toView:self.view.window];
                    [self popVC];
                }else {
                    [SVProgressHUD showErrorCustomHUDWithStatus:model.msg delay:3.0];
                }
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
                [self.payPasswordInputView clearText];
                self.payPWStr = @"";
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
            [self.payPasswordInputView clearText];
            self.payPWStr = @"";
        }
    }];
}

#pragma mark - 加载用户余额提现至支付宝数据
- (void)initWeAlipayWithdrawalData {
    NSDictionary *parms = @{@"amount" : self.saveTextFMoneyStr, @"payPassword" : self.payPWStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Alipay_Withdrawal] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        [self.view endEditing:YES];
        [self.payPasswordInputView clearText];
        self.payPasswordInputView.hidden = YES;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYWalletWithdrawalModel *model = [ZYWalletWithdrawalModel yy_modelWithJSON:Y_ResponsObject_dataDic];
                if (model.success) {
                    NSString *msg;
                    if (self.type == TiXianAndChongZhi_Type_tixian) {
                        msg = @"提现成功";
                    }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
                        msg = @"充值成功";
                    }
                    [ZYProgressHUDTool showCustomHUDTextMessage:msg toView:self.view.window];
                    [self popVC];
                }else {
                    [SVProgressHUD showErrorCustomHUDWithStatus:model.msg delay:3.0];
                }
            }else {
                [self.payPasswordInputView clearText];
                self.payPWStr = @"";
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            [self.payPasswordInputView clearText];
            self.payPWStr = @"";
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ====
- (void)fooBtnAction{
    DLog(@"");
    if (self.chooseType == ChooseType_Null) {
        Y_SVP_SHOW_ERR_MES(@"请输入选择方式。");
        return;
    }
    if (self.saveTextFMoneyStr.length <= 0) {
        Y_SVP_SHOW_ERR_MES(@"请输入金额！");
        return;
    }
    if ([self.saveTextFMoneyStr doubleValue] < 0.01) {
        Y_SVP_SHOW_ERR_MES(@"金额不能小于0.01！");
        return;
    }
    if ([self.saveTextFMoneyStr doubleValue] > self.moneyAndOtherModel.balance) {
        Y_SVP_SHOW_ERR_MES(@"提现金额不能大于当前余额！");
        return;
    }
    if (self.type==TiXianAndChongZhi_Type_chognzhi) {
         //@"余额充值";
    }else{
        //@"余额提现";
        [self.view endEditing:YES];//失去第一textf响应
        [self isSettingPayPassword]; //支付密码是否存在
    }
}
//全部提现
- (void)subCellAllTixianBtnAction{
    DLog(@"");
    self.saveTextFMoneyStr = [NSString stringWithFormat:@"%0.2f", self.moneyAndOtherModel.balance];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    
    if (textField.tag == 500) {
        self.saveTextFMoneyStr = textField.text;
    }else if (textField.tag == 1000) {
        if (textField.text.length < 6) {
            self.payPWStr = @"";
        }
    }else if (textField.tag == 2000) {
        if (textField.text.length < 6) {
            self.pwVerifyStr = @"";
        }
    }
}
#pragma mark ==
- (void)popViewWithChooseType:(ChooseType)chooseType{
    self.chooseType = chooseType;
    
    if (chooseType == ChooseType_WeiXin) {
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindWechat) {
            [self.tableView reloadData];
        }else {
            // 跳转微信绑定界面
            WEAKSELF
            [[WeiXinAuthorizationManager share]weiXinMoneyBangDingActionWithWeixinCodeStrBlock:^(NSString * codeS) {
                if (codeS.length>0) {
                    MoneyOfThridBangDingWeiXinEditVc *vc = [[MoneyOfThridBangDingWeiXinEditVc alloc]init];
                    vc.codeStrWithWxOrZfb = codeS;
                    [weakSelf pushVc:vc];
                    return;
                }
            }];
        }
    }else if (chooseType == ChooseType_ZhiFuBao) {
        if ([ShareUserInfo sharedUserInfo].userInfo.isBindAlipay) {
            [self.tableView reloadData];
        }else {
            // 跳转支付宝绑定界面
            MoneyOfThridBangDingZFBEditVc *vc = [[MoneyOfThridBangDingZFBEditVc alloc]init];
            [self pushVc:vc];
        }
    }
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self.popViewChooseType showInView:self.view thePopViewTableViewHeight:0.0 WithArray:@[].mutableCopy];//内部直接写的数据 不用外部传入
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 70;
    }else{
        return 120;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderViewWithTextLabel *v = [[SectionHeaderViewWithTextLabel alloc]init];
    v.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
    v.titleLabel.font = FontSize_MoneyWallet_Bold(16);
    v.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    NSMutableArray *sectionTextArr = [[NSMutableArray alloc]init];
    NSArray *chongZhi = @[@"充值方式",@"充值金额"];
    NSArray *arrTixian = @[@"提现至",@"提现金额"];
    if (self.type==TiXianAndChongZhi_Type_chognzhi) {
        sectionTextArr = [NSMutableArray arrayWithArray:chongZhi];
    }else{
        sectionTextArr = [NSMutableArray arrayWithArray:arrTixian];
    }
    v.titleLabel.text = sectionTextArr[section];
    return v;
}
 
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
            cell.accessoryView = accessoryImgView;
            cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
            cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (self.chooseType) {
            case ChooseType_WeiXin:
                cell.textLabel.text = @"微信";
                cell.imageView.image = [UIImage imageNamed:weiXinImgStr];
                cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
                break;
            case ChooseType_ZhiFuBao:
                cell.textLabel.text = @"支付宝";
                cell.imageView.image = [UIImage imageNamed:zhiFuBaoImgStr];
                cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
                break;
            default:
                if (self.type==TiXianAndChongZhi_Type_chognzhi) {
                    cell.textLabel.text = @"请选择充值方式";
                }else{
                    cell.textLabel.text = @"请选择提现方式";
                }
                cell.textLabel.textColor = [ [ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
                cell.imageView.image =  nil;
                break;
        }
      
        return cell;
    }else{
        ChongzhiTixianVcTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChongzhiTixianVcTextFieldTableViewCell_Identifier];
        if (!cell) {
            cell  = [[ChongzhiTixianVcTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChongzhiTixianVcTextFieldTableViewCell_Identifier];
        }
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.textField.tag = 500;
        cell.textField.delegate = self;
        [cell.allTixianBtn addTarget:self action:@selector(subCellAllTixianBtnAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.type==TiXianAndChongZhi_Type_chognzhi) {
            cell.bottomTipL.text = @"充值";
            cell.allTixianBtn.hidden = YES;
        }else{
            cell.bottomTipL.text =  [NSString stringWithFormat:@"可提现余额¥%0.2f",self.moneyAndOtherModel.balance];
            cell.allTixianBtn.hidden = NO;
        }
        cell.textField.text = self.saveTextFMoneyStr;
        return cell;
    }
}
 
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView  = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        if (self.type==TiXianAndChongZhi_Type_chognzhi) {
            [_footerView.footerBtn newAnBtnWithTextStr:@"确认充值"];
        }else{
            [_footerView.footerBtn newAnBtnWithTextStr:@"确认提现"];
        }
        _footerView.footerBtn.backgroundColor = Color_38BlueColor;
        [_footerView.footerBtn addTarget:self action:@selector(fooBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark - 监听键盘
- (void)registerForKeyboardNotifications {

    //使用NSNotificationCenter 键盘弹出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillChangeFrameNotification object:nil];

    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if (self.isShowPWView) {
        //输入框位置动画加载
        [UIView animateWithDuration:duration animations:^{
            self.signPasswordView.pwViewBottomConstraint.constant = keyboardSize.height - 24;
            [self.view layoutIfNeeded];
        }];
    }else if (self.isShowPayPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.payPasswordInputView.contentViewBottomConstraint.constant = keyboardSize.height + 20;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.isShowPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.signPasswordView.pwViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }else if (self.isShowPayPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.payPasswordInputView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - 判断支付密码是否存在
- (void)isSettingPayPassword {
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
        [self showPayPWView]; //输入支付
    }else {
        [self showPWView]; //设置支付密码
    }
}

#pragma mark - 显示密码设置界面
- (void)showPWView {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.isShowPWView = YES;
    self.isShowPayPWView = NO;
    self.signPasswordView.hidden = NO;
    self.payPasswordInputView.hidden = YES;
    [self.signPasswordView.pwTF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    self.signPasswordView.block = ^(NSString * _Nullable pwStr) {
        if (weakSelf.pwStr.length > 0) {
            weakSelf.pwVerifyStr = pwStr;
        }else {
            weakSelf.pwStr = pwStr;
            [weakSelf.signPasswordView clearText];
            weakSelf.signPasswordView.titleLabel.text = @"确认支付密码";
            weakSelf.signPasswordView.okButton.hidden = NO;
            [weakSelf.view reloadInputViews];
        }
    };
}

#pragma mark - 显示填写支付密码界面
- (void)showPayPWView {
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.isShowPayPWView = YES;
    self.isShowPWView = NO;
    self.payPasswordInputView.hidden = NO;
    self.signPasswordView.hidden = YES;
    if (self.type == TiXianAndChongZhi_Type_tixian) {
        if (self.chooseType == ChooseType_WeiXin) {
            self.payPasswordInputView.subTitleLabel.text = @"提现到微信";
        }else if (self.chooseType == ChooseType_ZhiFuBao) {
            self.payPasswordInputView.subTitleLabel.text = @"提现到支付宝";
        }
    }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
        if (self.chooseType == ChooseType_WeiXin) {
            self.payPasswordInputView.subTitleLabel.text = @"从微信充值";
        }else if (self.chooseType == ChooseType_ZhiFuBao) {
            self.payPasswordInputView.subTitleLabel.text = @"从支付宝充值";
        }
    }
    self.payPasswordInputView.moneyLabel.text = self.saveTextFMoneyStr;
    [self.payPasswordInputView.pwTF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    self.payPasswordInputView.block = ^(NSString * _Nullable pwStr) {
        weakSelf.payPWStr = pwStr;
        // 验证支付密码
        NSString *msg;
        if (self.type == TiXianAndChongZhi_Type_tixian) {
            msg = @"提现中...";
        }else if (self.type == TiXianAndChongZhi_Type_chognzhi) {
            msg = @"充值中...";
        }
        [SVProgressHUD showLoadingCustomHUDWithStatus:msg];
        [weakSelf initPayPasswordVerification];
    };
}

#pragma mark - 处理点击事件
// 设置签署密码
- (void)pwOkButtonClicked {
    
    NSLog(@"设置支付密码");
    if (self.pwVerifyStr.length > 0) {
        if ([self.pwStr isEqualToString:self.pwVerifyStr]) {
            
            [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"设置中..."];
            [self initSetPayPasswordData];
        }else {
            self.pwStr = @"";
            self.pwVerifyStr = @"";
            self.signPasswordView.titleLabel.text = @"设置支付密码";
            self.signPasswordView.okButton.hidden = YES;
            [self.signPasswordView clearText];
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"密码和确认密码不一致,请重新设置密码!" toView:self.signPasswordView.hintView delay:3.0];
        }
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"确认签署密码不能为空!" toView:self.signPasswordView.hintView delay:2.0];
    }
}

- (void)payPasswordInputViewTap {
    
    [self.payPasswordInputView.pwTF becomeFirstResponder];
}

// 关闭支付密码视图
- (void)closeButtonClicked {
    
    [self.view endEditing:YES];
    self.payPWStr = @"";
    [self.payPasswordInputView clearText];
    self.payPasswordInputView.hidden = YES;
}

@end
