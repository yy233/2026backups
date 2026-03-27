//
//  ZYFamilyArchiveVC.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveVC.h"
#import "ZYAddFamilyArchiveVC.h"
#import "ZYFamilyArchiveInfoVC.h"
#import "ZYMedicalCustomVC.h"
#import "MedicalWebViewVc.h"
#import "ZYFamilyArchiveBottomView.h"
#import "ZYFamilyArchiveCollectionViewCell.h"

static NSString * const familyArchiveCollectionViewCellID = @"ZYFamilyArchiveCollectionViewCell";
#define kFamilyArchiveBottomViewHeight button_bottom_height+75
#define kFamilyArchiveCollectionViewCell_W (kScreenW-65)/3.0
#define kFamilyArchiveCollectionViewCell_H 160

@interface ZYFamilyArchiveVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZYFamilyArchiveBottomViewDelegate>

@property (nonatomic, strong) ZYFamilyArchiveBottomView *bottomView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYFamilyArchiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家人档案";
    [self rightBarButtonItemCustom];
    [self setUI];
    [self customCollectionView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_FAMILY_BACK", addFamilyBack)
}

// 通知回调
- (void)addFamilyBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header beginRefreshing];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_FAMILY_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithSOSColor];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    navRightBtn.frame = CGRectMake(0, 0, 30, 40);
    [navRightBtn setImage:[UIImage imageNamed:@"yl_tianj"] forState:UIControlStateNormal];
    navRightBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kFamilyArchiveBottomViewHeight);
    }];
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_collectionView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYFamilyArchiveBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYFamilyArchiveBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:familyArchiveCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:familyArchiveCollectionViewCellID];
}

#pragma mark - 加载数据
- (void)initData {
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kFamilyListUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (self.dataArray.count > 0) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = [NSArray yy_modelArrayWithClass:[ZYFamilyArchiveModel class] json:responsObject[@"data"]];
                [self.dataArray addObjectsFromArray:array];
                [self.collectionView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYFamilyArchiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:familyArchiveCollectionViewCellID forIndexPath:indexPath];
    cell.infoButton.tag = 200 + indexPath.row;
    [cell.infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ZYFamilyArchiveModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kFamilyArchiveCollectionViewCell_W, kFamilyArchiveCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(16, 16, 16, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 16;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 16;
}

#pragma mark - ZYFamilyArchiveBottomViewDelegate
// 社区医疗需求定制
- (void)medicalCustomButtonEvent {
    
    NSLog(@"社区医疗需求定制");
//    ZYMedicalCustomVC *vc = [[ZYMedicalCustomVC alloc] init];
//    [self pushVc:vc];
    MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
    vc.selfInitType = MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation;
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
// 添加
- (void)navRightBtnAction {
    
    NSLog(@"添加");
    ZYAddFamilyArchiveVC *vc = [[ZYAddFamilyArchiveVC alloc] init];
    [self pushVc:vc];
}

// 完善信息
- (void)infoButtonClicked:(UIButton *)sender {
    
    NSLog(@"完善信息 %ld", sender.tag - 200);
    NSInteger index = sender.tag - 200;
    ZYFamilyArchiveModel *model = self.dataArray[index];
    ZYFamilyArchiveInfoVC *vc = [[ZYFamilyArchiveInfoVC alloc] init];
    vc.familyArchiveModel = model;
    [self pushVc:vc];
}

@end
