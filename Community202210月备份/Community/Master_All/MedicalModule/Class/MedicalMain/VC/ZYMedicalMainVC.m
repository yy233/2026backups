//
//  ZYMedicalMainVC.m
//  Community
//
//  Created by ZY on 2021/11/30.
//

#import "ZYMedicalMainVC.h"
#import "ZYMedicalMainShopVC.h"
#import "ZYMedicalMainServiceVC.h"
#import "ZYIntelligentInquirySearchVC.h"
#import "ZYPensionRootTabBarVC.h"
#import "ZYPensionMainVC.h"
#import "ZYFamilyArchiveVC.h"
#import "MedicalWebViewVc.h"

#import "ZYMedicalMainSearchView.h"
#import "ZYMedicalMainTopView.h"
#import "ZYMedicalMainTitleHeaderView.h"
#import "ZYMedicalMainFunctionCell.h"
#import "ZYMedicalMainNearShopCell.h"
#import "ZYMedicalMainNearServiceCell.h"

#import "MedicalShopRelatedData.h"
#import "MedicalStoresBaseModel.h"

static NSString * const medicalMainFunctionCellID = @"ZYMedicalMainFunctionCell";
static NSString * const medicalMainNearShopCellID = @"ZYMedicalMainNearShopCell";
static NSString * const medicalMainNearServiceCellID = @"ZYMedicalMainNearServiceCell";
#define kMedicalMainSearchViewHeight status_height+44
#define kMedicalMainTopViewHeight 150
#define kMedicalMainTitleHeaderViewHeight 45
#define kMedicalMainFunctionCellHeight kServiceCollectionViewCell_H+kHealthCollectionViewCell_H+40
#define kMedicalMainNearShopCellHeight 117
#define kMedicalMainNearServiceCellHeight 117

@interface ZYMedicalMainVC () <UITableViewDataSource, UITableViewDelegate, ZYMedicalMainSearchViewDelegate, ZYMedicalMainTopViewDelegate, ZYMedicalMainFunctionCellDelegate>

@property (nonatomic, strong) ZYMedicalMainSearchView *searchView;

@property (nonatomic, strong) ZYMedicalMainTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *shopArray;

@property (nonatomic, strong) NSMutableArray *serviceArray;

@end

@implementation ZYMedicalMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setUI];
    [self customTableView];
    [self initData];
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_searchView.superview);
        make.height.offset(kMedicalMainSearchViewHeight);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kMedicalMainTopViewHeight)];
    bgImageView.image = [UIImage imageNamed:@"yl_toptc"];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:bgImageView];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom);
        make.left.right.equalTo(bgView.superview);
        make.height.offset(kMedicalMainTopViewHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYMedicalMainSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"ZYMedicalMainSearchView" owner:nil options:nil].lastObject;
        _searchView.delegate = self;
    }
    
    return _searchView;
}

- (ZYMedicalMainTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYMedicalMainTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)shopArray {
    if (!_shopArray) {
        _shopArray = [NSMutableArray array];
    }
    
    return _shopArray;
}

- (NSMutableArray *)serviceArray {
    if (!_serviceArray) {
        _serviceArray = [NSMutableArray array];
    }
    
    return _serviceArray;
}

