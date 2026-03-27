//
//  ZYDigitalCerDetailVC.m
//  Community
//
//  Created by ZY on 2021/6/1.
//

#import "ZYDigitalCerDetailVC.h"
#import "ZYDigitalCerDetailTopCell.h"
#import "ZYDigitalCerDetailCell.h"
#import "ZYDigitalCerDetailBottomCell.h"

static NSString * const digitalCerDetailTopCellID = @"ZYDigitalCerDetailTopCell";
static NSString * const digitalCerDetailCellID = @"ZYDigitalCerDetailCell";
static NSString * const digitalCerDetailBottomCellID = @"ZYDigitalCerDetailBottomCell";
#define kDigitalCerDetailTopCellHeight 200
#define kDigitalCerDetailCellHeight 60
#define kDigitalCerDetailBottomCellHeight 90

@interface ZYDigitalCerDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation ZYDigitalCerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"用户证书信息";
    [self setupNavigationBarWhiteStyle];
    
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    
    return _titleArray;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    
    return _contentArray;
}

#pragma mark - 加载数据
- (void)initData {
    
    [self.titleArray addObjectsFromArray:@[@"颁发给 :", @"颁发者 :", @"证件号 :", @"证书序列号 :", @"证书有效期 :"]];
    [self.contentArray addObjectsFromArray:@[[ShareUserInfo sharedUserInfo].userInfo.realName, @"CFCA", @"685**********0021", @"608112315753424", @"2021/01/27/-2026/01/27"]];
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYDigitalCerDetailTopCell" bundle:nil] forCellReuseIdentifier:digitalCerDetailTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYDigitalCerDetailCell" bundle:nil] forCellReuseIdentifier:digitalCerDetailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYDigitalCerDetailBottomCell" bundle:nil] forCellReuseIdentifier:digitalCerDetailBottomCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return self.titleArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYDigitalCerDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:digitalCerDetailTopCellID forIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.section == 1) {
        ZYDigitalCerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:digitalCerDetailCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.contentLabel.text = self.contentArray[indexPath.row];
        
        return cell;
    }else {
        ZYDigitalCerDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:digitalCerDetailBottomCellID forIndexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kDigitalCerDetailTopCellHeight;
    }else if (indexPath.section == 1) {
        
        return kDigitalCerDetailCellHeight;
    }else {
        
        return kDigitalCerDetailBottomCellHeight;
    }
}

@end
