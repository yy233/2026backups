//
//  EIntergralMallShopEveryDayExchangeVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallShopEveryDayExchangeVC.h"
//
#import "EIntergralMallVcCollectionViewCell.h"
#define  EIntergralMallVcCollectionViewCell_Identifier               @"EIntergralMallVcCollectionViewCell"
#define  EIntergralMallVcTextAndBtnSectionHeaderView_Identifier      @"EIntergralMallVcTextAndBtnSectionHeaderView"

@interface EIntergralMallShopEveryDayExchangeVC ()

@end

@implementation EIntergralMallShopEveryDayExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每日兑换";
}
- (void)initData{
//    self.dataSourceArr = @[];
//    [self.collectionView reloadData];
}

#pragma mark -------------
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
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
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 10);//section header

}
@end
