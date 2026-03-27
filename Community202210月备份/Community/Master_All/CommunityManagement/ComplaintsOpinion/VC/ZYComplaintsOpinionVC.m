//
//  ZYComplaintsOpinionVC.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYComplaintsOpinionVC.h"
#import "ZYComplaintsOpinionCompleteVC.h"
#import "ZYComplaintsOpinionMyAdviceVC.h"
#import "ZYComplaintsOpinionCell.h"

static NSString * const complaintsOpinionCellID = @"ZYComplaintsOpinionCell";

#define kComplaintsOpinionCellHeight 450

@interface ZYComplaintsOpinionVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, copy) NSString *telStr;

@end

@implementation ZYComplaintsOpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投诉建议";
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"我的建议" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
- (void)initData {
    NSDictionary *params = @{@"content" : self.contentStr, @"phone" : self.telStr, @"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, kAddComplaintsOpinionUrl] withBody:params finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYComplaintsOpinionCompleteVC *vc = [[ZYComplaintsOpinionCompleteVC alloc] init];
                [self pushVc:vc];
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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYComplaintsOpinionCell" bundle:nil] forCellReuseIdentifier:complaintsOpinionCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYComplaintsOpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:complaintsOpinionCellID forIndexPath:indexPath];
    cell.textView.delegate = self;
    cell.telTF.delegate = self;
    [cell.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kComplaintsOpinionCellHeight;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.contentStr = textView.text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    self.telStr = textField.text;
}

#pragma mark - 点击事件
// 我的建议
- (void)navRightBtnAction {
    
    NSLog(@"我的建议");
    [self.view endEditing:YES];
    ZYComplaintsOpinionMyAdviceVC *vc = [[ZYComplaintsOpinionMyAdviceVC alloc] init];
    [self pushVc:vc];
}

// 提交
- (void)submitButtonClicked {
    
    NSLog(@"提交");
    if (self.contentStr.length > 0) {
        if (self.telStr.length > 0) {
            if ([ZYTextValidationTool validatePhone:self.telStr]) {
                [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
                [self initData];
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"手机格式不正确，请重新填写!" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入手机号" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入评价内容" toView:self.view];
    }
}

@end
