//
//  ZYElectronicNewsCommentsListVc.m
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import "ZYElectronicNewsCommentsListVc.h"
#import "ZYElectronicNewsCommentsListCell.h"
#import "ZYElectronicNewsCommentsListFooterView.h"
#import "ZYCommentsListModel.h"

static NSString * const electronicNewsCommentsListCellID = @"ZYElectronicNewsCommentsListCell";

@interface ZYElectronicNewsCommentsListVc () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightConstraint;

@property (nonatomic, strong) ZYElectronicNewsCommentsListFooterView *commentsListFooterView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, assign) CGFloat duration;

@end

@implementation ZYElectronicNewsCommentsListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论列表";
    [self customTableView];
    self.bottomViewHeightConstraint.constant = bottom_height;
    self.footerView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.bottomView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self.footerView addSubview:self.commentsListFooterView];
    [_commentsListFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_commentsListFooterView.superview);
    }];
    
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        weakSelf.currentPage = 1;
        [weakSelf initCommentListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    // 触底加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        weakSelf.currentPage += 1;
        [weakSelf initCommentListData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
    
    // 注册键盘通知
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (ZYElectronicNewsCommentsListFooterView *)commentsListFooterView {
    if (!_commentsListFooterView) {
        _commentsListFooterView = [[NSBundle mainBundle] loadNibNamed:@"ZYElectronicNewsCommentsListFooterView" owner:nil options:nil].lastObject;
        _commentsListFooterView.frame = CGRectMake(0, 0, kScreenW, 58);
        _commentsListFooterView.contentTextView.delegate = self;
        [_commentsListFooterView.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _commentsListFooterView;
}

#pragma mark - 加载数据
// 评论列表数据
- (void)initCommentListData {
    
    NSDictionary *parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(20), @"informationUuid" : self.detailModel.uuid};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractKnowledgeCommentListUrl withBody:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.dataArray removeAllObjects];
                }
                ZYCommentsListModel *model = [ZYCommentsListModel yy_modelWithJSON:responsObject];
                ZYCommentsListDataModel *dataModel = model.data;
                NSArray *array = dataModel.list;
                self.detailModel.commentNumber = dataModel.total;
                [self.dataArray addObjectsFromArray:array];
                // 判断数据是否加载完了
                if (self.dataArray.count >= dataModel.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                // 刷新tableView
                [self.tableView reloadData];
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 评论数据
- (void)initInsertCommentData {
    
    NSDictionary *params = @{@"content" : self.contentStr, @"informationUuid" : self.detailModel.uuid, @"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractKnowledgeInsertCommentUrl withBody:params finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                self.currentPage = 1;
                [self.tableView.mj_header beginRefreshing];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制UITableView
- (void)customTableView {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 设置单元格自适应
    self.tableView.estimatedRowHeight = 105;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置tableView样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYElectronicNewsCommentsListCell" bundle:nil] forCellReuseIdentifier:electronicNewsCommentsListCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYElectronicNewsCommentsListCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicNewsCommentsListCellID forIndexPath:indexPath];
    if ((self.dataArray.count - 1) == indexPath.row) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    ZYCommentsListDataListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 让输入框失去第一响应
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    // 获取textView的高度
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:textView.font,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width - 10,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dicAttr context:nil].size;
    NSInteger lines = size.height / textView.font.lineHeight;
    CGFloat labelHeight = 0.0;
    if (lines > 4) {
        textView.bounces = YES;
        textView.showsVerticalScrollIndicator = YES;
        textView.scrollEnabled = YES;
        labelHeight = textView.font.lineHeight * 3;
    }else {
        textView.bounces = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.scrollEnabled = NO;
        if (lines > 1) {
            labelHeight = textView.font.lineHeight * (lines - 1);
        }
    }
    [UIView animateWithDuration:self.duration animations:^{
        self.footerViewHeightConstraint.constant = 58 + labelHeight;
        [self.view layoutIfNeeded];
    }];
    
    if (textView.text.length > 0) {
        self.commentsListFooterView.placeholderLabel.hidden = YES;
    }else {
        self.commentsListFooterView.placeholderLabel.hidden = NO;
    }
    self.contentStr = textView.text;
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
    self.duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //输入框位置动画加载
    [UIView animateWithDuration:self.duration animations:^{
        self.bottomViewHeightConstraint.constant = keyboardSize.height;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {

    NSDictionary *info = [aNotification userInfo];
    self.duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:self.duration animations:^{
        self.bottomViewHeightConstraint.constant = bottom_height;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 处理点击事件
- (void)submitButtonClicked {
    
    // 让输入框失去第一响应
    [self.view endEditing:YES];
    
    // 去除字符串空格和换行
    self.contentStr = [self.contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.contentStr = [self.contentStr stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    if (self.contentStr.length > 0) {
        self.commentsListFooterView.contentTextView.text = @"";
        self.commentsListFooterView.placeholderLabel.hidden = NO;
        [UIView animateWithDuration:self.duration animations:^{
            self.footerViewHeightConstraint.constant = 58;
            [self.view layoutIfNeeded];
        }];
        [self.view reloadInputViews];
        
        [self initInsertCommentData];
    }else {
        self.commentsListFooterView.contentTextView.text = @"";
        self.commentsListFooterView.placeholderLabel.hidden = NO;
        [UIView animateWithDuration:self.duration animations:^{
            self.footerViewHeightConstraint.constant = 58;
            [self.view layoutIfNeeded];
        }];
        [self.view reloadInputViews];
        
        [ZYProgressHUDTool showCustomHUDTextMessage:@"发表内容不能为空!" toView:self.view];
    }
}

@end
