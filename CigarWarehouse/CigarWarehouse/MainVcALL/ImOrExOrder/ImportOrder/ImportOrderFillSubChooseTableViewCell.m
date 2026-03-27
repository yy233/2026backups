//
//  ImportOrderFillSubChooseTableViewCell.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/25.
//

#import "ImportOrderFillSubChooseTableViewCell.h"

@interface ShowCollectionViewTableViewCell ()
@property (nonatomic,assign)  BOOL  thisCvOneSectionShowIsBrandsBool;
@property (nonatomic,strong)  CigarBrandsUseModel* choosed_branM;
@property (nonatomic,strong)  BrandTypesModel * choosed_btypeM;
@end
@implementation ShowCollectionViewTableViewCell
//单行显示collv
#pragma mark ===
- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
- (void)isBands{
    self.mainSectionHeaderUseShowArr = @[@"品牌"];
    self.thisCvOneSectionShowIsBrandsBool = YES;
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.h_block)) {
            self.h_block(self.collectionView.contentSize.height);
        }
    });
}
- (void)isBandTypes{
    self.mainSectionHeaderUseShowArr = @[@"品牌型号"];
    self.thisCvOneSectionShowIsBrandsBool = NO;
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.h_block)) {
            self.h_block(self.collectionView.contentSize.height);
        }
    });
    
}

- (void)fillDataSourceModel:(NSMutableArray *)sourceArr{
    if (sourceArr.count==0) {
        return;
    }
    self.dataSourceArr = [NSMutableArray arrayWithArray:sourceArr];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.h_block)) {
            self.h_block(self.collectionView.contentSize.height);
        }
    });
}

- (void)changeTopViewToCellView{
    
}

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.collectionView];
        //
        self.mainSectionHeaderUseShowArr = @[];
        self.collectionView.tag = TopTypesChooseView_Tag;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_collectionView.superview);
        }];
        
    }
    return self;
}

