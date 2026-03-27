//
//  MainTableViewTopMenuCell.m
//  Community
//
//  Created by 余莹 on 2021/7/26.
// 新版在用

#import "MainTableViewTopMenuCell.h"
#import "MainTopMenuCollectionViewCell.h"
//5个/行
//#define W_AllGap 44 //空隙
//#define Cell_W ((Screen_W-32) - W_AllGap )/5
//#define Cell_H 90

//4个/行
#define W_AllGap 33 //空隙
#define Cell_W ((Screen_W-32) - W_AllGap )/4
#define Cell_H 90

#define MainTopMenuCollectionViewCell_Identifier @"MainTopMenuCollectionViewCell"
@interface MainTableViewTopMenuCell () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;

@end
@implementation MainTableViewTopMenuCell
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
    if (_delegate && [_delegate respondsToSelector:@selector(topMenuViewCollectionCellDidSelectWithItem:)]) {
        [_delegate topMenuViewCollectionCellDidSelectWithItem:indexPath];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ( kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1 ){//展示得到的数据 不做更多按钮
        return _sourceArr.count;
    }else{
        if (_sourceArr.count>0) {
            return _sourceArr.count+1;
        }else{
            return 1;
        }
    }
   
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTopMenuCollectionViewCell *cell = (MainTopMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MainTopMenuCollectionViewCell_Identifier  forIndexPath:indexPath];
    
    if ( kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1 ){//展示得到的数据 不做更多按钮
        cell.model = _sourceArr[indexPath.row];
        cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellOtherItemTextColor;
        return cell;
    }else{
        
        if (indexPath.row==_sourceArr.count) {
            MainCenterCollectionViewCellModel *moreItemModel = [[MainCenterCollectionViewCellModel alloc]init];
            moreItemModel.menuName = @"更多";
            moreItemModel.icon = @"";
            cell.model = moreItemModel;
            cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellOtherItemTextColor;
         }else{
            cell.model = _sourceArr[indexPath.row];
            cell.titleLabel.textColor = [ThemeManager shareManager].mainMenuCellOtherItemTextColor;
             
        }
        return cell;
    }
        
    
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
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, mainTableViewCell_Height_cell_TopMenuCell) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainTopMenuCollectionViewCell class] forCellWithReuseIdentifier:MainTopMenuCollectionViewCell_Identifier];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
@end
