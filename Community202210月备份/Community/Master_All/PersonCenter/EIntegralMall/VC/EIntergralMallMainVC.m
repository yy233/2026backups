//
//  EIntergralMallVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
// E币商城 主页

#import "EIntergralMallMainVC.h"
#define  Color_NavBack    Y_ColorWith16FromRGB(0x25283B)
//
#import "EIntergralMallVcHeaderView.h"
#define  EIntergralMallVcHeaderView_Identifier                       @"EIntergralMallVcHeaderView"
#define  EIntergralMallVcTextSectionHeaderView_Identifier            @"EIntergralMallVcTextSectionHeaderView"
//
#import "EIntergralMallVcCollectionViewCell.h"
#define  EIntergralMallVcCollectionViewCell_Identifier               @"EIntergralMallVcCollectionViewCell"
#define  EIntergralMallVcTextAndBtnSectionHeaderView_Identifier      @"EIntergralMallVcTextAndBtnSectionHeaderView"
//
#import "EIntergralMallShopVC.h"
#import "EIntergralMallOrderVC.h"
#import "EIntergralMallGoodsDatailVC.h"
#import "EIntergralMallMingXiListVC.h"

@interface EIntergralMallMainVC ()  <UICollectionViewDelegate,UICollectionViewDataSource,EIntergralMallVcHeaderViewDelegate>
@property (nonatomic,strong) EIntergralMallVcHeaderView *headerView;
@end

@implementation EIntergralMallMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的E币";
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor:Color_NavBack];
}

- (void)initView{
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}
- (void)initData{
//    dataSourceArr
}
#pragma mark ==
- (void)headerViewTouchMingXiAction{
    DLog(@"e明细");
//    Y_SVP_SHOW_INFO_MES(@"e明细");
    EIntergralMallMingXiListVC *vc = [[EIntergralMallMingXiListVC alloc]init];
    [self pushVc:vc];
}
- (void)headerViewTouchEMallAction{
    DLog(@"e商城");
//    Y_SVP_SHOW_INFO_MES(@"e商城");
    EIntergralMallShopVC *vc= [[EIntergralMallShopVC alloc]init];
    [self pushVc:vc];
}
- (void)headerViewTouchEOrderAction{
    DLog(@"e订单");
//    Y_SVP_SHOW_INFO_MES(@"e订单");
    EIntergralMallOrderVC *vc = [[EIntergralMallOrderVC alloc]init];
    [self pushVc:vc];
}

#pragma mark ==
- (NSMutableArray *)dataSourceArr{
   if (!_dataSourceArr) {
       _dataSourceArr = [[NSMutableArray alloc]init];
   }
   return _dataSourceArr;
}

#pragma mark ==
- (EIntergralMallVcHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[EIntergralMallVcHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-40)/2, 200);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        flowLayout.headerReferenceSize = CGSizeMake(Screen_W-32, 1);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = Color_245Gray;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EIntergralMallVcHeaderView_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EIntergralMallVcTextSectionHeaderView_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:EIntergralMallVcTextAndBtnSectionHeaderView_Identifier];
        [_collectionView registerClass:[EIntergralMallVcCollectionViewCell class] forCellWithReuseIdentifier: EIntergralMallVcCollectionViewCell_Identifier];
    }
    return _collectionView;
}


#pragma mark -------------
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 7;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EIntergralMallVcCollectionViewCell *cell = (EIntergralMallVcCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EIntergralMallVcCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.titleL.text = @"Beats头戴试耳机抽奖";
    cell.imgV.image = [UIImage imageNamed:@"Ecoin_Product_one"];
    cell.eNumL.text = @"200";
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //___
    if (indexPath.section==0) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:EIntergralMallVcHeaderView_Identifier   forIndexPath:indexPath];
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section==0) {
            self.headerView.eNumL.text = @"30";
            [view addSubview:self.headerView];
        }
        return view;
    }else{
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:EIntergralMallVcTextSectionHeaderView_Identifier   forIndexPath:indexPath];
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UILabel *sectionTextL = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 40)];
            sectionTextL.textAlignment = NSTextAlignmentLeft;
            sectionTextL.textColor = [UIColor blackColor];
            sectionTextL.font = FontSize_MoneyWallet_Bold(19);
            sectionTextL.text = @"E币兑福利";
            [view addSubview:sectionTextL];
        }
        return view;
    }
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(Screen_W, 200);//header
    }else{
        return CGSizeMake(Screen_W-32, 40);//文本header
    }

}
#pragma mark -------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
    //详情
    EIntergralMallGoodsDatailVC *vc = [[EIntergralMallGoodsDatailVC alloc]init];
//    vc.detailId = ;
    [self pushVc:vc];
}
 

@end
