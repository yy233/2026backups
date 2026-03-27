//
//  MainTableViewCenterOneCell.m
//  Community
// 顶部的功能区 集合视图
//  Created by 余莹 on 2020/11/16.
//

#import "MainCenterCollectionViewCell.h"

//#define CollectViewCellHeight mainTableViewCell_Height_cell_centerOneFunctionView //菜单
#define W_AllGap 30 //空隙 3个
#define Cell_W ((Screen_W-32) - W_AllGap )/4 // 60 (Screen_W=32)/4-10
#define Cell_H 100        //mainTableViewCell_Height_cell_centerOneFunctionView

#define MainCenterCollectionViewCell_Identifier @"MainCenterCollectionViewCell"
#define MainCenterCollectionViewCell_FooterView_Identifier @"MainCenterCollectionViewCell_FooterView"
@interface MainTableViewCenterMenuCell () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation MainTableViewCenterMenuCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
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
#pragma mark ===
#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    if (_delegate && [_delegate respondsToSelector:@selector(centerMenuViewCollectionCellDidSelectWithItem:)]) {
        [_delegate centerMenuViewCollectionCellDidSelectWithItem:indexPath];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_sourceArr.count>0) {
        return _sourceArr.count+1;
    }else{
        return 1;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCenterCollectionViewCell *cell = (MainCenterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MainCenterCollectionViewCell_Identifier  forIndexPath:indexPath];
    if (indexPath.row==_sourceArr.count) {
        MainCenterCollectionViewCellModel *moreItemModel = [[MainCenterCollectionViewCellModel alloc]init];
        moreItemModel.menuName = @"更多";
        moreItemModel.icon = @"";
        cell.model = moreItemModel;
        cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellOtherItemTextColor;
        cell.backView.backgroundColor = [ThemeManager shareManager].mainMenuCellOtherItemBackGroundColor;
    }else{
        cell.model = _sourceArr[indexPath.row];
        if (indexPath.row==0) {//信息登记item
            cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellFirstItemTextColor;
            cell.backView.backgroundColor = [ThemeManager shareManager].mainMenuCellFirstItemBackGroundColor;
        }else{
            cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellOtherItemTextColor;
            cell.backView.backgroundColor = [ThemeManager shareManager].mainMenuCellOtherItemBackGroundColor;
        }
    }
    return cell;
}

#pragma mark ===
- (void)setUI{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_W,Cell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
 
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, mainTableViewCell_Height_cell_centerOneFunctionView) collectionViewLayout:flowLayout];//// 旧版没在用
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainCenterCollectionViewCell class] forCellWithReuseIdentifier:MainCenterCollectionViewCell_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MainCenterCollectionViewCell_FooterView_Identifier];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
@end
