//
//  SetStockPosAndBrandsInfo.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "SetStockPosAndBrandsInfoBaseVC.h"

@interface SetStockPosAndBrandsInfoBaseVC ()

@end

@implementation SetStockPosAndBrandsInfoBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    [self initData];
    [self initChooseThings];
}
- (void)initChooseThings{
}
- (void)initData{
    switch (self.type) {

        case ImorExOrder_SubType_AddNewBrands:
        {
            self.title = @"新增品牌";
            NSLog(@"新增品牌");
            self.tableView.tableHeaderView = self.topShowImgView;
            self.dataSourceTitleArr = @[@"品牌名",@"品牌英文名"].mutableCopy;
            [self.dataSourceTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSourceSourceArr addObject:@""];
            }];
            
        }
            break;
        case ImorExOrder_SubType_AddNewBrandSubTypes:
        {
            self.title = @"新增品牌型号";
            NSLog(@"新增品牌型号");//选择后 填写 子类型信息
            self.tableView.tableHeaderView = self.topShowImgView;
            self.dataSourceTitleArr = @[@"品牌型号名",@"品牌型号英文名"].mutableCopy;
            [self.dataSourceTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSourceSourceArr addObject:@""];
            }];
        }
            break;
        case ImorExOrder_SubType_AddNewPos:
        {
            NSLog(@"新增位置");
            self.title = @"新增仓库";
            self.tableView.tableHeaderView = [UIView new];
            self.dataSourceTitleArr = @[@"库房名"].mutableCopy;
            self.tableView.tableHeaderView = [UIView new];
            [self.dataSourceTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSourceSourceArr addObject:@""];
            }];
        }
            break;
            
        case ImorExOrder_SubType_AddNewPos_Cib://柜子
        {
            self.title = @"新增柜子";
            NSLog(@"新增位置 柜子");
            self.tableView.tableHeaderView = [UIView new];
            //选择仓库后 填写柜子名
            self.dataSourceTitleArr = @[@"柜子名"].mutableCopy;
            self.tableView.tableHeaderView = [UIView new];
            [self.dataSourceTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSourceSourceArr addObject:@""];
            }];
        }
            break;
        case ImorExOrder_SubType_AddNewPos_Leve://层
        {
            self.title = @"新增层";
            NSLog(@"新增位置 层");
            //选择仓库后 选中柜子 填层
            self.tableView.tableHeaderView = [UIView new];
            self.dataSourceTitleArr = @[@"层名"].mutableCopy;
            self.tableView.tableHeaderView = [UIView new];
            [self.dataSourceTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataSourceSourceArr addObject:@""];
            }];
        }
            break;

        case ImorExOrder_SubType_TatalInfoShow:
        {
            NSLog(@"出入库统计");
            Y_SVP_SHOW_INFO_MES(@"敬请期待");
        }
            break;
            
        default:
            NSLog(@"出入库---sub 其他类型");
            break;
    }
    [self.tableView reloadData];
}
 


#pragma mark ===
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    DLog(@"%@ \n %@",self.dataSourceTitleArr,self.dataSourceSourceArr);
    
    
    switch (self.type) {

        case ImorExOrder_SubType_AddNewBrands:
        {
            NSLog(@"新增品牌");
            if ([self.dataSourceSourceArr.firstObject length]<=0) {
                Y_SVP_SHOW_INFO_MES(@"请填写品牌名！");
                return;
            }
            [[PosAndBrandInfoAddTools share]addBrandWithBrandNameStr:self.dataSourceSourceArr.firstObject
                                                         withEngName:self.dataSourceSourceArr[1] withIconUrl:@"" withIsCubaBool:YES withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
                if (succ) {
                    Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Y_SVP_SHOW_ERR_MES(@"添加失败");
                }
                 
            }];
            
        }
            break;
      
        case ImorExOrder_SubType_AddNewPos:
        {
            if ([self.dataSourceSourceArr.firstObject length]<=0) {
                Y_SVP_SHOW_INFO_MES(@"请填写仓库名！");
                return;
            }
            [[PosAndBrandInfoAddTools share] addPlaceNameStr:self.dataSourceSourceArr.firstObject
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


#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    if (photo == nil) {
        return;
    }
    [self.topShowImgView.showImgBtn setImage:photo forState:UIControlStateNormal];
    DLog(@"");
}
@end
