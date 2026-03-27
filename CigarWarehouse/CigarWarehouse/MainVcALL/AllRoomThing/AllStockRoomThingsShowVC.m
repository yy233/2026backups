//
//  AllStockRoomThingsShowVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "AllStockRoomThingsShowVC.h"

#import "AllStockRoomThingsShowCollectionViewCell.h"


@interface AllStockRoomThingsShowVC () <UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@end

@implementation AllStockRoomThingsShowVC

#pragma mark ===
- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
- (NSMutableArray *)dataSourceArr_S{
    if(!_dataSourceArr_S){
        _dataSourceArr_S = @[].mutableCopy;
    }
    return _dataSourceArr_S;
}

#pragma mark ===
- (TopSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[TopSearchView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Y_Height_50)];
        _searchView.searchBar.delegate = self;
    }
    return _searchView;
}
- (TopTypesChooseView *)topTypesChooseView{
    if (!_topTypesChooseView) {
        _topTypesChooseView = [[TopTypesChooseView alloc]init];
    }
    return _topTypesChooseView;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(MainVc_CellItem_W,MainVc_CellItem_H);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[AllStockRoomThingsShowCollectionViewCell class] 
            forCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_I];
        [_collectionView registerClass:[AllStockRoomThingsShowCollectionViewCell_subHaveTabv class]
            forCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_subHaveTabv_I];
        _collectionView.scrollEnabled = YES;
        _collectionView.tag = ThisVcMainCollectionView_Tag;
    }
    return _collectionView;
    
}
- (void)initViews{
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.topTypesChooseView];
    [self.view addSubview:self.collectionView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_searchView.superview);
        make.height.offset(Y_Height_50);
    }];
    [_topTypesChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_topTypesChooseView.superview);
        make.top.equalTo(_searchView.mas_bottom);
        make.height.offset(Y_Height_70);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTypesChooseView.mas_bottom);
        make.left.right.equalTo(_collectionView.superview);
        make.bottom.equalTo(_collectionView.superview).offset(kBottom_SafeHeight);
    }];
    
   
}

#pragma mark ===
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initData];//初试全部数据展示 相关查询总接口
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)initData{
  
//    for (int i = 0; i <3; i++) {
//        BrandStockInFoModel *model = [[BrandStockInFoModel alloc]init];
//        model.Name = [[BaseSVModel alloc]init];
//        model.Owner = [[BaseSVModel alloc]init];
//        model.Name.v = YES;
//        model.Name.s = [NSString stringWithFormat:@"Name - %d",i];
//        model.Owner.s = @"";
//        model.BuyPrice = @111.3;
//        model.Pieces = i;
//        model.ProduceFrom = @"ProduceFrom";
//        model.BuyFrom = @"BuyFrom";
//        model.Pack = @"支";
//        model.Code = @"Code111";
//        model.pos = i;
//        model.Id = i;
//        if (i==1) {
//            model.tubos = YES;
//        }
//        [self.dataSourceArr addObject:model];
//    }
//    [self.collectionView reloadData];
    //____test end
    
    WEAKSELF
    self.topTypesChooseView.h_block = ^(CGFloat thisHeight) {
        if (thisHeight < Y_Height_70) {//缩小动作
            thisHeight = Y_Height_70;
            DLog("topTypesChooseView 高度变小")
        }
        [weakSelf.topTypesChooseView mas_updateConstraints:^(MASConstraintMaker *make) {//更新筛选区域高度
            make.height.offset(thisHeight);
           
        }];
        //[weakSelf.collectionView reloadData];
    };
    
    self.topTypesChooseView.anBansBlcok = ^(CigarBrandsUseModel * _Nonnull bModel) {
        if (bModel.Id > 0) {
            //按品牌ID搜索仓库
            [[GetDatasTool share]getBrandStockNumOfOneBrandId:bModel.Id 
                                             withOtherInfoDic:@{}.mutableCopy
                                       withTypesListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
                if (succ) {
                    weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[BrandStockInFoModel mj_objectArrayWithKeyValuesArray:dataList]];
                    [weakSelf.collectionView reloadData];
                }else{
                    
                }
            }];
            
        }
    };
    
    self.topTypesChooseView.oneBrandAnTypeBlcok = ^(BrandTypesModel * _Nonnull bTypeModel) {
        if (bTypeModel.Id > 0) {
            //按某品牌的某子类型ID搜索仓库
            DLog(@"某品牌的某子类型ID搜 暂无接口")
    
            
        }
    };
    
}

#pragma mark ======= 搜索状态下的data
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length <= 0) {
        [self searchDataRefrsh:searchBar];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   [self searchDataRefrsh:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   //清空text
   [self.searchView.searchBar resignFirstResponder];//失去第一响应者身份后//输入框回去
   self.searchView.searchBar.text = @"";
   searchBar.text = @"";
   [self searchDataRefrsh:searchBar];
}

- (void)searchDataRefrsh:(UISearchBar *)searchBar{
   if (searchBar.text.length>0) {
       //重新处理 data_S 数据
       NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF.Name.s CONTAINS %@ || SELF.ProduceFrom CONTAINS %@ || SELF.Owner.s CONTAINS %@",searchBar.text,searchBar.text,searchBar.text];
       NSLog(@"predicate.predicateFormat: %@", predicate.predicateFormat);
       self.dataSourceArr_S = [NSMutableArray arrayWithArray:[self.dataSourceArr filteredArrayUsingPredicate:predicate]];
   }else{
       //重新处理 data_S 数据 可以清空
       [self.searchView.searchBar resignFirstResponder];
   }
   NSLog(@"dataSourceArr_S -- %@",self.dataSourceArr_S);
   [self.collectionView reloadData];
}

#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.searchView.searchBar.text.length>0) {
        return self.dataSourceArr_S.count;
    }else{
        return self.dataSourceArr.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 10);
}
#pragma mark ====

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AllStockRoomThingsShowCollectionViewCell_subHaveTabv *cell = (AllStockRoomThingsShowCollectionViewCell_subHaveTabv *)[collectionView dequeueReusableCellWithReuseIdentifier:AllStockRoomThingsShowCollectionViewCell_subHaveTabv_I forIndexPath:indexPath];
    cell.buyAddBtn.tag = buyAddBtn_baseTag+indexPath.row;
    [cell.buyAddBtn addTarget:self action:@selector(buyAddBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    BrandStockInFoModel *model;
    if (self.searchView.searchBar.text.length>0) {
        model = self.dataSourceArr_S[indexPath.row];
    }else{
        model = self.dataSourceArr[indexPath.row];
    }
    if (self.subCellIsShowAddBtn == YES) {
        [cell fillDataModel:model haveAddBtnShow:self.subCellIsShowAddBtn];
    }else{
        [cell fillDataModel:model];

    }
 
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    BrandStockInFoModel *model;
    if (self.searchView.searchBar.text.length>0) {
        model = self.dataSourceArr_S[indexPath.row];
    }else{
        model = self.dataSourceArr[indexPath.row];
    }
}

#pragma mark ====  addbtnAction
- (void)buyAddBtnAction:(UIButton *)sender{
    
    NSInteger addIndex = sender.tag - buyAddBtn_baseTag;
    BrandStockInFoModel *model;
    if (self.searchView.searchBar.text.length>0) {
        model = self.dataSourceArr_S[addIndex];
    }else{
        model = self.dataSourceArr[addIndex];
    }
    [self dealBuyAddBtnChooseModel:model];
}
- (void)dealBuyAddBtnChooseModel:(BrandStockInFoModel *)model{
    DLog()
}
@end
