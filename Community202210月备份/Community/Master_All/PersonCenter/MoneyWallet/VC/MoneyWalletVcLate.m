//
//  MoneyWalletVcLate.m
//  Community
//
//  Created by 余莹 on 2021/10/12.
//

#import "MoneyWalletVcLate.h"
 
#import "MoneyWalletVcLateTopView.h"

#import "MoneyWalletYuEVc.h"
#import "MoneyWalletAddBankCard.h"
//
#import "XianjingJuanVC.h"
#import "EIntergralMallMainVC.h"
//
#import "PersonMoneyModelData.h"
//
#import "ChongZhiAndTiXianVC.h"
//
//
#import "ZYElectronicSignPasswordSettingVc.h"
#import "ZYElectronicSignPasswordChangedVc.h"
//
#import "MoneyWalletYuEMingXiListVc.h"
#import "MoneyOfThridBangDingListVc.h"
//
#import "PayPasswordSetVC.h"
//
#import "ZYWalletBalanceModel.h"

//1217 更改提现流程
#import "PopViewWithTiXianAndChongZhi.h"
#import "WeiXinAuthorizationManager.h"
#import "ZFBAnthorzationManager.h"
#import "MoneyOfThridBangDingWeiXinEditVc.h"
#import "MoneyOfThridBangDingZFBEditVcLate.h"
#import "ThridTIXianChongZhiData.h"
#import "ZYSignPasswordView.h"
#import "ZYPayPasswordInputView.h"


#define  topV_Height  (110)
@interface MoneyWalletVcLate () <UITableViewDataSource,UITableViewDelegate,MoneyWalletVcLateTopViewDelegate,PopViewWithGoToRealCertificationDelegate,PopViewWithTiXianAndChongZhiDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)  MoneyWalletVcLateTopView *topView;

@property (nonatomic,strong) PopViewWithGoToRealCertification *popViewGotoCertification;

@property (nonatomic) PersonMoneyModel *moneyAndOtherModel;
//1217 更改提现流程
@property (nonatomic,strong) PopViewWithTiXianAndChongZhi *popViewChooseType;//支付宝 微信 等选择项

@property (nonatomic, strong) ZYPayPasswordInputView *payPasswordInputView; //输入支付密码视图

// 支付密码
@property (nonatomic, assign) BOOL isShowPayPWView;

@property (nonatomic, copy) NSString *payPWStr;

@property (nonatomic,assign) ChooseType chooseType;

@property (nonatomic,copy) NSString *saveTextFMoneyStr;


@end

@implementation MoneyWalletVcLate

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

- (PopViewWithTiXianAndChongZhi *)popViewChooseType{
    _popViewChooseType = [[PopViewWithTiXianAndChongZhi alloc]init];
    _popViewChooseType.chooseTypeDelegate = self;
    return _popViewChooseType;
}
#pragma mark - 处理点击事件
 

- (void)payPasswordInputViewTap {
    
    [self.payPasswordInputView.pwTF becomeFirstResponder];
}

// 关闭支付密码视图
- (void)closeButtonClicked {
    
    [self.view endEditing:YES];
    self.payPWStr = @"";
    self.isShowPayPWView = NO;
    [self.payPasswordInputView clearText];
    self.payPasswordInputView.hidden = YES;
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
    if (self.isShowPayPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.payPasswordInputView.contentViewBottomConstraint.constant = keyboardSize.height + 20;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.isShowPayPWView) {
        [UIView animateWithDuration:duration animations:^{
            self.payPasswordInputView.contentViewBottomConstraint.constant = kScreenH / 2 - 115;
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.isShowPayPWView = NO;
    self.saveTextFMoneyStr = @"";
    self.chooseType = ChooseType_Null;
    
    [self initView];
    [self initMoneyShowData];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initBalanceData];
}

#pragma mark - 加载余额数据
- (void)initBalanceData {
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Get_Balance] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYWalletBalanceModel *model = [ZYWalletBalanceModel yy_modelWithJSON:responsObject];
                self.topView.moneyL.text = model.data.balance;
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];
    [self setUI];
}
- (void)setUI{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_topView.superview);
        make.top.equalTo(_topView.superview.mas_top).offset(15);
        make.height.offset(topV_Height);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom).offset(-5);
    }];
    [self.tableView reloadData];
    //
    [self.view addSubview:self.payPasswordInputView];
    [_payPasswordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_payPasswordInputView.superview);
    }];
    self.payPasswordInputView.hidden = YES;
    
}
#pragma mark ==
 
