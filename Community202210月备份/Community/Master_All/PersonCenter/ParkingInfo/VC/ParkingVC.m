//
//  ParkingVC.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingVC.h"
#import "ParkingTemporaryVC.h"
#import "ParkingTemporaryVCLate.h"
#import "ParkingMonthlyTenancyVC.h"
#import "ParkingPayInfoVC.h"

#import "ZYParkingTemporaryVC.h"

//
#import "ParkingVcCollectionViewCell.h"
#define  ParkingVcCollectionViewCell_Identifier    @"ParkingVcCollectionViewCell"
#define  ParkingVcCollectionHeaderView_Identifier  @"ParkingVcCollectionHeaderView"

//
//#define  CellW ((Screen_W-2)/2 )
//#define  CellH ( CellW*0.75 )

#define  CellW (Screen_W-32)
#define  CellH (Screen_W*0.5)
@interface ParkingVC () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *cellIconNameArr;

@end

@implementation ParkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能停车";
    [self initData];
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}

- (void)initData{
    //有临时缴费
//    self.titleArr = [[NSMutableArray alloc]initWithObjects:@"临时缴费", @"月租缴费",@"缴费记录",nil];
//    self.cellIconNameArr = [[NSMutableArray alloc]initWithObjects:@"temporary", @"Monthly＿rent",@"record",nil];
//    //没有临时缴费
//    self.titleArr = [[NSMutableArray alloc]initWithObjects: @"临时缴费",@"月租缴费",@"缴费记录", @"",nil];
//    self.cellIconNameArr = [[NSMutableArray alloc]initWithObjects: @"temporary",@"Monthly＿rent",@"record", @"",nil];
    
        self.titleArr = [[NSMutableArray alloc]initWithObjects: @"月卡",@"缴费记录",nil];
        self.cellIconNameArr = [[NSMutableArray alloc]initWithObjects: @"zntcyueka_icon",@"zntcjfjl_icon", nil];
}
- (void)initView{
    [self.view addSubview:self.collectionView];
}
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //有临时缴费
//    switch (indexPath.item) {
//        case 0:
//        {
////            ParkingTemporaryVC *vc = [[ParkingTemporaryVC alloc]init]; //临时缴费
////            [self pushVc:vc];
//
//            ParkingTemporaryVCLate *vc = [[ParkingTemporaryVCLate alloc]init]; //临时缴费
//            [self pushVc:vc];
//
//        }
//            break;
//        case 1:
//        {
//            ParkingMonthlyTenancyVC *vc = [[ParkingMonthlyTenancyVC alloc]init];
//            [self pushVc:vc];
//        }
//            break;
//        default:
//        {
//            ParkingPayInfoVC *vc = [[ParkingPayInfoVC alloc]init];
//            [self pushVc:vc];
//        }
//            break;
//    }
//
//    switch (indexPath.item) {
//        case 0:
//        {
//            NSLog(@"临时缴费");
//            ZYParkingTemporaryVC *vc = [[ZYParkingTemporaryVC alloc] init];
//            [self pushVc:vc];
//        }
//            break;
//        case 1:
//        {
//            ParkingMonthlyTenancyVC *vc = [[ParkingMonthlyTenancyVC alloc]init];
//            [self pushVc:vc];
//        }
//            break;
//        case 2:
//        {
//            ParkingPayInfoVC *vc = [[ParkingPayInfoVC alloc]init];
//            [self pushVc:vc];
//        }
//            break;
//        default:
//            break;
//    }
    
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"月卡");
    
        }
            break;
        case 1:
        {
            NSLog(@"缴费记录");
            ParkingPayInfoVC *vc = [[ParkingPayInfoVC alloc]init];
            [self pushVc:vc];
        }
            break;

        default:
            break;
    }
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ParkingVcCollectionViewCell *cell = (ParkingVcCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ParkingVcCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.titleL.text = self.titleArr[indexPath.section];
    cell.imgV.image = [UIImage imageNamed:self.cellIconNameArr[indexPath.section]];
     return cell;
}
//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ParkingVcCollectionHeaderView_Identifier   forIndexPath:indexPath];
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 30);
}
#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(CellW , CellH);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect farme = self.view.frame;
        _collectionView = [[UICollectionView alloc]initWithFrame:farme  collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ParkingVcCollectionViewCell class] forCellWithReuseIdentifier: ParkingVcCollectionViewCell_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ParkingVcCollectionHeaderView_Identifier];
    }
    return _collectionView;
}

@end
