//
//  ListSubChooseItemViewTableViewCell.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/24.
//

#import "ListSubChooseItemViewTableViewCell.h"
#import "TopTypesChooseView.h"

@interface ListSubChooseItemViewTableViewCell ()

@property (nonatomic,strong) NSMutableArray *sectionArr;
@property (nonatomic,strong) NSMutableArray *bransMainArr;
@property (nonatomic,strong) NSMutableArray *placeMainArr;
@property (nonatomic,strong) NSMutableArray *onePlaceSubCabinetsArr;

@property (nonatomic,strong) CigarBrandsUseModel* choosed_branM;
@property (nonatomic,strong) PlaceModel* choosed_placeM;
@property (nonatomic,strong) CabinetModel* choosed_cM;

@end

@implementation ListSubChooseItemViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sectionArr = @[].mutableCopy;
        self.bransMainArr = @[].mutableCopy;
        self.placeMainArr = @[].mutableCopy;
        self.onePlaceSubCabinetsArr = @[].mutableCopy;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_collectionView.superview);
        }];
        
        
    }
    return self;
}

- (void)showChooseCvUseSectionHeaderTitleStr:(NSString *)sectionTitleStr{
    self.sectionArr = @[sectionTitleStr].mutableCopy;
    [self.collectionView reloadData];
}
- (void)fillDataWithArr:(NSMutableArray *)showArr WithType:(ImorExOrder_SubType)type{

    switch (type) {
            
        case ImorExOrder_SubType_AddNewBrandSubTypes://给到品牌arr
        {
            self.bransMainArr = [NSMutableArray arrayWithArray:showArr];
        }
            break;
            
        case ImorExOrder_SubType_AddNewPos_Cib://给到库arr
        case ImorExOrder_SubType_AddNewPos_Leve://给到库arr 选好库时 再fillDataWithCabArr接口得到柜子列表
        {
            self.placeMainArr = [NSMutableArray arrayWithArray:showArr];
            
        }
            break;
            
        default:
            break;
    }
    [self reHeightAndReloadData];
}
- (void)fillDataWithCabArr:(NSMutableArray *)cabArr{
    self.onePlaceSubCabinetsArr = [NSMutableArray arrayWithArray:cabArr];
    [self reHeightAndReloadData];
}
- (void)reHeightAndReloadData{
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.h_block)) {
            if ( self.h_save == self.collectionView.contentSize.height ) {
                 //刷新过高度了 不再通知tabv刷新
            } else {
                self.h_save = self.collectionView.contentSize.height;
                self.h_block(self.collectionView.contentSize.height);
            }
        }
    });
}
#define  ShowList_All_W        (Screen_W-32)
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//竖着滑动
        //        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;横着滑动
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;//状态条显示 竖着的
        //        _collectionView.showsHorizontalScrollIndicator = NO;;//状态条显示 横着的
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TopTypesChooseViewCollectionViewCell class]
            forCellWithReuseIdentifier:TopTypesChooseViewCollectionViewCell_I];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:ksectionTitileHeaderView_I];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:ksectionTitileHeaderView_I];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
