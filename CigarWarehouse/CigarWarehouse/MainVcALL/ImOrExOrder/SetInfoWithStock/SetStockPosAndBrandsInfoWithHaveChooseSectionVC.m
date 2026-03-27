//
//  SetStockPosAndBrandsInfoWithHaveChooseSectionVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/24.
//

#import "SetStockPosAndBrandsInfoWithHaveChooseSectionVC.h"
#import "ListSubChooseItemViewTableViewCell.h"
@interface SetStockPosAndBrandsInfoWithHaveChooseSectionVC ()
@property (nonatomic,strong) CabinetModel *cabM;
@property (nonatomic,strong) PlaceModel *placeM;
@property (nonatomic,strong) CigarBrandsUseModel *brandM;
@property (nonatomic,strong) NSMutableArray *arr_brands;
@property (nonatomic,strong) NSMutableArray *arr_places;
@property (nonatomic,strong) NSMutableArray *arr_cabnets;
@property (nonatomic,assign) CGFloat getChooseSection_Height;
@property (nonatomic,assign) CGFloat getChooseSection_Height_SectionCib;

@end

@implementation SetStockPosAndBrandsInfoWithHaveChooseSectionVC

- (NSMutableArray *)chooseUseSectionTitleArr{
    if (!_chooseUseSectionTitleArr) {
        _chooseUseSectionTitleArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _chooseUseSectionTitleArr;
}
- (NSMutableArray *)arr_brands{
    if (!_arr_brands) {
        _arr_brands = @[].mutableCopy;
    }
    return _arr_brands;
}
- (NSMutableArray *)arr_places{
    if (!_arr_places) {
        _arr_places = @[].mutableCopy;
    }
    return _arr_places;
}
- (NSMutableArray *)arr_cabnets{
    if (!_arr_cabnets) {
        _arr_cabnets = @[].mutableCopy;
    }
    return _arr_cabnets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getChooseSection_Height = 80;
    self.getChooseSection_Height_SectionCib = 8;
    [self getOneSectionChooseUseData];
}

- (void)initChooseThings{
    switch (self.type) {
        case ImorExOrder_SubType_AddNewBrandSubTypes://型号
        {
            self.chooseUseSectionTitleArr = @[@"品牌名"].mutableCopy;
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Cib://柜子
        {
            self.chooseUseSectionTitleArr = @[@"库房"].mutableCopy;
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Leve://层
        {
            self.chooseUseSectionTitleArr = @[@"库房",@"柜子"].mutableCopy;
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}


#pragma mark ===
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
    /**
     if (section == [tableView numberOfSections]-1) {
         return [UIView new];
     }else{
         UIView *sectionHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
         LabelYu *sTitle = [[LabelYu alloc]init];
         sTitle.textInsets = UIEdgeInsetsMake(0, 16, 0, 0);
         sTitle.text = self.chooseUseSectionTitleArr[section];
         [sectionHeaderV addSubview:sTitle];
         return sectionHeaderV;
     }
     */

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chooseUseSectionTitleArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == [tableView numberOfSections]-1) {
        return self.dataSourceTitleArr.count;
    }else{
        return 1;
    }

}

#pragma mark ========= cell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == [tableView numberOfSections]-1) {
        return 65;
    }else{//选择区域高度待动态
        if (self.type == ImorExOrder_SubType_AddNewPos_Cib) {//添加柜子 上级 库数据 就两条数据 高度钉死
            return 70;
        }else{
//            ListSubChooseItemViewTableViewCell *cell= (ListSubChooseItemViewTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (self.type == ImorExOrder_SubType_AddNewPos_Leve){//层lev
                if (indexPath.section==0) {//p
                    return self.getChooseSection_Height;//sectionPlace
                    NSLog(@"getChooseSection_Height -- %f",self.getChooseSection_Height);
                }else{//cib
                    return self.getChooseSection_Height_SectionCib;
                    NSLog(@"getChooseSection_Height_SectionCib -- %f",self.getChooseSection_Height_SectionCib);
                }
            }else{
                return self.getChooseSection_Height;
            }
          
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [tableView numberOfSections]-1) {//最后一排 填写区
        ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_I];
        if (!cell) {
            cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_I];
        }
        cell.titL.text = self.dataSourceTitleArr[indexPath.row];
        cell.textF.text = self.dataSourceSourceArr[indexPath.row];
        cell.textF.tag = cell_tf_BaseTag + indexPath.row;
        cell.textF.delegate = self;
        return cell;
    }else if(indexPath.section == 0){//品牌/库
        ListSubChooseItemViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListSubChooseItemViewTableViewCell_I];
        if (!cell) {
            cell = [[ListSubChooseItemViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListSubChooseItemViewTableViewCell_I];
        }
       
        [cell showChooseCvUseSectionHeaderTitleStr:self.chooseUseSectionTitleArr[indexPath.section]];
        [cell fillDataWithArr:@[].mutableCopy WithType:self.type];
        WEAKSELF
        cell.h_block = ^(CGFloat h) {
            weakSelf.getChooseSection_Height = h;
            NSLog(@"heightForRowAtIndexPath ListSubChooseItemViewTableViewCell hblock");
            //[tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf reHeightNoReData];
        };
        cell.branBlcok = ^(CigarBrandsUseModel * _Nonnull bModel) {
            weakSelf.brandM = bModel;
        };
        cell.placeBlcok = ^(PlaceModel * _Nonnull placeModel) {
            weakSelf.placeM = placeModel;
            weakSelf.cabM = nil;
            weakSelf.arr_cabnets = @[].mutableCopy;
            
            if (weakSelf.type == ImorExOrder_SubType_AddNewPos_Leve) {
                [weakSelf getCibArrWithPid:placeModel.Id];
            }
        };
        if (self.type == ImorExOrder_SubType_AddNewBrandSubTypes) {
            cell.type = self.type;//一级
            [cell fillDataWithArr:self.arr_brands WithType:self.type];
        }
        if (self.type == ImorExOrder_SubType_AddNewPos_Cib || self.type == ImorExOrder_SubType_AddNewPos_Leve) {
            cell.type = ImorExOrder_SubType_AddNewPos_Cib;//self.type; 做成库数据和品牌数据一级
            [cell fillDataWithArr:self.arr_places WithType:ImorExOrder_SubType_AddNewPos_Cib];//一级数据
        }
        return cell;
    }else{//柜子
        ListSubChooseItemViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListSubChooseItemViewTableViewCell_I];
        if (!cell) {
            cell = [[ListSubChooseItemViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListSubChooseItemViewTableViewCell_I];
        }
       
        cell.type = self.type;
        [cell showChooseCvUseSectionHeaderTitleStr:self.chooseUseSectionTitleArr[indexPath.section]];
        [cell fillDataWithCabArr:self.arr_cabnets];
        WEAKSELF
        cell.h_block = ^(CGFloat h) {
            weakSelf.getChooseSection_Height_SectionCib = h;
            NSLog(@"heightForRowAtIndexPath ListSubChooseItemViewTableViewCell hblock");
            //[tableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf reHeightNoReData];
        };
        cell.cabBlcok = ^(CabinetModel * _Nonnull cibModel) {
            weakSelf.cabM = cibModel;
        };
        if (self.type == ImorExOrder_SubType_AddNewPos_Leve) {
            [cell fillDataWithArr:self.arr_cabnets WithType:self.type];
        }
        return cell;
    }
   
}

