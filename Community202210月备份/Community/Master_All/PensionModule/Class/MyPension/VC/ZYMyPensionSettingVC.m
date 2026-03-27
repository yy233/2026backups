//
//  ZYMyPensionSettingVC.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYMyPensionSettingVC.h"
#import "ZYMyPensionSettingCell.h"

static NSString * const myPensionSettingCellID = @"ZYMyPensionSettingCell";
#define kMyPensionSettingCellHeight 200

@interface ZYMyPensionSettingVC () <UITableViewDataSource, UITableViewDelegate, ZYMyPensionSettingCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYMyPensionSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";
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
    [self.tableView registerNib:[UINib nibWithNibName:myPensionSettingCellID bundle:nil] forCellReuseIdentifier:myPensionSettingCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMyPensionSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:myPensionSettingCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kMyPensionSettingCellHeight;
}

#pragma mark - ZYMyPensionSettingCellDelegate
// 消息提醒
- (void)remindSwitchEvent:(UISwitch *)sender {
    
    NSLog(@"消息提醒");
}

// 开启震动
- (void)shakeSwitchEvent:(UISwitch *)sender {
    
    NSLog(@"开启震动");
}

@end
