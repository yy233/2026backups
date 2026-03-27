//
//  ZYElectronicSignPasswordChangedVc.m
//  Community
//
//  Created by ZY on 2021/7/5.
//

#import "ZYElectronicSignPasswordChangedVc.h"
#import "ZYElectronicSignPasswordForgetVc.h"
#import "ZYElectronicSignPasswordChangedCell.h"

static NSString * const electronicSignPasswordChangedCellID = @"ZYElectronicSignPasswordChangedCell";
#define kElectronicSignPasswordChangedCellHeight 400

@interface ZYElectronicSignPasswordChangedVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, copy) NSString *oldPWStr;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *verifyPWStr;

@end

@implementation ZYElectronicSignPasswordChangedVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.typeStr isEqual:@"支付密码"]) {
        self.title = @"修改支付密码";
    }else {
        self.title = @"修改签署密码";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYElectronicSignPasswordChangedCell" bundle:nil] forCellReuseIdentifier:electronicSignPasswordChangedCellID];
}

#pragma mark - 加载数据
// 修改签约密码数据
- (void)initContractUpdateSignPasswordData {
    
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"oldPassword" : self.oldPWStr, @"newPassword" : self.pwStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractUpdateSignPasswordUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"签约密码修改成功" toView:self.view.window];
                [self popVC];
            }else {
                
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 修改支付密码数据
- (void)initPayPasswordChangedData {
    NSDictionary *parms = @{@"payPassword" : self.pwStr, @"confirmPayPassword" : self.verifyPWStr, @"oldPayPassword" : self.oldPWStr};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Set_Password] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"支付密码修改成功" toView:self.view.window];
                [self popVC];
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
    
    ZYElectronicSignPasswordChangedCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicSignPasswordChangedCellID forIndexPath:indexPath];
    if ([self.typeStr isEqual:@"支付密码"]) {
        cell.titleLabel.text = @"请输入6位支付密码，用于确认本人身份";
    }else {
        cell.titleLabel.text = @"请输入6位签署密码，用于确认本人身份";
    }
    cell.pwTF.tag = 100;
    cell.pwTF.delegate = self;
    cell.verifyPWTF.tag = 200;
    cell.verifyPWTF.delegate = self;
    cell.oldPWTF.tag = 300;
    cell.oldPWTF.delegate = self;
    [cell.forgetButton addTarget:self action:@selector(forgetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cell.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kElectronicSignPasswordChangedCellHeight;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    if (textField.tag == 100 || textField.tag == 200 || textField.tag == 300) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        
        if (textField.tag == 100) {
            self.pwStr = textField.text;
        }else if (textField.tag == 200) {
            self.verifyPWStr = textField.text;
        }else if (textField.tag == 300) {
            self.oldPWStr = textField.text;
        }
    }
}

#pragma mark - 处理点击事件
// 忘记密码
- (void)forgetButtonClicked {
    
    [self.view endEditing:YES];
    ZYElectronicSignPasswordForgetVc *vc = [[ZYElectronicSignPasswordForgetVc alloc] init];
    vc.typeStr = self.typeStr;
    [self pushVc:vc];
}

// 确认修改
- (void)okButtonClicked {
    
    NSLog(@"确认修改");
    [self.view endEditing:YES];
    if (self.oldPWStr.length > 0) {
        if (self.pwStr.length > 0) {
            if (self.verifyPWStr.length > 0) {
                if (self.pwStr.length == 6) {
                    if ([self.pwStr isEqualToString:self.verifyPWStr]) {
                        
                        [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"修改中..."];
                        if ([self.typeStr isEqual:@"支付密码"]) {
                            [self initPayPasswordChangedData];
                        }else {
                            [self initContractUpdateSignPasswordData];
                        }
                    }else {
                        
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"密码不一致!" toView:self.view];
                    }
                }else {
                    
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"密码长度为6" toView:self.view];
                }
            }else {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"确认密码不能为空!" toView:self.view];
            }
        }else {
            
            [ZYProgressHUDTool showCustomHUDTextMessage:@"新密码不能为空!" toView:self.view];
        }
    }else {
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"旧密码不能为空!" toView:self.view];
    }
}


@end
