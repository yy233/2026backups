//
//  FeedbackCollectionViewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "FeedbackCollectionViewTableViewCell.h"
#import "FeedBackCellSubCollectionViewCell.h"
#define  FeedBackCellSubCollectionViewCell_Identifier    @"FeedBackCellSubCollectionViewCell"
#define  Cell_Width   (((Screen_W-32)-31)/4)
#define  Cell_Height  (((Screen_W-32)-31)/4)
#import "FeedBackCellSubCollectionViewCell.h"

#define  Tag_subCellDeletBtn    200

@interface FeedbackCollectionViewTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UILabel *rightTipLabel;

@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@end

@implementation FeedbackCollectionViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setImageArray:(NSArray<ZYSealImageDataModel *> *)imageArray {
    
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    [self.dataSourceArr addObjectsFromArray:imageArray];
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.text = @"添加照片:";
        [self.backView addSubview:self.rightTipLabel];
        [self.backView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}

- (void)cellSubCentenAddBtnAction{
    if (_deleagte && [_deleagte respondsToSelector:@selector(addPhotosAction)]) {
        [_deleagte addPhotosAction];
    }
}
- (void)cellSubDeletBtnAction:(UIButton *)sender{
    if (_deleagte && [_deleagte respondsToSelector:@selector(deletPhotoActionWithIndex:)]) {
        [_deleagte deletPhotoActionWithIndex:(sender.tag-Tag_subCellDeletBtn)];
    }
}
- (void)selectorimgView:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 500;
    if (_deleagte && [_deleagte respondsToSelector:@selector(imgViewTapWithIndex:)]) {
        [_deleagte imgViewTapWithIndex:index];
    }
}
#pragma mark ===
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count+1;;
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size =   CGSizeMake(Cell_Width, Cell_Height);
    return size;
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedBackCellSubCollectionViewCell *cell = (FeedBackCellSubCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:FeedBackCellSubCollectionViewCell_Identifier forIndexPath:indexPath];
    ZYSealImageDataModel *model = self.dataSourceArr[indexPath.row];
    NSInteger maxPhotoNum = 10;
    if (indexPath.item>=maxPhotoNum) {
        [cell isMaxNumWillHiddendAllSubV];
    }else{
        if (indexPath.item == [collectionView numberOfItemsInSection:0]-1) {
            [cell isAddUIShow];
            [cell.centerBtn addTarget:self action:@selector(cellSubCentenAddBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell isObjImgUIShow];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, model.url]];
            [cell.imgView sd_setImageWithURL:url];
            cell.imgView.userInteractionEnabled = YES;
            cell.imgView.tag = 500 + indexPath.row;
            [cell.imgView zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
            [cell.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorimgView:)]];
            cell.deletBtn.tag = Tag_subCellDeletBtn +indexPath.item;
            [cell.deletBtn addTarget:self action:@selector(cellSubDeletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
}

//
- (void)setUI{
    [_rightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.titleLabel);
        make.width.offset(80);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_collectionView.superview);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}
- (UILabel *)rightTipLabel{
    
    if (!_rightTipLabel) {
        _rightTipLabel = [[UILabel alloc]init];
        _rightTipLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        _rightTipLabel.font = FontSize_ElectronicSignature_Nomail(12);
        _rightTipLabel.text = @"最多10张";
        _rightTipLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightTipLabel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FeedBackCellSubCollectionViewCell class] forCellWithReuseIdentifier:FeedBackCellSubCollectionViewCell_Identifier];
    }
    return _collectionView;
}
//
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}

@end
