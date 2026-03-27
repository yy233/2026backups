//
//  ZYElectronicSignAboutVc.m
//  Community
//
//  Created by ZY on 2021/5/25.
//

#import "ZYElectronicSignAboutVc.h"
#import "ZYElectronicSignAboutCell.h"

static NSString * const electronicSignAboutCellID = @"ZYElectronicSignAboutCell";
#define kElectronicSignAboutCellHeight (415 + (kScreenW - 24) * 216 / 353)

@interface ZYElectronicSignAboutVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ZYElectronicSignAboutVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于电子签章";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYElectronicSignAboutCell" bundle:nil] forCellReuseIdentifier:electronicSignAboutCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYElectronicSignAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicSignAboutCellID forIndexPath:indexPath];
    [cell.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kElectronicSignAboutCellHeight;
}

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    
    [self popVC];
}

@end
