//
//  ZYIntelligentInquiryVC.m
//  Community
//
//  Created by ZY on 2021/11/30.
//

#import "ZYIntelligentInquiryVC.h"
#import "ZYIntelligentInquirySearchVC.h"
#import "ZYIntelligentInquiryTopView.h"
#import "ZYIntelligentInquiryCell.h"

static NSString * const intelligentInquiryCellID = @"ZYIntelligentInquiryCell";
#define kIntelligentInquiryTopViewHeight 44+status_height

@interface ZYIntelligentInquiryVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ZYIntelligentInquiryCellDelegate, ZYIntelligentInquiryTopViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYIntelligentInquiryTopView *topView;

@end

@implementation ZYIntelligentInquiryVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setupNavigationBarClearTransparentStyle];
    
    self.title = @"";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kIntelligentInquiryTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYIntelligentInquiryTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYIntelligentInquiryTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:intelligentInquiryCellID bundle:nil] forCellReuseIdentifier:intelligentInquiryCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYIntelligentInquiryCell *cell = [tableView dequeueReusableCellWithIdentifier:intelligentInquiryCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYIntelligentInquiryCell *cell = (ZYIntelligentInquiryCell *)currentCell;
    cell.delegate = self;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:intelligentInquiryCellID configuration:^(ZYIntelligentInquiryCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

#pragma mark - ZYIntelligentInquiryCellDelegate
// 皮肤
- (void)pfViewEvent {
    
    NSLog(@"皮肤");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"皮肤";
    [self pushVc:vc];
}

// 康复
- (void)kfViewEvent {
    
    NSLog(@"康复");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"康复";
    [self pushVc:vc];
}

// 口腔
- (void)kqViewEvent {
    
    NSLog(@"口腔");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"口腔";
    [self pushVc:vc];
}

// 体检
- (void)tjViewEvent {
    
    NSLog(@"体检");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"体检";
    [self pushVc:vc];
}

// 儿童
- (void)rtViewEvent {
    
    NSLog(@"儿童");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"儿童";
    [self pushVc:vc];
}

// 中医
- (void)zyViewEvent {
    
    NSLog(@"中医");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"中医";
    [self pushVc:vc];
}

// 语音
- (void)recordButtonEvent {
    
    NSLog(@"语音");
    // 是否有麦克风权限
    if (![[ZYAuthorizationManager sharedManager] requestAuthorization:KAVAudioSession presentVc:self]) {
        return;
    }
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.searchStr = @"";
    vc.isRecord = YES;
    [self pushVc:vc];
}

#pragma mark - ZYIntelligentInquiryTopViewDelegate
- (void)backButtonEvent {
    [self popVC];
}

@end