#define ThisCell_Item_H (35)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //品牌/库/柜子
    if (self.type == ImorExOrder_SubType_AddNewBrandSubTypes) {
        CigarBrandsUseModel *branModel = self.bransMainArr[indexPath.row];
        NSString *showName;
        if (branModel.EngName.v == YES) {
            showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branModel.Brand],[TextShowWithModelStr textShowWithModelStr:branModel.EngName.s]];
        }else{
            showName = [TextShowWithModelStr textShowWithModelStr:branModel.Brand];
        }
        float need_W = [Tool getTextWidthWhenOneLineWithTextStr:showName withFont:[UIFont systemFontOfSize:11]];
        if (need_W < 25) {
            need_W = 25;
        }
        return  CGSizeMake(need_W+15, ThisCell_Item_H);
    }else if(self.type == ImorExOrder_SubType_AddNewPos_Cib){//加柜子 显示上级库名字
        PlaceModel *placeModel = self.placeMainArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:placeModel.Place];
        float need_W = [Tool getTextWidthWhenOneLineWithTextStr:showName withFont:[UIFont systemFontOfSize:11]];
        if (need_W < 25) {
            need_W = 25.0;
        }
        return  CGSizeMake(need_W+15, ThisCell_Item_H);
    }else{//层
        CabinetModel *cM = self.onePlaceSubCabinetsArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:cM.Cabinet];
        float need_W = [Tool getTextWidthWhenOneLineWithTextStr:showName withFont:[UIFont systemFontOfSize:11]];
        if (need_W < 25) {
            need_W = 25.0;
        }
        return  CGSizeMake(need_W+15, ThisCell_Item_H);
    }
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{//外部tabv 一个cell 做 一个section
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view addSubview:[self collectionHeader_sectionTitileHeaderViewAtIndexPath:indexPath]];
        return view;
        
    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        view.backgroundColor = [UIColor clearColor];//有分割线的效果
        return view;
    }
    
}
#define sectionMainTypeBtn_baseTag (200)
- (UIView *)collectionHeader_sectionTitileHeaderViewAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleS = self.sectionArr.firstObject;
    UIView *sectionTitileHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
    UIButton *sectionMainTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionMainTypeBtn newAnBtnWithTextStr:titleS];
    sectionMainTypeBtn.tag = indexPath.section + sectionMainTypeBtn_baseTag;
    sectionMainTypeBtn.frame = CGRectMake(16, 0, 60, 30);
    [sectionMainTypeBtn newAnBtnWithTextColor:[UIColor whiteColor]];
    [sectionMainTypeBtn newAnBtnWithBackColor:CC_Brown_A];
    [sectionMainTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
    [sectionMainTypeBtn newAnBtnWithLayerCorNerNum:2 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    [sectionTitileHeaderView addSubview:sectionMainTypeBtn];
    return sectionTitileHeaderView;
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 16, 2, 16);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 30);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 5);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;//只有一个section
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.type == ImorExOrder_SubType_AddNewPos_Leve){
        return self.onePlaceSubCabinetsArr.count;
        
    }else if (self.type == ImorExOrder_SubType_AddNewPos_Cib){
        return self.placeMainArr.count;
    }else{
        return self.bransMainArr.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopTypesChooseViewCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:TopTypesChooseViewCollectionViewCell_I forIndexPath:indexPath];
    
    if(self.type == ImorExOrder_SubType_AddNewPos_Leve){
        //柜子
        CabinetModel *cibModel = self.onePlaceSubCabinetsArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:cibModel.Cabinet];
        cell.titleLabel.text = showName;
        if (isNotNil( self.choosed_cM ) && cibModel.Id == self.choosed_cM.Id) {
            cell.backView.backgroundColor  = CC_Red_Drak_A;
        }else{
            cell.backView.backgroundColor  = CC_Brown_C;
        }
        
    }else if (self.type == ImorExOrder_SubType_AddNewPos_Cib){
        //位置 -仓库一级
        PlaceModel *placeModel = self.placeMainArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:placeModel.Place];
        cell.titleLabel.text = showName ;
        if (isNotNil( self.choosed_placeM ) && placeModel.Id == self.choosed_placeM.Id) {
            cell.backView.backgroundColor  = CC_Red_Drak_A;
        }else{
            cell.backView.backgroundColor  = CC_Brown_C;
        }
    }else{//品牌一级
        CigarBrandsUseModel *branModel = self.bransMainArr[indexPath.row];
        NSString *showName;
        if (branModel.EngName.v == YES) {
            showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branModel.Brand],[TextShowWithModelStr textShowWithModelStr:branModel.EngName.s]];
        }else{
            showName = [TextShowWithModelStr textShowWithModelStr:branModel.Brand];
        }
        cell.titleLabel.text = showName;
        if (isNotNil( self.choosed_branM ) && branModel.Id == self.choosed_branM.Id) {
            cell.backView.backgroundColor  = CC_Red_Drak_A;
        }else{
            cell.backView.backgroundColor  = CC_Brown_C;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.type == ImorExOrder_SubType_AddNewPos_Leve){
        //柜子
        if (isNotNil(self.cabBlcok) && isNotNil(self.onePlaceSubCabinetsArr)) {
            self.cabBlcok(self.onePlaceSubCabinetsArr[indexPath.row]);
            self.choosed_cM = self.onePlaceSubCabinetsArr[indexPath.row];

        }
        //层
    }else if (self.type == ImorExOrder_SubType_AddNewPos_Cib){
        if (isNotNil(self.placeBlcok) && isNotNil(self.placeMainArr)) {
            self.placeBlcok(self.placeMainArr[indexPath.row]);
            self.choosed_placeM = self.placeMainArr[indexPath.row];
            self.choosed_cM = nil;
        }
    }else{//品牌一级
        if (isNotNil(self.branBlcok) && isNotNil(self.bransMainArr)) {
            self.branBlcok(self.bransMainArr[indexPath.row]);
            self.choosed_branM = self.bransMainArr[indexPath.row];
        }
    }
    [self.collectionView reloadData];
    
}
@end
