//
//  ZYMedicalAboutUsVC.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYMedicalAboutUsVC.h"
#import "ZYMedicalAboutUsCell.h"

static NSString * const medicalAboutUsCellID = @"ZYMedicalAboutUsCell";

@interface ZYMedicalAboutUsVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYMedicalAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navigationBarWhiteStyleWithColorChanged:[UIColor zy_colorWithHexString:@"#F0F1F6"]];
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
    self.tableView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:medicalAboutUsCellID bundle:nil] forCellReuseIdentifier:medicalAboutUsCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMedicalAboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalAboutUsCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:medicalAboutUsCellID configuration:^(ZYMedicalAboutUsCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

@end