#pragma mark - 加载数据
- (void)initData {
    
    WEAKSELF
    [MedicalShopRelatedData getMedicalShopOnlyMinNumCountWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.shopArray = [MedicalStoresBaseModel mj_objectArrayWithKeyValuesArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    [MedicalShopRelatedData getMedicalNearTheServiceMinNumCountWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.serviceArray = [MedicalServiceBaseModel mj_objectArrayWithKeyValuesArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:medicalMainFunctionCellID bundle:nil] forCellReuseIdentifier:medicalMainFunctionCellID];
    [self.tableView registerNib:[UINib nibWithNibName:medicalMainNearShopCellID bundle:nil] forCellReuseIdentifier:medicalMainNearShopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:medicalMainNearServiceCellID bundle:nil] forCellReuseIdentifier:medicalMainNearServiceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        
        return self.shopArray.count;
    }else if (section == 2) {
        
        return self.serviceArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYMedicalMainFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalMainFunctionCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1) {
        ZYMedicalMainNearShopCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalMainNearShopCellID forIndexPath:indexPath];
        [cell fillDataWithStoreShopModel:self.shopArray[indexPath.row]];
        return cell;
    }else if (indexPath.section == 2) {
        ZYMedicalMainNearServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalMainNearServiceCellID forIndexPath:indexPath];
        [cell fillDataWithServiceModel:self.serviceArray[indexPath.row]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return kMedicalMainFunctionCellHeight;
    }else if (indexPath.section == 1) {
        
        return kMedicalMainNearShopCellHeight;
    }else if (indexPath.section == 2) {
        
        return kMedicalMainNearServiceCellHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.topView;
    }else if (section == 1) {
        ZYMedicalMainTitleHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYMedicalMainTitleHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"附近商铺";
        [headerView.moreButton addTarget:self action:@selector(shopMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    }else if (section == 2) {
        ZYMedicalMainTitleHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ZYMedicalMainTitleHeaderView" owner:nil options:nil].lastObject;
        headerView.titleLabel.text = @"附近服务";
        [headerView.moreButton addTarget:self action:@selector(serviceMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return headerView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return kMedicalMainTopViewHeight;
    }else if (section == 1) {
        
        return kMedicalMainTitleHeaderViewHeight;
    }else if (section == 2) {
        
        return kMedicalMainTitleHeaderViewHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        
        return 20;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSLog(@"商铺%ld", indexPath.row);
        MedicalStoresBaseModel *storeModel = self.shopArray[indexPath.row];
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_StoreDetail;
        vc.shopNameStr = [TextShowWithModelStr textShowWithNotNullStr:storeModel.shopName];
        vc.shopIdStr = [NSString stringWithFormat:@"%ld",(long)storeModel.ID];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];

    }else if (indexPath.section == 2) {
        NSLog(@"服务%ld", indexPath.row);
        MedicalServiceBaseModel  *serviceModel = self.serviceArray[indexPath.row];
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_ServicesDetail;
        vc.serviceIdStr = [NSString stringWithFormat:@"%ld",(long)serviceModel.ID];
        vc.serviceType = serviceModel.type;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

#pragma mark - ZYMedicalMainSearchViewDelegate
// 返回
- (void)backButtonEvent {
    
    NSLog(@"返回");
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

// 搜索
- (void)searchContentViewEvent {
    
    NSLog(@"搜索");
    ZYIntelligentInquirySearchVC *vc = [[ZYIntelligentInquirySearchVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark - ZYMedicalMainTopViewDelegate
// 立即查看
- (void)showButtonEvent {
    
    NSLog(@"立即查看");
}

#pragma mark - ZYMedicalMainFunctionCellDelegate
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            NSLog(@"医疗服务");
            MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
            vc.selfInitType = MedicalWebViewVc_ShowInitType_MedicalServices;
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }else if (indexPath.row == 1) {
            
            NSLog(@"家人档案");
            ZYFamilyArchiveVC *vc = [[ZYFamilyArchiveVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }else if (indexPath.row == 2) {
            
            NSLog(@"健康数据");
            for (UIViewController *tempVc in self.tabBarController.navigationController.viewControllers) {
                if ([tempVc isKindOfClass:[ZYPensionMainVC class]]) {
                    ZYPensionMainVC *mainVc = (ZYPensionMainVC *)tempVc;
                    mainVc.isSwitHealthData = YES;
                    [self.tabBarController.navigationController popToViewController:mainVc animated:YES];
                    return;
                }
            }
            ZYPensionRootTabBarVC *vc = [[ZYPensionRootTabBarVC alloc] init];
            vc.selectedIndex = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }else if (indexPath.row == 3) {
            
            NSLog(@"推荐产品");
            MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
            vc.selfInitType = MedicalWebViewVc_ShowInitType_MallGoods;
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            NSLog(@"去参加");
            for (UIViewController *tempVc in self.tabBarController.navigationController.viewControllers) {
                if ([tempVc isKindOfClass:[ZYPensionMainVC class]]) {
                    [self.tabBarController.navigationController popToViewController:tempVc animated:YES];
                    return;
                }
            }
            ZYPensionRootTabBarVC *vc = [[ZYPensionRootTabBarVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }else if (indexPath.row == 1) {
            
            NSLog(@"去填写");
            MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
            vc.selfInitType = MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation;
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
    }
}

#pragma mark - 处理点击事件
// 更多商铺
- (void)shopMoreButtonClicked {
    
    NSLog(@"更多商铺");
    ZYMedicalMainShopVC *vc = [[ZYMedicalMainShopVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

// 更多服务
- (void)serviceMoreButtonClicked {
    
    NSLog(@"更多服务");
    ZYMedicalMainServiceVC *vc = [[ZYMedicalMainServiceVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

@end
