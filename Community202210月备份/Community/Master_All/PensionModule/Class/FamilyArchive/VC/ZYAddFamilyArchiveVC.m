//
//  ZYAddFamilyArchiveVC.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYAddFamilyArchiveVC.h"
#import "ZYLeadFamilyArchiveVC.h"
#import "ZYAddFamilyArchiveCell.h"

static NSString * const addFamilyArchiveCellID = @"ZYAddFamilyArchiveCell";
#define kAddFamilyArchiveCellHeight 430

@interface ZYAddFamilyArchiveVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYAddFamilyArchiveCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *code;

@end

@implementation ZYAddFamilyArchiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加家人";
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"导入" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -16, -8, -16);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
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
    }
    
    return _tableView;
}

#pragma mark - 加载数据
// 新增家人档案
- (void)initAddFamilyData {
    NSDictionary *params = @{@"name" : self.name, @"mobile" : self.tel, @"code" : self.code};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kAddFamilyUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"添加成功" toView:self.view.window];
                // 发送通知
                Y_NSNotificationCenter_PostNotice_NilObject_Name(@"PENSION_ADD_FAMILY_BACK")
                [self popVC];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 获取验证码
- (void)initFamilySendCodeData {
    NSDictionary *params = @{@"mobile" : self.tel};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilySendCodeUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"验证码获取成功");
                    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
                    ZYAddFamilyArchiveCell *cell = (ZYAddFamilyArchiveCell *)[self.tableView cellForRowAtIndexPath:indePath];
                    [cell countdown];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:addFamilyArchiveCellID bundle:nil] forCellReuseIdentifier:addFamilyArchiveCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYAddFamilyArchiveCell *cell = [tableView dequeueReusableCellWithIdentifier:addFamilyArchiveCellID forIndexPath:indexPath];
    cell.nameTF.tag = 200;
    cell.nameTF.delegate = self;
    cell.telTF.tag = 300;
    cell.telTF.delegate = self;
    cell.codeTF.tag = 500;
    cell.codeTF.delegate = self;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kAddFamilyArchiveCellHeight;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (textField.tag == 200) {
        self.name = text;
    }else if (textField.tag == 300) {
        self.tel = text;
    }else if (textField.tag == 500) {
        self.code = text;
    }
}

#pragma mark - ZYAddFamilyArchiveCellDelegate
// 验证码
- (void)codeButtonEvent {
    
    NSLog(@"验证码");
    if (self.tel.length > 0) {
        if ([ZYTextValidationTool validatePhone:self.tel]) {
            [SVProgressHUD showLoadingCustomHUDWithStatus:@"发送中..."];
            [self initFamilySendCodeData];
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号!" toView:self.view];
    }
}

// 添加家人
- (void)addButtonEvent {
    
    NSLog(@"添加家人");
    if (self.name.length > 0) {
        if (self.tel.length > 0) {
            if (self.code.length > 0) {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"添加中..."];
                [self initAddFamilyData];
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入验证码!" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号!" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入姓名!" toView:self.view];
    }
}

#pragma mark - 处理点击事件
// 导入
- (void)navRightBtnAction {
    
    NSLog(@"导入");
    ZYLeadFamilyArchiveVC *vc = [[ZYLeadFamilyArchiveVC alloc] init];
    [self pushVc:vc];
}

@end
