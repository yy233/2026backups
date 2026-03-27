//
//  MainLateMyServiceCell.m
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import "MainLateMyServiceCell.h"

#define  MainLateMyServiceSubCollectionViewCell_Identifier  @"MainLateMyServiceSubCollectionViewCell"

#define SubCell_H  (120)
#define SubCell_W  ((Screen_W-32-22)/3)


@interface MainLateMyServiceCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation MainLateMyServiceCell

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
        [self.contentView addSubview:self.collectionView];
        [self setUI];
        [self addTemChangeNotice];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

 
#pragma mark ==
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NOTICE_NAME_ThemeISChanged)
}
- (void)addTemChangeNotice{
    Y_NSNotificationCenter_Creat_NameAction(NOTICE_NAME_ThemeISChanged, themeIsChange:)
}
- (void)themeIsChange:(NSNotification*)notice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData]; //fillType被调用更新我的服务subcell图片
    });
}
 
#pragma mark ===
#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"  didSelect %ld",indexPath.row);
    if (isNil(self.touchSubCellBlock)) {
        return;
    }
    self.touchSubCellBlock(indexPath.row);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MainLateMyServiceSubCollectionViewCell *cell = (MainLateMyServiceSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MainLateMyServiceSubCollectionViewCell_Identifier  forIndexPath:indexPath];
    [cell fillType:indexPath.row];
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
        flowLayout.itemSize = CGSizeMake(SubCell_W,SubCell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, mainTableViewCell_Height_cell_topRollingView) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainLateMyServiceSubCollectionViewCell class] forCellWithReuseIdentifier:MainLateMyServiceSubCollectionViewCell_Identifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _collectionView;
}
@end
