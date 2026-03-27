//
//  ZYPensionAboutUsVC.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYPensionAboutUsVC.h"
#import "ZYPensionAboutUsCell.h"

static NSString * const pensionAboutUsCellID = @"ZYPensionAboutUsCell";

@interface ZYPensionAboutUsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYPensionAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
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

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:pensionAboutUsCellID bundle:nil] forCellReuseIdentifier:pensionAboutUsCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYPensionAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionAboutUsCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
//    ZYPensionAboutUsCell *cell = (ZYPensionAboutUsCell *)currentCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:pensionAboutUsCellID configuration:^(ZYPensionAboutUsCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

@end
