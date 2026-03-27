//
//  ZYLifeCostPaymentAgreementVC.m
//  Community
//
//  Created by ZY on 2022/1/11.
//

#import "ZYLifeCostPaymentAgreementVC.h"
#import "ZYLifeCostPaymentAgreementCell.h"

static NSString * const lifeCostPaymentAgreementCellID = @"ZYLifeCostPaymentAgreementCell";

@interface ZYLifeCostPaymentAgreementVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYLifeCostPaymentAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生活缴费服务协议";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
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
    }
    
    return _tableView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:lifeCostPaymentAgreementCellID bundle:nil] forCellReuseIdentifier:lifeCostPaymentAgreementCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYLifeCostPaymentAgreementCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCostPaymentAgreementCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:lifeCostPaymentAgreementCellID configuration:^(ZYLifeCostPaymentAgreementCell *cell) {
    }];
}

@end
