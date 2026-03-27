//
//  ZYElectronicSignPasswordSettingVc.m
//  Community
//
//  Created by ZY on 2021/7/5.
//

#import "ZYElectronicSignPasswordSettingVc.h"
#import "ZYElectronicSignPasswordSettingCell.h"

static NSString * const electronicSignPasswordSettingCellID = @"ZYElectronicSignPasswordSettingCell";
#define kElectronicSignPasswordSettingCellHeight 350

@interface ZYElectronicSignPasswordSettingVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, copy) NSString *pwStr;

@property (nonatomic, copy) NSString *verifyPWStr;

@end

@implementation ZYElectronicSignPasswordSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.typeStr isEqual:@"支付密码"]) {
        self.title = @"设置支付密码";
    }else {
        self.title = @"设置签署密码";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYElectronicSignPasswordSettingCell" bundle:nil] forCellReuseIdentifier:electronicSignPasswordSettingCellID];
}

#pragma mark - 加载数据
// 设置签约密码数据
- (void)initContractSetSignPasswordData {
    
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"password" : self.pwStr};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractSetSignPasswordUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [ZYProgressHUDTool showCustomHUDTextMessage:@"签约密码设置成功" toView:self.view.window];
                [self popVC];
            }else {
                
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 设置支付密码数据
- (void)initSetPayPasswordData {
    NSDictionary *parms = @{@"payPassword" : self.pwStr, @"confirmPayPassword" : self.verifyPWStr};
    NSLog(@"%@", parms);
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_Set_Password] withBody:parms finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                [ShareUserInfo sharedUserInfo].userInfo.isBindPayPassword = YES;
                [ZYProgressHUDTool showCustomHUDTextMessage:@"支付密码设置成功" toView:self.view.window];
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
    
    ZYElectronicSignPasswordSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicSignPasswordSettingCellID forIndexPath:indexPath];
    if ([self.typeStr isEqual:@"支付密码"]) {
        cell.titleLabel.text = @"请输入6位支付密码，用于确认本人身份";
    }else {
        cell.titleLabel.text = @"请输入6位签署密码，用于确认本人身份";
    }
    cell.pwTF.tag = 100;
    cell.pwTF.delegate = self;
    cell.verifyPWTF.tag = 200;
    cell.verifyPWTF.delegate = self;
    [cell.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kElectronicSignPasswordSettingCellHeight;
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
    }
}

#pragma mark - 处理点击事件
// 确认
- (void)okButtonClicked {
    
    NSLog(@"点击确认");
    [self.view endEditing:YES];
    if (self.pwStr.length > 0) {
        if (self.verifyPWStr.length > 0) {
            if (self.pwStr.length == 6) {
                if ([self.pwStr isEqualToString:self.verifyPWStr]) {
                    
                    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:@"设置中..."];
                    if ([self.typeStr isEqual:@"支付密码"]) {
                        [self initSetPayPasswordData];
                    }else {
                        [self initContractSetSignPasswordData];
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
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"密码不能为空!" toView:self.view];
    }
}

@end
