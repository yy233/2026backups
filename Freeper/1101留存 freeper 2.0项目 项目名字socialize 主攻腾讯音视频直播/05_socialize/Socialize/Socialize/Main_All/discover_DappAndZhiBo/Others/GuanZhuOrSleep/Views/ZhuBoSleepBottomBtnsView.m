//
//  BottomBtnsView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "ZhuBoSleepBottomBtnsView.h"
#import "ZhiBoMainListSubCollectionViewCell.h"

#define  Item_W_H ((Screen_W-40)*0.5-20)
#define DiscoverMainCollectionViewCell_I @"DiscoverMainCollectionViewCell"

@interface ZhuBoSleepBottomBtnsView () <UICollectionViewDelegate,UICollectionViewDataSource>
@end
@implementation ZhuBoSleepBottomBtnsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, Screen_H/2, Screen_W, Screen_H/2)];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titL];
        [self addSubview:self.collectionView];
        [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titL.superview).offset(10);
            make.height.offset(50);
            make.top.equalTo(_titL.superview);
        }];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_collectionView.superview).offset(-20);
            make.centerX.equalTo(_collectionView.superview);
            make.top.equalTo(_titL.mas_bottom);
            make.bottom.equalTo(_collectionView.superview);
            
        }];
    }
    return self;
}
- (UILabel *)titL{
    if(!_titL){
        _titL = [[UILabel alloc]init];
        _titL.text = @"相关推荐";
        _titL.textColor = rgba(51, 51, 51, 1);
        _titL.font = [UIFont systemFontOfSize:18.0];
    }
    return _titL;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(Item_W_H,Item_W_H);
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat collv_h = self.frame.size.height-60;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZhiBoMainListSubCollectionViewCell class] forCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
 
}

#pragma mark ==
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Item_W_H, Item_W_H);
}

//动态设置每个分区的EdgeInsets｜view轮廓距离v边
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//动态设置每列的间距大小|每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
//动态设置每行的间距|每个item之间的间距|数列之间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}


#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return self.dataSourceArr.count;
    return 5;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:DiscoverMainCollectionViewCell_I   forIndexPath:indexPath];
////    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
////        MoreMenuSectionHeaderModle *model = self.dataSourceArr[indexPath.section];
////        MoreMenuCollectionHeaderView *sectionHeader = [[MoreMenuCollectionHeaderView alloc]initWithFrame:CGRectZero];
////        [sectionHeader headerTitleTest:model.menuName];
////        [view addSubview:sectionHeader];
////    }
// return view;
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZhiBoMainListSubCollectionViewCell *cell = (ZhiBoMainListSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I  forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZhiBoMainListSubCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, Item_W_H, Item_W_H)];
    }
//    cell.titleLabel.text = [NSString stringWithFormat:@"主播%@",@"某xxxx"];
//    cell.subtitleLabel.text = @"房间名字";
//    cell.numLabel.text =@"numwwwddd";
    cell.typeImg.backgroundColor = [UIColor orangeColor];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
    if(_delegate && [_delegate respondsToSelector:@selector(touchOtherZhuBoRoom)]){
        [_delegate touchOtherZhuBoRoom];
    }
}
 
@end
