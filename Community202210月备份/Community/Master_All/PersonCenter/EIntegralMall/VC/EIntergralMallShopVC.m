//
//  EIntergralMallShopVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallShopVC.h"
//
#import "EIntergralMallVcCollectionViewCell.h"
#define  EIntergralMallVcCollectionViewCell_Identifier               @"EIntergralMallVcCollectionViewCell"
#define  EIntergralMallVcTextAndBtnSectionHeaderView_Identifier      @"EIntergralMallVcTextAndBtnSectionHeaderView"

//
#import "EIntergralMallShopEveryDayExchangeVC.h"
#import "EIntergralMallShopHotVC.h"
#import "EIntergralMallGoodsDatailVC.h"

@interface EIntergralMallShopVC ()

@end

@implementation EIntergralMallShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"E币商城";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initData{
//    self.dataSourceArr = @[];
//    [self.collectionView reloadData];
}

#pragma mark -------------
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }else{
        return 4;
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
  
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:EIntergralMallVcTextAndBtnSectionHeaderView_Identifier   forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UILabel *sectionTextL = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 40)];
        sectionTextL.textAlignment = NSTextAlignmentLeft;
        sectionTextL.textColor = [UIColor blackColor];
        sectionTextL.font = FontSize_MoneyWallet_Bold(19);
        //___
        if (indexPath.section==0) {
            sectionTextL.text = @"每日抢兑";
        }else{
            sectionTextL.text = @"热门精选";
        }
        [view addSubview:sectionTextL];
        //
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(Screen_W-32-50, 10, 60, 20);//40-20*0.5==10
        [btn newAnBtnWithTextStr:@"查看更多"];
        [btn newAnBtnWithTextColor:Color_138GrayColor];
        [btn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        [btn newAnBtnWithImg:[UIImage imageNamed:@"skip"]];
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:1];
        //___
        if (indexPath.section==0) {
            [btn addTarget:self action:@selector(oneSectionHeaderViewRightBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];//@"每日抢兑";
        }else{
            [btn addTarget:self action:@selector(twoSectionHeaderViewRightBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];//@"热门精选";
        }
        [view addSubview:btn];
        
    }
    return view;
 
  
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 40);//section header

}
#pragma mark ===
- (void)oneSectionHeaderViewRightBtnTouchAction{
    DLog(@"每日抢兑");
    EIntergralMallShopEveryDayExchangeVC *vc = [[EIntergralMallShopEveryDayExchangeVC alloc]init];
    [self pushVc:vc];
}
- (void)twoSectionHeaderViewRightBtnTouchAction{
    DLog(@"热门精选");
    EIntergralMallShopHotVC *vc = [[EIntergralMallShopHotVC alloc]init];
    [self pushVc:vc];
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