- (void)initMoneyShowData{
    WEAKSELF
    [PersonMoneyModelData getPersonMoneyDataWithBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.moneyAndOtherModel = [PersonMoneyModel mj_objectWithKeyValues:dic];
            //@(model.bankCard)银行卡 @(model.balance)余额 @(model.tickets)现金券
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.topView fillDataWithYuE:self.moneyAndOtherModel.balance];
            });
        }
    }];
}
#pragma mark ===
//未实名认证popView
- (PopViewWithGoToRealCertification *)popViewGotoCertification{
    _popViewGotoCertification = [[PopViewWithGoToRealCertification alloc]init];
    _popViewGotoCertification.delegate = self;
    return _popViewGotoCertification;
}
#pragma mark ===
- (BOOL)isShiMing{
    DLog(@"是否实名认证过的");
    if (ZY_IsRealName) {
        return YES;
    }else {
        return NO;
    }
}
- (void)goToBangKaBtnAction{//绑定银行卡 （去绑卡按钮）
    // 实名才能绑卡
    if ([self isShiMing]) {
        MoneyWalletAddBankCard *vc = [[MoneyWalletAddBankCard alloc]init];
        [self pushVc:vc];
    }else{
        [self.popViewGotoCertification showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    }
}
//去实名认证页面
- (void)popViewBtnActionWithGoToRealCertificationAction{
    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)showYuEMingXiBtnAction{//余额明细
    MoneyWalletYuEVc *vc = [[MoneyWalletYuEVc alloc]init];
    vc.yuE = self.moneyAndOtherModel.balance;
    [self pushVc:vc];
}
#pragma mark === 钱包提现
/**
 1217更改。
 绑定状态 本页密码pop view 一个接口结束
 未绑定状态 本页跳转做三方绑定 才能继续普通提现流程
 
 */
- (void)goToTiXianBtnAction{  
    DLog(@"钱包提现");
    if (self.moneyAndOtherModel.balance > 0) {
        [self.popViewChooseType showInView:self.view thePopViewTableViewHeight:0.0 WithArray:@[].mutableCopy];//内部直接写的数据 不用外部传入
//        //旧版 暂不使用
//        ChongZhiAndTiXianVC *vc = [[ChongZhiAndTiXianVC alloc]init];
//        vc.type = TiXianAndChongZhi_Type_tixian;
//        [self pushVc:vc];
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"余额不足！" toView:self.view];
    }
}
#pragma mark === 提现前的判定
- (void)goToSetPasswordVc{
    DLog(@"没有密码 需要设置后 才能提现");
    Y_SVP_SHOW_INFO_MES(@"没有支付密码，需要设置后，才能提现。");
    dispatch_async(dispatch_get_main_queue(), ^{
        PayPasswordSetVC *vc = [[PayPasswordSetVC alloc]init];
        vc.type = Set_Password_Type_Pay;
        [self pushVc:vc];
    });
}
- (void)notBindWithAlartShow{
    NSString *titleS = @"";
    if (self.chooseType == ChooseType_WeiXin) {
        titleS = @"没有绑定微信，需要绑定后，才能提现。";
    }else if(self.chooseType == ChooseType_ZhiFuBao) {
        titleS = @"没有绑定支付宝，需要绑定后，才能提现。";
    }else{
        return;
    }
    WEAKSELF
    [[AlertManager shareManager] creatAlertWithTitle:titleS message:@"" preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitleArr:@[@"去绑定"].mutableCopy];
    [[AlertManager shareManager] showWithViewController:self IndexBlock:^(NSInteger index) {
        switch (index) {
            case AlertManagerCancelIndex:
                break;
                
            default:
            {
                if (self.chooseType == ChooseType_WeiXin) {
                    //拿到授权code 跳转微信绑定界面
                    [[WeiXinAuthorizationManager share]weiXinMoneyBangDingActionWithWeixinCodeStrBlock:^(NSString * codeS) {
                        if (codeS.length>0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                MoneyOfThridBangDingWeiXinEditVc *vc = [[MoneyOfThridBangDingWeiXinEditVc alloc]init];
                                vc.codeStrWithWxOrZfb = codeS;
                                [weakSelf pushVc:vc];
                            });
                            return;
                        }
                    }];
                 }else if(self.chooseType == ChooseType_ZhiFuBao) {
                     [[ZFBAnthorzationManager shareManager]getZFBAnthorzationCodeWithBLock:^(NSString * _Nonnull codeStr, BOOL success) {
                         if (codeStr.length>0) {
                             // 跳转支付宝绑定界面
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 MoneyOfThridBangDingZFBEditVcLate *vc = [[MoneyOfThridBangDingZFBEditVcLate alloc]init];
                                 vc.codeStrWithWxOrZfb = codeStr;
                                 [weakSelf pushVc:vc];
                             });
                         }
                     }];
                 }else{
                }
            }
           
                break;
        }
    }];
}
#pragma mark ===
- (BOOL)canGoTiXianWithtypeOrmoneySvpShow{
    if (self.chooseType == ChooseType_Null) {
        Y_SVP_SHOW_ERR_MES(@"请输入选择方式。");
        return NO;
    }
    if (self.saveTextFMoneyStr.length <= 0) {
        Y_SVP_SHOW_ERR_MES(@"请输入金额！");
        return NO;
    }
    if ([self.saveTextFMoneyStr doubleValue] < 0.01) {
        Y_SVP_SHOW_ERR_MES(@"金额不能小于0.01！");
        return NO;
    }
    if ([self.saveTextFMoneyStr doubleValue] > self.moneyAndOtherModel.balance) {
        Y_SVP_SHOW_ERR_MES(@"提现金额不能大于当前余额！");
        return NO;
    }
  
    //@"余额提现";
    [self.view endEditing:YES];//失去第一textf响应
    return YES;
}
#pragma mark == 提现Action
- (void)popViewWithChooseType:(ChooseType)chooseType{
    self.chooseType = chooseType;
    if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword == NO) {//没有密码
        [self goToSetPasswordVc];
        return;
    }
    if ((chooseType == ChooseType_WeiXin  && ![ShareUserInfo sharedUserInfo].userInfo.isBindWechat) || (chooseType == ChooseType_ZhiFuBao  && ![ShareUserInfo sharedUserInfo].userInfo.isBindAlipay)) {//没绑定对应的 去绑定
        //拿到授权code 跳转绑定界面
        [self notBindWithAlartShow];
        return;
    }
    self.saveTextFMoneyStr = [NSString stringWithFormat:@"%0.2f", self.moneyAndOtherModel.balance];//金额处理
    self.saveTextFMoneyStr = @"0.2";//test
    if ([self canGoTiXianWithtypeOrmoneySvpShow]==NO) {//金额符合规则
        return;
    }
    [self showPayPWView];//输入密码 走提现流程
    
}


