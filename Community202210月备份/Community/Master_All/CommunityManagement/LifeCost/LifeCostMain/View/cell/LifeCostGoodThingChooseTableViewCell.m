//
//  LifeCostGoodThingChooseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCostGoodThingChooseTableViewCell.h"
//
#import "LifeGoodThingCellSubCollectionViewCell.h"
#define LifeGoodThingCellSubCollectionViewCell_Identifier    @"LifeGoodThingCellSubCollectionViewCell"
//
#define collectionView_H         100
#define collectionView_W         (Screen_W-32-20-20)/3    //32-  20backview间隔 20item2个

@interface LifeCostGoodThingChooseTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UICollectionView *collectionView;
//
@property (nonatomic,strong) NSArray *dataSourceAdArr;//广告
@property (nonatomic,strong) NSArray *dataSourceItemArr;//商品
@end

@implementation LifeCostGoodThingChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark == data
///

- (void)setD{
    //
    _dataSourceAdArr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    _dataSourceItemArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"11",@"22", nil];
    //
    //_cycleScrollView.imageURLStringsGroup = _dataSourceAdArr;
    [_collectionView reloadData];
}
#pragma mark ===
#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
//    if (_delegate && [_delegate respondsToSelector:@selector(addressBookViewCollectionCellDidSelectWithItem:)]) {
//        [_delegate addressBookViewCollectionCellDidSelectWithItem:indexPath];
//    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataSourceItemArr.count>0) {
        return _dataSourceItemArr.count;
    }else{
        return 0;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LifeGoodThingCellSubCollectionViewCell *cell = (LifeGoodThingCellSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LifeGoodThingCellSubCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.imgV.backgroundColor = [UIColor lightGrayColor];
    cell.titleNameL.text = @"商品文本";
 
    return cell;
}


#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   if (self) {
       self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.backgroundColor = [UIColor clearColor];
       [self.contentView addSubview:self.backView];
       [self.backView addSubview:self.titleL];
       [self.backView addSubview:self.moreBtn];
       [self.backView addSubview:self.collectionView];
       [self.backView addSubview:self.cycleScrollView];
       [self setUI];
       [self setD];
   }
   return self;
}
- (void)setUI{
   [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
   }];
//    self.backView.backgroundColor = [UIColor redColor];
//    self.collectionView.backgroundColor = [UIColor blueColor];
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_top).offset(0);
        make.left.equalTo(_backView.mas_left).offset(10);
        make.width.equalTo(_backView.mas_width).offset(-70);
        make.height.offset(20);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.mas_centerY);
        make.left.equalTo(_titleL.mas_right);
        make.right.equalTo(_backView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    //商品item
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.mas_left).offset(0);
        make.right.equalTo(_moreBtn.mas_right).offset(0);
        make.bottom.equalTo(_backView.mas_bottom);
        make.height.equalTo(_backView.mas_height).multipliedBy(0.4);
    }];
    //广告
   [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(_titleL.mas_left);
       make.right.equalTo(_moreBtn.mas_right);
       make.top.equalTo(_titleL.mas_bottom).offset(15);
       make.bottom.equalTo(_collectionView.mas_top).offset(-5);
   }];
 
}
- (UIView *)backView{
   if (!_backView) {
       _backView = [[UIView alloc]init];
       _backView.layer.cornerRadius = 10;
       _backView.layer.masksToBounds = YES;
   }
   return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"好物精选";
    }
    return _titleL;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_moreBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal]; 
        if ([ThemeManager shareManager].type==ThemeType_White) {
            [_moreBtn setImage:[UIImage imageNamed:@"rightSkip"] forState:UIControlStateNormal];
        }else{
            [_moreBtn setImage:[UIImage imageNamed:@"rightSkip_white"] forState:UIControlStateNormal];
        }
    }
    return _moreBtn;
}

- (SDCycleScrollView *)cycleScrollView{
   if (!_cycleScrollView) {
       _cycleScrollView = [[SDCycleScrollView alloc]init];
       _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
       _cycleScrollView.currentPageDotColor = Y_RGBA(37, 95, 255, 1);
       _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
       _cycleScrollView.tag = MainTopCycleScrollView_TAG;
       _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
       _cycleScrollView.backgroundColor = [UIColor grayColor];
       _cycleScrollView.layer.cornerRadius = 5;
       
   }
   return _cycleScrollView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(collectionView_W,collectionView_H);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LifeGoodThingCellSubCollectionViewCell class] forCellWithReuseIdentifier:LifeGoodThingCellSubCollectionViewCell_Identifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

    }
    return _collectionView;
}
@end