#define  ShowList_All_W        (Screen_W-32)
#define  Item_H                (25)
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
        _collectionView.tag = TopTypesChooseView_Tag;
    }
    return _collectionView;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){//品牌
        if (self.thisCvOneSectionShowIsBrandsBool == YES) {
            CigarBrandsUseModel *branModel = self.dataSourceArr[indexPath.row];
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
            return  CGSizeMake(need_W+15, Item_H);
        } else {
            //品牌型号
            BrandTypesModel *branTypeModel = self.dataSourceArr[indexPath.row];
            NSString *showName;
            if (branTypeModel.Name.length == 0) {
                return  CGSizeMake(25+15, Item_H);
            }
            if (branTypeModel.EngName.v == YES) {
                showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branTypeModel.Name],[TextShowWithModelStr textShowWithModelStr:branTypeModel.EngName.s]];
            }else{
                showName = [TextShowWithModelStr textShowWithModelStr:branTypeModel.Name];
            }
            float need_W = [Tool getTextWidthWhenOneLineWithTextStr:showName withFont:[UIFont systemFontOfSize:11]];
            if (need_W < 25) {
                need_W = 25;
            }
            return  CGSizeMake(need_W+15, Item_H);
        }
       
    }else{
        return  CGSizeMake(Item_H, Item_H);
    }
    
    
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 20, 5, 20);//某Section总的上下左右
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
    return self.mainSectionHeaderUseShowArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSourceArr.count;
    
    
}
#pragma mark ==== 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        TopTypesChooseViewCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:TopTypesChooseViewCollectionViewCell_I forIndexPath:indexPath];
        
        if (self.thisCvOneSectionShowIsBrandsBool == YES) {//品牌
            CigarBrandsUseModel *branModel = self.dataSourceArr[indexPath.row];
            NSString *showName;
            if (branModel.EngName.v == YES) {
                showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branModel.Brand],[TextShowWithModelStr textShowWithModelStr:branModel.EngName.s]];
            }else{
                showName = [TextShowWithModelStr textShowWithModelStr:branModel.Brand];
            }
            cell.titleLabel.text = showName;
             
            if (isNotNil( self.choosed_branM ) && self.choosed_branM.Id == branModel.Id) {
                cell.backView.backgroundColor  = CC_Red_Drak_A;
            }else{
                cell.backView.backgroundColor  = CC_Brown_C;
            }
            return cell;
                
        } else {
            //品牌型号
            BrandTypesModel *branTypeModel = self.dataSourceArr[indexPath.row];
            NSString *showName;
            if (branTypeModel.EngName.v == YES) {
                showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branTypeModel.Name],[TextShowWithModelStr textShowWithModelStr:branTypeModel.EngName.s]];
            }else{
                showName = [TextShowWithModelStr textShowWithModelStr:branTypeModel.Name];
            }
            cell.titleLabel.text = showName;
            if (isNotNil( self.choosed_btypeM ) && self.choosed_btypeM.Id == branTypeModel.Id) {
                cell.backView.backgroundColor  = CC_Red_Drak_A;
            }else{
                cell.backView.backgroundColor  = CC_Brown_C;
            }
            return cell;
                
        }
    
    }else{//非第一组section
        return [[UICollectionViewCell alloc]init];
    }
    
   
    
    
}
#pragma mark ====
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view addSubview:[self collectionHeader_sectionTitileHeaderViewAtIndexPath:indexPath]];
        return view;
        
    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        return view;
    }
    
}
#define sectionMainTypeBtn_baseTag (200)
- (UIView *)collectionHeader_sectionTitileHeaderViewAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mainSectionHeaderUseShowArr.count<=0 || self.mainSectionHeaderUseShowArr.count <= indexPath.section) {
        return [UIView new];
    }
    NSString *titleS = self.mainSectionHeaderUseShowArr[indexPath.section];
    
    UIView *sectionTitileHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
    UIButton *sectionMainTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionMainTypeBtn newAnBtnWithTextStr:titleS];
    sectionMainTypeBtn.tag = indexPath.section + sectionMainTypeBtn_baseTag;
    sectionMainTypeBtn.frame = CGRectMake(16, 2, 88, 26);
    [sectionMainTypeBtn newAnBtnWithTextColor:[UIColor whiteColor]];
    [sectionMainTypeBtn newAnBtnWithBackColor:CC_Brown_A];
    [sectionMainTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
    [sectionMainTypeBtn newAnBtnWithLayerCorNerNum:2 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    [sectionMainTypeBtn addTarget:self action:@selector(beginChooseMianType:) forControlEvents:UIControlEventTouchUpInside];
    [sectionTitileHeaderView addSubview:sectionMainTypeBtn];
    return sectionTitileHeaderView;
}

//点击类型
- (void)beginChooseMianType:(UIButton *)sender{
    //单组的 不做sectionHeaderd点击显隐 直接外部给数据 
}
#pragma mark ====
/**
 if (section == 0){
     if (self.thisCvOneSectionShowIsBrandsBool == YES) {//品牌
     } else {
     }
     
 }else{
 }*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"sec=%ld row%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (indexPath.section == 0){
        if (self.thisCvOneSectionShowIsBrandsBool == YES) {//品牌
            CigarBrandsUseModel *branModel = self.dataSourceArr[indexPath.row];
            //刷新首页——品牌类型
            if (isNotNil(self.anBansBlcok)) {
                self.anBansBlcok(branModel);
                self.choosed_branM = branModel;
            }
        } else {
            BrandTypesModel *branTypeModel = self.dataSourceArr[indexPath.row];
            //刷新首页——品牌类型
            if (isNotNil(self.oneBrandAnTypeBlcok)) {
                self.oneBrandAnTypeBlcok(branTypeModel);
                self.choosed_btypeM = branTypeModel;
            }
        }
    }else{
    }
    [self.collectionView reloadData];
}
@end

#pragma mark ==========================================================================================

@implementation ImportOrderFillSubChooseTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [self changeTopViewToCellView];
    }
    return self;
}

 
- (void)changeTopViewToCellView{
    
}


@end
