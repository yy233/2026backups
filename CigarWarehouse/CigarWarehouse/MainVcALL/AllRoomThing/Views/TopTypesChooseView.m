//
//  TopTypesChooseView.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "TopTypesChooseView.h"

@implementation TopTypesChooseViewCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor  = CC_Brown_B;
    }
    return _backView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}


@end


#pragma mark ============================================================================ TopTypesChooseView 主页 大类查寻点击view

@interface TopTypesChooseView ()
@property (nonatomic,strong) NSMutableArray *bransMainArr;
@property (nonatomic,strong) NSMutableArray *oneBranSubTypesArr;
@property (nonatomic,strong) NSMutableArray *placeMainArr;
@property (nonatomic,strong) NSMutableArray *onePlaceSubCabinetsArr;

@property (nonatomic,strong) id saveNowChooseBrandsModel;

@end
@implementation TopTypesChooseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.mainSectionHeaderUseShowArr = @[@"品牌",@"位置"];
        self.mainSectionHeaderUseShowArr =  @[@"品牌"];
        [self addSubview:self.collectionView];
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
        return  CGSizeMake(need_W+15, Item_H);
    }else{
        PlaceModel *placeModel = self.placeMainArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:placeModel.Place];
        float need_W = [Tool getTextWidthWhenOneLineWithTextStr:showName withFont:[UIFont systemFontOfSize:11]];
        if (need_W < 25) {
            need_W = 25.0;
        }
        return  CGSizeMake(need_W+15, Item_H);
    }
    
    
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 20, 0, 20);//某Section总的上下左右
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
    
    if (section == 0) {//品牌
        if (self.isShowBool_brans == YES) {//显示隐藏
            return self.bransMainArr.count;
        }else{
            return 0;
        }
    }else{//位置
        if (self.isShowBool_Pos == YES) {
            return self.placeMainArr.count;
        }else{
            return 0;
        }
       
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopTypesChooseViewCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:TopTypesChooseViewCollectionViewCell_I forIndexPath:indexPath];
    if(indexPath.section == 0){//品牌一级
        CigarBrandsUseModel *branModel = self.bransMainArr[indexPath.row];
        NSString *showName;
        if (branModel.EngName.v == YES) {
            showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branModel.Brand],[TextShowWithModelStr textShowWithModelStr:branModel.EngName.s]];
        }else{
            showName = [TextShowWithModelStr textShowWithModelStr:branModel.Brand];
        }
        cell.titleLabel.text = showName;
        if (isNotNil(self.saveChooseBranModel) && self.saveChooseBranModel.Id == branModel.Id) {
            cell.backView.backgroundColor  = CC_Red_Drak_A;
        }else{
            cell.backView.backgroundColor  = CC_Brown_C;
        }
        
    }else{//位置 -仓库一级
        
        PlaceModel *placeModel = self.placeMainArr[indexPath.row];
        NSString *showName = [TextShowWithModelStr textShowWithModelStr:placeModel.Place];
        cell.titleLabel.text = showName ;
    }
    
    return cell;
    
    
}
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
    sectionMainTypeBtn.frame = CGRectMake(16, 0, 60, 30);
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
    if (  sender.tag - sectionMainTypeBtn_baseTag == 0) {
        //品牌
        self.isShowBool_brans = !self.isShowBool_brans;
        if (self.isShowBool_brans == true) {
            //搜索并展示
            [self refData_allMainBrans];
        }else{
            //不展示
            [self needCvreloadDataAndHaveNewHeight];

        }
        
    }else{
        //位置
        self.isShowBool_Pos = !self.isShowBool_Pos;
        if (self.isShowBool_Pos == true) {
            //搜索并展示
            [self refData_allMainPos_Place];
        }else{
            //不展示
            [self needCvreloadDataAndHaveNewHeight];

        }
       
    }
}


#pragma mark ====
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"sec=%ld row%ld",(long)indexPath.section,(long)indexPath.row);
    if(indexPath.section == 0){//品牌
        CigarBrandsUseModel *branModel = self.bransMainArr[indexPath.row];
        NSString *showName;
        if (branModel.EngName.v == YES) {
            showName = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:branModel.Brand],[TextShowWithModelStr textShowWithModelStr:branModel.EngName.s]];
        }else{
            showName = [TextShowWithModelStr textShowWithModelStr:branModel.Brand];
        }
        NSString *choseBranStr = [NSString stringWithFormat:@"选中品牌：%@",showName];
        Y_SVP_SHOW_INFO_MES(choseBranStr);
        [self homeListShowThisBransAndTypeCollectViewShowMuneWithBrandModel:branModel];
    }else{//位置
        Y_SVP_SHOW_INFO_MES(@"敬请期待");
        
    }
    
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    if (indexPath.section == 0) {//品牌
        return  [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
            return [self mmmmListsShowBrandTypes];
        }];
    }else{
        return  [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
            return [self mmmmListsShowPosTypess];
        }];
    }
    
}
 
