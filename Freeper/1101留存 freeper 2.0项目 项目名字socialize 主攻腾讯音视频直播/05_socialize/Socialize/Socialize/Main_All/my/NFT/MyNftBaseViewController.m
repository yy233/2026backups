//
//  MyNftBaseViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "MyNftBaseViewController.h"
#import "MyNftBaseCollectionViewCell.h"

#define  Item_W ((Screen_W-32-10)/2)
#define  Item_H (Item_W+40)

@interface MyNftBaseViewController () 

@end



@implementation MyNftBaseViewController
#pragma mark ==
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, Screen_W, Screen_H-KNavBarHeight-60) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MyNftBaseCollectionViewCell class] forCellWithReuseIdentifier:kMyNftBaseCollectionViewCell_i];
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRefresh];
    [self initListData];
}

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initListData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upDataListData)];//暂无
    self.collectionView.mj_header = headeerRefresh;
    self.collectionView.mj_footer = footerRefresh;
    self.collectionView.mj_footer.hidden = YES;
}

- (void)initListData{
    DLog();
    self.dataArr = @[@1,@2,@3,@4,@5,@1,@2,@3,@4,@5,@1,@2,@3,@4,@5].mutableCopy;
    [self.collectionView reloadData];
}
- (void)upDataListData{
    DLog();
}

 
#pragma mark ===

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Item_W, Item_H);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 10);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 10);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyNftBaseCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kMyNftBaseCollectionViewCell_i forIndexPath:indexPath];
    cell.imgView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.titL.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    cell.titL.backgroundColor = [UIColor grayColor];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",indexPath.row);
}


@end
