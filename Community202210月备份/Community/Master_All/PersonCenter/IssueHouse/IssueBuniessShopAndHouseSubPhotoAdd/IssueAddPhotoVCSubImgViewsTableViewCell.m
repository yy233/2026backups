//
//  IssueAddPhotoVCSubImgViewsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/20.
//  发布租赁 传照片vc的sub cell

#import "IssueAddPhotoVCSubImgViewsTableViewCell.h"
#import "ImgAndBtnCollectionViewCell.h"
#define  ImgAndBtnCollectionViewCell_Identifier          @"ImgAndBtnCollectionViewCell"
#define  Cell_Width  ((Screen_W-32-50)/4)
#define  Cell_Height 80
#define  CollectionView_Height   100

#define  Tag_subBtn_delet  400
#define  Tag_subBtn_edit   500


@interface IssueAddPhotoVCSubImgViewsTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,assign) Cell_SubImgViews_Type type;
@property (nonatomic,strong) NSMutableArray *dataSourceImgArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation IssueAddPhotoVCSubImgViewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dataSourceWithImgviewsArr:(NSMutableArray *)dataSourceImgArr andType:(Cell_SubImgViews_Type)type{
    self.type = type;
    if (isNotNil(dataSourceImgArr)) {
        self.dataSourceImgArr = dataSourceImgArr;
        [self.collectionView reloadData];
    }
}
#pragma mark == add
- (void)addPhoneBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(subImgViewsCellAddPhotoActionWithCellType:)]) {
        [_delegate subImgViewsCellAddPhotoActionWithCellType:self.type];
    }
}
#pragma mark == delet
- (void)subBtnDeletAction:(UIButton *)sender{
    NSInteger index = sender.tag-Tag_subBtn_delet;
    if (_delegate && [_delegate respondsToSelector:@selector(subImgViewsCellDeletPhotoActionWithCellType:withIndex:)]) {
        [_delegate subImgViewsCellDeletPhotoActionWithCellType:self.type withIndex:index];
    }
}
#pragma mark == edit
- (void)subBtnEditAction:(UIButton *)sender{
    NSInteger index = sender.tag-Tag_subBtn_edit;
    if (_delegate && [_delegate respondsToSelector:@selector(subImgViewsCellEditPhotoActionWithCellType:withIndex:)]) {
        [_delegate subImgViewsCellEditPhotoActionWithCellType:self.type withIndex:index];
    }
}

#pragma mark ===
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceImgArr.count+1;
//    if (self.type==Cell_SubImgViews_Type_mainImg) {//门
//    }else if (self.type==Cell_SubImgViews_Type_shiNeiImg){//室内
//    }else{
//    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImgAndBtnCollectionViewCell *cell = (ImgAndBtnCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ImgAndBtnCollectionViewCell_Identifier  forIndexPath:indexPath];
    NSInteger maxPhotoNum = 8;
    if (self.type == Cell_SubImgViews_Type_mainImg) {
        maxPhotoNum = 3;
    }else{
//        maxPhotoNum 除了3张其他都8张maxPhotoNum
    }
    //
    if (indexPath.item>=maxPhotoNum) {
        [cell hiddenAllSubViewWithBool:YES];
        return cell;
    }else{
        [cell hiddenAllSubViewWithBool:NO];
    }
    //
    if ((self.dataSourceImgArr.count != maxPhotoNum && indexPath.item==self.dataSourceImgArr.count) || self.dataSourceImgArr.count == 0) {//没达到max且是最后一个item || 无图状态第一个item------cell样式是按钮
        [cell showCenterAddBtnWithBool:YES];
        [cell.centerBtn addTarget:self action:@selector(addPhoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell showCenterAddBtnWithBool:NO];
        if (self.dataSourceImgArr.count>indexPath.item) {
            cell.imgView.image = self.dataSourceImgArr[indexPath.row];
            cell.deletBtn.tag = Tag_subBtn_delet + indexPath.row;
            cell.editBtn.tag = Tag_subBtn_edit +indexPath.row;
            [cell.deletBtn addTarget:self action:@selector(subBtnDeletAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editBtn addTarget:self action:@selector(subBtnEditAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

#pragma markk=
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.collectionView];
        [self setUI];
    }
    return self;
}
 
- (void)setUI{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
   
}
#pragma mark ==
 

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_Width, Cell_Height);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, CollectionView_Height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ImgAndBtnCollectionViewCell class] forCellWithReuseIdentifier:ImgAndBtnCollectionViewCell_Identifier];
        _collectionView.scrollEnabled  = NO;
    }
    return _collectionView;
}
@end
