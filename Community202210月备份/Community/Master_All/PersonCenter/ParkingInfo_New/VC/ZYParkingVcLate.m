//
//  ZYParkingVcLate.m
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import "ZYParkingVcLate.h"
#import "ZYParkingMonthCardVc.h"
#import "ZYParkingCell.h"
#import "PackingPayHistoryVC.h"
#import "ZYCarInvitePayVc.h"
#import "ZYCarInviteVc.h"

static NSString * const ZYParkingCellID = @"ZYParkingCell";
#define kZYParkingCellHeight 170

@interface ZYParkingVcLate () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation ZYParkingVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智能停车";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

#pragma mark - 布局视图
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

- (NSArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = @[@"pa_zntcyueka_icon", @"pa_zntcjfjl_icon"];
//        _imagesArray = @[@"pa_zntcyueka_icon", @"pa_zntcjfjl_icon", @"pa_ltjf_icon"];
    }
    
    return _imagesArray;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"月卡", @"缴费记录"];
//        _titlesArray = @[@"月卡", @"缴费记录", @"临停缴费"];
    }
    
    return _titlesArray;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYParkingCellID bundle:nil] forCellReuseIdentifier:ZYParkingCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYParkingCellID forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    cell.titleLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYParkingCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSLog(@"月卡");
        ZYParkingMonthCardVc *vc = [[ZYParkingMonthCardVc alloc] init];
        [self pushVc:vc];
    }else if (indexPath.row == 1) {
        NSLog(@"缴费记录");
        PackingPayHistoryVC *vc = [[PackingPayHistoryVC alloc]init];
        [self pushVc:vc];
    }
//    else if (indexPath.row == 2) {
//        NSLog(@"临停缴费");
//        ZYCarInvitePayVc *vc = [[ZYCarInvitePayVc alloc] init];
//        [self pushVc:vc];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

@end
