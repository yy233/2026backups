//
//  MoreNftViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/17.
//

#import "MoreNftViewController.h"
#import "TopSearchView.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendDetailViewController.h"

#define  Item_W ((Screen_W-32-10)/2)
#define  Item_H (Item_W+60)


@interface MoreNftViewController () <UICollectionViewDelegate,UICollectionViewDataSource,TopSearchViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) TopSearchView *searchView;
@end

@implementation MoreNftViewController
#pragma mark ==
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
#pragma mark ==
- (TopSearchView *)searchView{
    if(!_searchView){
        _searchView = [[TopSearchView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
        _searchView.delegate = self;
    }
    return _searchView;
}
- (void)touchOkBtn{
    NSLog(@"touchOkBtn %@",self.searchView.textField.text);
}
- (void)searchTextIsChanged{
    NSLog(@"searchTextIsChanged %@",self.searchView.textField.text);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多编号";
    self.view.backgroundColor = rgba(248, 248, 248, 1);
    [self initViews];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, Screen_W, Screen_H-KNavBarHeight-60) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:kRecommendCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
 
}


#pragma mark ===
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor whiteColor]];
}

 
- (void)initViews{
    [self.view addSubview:self.searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_searchView.superview);
        make.height.offset(60);
        make.top.equalTo(_searchView.superview).offset(KNavBarHeight);
    }];
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_collectionView.superview);
        make.top.equalTo(_searchView.mas_bottom);
        make.bottom.equalTo(_collectionView.superview).offset(-kTabBar_Height);
    }];
    
 
    
    
}
- (void)initDatas{
    self.dataArr = @[@1,@2,@3,@4,@5,@1,@2,@3,@4,@5,@1,@2,@3,@4,@5].mutableCopy;
}

#pragma mark ===

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Item_W, Item_H);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 16, 0, 16);
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
    return CGSizeMake(Screen_W, 20);
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
    RecommendCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCollectionViewCell_I forIndexPath:indexPath];
    cell.backView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    cell.titL.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
    RecommendDetailViewController *vc = [[RecommendDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

@end
