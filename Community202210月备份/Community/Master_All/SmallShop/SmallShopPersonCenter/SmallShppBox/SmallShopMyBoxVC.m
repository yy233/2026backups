//
//  SmallShopMyBoxVC.m
//  Community
//
//  Created by 余莹 on 2022/3/9.
//

#import "SmallShopMyBoxVC.h"
#import "SmallShopMyBoxCollectionViewCell.h"
#import "ZYSmallShopContainerRentPayVc.h"
#define  data_records_Key                 @"records"

#define kMyBoxCollectionViewCell_W    (kScreenW-46)/2.0
#define kMyBoxCollectionViewCell_H    (60+113+(kScreenW-46)/2.0*102.0/145.0)   //102.0/145.0  图片宽高比
 

@interface SmallShopMyBoxVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SmallShopMyBoxVC
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的货柜";//货柜租用
    
    [self setUI];
    [self customCollectionView];
    [self addRefresh];
    [self initAllList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    
    return _collectionView;
}
#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SmallShopMyBoxCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:SmallShopMyBoxCollectionViewCell_I];

}

#pragma mark - 加载数据
- (void)initData {
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    for (int i = 0; i < 10; i++) {
        [self.dataArray addObject:@""];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SmallShopMyBoxCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SmallShopMyBoxCollectionViewCell_I forIndexPath:indexPath];
   WEAKSELF
    SmallShopMyBoxModel *model = self.dataArray[indexPath.row];
    cell.cellSubAddDayBtnBlock = ^{
        [weakSelf addDayWithOneBoxInfo:model];
    };
    [cell fillDataWithBoxModel: model];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"我的货柜:%ld", indexPath.row);
     
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kMyBoxCollectionViewCell_W, kMyBoxCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 16, 20, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 13;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 13;
}

#pragma mark  ==== 续约
- (void)addDayWithOneBoxInfo:(SmallShopMyBoxModel  *)model{
    DLog(@"续租 boxid= %@",model.cabinetId);
    if (model.cabinetId.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"货柜数据有误！暂不可续租。");
        return;
    }
    [self willContainerRentWithDataWithCabinetId:model.cabinetId];
 
}
#pragma mark - 续租类型的详情数据
- (void)willContainerRentWithDataWithCabinetId:(NSString *)cabinetId{
    WEAKSELF
    Y_SVP_SHOW_MES_5Delay(@"正在加载...");
    NSDictionary *params = @{@"cabinetId" : cabinetId};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopContainerDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{ 
            Y_SVP_DISMISS
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYSmallShopContainerRentDetailModel *model = [ZYSmallShopContainerRentDetailModel yy_modelWithJSON:responsObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZYSmallShopContainerRentPayVc *vc = [[ZYSmallShopContainerRentPayVc alloc] init];
                    vc.isRelet = YES;
                    vc.model = model;
                    [weakSelf pushVc:vc];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

#pragma mark  ==== allListData
#pragma mark ==

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initAllList)];
     self.collectionView.mj_header = headeerRefresh;
}
//当前小区全部柜子
- (void)initAllList{
    NSDictionary *parms = @{
        @"page":@(1),
        @"size":@(99999),
        @"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)
    };
    
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(@"order/selectOrderByPage")  withBody:parms.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                weakSelf.dataArray = [NSMutableArray arrayWithArray: [SmallShopMyBoxModel mj_objectArrayWithKeyValuesArray:getArrs]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                    if (getArrs.count==0) {
                        Y_SVP_SHOW_SUCCESS_MES(@"暂无数据");
                    }else{
                        Y_SVP_SHOW_SUCCESS_MES(@"查询成功");
                    }
                });
                
            }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Y_SVP_SHOW_ERR_MESSAGE
                    });
                }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
}





#pragma mark == 如果有tableview  则需要处理空数据时的占位背景图片
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self emptyInfoInit];
}
#pragma mark ==  无数据占位 协议
- (void)emptyInfoInit{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UICollectionView class]]) {
            self.collectionView  = (UICollectionView *)subview;
           // NSLog(@"baseVc 内views 有 UITableView ");
            if (isNotNil(self.collectionView)) {
                self.collectionView.emptyDataSetSource = self;
                self.collectionView.emptyDataSetDelegate = self;
                [self.collectionView reloadData];//vc的子tableView 初始时若没有刷新 就没有初始有数据且数据row=0时的图片文字。
                NSLog(@"baseVc 内views  collectionView 遵循emptyInfoInit  ");
            }else{
               // NSLog(@"baseVc 内views  UITableView 不遵循emptyInfoInit  ");
            }
        }
    }
   
    
}
#pragma mark - 文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"暂无数据";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:Y_ColorWith16FromRGB(0xf2f2f2)
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
#pragma mark - 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"Nomal_ZeroWidthIcon"];//Nomal_ZeroWidthIcon
}
#pragma mark - 中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    if (isNotNil(self.collectionView)) {
        //return self.collectionView.tableHeaderView.height * 0.5;
        return 0;
    }else{
        return 0;
    }
}
// 是否允许滚动 ｜有数据能正常下拉刷新 空数据时 无法下拉动作 设置yes即可正常
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

#pragma mark -  无数据占位 end
@end