- (UIMenu *)mmmmListsShowBrandTypes{
    return [self mmmmInitWithPosDicArr:nil orBransunTypesArr:self.oneBranSubTypesArr];
}
- (UIMenu *)mmmmListsShowPosTypess{
    return [self mmmmInitWithPosDicArr:self.onePlaceSubCabinetsArr orBransunTypesArr:nil];

}
- (UIMenu *)mmmmInitWithPosDicArr:(NSMutableArray *)pShowArr orBransunTypesArr:(NSMutableArray *)bShowArr{
    
    NSMutableArray *getChildredMenuArr = [[NSMutableArray alloc]init];;
    if (bShowArr.count>0) {
        for (int i = 0 ; i<bShowArr.count; i++) {
            BrandTypesModel *btm = bShowArr[i];
            NSString *titles;
            if (btm.EngName.v == true) {
                titles = [[TextShowWithModelStr textShowWithModelStr: btm.Name]
                                    stringByAppendingString:[TextShowWithModelStr textShowWithModelStr: btm.EngName.s]];
            } else {
                titles = [TextShowWithModelStr textShowWithModelStr: btm.Name];
            }
            UIAction *action = [UIAction actionWithTitle:titles
                                                   image:[UIImage new] identifier:[NSString stringWithFormat:@"%ld",(long)btm.Id]
                                                 handler:^(UIAction *action) {
                [self chooseOneBranSubOneType:btm];
                
            }];
            [getChildredMenuArr addObject: action];
        }
        return [UIMenu menuWithChildren:getChildredMenuArr];

        
    }else{
        return [UIMenu menuWithChildren:@[]];
    }
}


#pragma mark ==================================== 品牌位置相关查询刷新动作
- (void)homeListShowThisBransAndTypeCollectViewShowMuneWithBrandModel:(CigarBrandsUseModel *)bModel{
    
    //刷新首页——品牌类型
    if (isNotNil(self.anBansBlcok)) {
        self.anBansBlcok(bModel);
    }
    //获取子品牌型号--   后去生成品牌型号菜单 前后刷新导致子型号不出现问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refData_OneBranSubTypesWithTouchBrandId:bModel.Id];
    });
    self.isShowBool_brans = NO;
    //做完折叠隐藏动作 自主刷新+处理高度block
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self needCvreloadDataAndHaveNewHeight];//选择后更改了高度折叠动作
    });

    
}

#pragma mark == 二级三级查询mune
- (void)addAnMuneWithNowTypeIsBransunType:(BOOL)isBranSubTypes withSubTypesArr:(NSMutableArray *)subArr{
    DLog(@"查询菜单 显示");
    if (isBranSubTypes == true) {
        self.onePlaceSubCabinetsArr = nil;
    }else{
        self.oneBranSubTypesArr = nil;
    }
    [self.collectionView reloadData];//触发显示菜单
}
- (void)chooseOneBranSubOneType:(BrandTypesModel *)brandSubType{
    //选择a品牌的某个型号
    //刷新首页——品牌类型
    if (isNotNil(self.oneBrandAnTypeBlcok)) {
        self.oneBrandAnTypeBlcok(brandSubType);
    }
}

#pragma mark ============================ 高度相关并刷新
//刷新列表 并更新高度
- (void)needCvreloadDataAndHaveNewHeight{
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.h_block)) {
            self.h_block(self.collectionView.contentSize.height);
        }
    });
  
}

#pragma mark ==== doData

- (NSMutableArray *)bransMainArr{
    if (!_bransMainArr) {
        _bransMainArr = [[NSMutableArray alloc]init];
    }
    return _bransMainArr;
}
- (NSMutableArray *)placeMainArr{
    if (!_placeMainArr) {
        _placeMainArr = [[NSMutableArray alloc]init];
    }
    return _placeMainArr;
}
- (NSMutableArray *)oneBranSubTypesArr{
    if (!_oneBranSubTypesArr) {
        _oneBranSubTypesArr = [[NSMutableArray alloc]init];
    }
    return _oneBranSubTypesArr;
}

- (NSMutableArray *)onePlaceSubCabinetsArr{
    if (!_onePlaceSubCabinetsArr) {
        _onePlaceSubCabinetsArr = [[NSMutableArray alloc]init];
    }
    return _onePlaceSubCabinetsArr;
}
//搜索品牌列表
- (void)refData_allMainBrans{
    [[GetDatasTool share]getAllBrandsListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        if (succ) {
            NSArray *getmodels = [CigarBrandsUseModel mj_objectArrayWithKeyValuesArray:dataList];
            self.bransMainArr = getmodels.mutableCopy;
            [self needCvreloadDataAndHaveNewHeight];
        }
    }];
}
//搜索品牌的子类型列表
- (void)refData_OneBranSubTypesWithTouchBrandId:(NSInteger)bId{
    self.isShowBool_brans = NO;//点击品牌回去搜索子型号 此时 主界面列表展示 需要本view 折叠状态
    DLog(@"bId = %ld",(long)bId)
    self.oneBranSubTypesArr = @[].mutableCopy;//清空之前的品牌子型号类型列表
    [[GetDatasTool share]getBrandTypesOfOneBrandId:bId withTypesListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        if (succ) {
            NSArray *getmodels = [BrandTypesModel mj_objectArrayWithKeyValuesArray:dataList];
            if (getmodels.count == 0) {
                Y_SVP_SHOW_INFO_MES(@"当前品牌暂无型号数据");
                self.oneBranSubTypesArr = @[].mutableCopy;//清空之前的品牌子型号类型列表
            }else{
                self.oneBranSubTypesArr = getmodels.mutableCopy;
            }
            [self addAnMuneWithNowTypeIsBransunType:YES withSubTypesArr:self.oneBranSubTypesArr];
        }else{
        }
    }];
     
}

//搜索仓库
- (void)refData_allMainPos_Place{
    [[GetDatasTool share] getAllPlaceListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        if (succ) {
            NSArray *getmodels = [PlaceModel mj_objectArrayWithKeyValuesArray:dataList];
            self.placeMainArr = getmodels.mutableCopy;
            [self needCvreloadDataAndHaveNewHeight];
        }
    }];
}


@end
