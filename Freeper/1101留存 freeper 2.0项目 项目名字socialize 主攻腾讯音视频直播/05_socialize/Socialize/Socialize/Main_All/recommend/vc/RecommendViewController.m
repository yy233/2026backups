//
//  RecommendViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "RecommendViewController.h"
#import "TopSearchView.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendDetailViewController.h"


#define  Item_W ((Screen_W-32-10)/2)
#define  Item_H (Item_W+60)

#define ksectionTitileHeaderView_I   @"sectionTitileHeaderView_I"
@interface RecommendViewController () <UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TopSearchViewDelegate>
@property (nonatomic,strong) TopSearchView *searchView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation RecommendViewController
#pragma mark ==
 
- (void)addBkView{
   
   GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
   [self.view addSubview:bgColorView];
   [self.view bringSubviewToFront:self.collectionView];//吧collectionView 放到最前
    
}
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

- (UICollectionView *)collectionView{
    if (!_collectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake(Item_W,Item_H);
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        CGFloat collv_h = self.view.frame.size.height-self.discoverTopView.frame.size.height;
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, self.discoverTopView.frame.size.height, Screen_W-32,collv_h ) collectionViewLayout:flowLayout];
        DLog(@"%f",self.searchView.frame.size.height);
        DLog(@"%f",Screen_H);
        DLog(@"%f",KNavBarHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, Screen_W, Screen_H-KNavBarHeight-60) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:kRecommendCollectionViewCell_I];
        [_collectionView registerClass:[RecommendCollectionViewCell_TopCell class] forCellWithReuseIdentifier:RecommendCollectionViewCell_TopCell_I];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksectionTitileHeaderView_I];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ksectionTitileHeaderView_I];
        
        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
 
}
- (UIView *)collectionHeader_sectionTitileHeaderView{
    UIView *sectionTitileHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 40)];
    titleLabel.text = @"NFT";
    [sectionTitileHeaderView addSubview:titleLabel];
    return sectionTitileHeaderView;
}


#pragma mark ===
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBkView];
    [self initViews];
    [self initDatas];
    
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTransparentStyle];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  [self navBackColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Y_gray_img;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= appearance;
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = Y_gray_img;
        [[UINavigationBar appearance] setTranslucent:NO];
    }

}
- (UIColor *)navBackColor {
    return [UIColor clearColor];;
}

 
   
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor purpleColor]];
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
    if(indexPath.section == 0){
        return CGSizeMake( Screen_W-32, 200);;
    }
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
    if(section == 1){
        return CGSizeMake(Screen_W, 40);
    }
    return CGSizeMake(Screen_W, 10);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 20);
}

#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.dataArr.count;
    }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        RecommendCollectionViewCell_TopCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCollectionViewCell_TopCell_I forIndexPath:indexPath];
        cell.imgView.backgroundColor = Y_randomColor;
        return cell;
    }else{
        RecommendCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCollectionViewCell_I forIndexPath:indexPath];
       // cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        cell.titL.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
        return cell;
    }
 
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        
        if (indexPath.section==1) {
            [view addSubview:[self collectionHeader_sectionTitileHeaderView]];
            return view;
        }else{
            return view;
        }
    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        return view;
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
    if(indexPath.section == 1){
        RecommendDetailViewController *vc = [[RecommendDetailViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
@end
