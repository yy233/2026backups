//
//  MyHousekeeperView.m
//  Community
//
//  Created by 余莹 on 2021/7/28.
//

#import "MyHousekeeperView.h"
#import "WuYeAddressBookCollectionViewCell.h"
#define  WuYeAddressBookCollectionViewCell_Identifier  @"WuYeAddressBookCollectionViewCell"
@interface MyHousekeeperView ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LabelYu *centerLabel;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;//0407新增唯一电话btn
@property (nonatomic,strong) NSMutableArray *cellSourceArr;

@end


@implementation MyHousekeeperView

- (void)fillBText:(NSString *)showtext{ 
    self.centerLabel.text = showtext;
    CGFloat textH = [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32) withTextStr:showtext withFont:[UIFont systemFontOfSize:13]];
    //左右15 高度num0不够显示 更新高度
    [_centerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textH+20);
    }];
}
- (void)fillBannerData:(NSMutableArray *)bannerArr{
     self.cycleScrollView.imageURLStringsGroup = bannerArr;
}
- (void)fillCellData:(NSMutableArray *)dataSourceArr{//MainCenterCollectionViewAddressBookCellModel
    self.cellSourceArr = [NSMutableArray arrayWithArray:dataSourceArr];
    [self.collectionView reloadData];
}
- (void)fillOnlyPhoneStr:(NSString *)onlyPhoneStr{
    if (onlyPhoneStr.length <= 0) {
        return;
    }
    self.footerView.hidden = NO;
    [self.footerView.footerBtn newAnBtnWithTextStr:onlyPhoneStr];
    [self.footerView.footerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
}

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        self.cellSourceArr = [[NSMutableArray alloc]init];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.centerLabel];
        [self addSubview:self.collectionView];
        [self addSubview:self.footerView];
        [self setUI];
    }
    return self;
}
#pragma mark === SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"didSelectItemAt ScrollViewItem");
    if (_delegate && [_delegate respondsToSelector:@selector(myHousekeeperViewTouchTopSdcyclviewWithIndex:)]) {
        [_delegate myHousekeeperViewTouchTopSdcyclviewWithIndex:index];
    }
}
#pragma mark ===  UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    if (_delegate && [_delegate respondsToSelector:@selector(myHousekeeperViewTouchBottomCellWithIndex:)]) {
        [_delegate myHousekeeperViewTouchBottomCellWithIndex:indexPath.row];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WuYeAddressBookCollectionViewCell *cell = (WuYeAddressBookCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:WuYeAddressBookCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.model = self.cellSourceArr[indexPath.row]; 
    return cell;
}

#pragma mark ===
- (void)setUI{
 
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_cycleScrollView.superview);
        make.height.equalTo(_cycleScrollView.superview).multipliedBy(0.3);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {//高度限制最大0.3
        make.left.right.equalTo(_centerLabel.superview);
        make.top.equalTo(_cycleScrollView.mas_bottom);
        make.height.lessThanOrEqualTo(_centerLabel.superview).multipliedBy(0.3);//最多ScreenH的0.3
        make.height.greaterThanOrEqualTo(_centerLabel.superview).multipliedBy(0.01).offset(40);//textInsets 保证至少有两行数据高度
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_collectionView.superview).offset(-32);
        make.centerX.equalTo(_collectionView.superview);
        make.top.equalTo(_centerLabel.mas_bottom).offset(20);
        make.height.offset(150);
    }];//collectionV 0407后 没数据 不显示
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_footerView.superview);
        make.width.equalTo(_footerView.superview);
        make.height.offset(90);
        make.top.equalTo(_centerLabel.mas_bottom).offset(30);
    }];
    _footerView.hidden = YES;

}
#pragma mark ===
- (LabelYu *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[LabelYu alloc]init];
//        _centerLabel.textInsets  = UIEdgeInsetsMake(8.f, 15.f, 8.f, 15.f); // 设置左内边距(上、左、下、右)
        _centerLabel.textInsets  = UIEdgeInsetsMake(2.f, 15.f, 2.f, 15.f); // 设置左内边距(上、左、下、右)
        _centerLabel.numberOfLines = 0;
        _centerLabel.font = [UIFont systemFontOfSize:13];
        _centerLabel.text = @"。";
    }
    _centerLabel.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    _centerLabel.textColor =  [[ThemeManager shareManager].themeTextMainColor colorWithAlphaComponent:0.7]; 
    return _centerLabel;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView  = [[SDCycleScrollView alloc]init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = Color_Blue;
        _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.delegate = self;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"cc_placeholder_big_banner"];//不需要本Community_Homepage_bannerone占位
    }
    return _cycleScrollView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W -32 -20)/3,130);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 150) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WuYeAddressBookCollectionViewCell class] forCellWithReuseIdentifier:WuYeAddressBookCollectionViewCell_Identifier];
    }
    return _collectionView;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]init];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithImg: [UIImage imageNamed:@"theiPhone_icon"]];
        [_footerView setBtnFram:CGRectMake(0, 0, 200, 40)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (void)footerBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchFooterBtnActionWithCallPhone)]) {
        [_delegate touchFooterBtnActionWithCallPhone];
    }
}
@end