//只更新高度不会更数据 防hblock的反复触发
- (void)reHeightNoReData{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    //[self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
#pragma mark ==
- (void)getOneSectionChooseUseData{
    if (self.type == ImorExOrder_SubType_AddNewBrandSubTypes) {
        [[GetDatasTool share]getAllBrandsListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
            if (succ) {
                if (dataList.count>0) {
                    self.arr_brands = [NSMutableArray arrayWithArray:[CigarBrandsUseModel mj_objectArrayWithKeyValuesArray:dataList]];
                    [self.tableView reloadData];

                }
            }
        }];
    }else{
        [[GetDatasTool share]getAllPlaceListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
            if (succ) {
                if (dataList.count>0) {
                    self.arr_places = [NSMutableArray arrayWithArray:[PlaceModel mj_objectArrayWithKeyValuesArray:dataList]];
                    if (self.type == ImorExOrder_SubType_AddNewPos_Leve) {
                        [self.tableView reloadData];
//                        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

                    }else{
                        [self.tableView reloadData];

                    }
                }
            }
        }];
    }
    
}
//层数据
- (void)getCibArrWithPid:(NSInteger)pid{
    WEAKSELF
    [[GetDatasTool share]getOnePlaceSubCabinetListWithPlaceId:pid withCabinetListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        if (succ) {
            if (dataList.count>0) {
                weakSelf.arr_cabnets = [NSMutableArray arrayWithArray:[CabinetModel mj_objectArrayWithKeyValuesArray:dataList]];
            }
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            DLog(@"getOnePlaceSubCabinetListWithPlaceId 失败");
        }
            
    }];
    
}
#pragma mark ==
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    DLog(@"%@ \n %@",self.dataSourceTitleArr,self.dataSourceSourceArr);
    switch (self.type) {

      
        case ImorExOrder_SubType_AddNewBrandSubTypes:
        {
            NSLog(@"新增品牌型号");//选择后 填写 子类型信息
            if (self.brandM.Id<=0) {
                Y_SVP_SHOW_INFO_MES(@"请选择品牌！");
                return;
            }
            if ([self.dataSourceSourceArr.firstObject length]<=0) {
                Y_SVP_SHOW_INFO_MES(@"请填写品牌型号名！");
                return;
            }
            [[PosAndBrandInfoAddTools share]addBrandTypeWithBrandTypeNameStr:self.dataSourceSourceArr.firstObject
                                                             withEngTypeName:self.dataSourceSourceArr[1]
                                                               withBasePrice:@"0"
                                                              withIsCubaBool:YES
                                                       withThisTypeOfBarnsId:self.brandM.Id
                                                                   withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
                
                if (succ) {
                    Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Y_SVP_SHOW_ERR_MES(@"添加失败");
                }
                 
            }];
            
            
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Cib:
        {
            if (self.placeM.Id<=0) {
                Y_SVP_SHOW_INFO_MES(@"请选择仓库！");
                return;
            }
            if ([self.dataSourceSourceArr.firstObject length]<=0) {
                Y_SVP_SHOW_INFO_MES(@"请填写柜子名！");
                return;
            }
            [[PosAndBrandInfoAddTools share] addCabinetNameStr:self.dataSourceSourceArr.firstObject
                                                   withPlaceId:self.placeM.Id
                                                     withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
                 
                if (succ) {
                    Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Y_SVP_SHOW_ERR_MES(@"添加失败");
                }
            }];
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Leve:
        {
            if (self.placeM.Id<=0) {
                Y_SVP_SHOW_INFO_MES(@"请选择仓库！");
                return;
            }
            if (self.cabM.Id<=0) {
                Y_SVP_SHOW_INFO_MES(@"请选择柜子！");
                return;
            }
            if ([self.dataSourceSourceArr.firstObject length]<=0) {
                Y_SVP_SHOW_INFO_MES(@"请填写层名！");
                return;
            }
            [[PosAndBrandInfoAddTools share] addLevelNameStr:self.dataSourceSourceArr.firstObject
                                               withCabinetId:self.cabM.Id
                                                   withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
                if (succ) {
                    Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Y_SVP_SHOW_ERR_MES(@"添加失败");
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