#pragma mark - 显示填写支付密码界面
- (void)showPayPWView {
    DLog(@"");
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.isShowPayPWView = YES;
    self.payPasswordInputView.hidden = NO;
    if (self.chooseType == ChooseType_WeiXin) {
        self.payPasswordInputView.subTitleLabel.text = @"提现到微信";
    }else if (self.chooseType == ChooseType_ZhiFuBao) {
        self.payPasswordInputView.subTitleLabel.text = @"提现到支付宝";
    }
   
    self.payPasswordInputView.moneyLabel.text = self.saveTextFMoneyStr;
    [self.payPasswordInputView.pwTF becomeFirstResponder];
    __weak typeof(self) weakSelf = self;
    self.payPasswordInputView.block = ^(NSString * _Nullable pwStr) {
        weakSelf.payPWStr = pwStr;
        // 验证支付密码
        NSString *msg;
        msg = @"提现中...";
        
        [SVProgressHUD showLoadingCustomHUDWithStatus:msg];
        [weakSelf initPayPasswordVerification]; 
    };
}
#pragma mark - 加载验证支付密码数据
- (void)initPayPasswordVerification {
    NSDictionary *parms = @{@"payPassword" : self.payPWStr};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Get_Pay_Password_Verification] withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.chooseType == ChooseType_WeiXin) {
                    [self weChatTiXianAction];
                }else if (self.chooseType == ChooseType_ZhiFuBao) {
                    [self zfbTiXianAction];
                }
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark === 两种提现接口
- (void)weChatTiXianAction{
    DLog(@"微信全部提现");
    WEAKSELF
    [ThridTIXianChongZhiData tiXianToWechatWithMoneyAmount:self.saveTextFMoneyStr withPatPassword:self.payPWStr withBlock:^(NSDictionary * _Nonnull dic,BOOL success) {
        if (success) {
            Y_SVP_DISMISS;
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view endEditing:YES];//失去第一textf响应
                [ZYProgressHUDTool showCustomHUDTextMessage:@"提现成功" toView:self.view.window];
                weakSelf.payPasswordInputView.hidden = YES;
            });
            weakSelf.chooseType = ChooseType_Null;
            [weakSelf initMoneyShowData];
  
        }else {
            [weakSelf.payPasswordInputView clearText];
            weakSelf.payPWStr = @"";
        }
    }];
}
- (void)zfbTiXianAction{
    DLog(@"支付宝全部提现");
    WEAKSELF
    [ThridTIXianChongZhiData tiXianToZFBWithMoneyAmount:self.saveTextFMoneyStr  withPatPassword:self.payPWStr withBlock:^(NSDictionary * _Nonnull dic,BOOL success) {
        if (success) {
            Y_SVP_DISMISS;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view endEditing:YES];//失去第一textf响应
                [ZYProgressHUDTool showCustomHUDTextMessage:@"提现成功" toView:self.view.window];
                weakSelf.payPasswordInputView.hidden = YES;
            });
            weakSelf.chooseType = ChooseType_Null;
            [weakSelf initMoneyShowData];
        }else{
            [weakSelf.payPasswordInputView clearText];
            weakSelf.payPWStr = @"";
        }
    }];
}
#pragma mark === 提现逻辑 end
#pragma mark - Table view data source
//@"余额",@"密码设置"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"");
    switch (indexPath.row) {
        case 0://@"余额明细"
        {
            //明细
            MoneyWalletYuEMingXiListVc *vc = [[MoneyWalletYuEMingXiListVc alloc]init];
            [self pushVc:vc];
            
        }
            
            break;
            //1217更改 保留提现和余额明细 其余暂时不使用
            /**
             case 1://@"密码设置"
             {
     //            PayPasswordSetVC *vc = [[PayPasswordSetVC alloc] init];
     //            [self pushVc:vc];
                 
                 if ([ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword) {
                     ZYElectronicSignPasswordChangedVc *vc = [[ZYElectronicSignPasswordChangedVc alloc] init];
                     vc.typeStr = @"支付密码";
                     [self pushVc:vc];
                 }else {
                     ZYElectronicSignPasswordSettingVc *vc = [[ZYElectronicSignPasswordSettingVc alloc] init];
                     vc.typeStr = @"支付密码";
                     [self pushVc:vc];
                 }
             }
                 
                 break;
             case 2://@"第三方账号绑定"
             {
                 MoneyOfThridBangDingListVc *vc = [[MoneyOfThridBangDingListVc alloc]init];
                 [self pushVc:vc];
             }
             */

            
            break;
        default:
        {
            //没有密码 test
           // [self goToSetPasswordVc];
        }
            break;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell1"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell1"];
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        CGRect frame = accessoryImgView.frame;
        frame.size.width = frame.size.width + 10;
        accessoryImgView.frame = frame;
        [accessoryImgView setContentMode:UIViewContentModeLeft];
        cell.accessoryView = accessoryImgView;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26 );
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    cell.textLabel.text = self.dataSourceArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];;
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        //        if (tableView == self.tableView) {
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor= [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            //            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            //            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
  
}

#pragma mark ====
- (PersonMoneyModel *)moneyAndOtherModel{
    if (!_moneyAndOtherModel) {
        _moneyAndOtherModel = [[PersonMoneyModel alloc]init];
    }
    return _moneyAndOtherModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
//        _tableView.tableFooterView  = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor  = [ThemeManager shareManager].themeLineColor;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (MoneyWalletVcLateTopView *)topView{
    if (!_topView) {
        _topView = [[MoneyWalletVcLateTopView alloc]initWithFrame:CGRectZero];
        _topView.delegate = self;
        _topView.moneyL.text = self.balanceStr;
    }
    return _topView;
}
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithObjects:@"余额明细", nil];
    }
    return _dataSourceArr;
}
@end
