//
//  ZYMyMedicalVC.m
//  Community
//
//  Created by ZY on 2021/11/30.
//

#import "ZYMyMedicalVC.h"
#import "ZYMedicalAboutUsVC.h"
#import "MyHistoryDevListVc.h"
#import "ZYFamilyArchiveVC.h"
#import "MedicalWebViewVc.h"
#import "MainAllTypeInformationVC.h"
#import "ZYMyMedicalTopView.h"
#import "ZYMyMedicaCell.h"

static NSString * const myMedicaCellID = @"ZYMyMedicaCell";
#define kMyMedicalTopViewHeight status_height+140
#define kMyMedicaCellHeight 66

@interface ZYMyMedicalVC () <UITableViewDataSource, UITableViewDelegate, ZYMyMedicalTopViewDelegate>

@property (nonatomic, strong) ZYMyMedicalTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYMyMedicalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kMyMedicalTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYMyMedicalTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYMyMedicalTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    NSArray *iconImageNameArray = @[@"yl_wddd", @"yl_device", @"yl_jiaren", @"yl_gywm"];
    NSArray *titleArray = @[@"我的订单", @"我的设备", @"家人档案", @"关于我们"];
    for (int i = 0; i < iconImageNameArray.count; i++) {
        ZYMyMedicaModel *model = [[ZYMyMedicaModel alloc] init];
        model.iconImageName = iconImageNameArray[i];
        model.title = titleArray[i];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:myMedicaCellID bundle:nil] forCellReuseIdentifier:myMedicaCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMyMedicaCell *cell = [tableView dequeueReusableCellWithIdentifier:myMedicaCellID forIndexPath:indexPath];
    ZYMyMedicaModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kMyMedicaCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        NSLog(@"我的订单");
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_MyOrder;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 1) {
        
        NSLog(@"我的设备");
        MyHistoryDevListVc *vc = [[MyHistoryDevListVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 2) {
        
        NSLog(@"家人档案");
        ZYFamilyArchiveVC *vc = [[ZYFamilyArchiveVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (indexPath.row == 3) {
        
        NSLog(@"关于我们");
        ZYMedicalAboutUsVC *vc = [[ZYMedicalAboutUsVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

#pragma mark - ZYMyMedicalTopViewDelegate
- (void)backButtonEvent {
    
    NSLog(@"返回");
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

// 消息
- (void)messageButtonEvent {
    
    NSLog(@"消息");
    MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

@end
