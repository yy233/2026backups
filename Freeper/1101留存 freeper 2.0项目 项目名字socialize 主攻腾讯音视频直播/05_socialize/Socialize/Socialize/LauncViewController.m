//
//  LauncViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/8/28.
//
//启动页横向滑动的
#import "LauncViewController.h"
#import "MainTabbarControll.h"

#define launc_identifier @"welcomeCell"

@interface LauncViewController () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray   *imageArray;
@property (nonatomic, assign) Boolean          isFullScreen;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, assign) int currentIndex;
//跳过按钮
@property (nonatomic,strong) UIButton *tiaoGuoBtn;


@end

@implementation LauncViewController

- (UIButton *)tiaoGuoBtn{
    if(!_tiaoGuoBtn){
        _tiaoGuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tiaoGuoBtn newAnBtnWithBackColor:rgba(26, 26, 26, 0.5)];
        [_tiaoGuoBtn newAnBtnWithFont:[UIFont systemFontOfSize:18]];
        [_tiaoGuoBtn newAnBtnWithTextColor: [UIColor whiteColor]];
        [_tiaoGuoBtn newAnBtnWithLayerCorNerNum:25.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        //
        [_tiaoGuoBtn newAnBtnWithTextStr: Y_LocaleTypeFile_NSLocalString(@"跳过")];
        _tiaoGuoBtn.titleLabel.numberOfLines = 2;
        [_tiaoGuoBtn addTarget:self action:@selector(tiaoGuoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tiaoGuoBtn;
}
- (void)otherView{
    [self.view addSubview:self.tiaoGuoBtn];
    [_tiaoGuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tiaoGuoBtn.superview).offset(-50);
        make.bottom.equalTo(_tiaoGuoBtn.superview).offset(-40);
        make.height.offset(50);
        make.width.offset(90);
    }];
}

- (void)tiaoGuoBtnAction{
    //直接到主页
    self.window.rootViewController  = [[MainTabbarControll alloc]init];//0828
}

#pragma mark ========================

- (void)viewDidLoad {
    self.imageArray = [NSMutableArray arrayWithArray:@[@"Post1",@"Post2",@"Post3"]];

    [super viewDidLoad];
    [self intiWithCollection];
    [self otherView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)intiWithCollection
{
    NSInteger imageCount = self.imageArray.count;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(Screen_W, Screen_H);
    layout.minimumInteritemSpacing = 0.0f;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W , Screen_H) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:launc_identifier];
    self.collectionView.contentSize = CGSizeMake(Screen_W*imageCount, Screen_H);
    self.collectionView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_collectionView];
    
    //pageControl 显示问题 不要给宽度即可
    
    _pageControl = [[UIPageControl alloc]init];
    //_pageControl.frame = CGRectMake(Screen_W/2-30, Screen_H- 60, 60, 40);
    _pageControl.numberOfPages = self.imageArray.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = Color_Socialize_GreenColor;
    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    [self.view addSubview:self.pageControl];
    [self.view insertSubview:self.pageControl aboveSubview:self.collectionView];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_pageControl.superview);
        make.height.offset(40.0);
        make.bottom.equalTo(_pageControl.superview).offset(-40);
    }];

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:launc_identifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSLog(@"indexPath.row ====>%ld",(long)indexPath.row);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_imageArray[indexPath.row]]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    [cell.contentView addSubview:imageView];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Screen_W, Screen_H);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    if(_currentIndex == _imageArray.count-1){
        
    }
    self.pageControl.currentPage = _currentIndex;
}
 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
}

@end
