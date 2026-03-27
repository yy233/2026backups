//
//  ZYMedicalMainServiceVC.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYMedicalMainServiceVC.h"
#import "ZYMedicalMainNearServiceCell.h"

#import "MedicalShopRelatedData.h"
#import "MedicalWebViewVc.h"

static NSString * const medicalMainNearServiceCellID = @"ZYMedicalMainNearServiceCell";
#define kMedicalMainNearServiceCellHeight 117

@interface ZYMedicalMainServiceVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation ZYMedicalMainServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多服务";
    [self setUI];
    [self customTableView];
    [self addRefresh];
    [self initData];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据

- (void)initData {
    self.pageNum = 1;
    WEAKSELF
    [MedicalShopRelatedData getMedicalNearTheServiceFirstPageNumWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray: [MedicalServiceBaseModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count>=Y_PAGE_SIZE) {
                weakSelf.tableView.mj_footer.hidden = NO;
                weakSelf.pageNum += 1;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)moreData{
    WEAKSELF
    [MedicalShopRelatedData getMedicalNearTheServiceWithPageNum:self.pageNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
        });
        if (success) {
            [weakSelf.dataArray addObjectsFromArray: [MedicalServiceBaseModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count>=Y_PAGE_SIZE) {
                weakSelf.tableView.mj_footer.hidden = NO;
                weakSelf.pageNum += 1;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:medicalMainNearServiceCellID bundle:nil] forCellReuseIdentifier:medicalMainNearServiceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYMedicalMainNearServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalMainNearServiceCellID forIndexPath:indexPath];
    [cell fillDataWithServiceModel:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kMedicalMainNearServiceCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"服务%ld", indexPath.row);
    MedicalServiceBaseModel  *serviceModel = self.dataArray[indexPath.row];
    MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
    vc.selfInitType = MedicalWebViewVc_ShowInitType_ServicesDetail;
    vc.serviceIdStr = [NSString stringWithFormat:@"%ld",(long)serviceModel.ID];
    vc.serviceType = serviceModel.type;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

@end
