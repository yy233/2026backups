//
//  ZYElectronicSignPasswordForgetVc.m
//  Community
//
//  Created by ZY on 2021/7/5.
//

#import "ZYElectronicSignPasswordForgetVc.h"
#import "ZYElectronicSignPasswordChangedVc.h"
#import "ZYElectronicSignPasswordForgetCell.h"

static NSString * const electronicSignPasswordForgetCellID = @"ZYElectronicSignPasswordForgetCell";
#define kElectronicSignPasswordForgetCellHeight 360

@interface ZYElectronicSignPasswordForgetVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *verifyPWStr;

@property (nonatomic, copy) NSString *codeStr;

@end

@implementation ZYElectronicSignPasswordForgetVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.typeStr isEqual:@"支付密码"]) {
        self.title = @"忘记支付密码";
    }else {
        self.title = @"忘记签署密码";
    }
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYElectronicSignPasswordForgetCell" bundle:nil] forCellReuseIdentifier:electronicSignPasswordForgetCellID];
}

#pragma mark - 加载数据
// 忘记签约密码数据
- (void)initContractForgetSignPasswordData {
    
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"newPassword" : self.pwStr, @"phoneNumber" : [ShareUserInfo sharedUserInfo].userInfo.mobile, @"code" : self.codeStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractForgetSignPasswordUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ZYElectronicSignPasswordChangedVc class]]) {
                        [vcs removeObject:vc];
                    }
                }
                self.navigationController.viewControllers = [vcs copy];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"签约密码重设成功" toView:self.view.window];
                [self popVC];
            }else {
                
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 忘记支付密码数据
- (void)initPayForgetSignPasswordData {
    NSDictionary *parms = @{@"payPassword" : self.pwStr, @"confirmPayPassword" : self.verifyPWStr, @"code" : self.codeStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Pay_Forget] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ZYElectronicSignPasswordChangedVc class]]) {
                        [vcs removeObject:vc];
                    }
                }
                self.navigationController.viewControllers = [vcs copy];
                [ZYProgressHUDTool showCustomHUDTextMessage:@"支付密码重设成功" toView:self.view.window];
                [self popVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 发送验证码数据
- (void)initSendPhoneMessageData {
    NSDictionary *parms = @{@"uuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"telePhone" : [ShareUserInfo sharedUserInfo].userInfo.mobile};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractSendPhoneMessageUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                ZYElectronicSignPasswordForgetCell *cell = (ZYElectronicSignPasswordForgetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell countdown];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 发送支付密码设置验证码
- (void)initSendPayPhoneMessageData {
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Get_Pay_Code] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                ZYElectronicSignPasswordForgetCell *cell = (ZYElectronicSignPasswordForgetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell countdown];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYElectronicSignPasswordForgetCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicSignPasswordForgetCellID forIndexPath:indexPath];
    if ([self.typeStr isEqual:@"支付密码"]) {
        cell.titleLabel.text = @"请输入6位支付密码，用于确认本人身份";
    }else {
        cell.titleLabel.text = @"请输入6位签署密码，用于确认本人身份";
    }
    cell.pwTF.tag = 100;
    cell.pwTF.delegate = self;
    cell.verifyPWTF.tag = 200;
    cell.verifyPWTF.delegate = self;
    cell.codeTF.tag = 300;
    cell.codeTF.delegate = self;
    [cell.codeButton addTarget:self action:@selector(codeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kElectronicSignPasswordForgetCellHeight;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.tag == 100 || textField.tag == 200) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        
        if (textField.tag == 100) {
            self.pwStr = textField.text;
        }else if (textField.tag == 200) {
            self.verifyPWStr = textField.text;
        }
    }else if (textField.tag == 300) {
        self.codeStr = textField.text;
    }
}

#pragma mark - 处理点击事件
// 验证码
- (void)codeButtonClicked {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZYElectronicSignPasswordForgetCell *cell = (ZYElectronicSignPasswordForgetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.codeTF becomeFirstResponder];
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"获取中..."];
    if ([self.typeStr isEqual:@"支付密码"]) {
        [self initSendPayPhoneMessageData];
    }else {
        [self initSendPhoneMessageData];
    }
}

// 确认修改
- (void)okButtonClicked {
    
    NSLog(@"确认修改");
    [self.view endEditing:YES];
    if (self.pwStr.length > 0) {
        if (self.verifyPWStr.length > 0) {
            if (self.codeStr.length > 0) {
                if (self.pwStr.length == 6) {
                    if ([self.pwStr isEqualToString:self.verifyPWStr]) {
                        
                        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"修改中..."];
                        if ([self.typeStr isEqual:@"支付密码"]) {
                            [self initPayForgetSignPasswordData];
                        }else {
                            [self initContractForgetSignPasswordData];
                        }
                    }else {
                        
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"密码不一致!" toView:self.view];
                    }
                }else {
                    
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"密码长度为6" toView:self.view];
                }
            }else {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"验证码不能为空!" toView:self.view];
            }
        }else {
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"确认密码不能为空!" toView:self.view];
        }
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"密码不能为空!" toView:self.view];
    }
}

@end
