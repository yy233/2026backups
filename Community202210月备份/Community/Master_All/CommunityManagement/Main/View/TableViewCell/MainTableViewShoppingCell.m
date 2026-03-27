//
//  MainTableViewShoppingCell.m
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import "MainTableViewShoppingCell.h"
 
//#define mainTableViewCell_Height_cell_centerShoppingView   //轮播图+左右集合视图(2个 ====110+10+90)
 //220*0.5==110 90+20==110
#define Shopping_Cell_W ((Screen_W-32-10)*0.5)
#define Shopping_Cell_H 90
#define Shopping_TableViewCell_H 110 //
#define ShoppingCollectionViewCell_Identifier @"MainCenterShoppingCollectionViewCell"

@interface MainTableViewShoppingCell () <UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UIView * topScrollBackView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation MainTableViewShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.topScrollBackView];
        [self.topScrollBackView addSubview:self.cycleScrollView];
        [self.contentView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)setSourceArr:(NSMutableArray *)sourceArr{
    _sourceArr = sourceArr;
    [self.collectionView reloadData];
}
- (void)setScrollViewSourceArr:(NSMutableArray *)scrollViewSourceArr{
    _scrollViewSourceArr = scrollViewSourceArr;
    NSMutableArray *arrOfTitle = @[].mutableCopy;
    NSMutableArray *arrOfImgUrl = @[].mutableCopy;
    for (int i = 0; i<_scrollViewSourceArr.count; i++) {
        TableViewTopAndCenterBannerCellModel *bannerModel = _scrollViewSourceArr[i];
        [arrOfTitle addObject:[TextShowWithModelStr textShowWithModelStr:bannerModel.desc]];
        [arrOfImgUrl addObject:[TextShowWithModelStr textShowWithModelStr:bannerModel.url]];
    }
    _cycleScrollView.titlesGroup = arrOfTitle;
    _cycleScrollView.imageURLStringsGroup = arrOfImgUrl;
    
}
#pragma mark ===
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"didSelectItemAt ScrollViewItem");
    if (_delegate && [_delegate respondsToSelector:@selector(shoppingViewCollectionCellDidSelectWithScrollViewItem:)]) {
        [_delegate shoppingViewCollectionCellDidSelectWithScrollViewItem:index];
    }
}
#pragma mark ===
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    if (_delegate && [_delegate respondsToSelector:@selector(shoppingViewCollectionCellDidSelectWithItem:)]) {
        [_delegate shoppingViewCollectionCellDidSelectWithItem:indexPath];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_sourceArr.count>0) {
        return _sourceArr.count;
    }else{
        return 0;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCenterShoppingCollectionViewCell *cell = (MainCenterShoppingCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ShoppingCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.model = _sourceArr[indexPath.row];
    return cell;
}

#pragma mark ===
- (void)setUI{
    _topScrollBackView.backgroundColor = [UIColor clearColor];
    [_topScrollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topScrollBackView.superview.mas_left);
        make.right.equalTo(_topScrollBackView.superview.mas_right);
        make.top.equalTo(_topScrollBackView.superview.mas_top).offset(5);
        make.height.equalTo(_topScrollBackView.superview.mas_height).multipliedBy(0.5);
    }];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topScrollBackView);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_collectionView.superview.mas_left);
        make.right.equalTo(_collectionView.superview.mas_right);
        make.bottom.equalTo(_collectionView.superview.mas_bottom);
        make.top.equalTo(_topScrollBackView.mas_bottom);
    }];
}
#pragma mark ===
- (UIView *)topScrollBackView{
    if (!_topScrollBackView) {
        _topScrollBackView = [[UIView alloc]init];
        _topScrollBackView.layer.cornerRadius = 10;
        _topScrollBackView.layer.masksToBounds = YES;
    }
    return _topScrollBackView;
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
        flowLayout.itemSize = CGSizeMake(Shopping_Cell_W,Shopping_Cell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Shopping_TableViewCell_H) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainCenterShoppingCollectionViewCell class] forCellWithReuseIdentifier:ShoppingCollectionViewCell_Identifier];
    }
    return _collectionView;
}
@end
