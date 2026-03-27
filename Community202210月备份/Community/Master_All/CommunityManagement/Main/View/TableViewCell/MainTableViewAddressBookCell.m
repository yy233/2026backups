//
//  MainTableViewAddressBookCell.m
//  Community
//
//  Created by 余莹 on 2020/11/17.
//
#import "MainTableViewAddressBookCell.h"
 
//#define mainTableViewCell_Height_cell_centerAddressBookView (120+10) //社区通讯录
#define AddressBook_Cell_W ((Screen_W-32-30-30)/3) //2个间隔20 3个间隔30------ 3个间隔加多余的第四半边
#define AddressBook_Cell_H 120
#define AddressBookCollectionViewCell_Identifier @"MainCenterAddressBookCollectionViewCell"

@interface MainTableViewAddressBookCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation MainTableViewAddressBookCell

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
    if (_delegate && [_delegate respondsToSelector:@selector(addressBookViewCollectionCellDidSelectWithItem:)]) {
        [_delegate addressBookViewCollectionCellDidSelectWithItem:indexPath];
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
    MainCenterAddressBookCollectionViewCell *cell = (MainCenterAddressBookCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AddressBookCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.model = _sourceArr[indexPath.row];
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
        flowLayout.itemSize = CGSizeMake(AddressBook_Cell_W,AddressBook_Cell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, mainTableViewCell_Height_cell_centerAddressBookView) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainCenterAddressBookCollectionViewCell class] forCellWithReuseIdentifier:AddressBookCollectionViewCell_Identifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

    }
    return _collectionView;
}
@end
