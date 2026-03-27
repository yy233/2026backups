//
//  ImportOrderFillVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import "ImportOrderFillVC.h"
#import "PosAndBrandInfoAddTools.h"
#import "ImportOrderFillSubChooseTableViewCell.h"


#import <SGQRCode/SGQRCode.h>
#import "ScanQR_BaseViewController.h"
#import "WBQRCodeVC.h"

@interface ImportOrderFillVC ()
@property (nonatomic,strong) InsertStockModel *willImportModel;
@property (nonatomic,assign) CGFloat brans_h;
@property (nonatomic,assign) CGFloat branTypes_h;
@property (nonatomic,strong) NSMutableArray *saveBrandsArr;
@property (nonatomic,strong) NSMutableArray *saveAnBrandTypesArr;
@property (nonatomic,strong) CigarBrandsUseModel *saveBrandModel;
@property (nonatomic,strong) BrandTypesModel *saveBrandTypeModel;


@end
/**
 @property (nonatomic,assign) NSInteger    brand_id;
 @property (nonatomic,assign) NSInteger    brand_type_id;
 @property (nonatomic,strong) NSNumber     *buy_price;//价格
 @property (nonatomic,copy)   NSString     *pack;
 @property (nonatomic,strong) NSNumber     *cigar_piece;//数量
 @property (nonatomic,copy)   NSString     *code;
 @property (nonatomic,copy)   NSString     *pos;
 @property (nonatomic,copy)   NSString     *produce_from;
 @property (nonatomic,copy)   NSString     *buy_from;
 @property (nonatomic,copy)   NSString     *owner;

 */

@implementation ImportOrderFillVC
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"入库填表";
    [self initData];
}

//列表 写完单子的属性后 做提交动作
- (void)initData{//入库
    self.brans_h = 40;
    self.branTypes_h = 40;
    self.saveBrandsArr = @[].mutableCopy;
    self.saveAnBrandTypesArr = @[].mutableCopy;
    self.willImportModel = [[InsertStockModel alloc]init];
    self.willImportModel.code = [(__bridge NSString * _Nonnull)(CFUUIDCreateString(nil, CFUUIDCreate(nil))) lowercaseString] ;
    self.willImportModel.produce_from = @"墨西哥";
    self.willImportModel.buy_from = @"墨西哥";
    self.willImportModel.pack = @"盒";
    self.willImportModel.owner = @"公司";
    self.tableView.tableHeaderView = [UIView new];// self.tableView.tableHeaderView = self.topShowImgView;

    //section1 选择区+填写区域
    self.dataSourceTitleArr = @[@"品牌",@"品牌型号",@"成本价",@"包装（支/盒）",@"总支数",@"码",@"位置",@"原产地",@"购买地",@"铝管",@"拥有者"].mutableCopy;
    
    [[GetDatasTool share]getAllBrandsListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        
        if (succ) {
            NSArray *getmodels = [CigarBrandsUseModel mj_objectArrayWithKeyValuesArray:dataList];
            self.saveBrandsArr = getmodels.mutableCopy;
            //刷新1r
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    [self.tableView reloadData];
}
//搜索品牌的子类型列表
- (void)refData_OneBranSubTypesWithTouchBrandId:(NSInteger)bId{
    DLog(@"bId = %ld",(long)bId)
    self.saveAnBrandTypesArr = @[].mutableCopy;//清空之前的品牌子型号类型列表
    [[GetDatasTool share]getBrandTypesOfOneBrandId:bId withTypesListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
        if (succ) {
            NSArray *getmodels = [BrandTypesModel mj_objectArrayWithKeyValuesArray:dataList];
            if (getmodels.count == 0) {
                Y_SVP_SHOW_INFO_MES(@"当前品牌暂无型号数据");
            }else{
                self.saveAnBrandTypesArr = getmodels.mutableCopy;
            }
            //刷新2r
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            //失败清空当前对应的子型号数据cell
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
}




#pragma mark ========= cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<2) {
        if (indexPath.row == 0) {
            return self.brans_h;
        }else{
            return self.branTypes_h;
        }
        
    } else {
        return 65;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<2) {//品牌选择区
        //@"品牌",@@"品牌型号"
        ImportOrderFillSubChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImportOrderFillSubChooseTableViewCell_I];
        if (!cell) {
            cell = [[ImportOrderFillSubChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ImportOrderFillSubChooseTableViewCell_I];
        }
        WEAKSELF
        if (indexPath.row == 0) {
            [cell isBands];
            [cell fillDataSourceModel:self.saveBrandsArr];
            cell.anBansBlcok = ^(CigarBrandsUseModel * _Nonnull bm) {
                weakSelf.saveBrandModel = bm;
                [weakSelf refData_OneBranSubTypesWithTouchBrandId:bm.Id];
            };
        }else{
            [cell isBandTypes];
            [cell fillDataSourceModel:self.saveAnBrandTypesArr];
            cell.oneBrandAnTypeBlcok = ^(BrandTypesModel * _Nonnull btm) {
                weakSelf.saveBrandTypeModel = btm;
            };
        }
        
        cell.h_block = ^(CGFloat thisHeight) {
            if (indexPath.row == 0) {
                weakSelf.brans_h = thisHeight;
            }else{
                weakSelf.branTypes_h = thisHeight;
            }
            //活动高度
            [weakSelf reHeightNoReData];
        };
        
        
    
        return cell;
    } else {//填写区
        if (indexPath.row == 6) {//位置
            ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_ShowBtn_I];
            if (!cell) {
                cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_ShowBtn_I];
            }
            cell.titL.text = self.dataSourceTitleArr[indexPath.row];
            //cell.textF.text = self.dataSourceSourceArr[indexPath.row];
            cell.textF.tag = cell_tf_BaseTag + indexPath.row;
            cell.textF.delegate = self;
            cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.pos];
            [cell showRightBtnWithTextStr:@"扫码"];
            [cell.rightBtn addTarget:self action:@selector(posQR) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }else if (indexPath.row == 9){//铝管
            ListBaseTableViewCell_Switch *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_Switch_I];
            if (!cell) {
                cell = [[ListBaseTableViewCell_Switch alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_Switch_I];
            }
            cell.titL.text = self.dataSourceTitleArr[indexPath.row];
            [cell.swi addTarget:self action:@selector(tubosInfoChange:) forControlEvents: UIControlEventValueChanged];//UIControlEventValueChanged
            return cell;
        } else {
            ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_I];
            if (!cell) {
                cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_I];
            }
            cell.titL.text = self.dataSourceTitleArr[indexPath.row];
            //cell.textF.text = self.dataSourceSourceArr[indexPath.row];
            cell.textF.tag = cell_tf_BaseTag + indexPath.row;
            cell.textF.delegate = self;
            cell.textF.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeASCIICapable
            switch (indexPath.row) {//@[@"品牌"0,@"品牌型号"1,@"购买价格"2,@"盒/支"3,@"数量"4,@"码5",@"位置6",@"原产地7",@"购买地8"]
                    
                case 2:
                    cell.textF.text = [TextShowWithModelStr textShowWithModelStr:self.willImportModel.buy_price];//金额 数字加点的键盘
                    cell.textF.keyboardType = UIKeyboardTypeDecimalPad;
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                case 4:
                    cell.textF.text = [NSString stringWithFormat:@"%ld", self.willImportModel.cigar_piece];//数量 键盘只有数字
                    cell.textF.keyboardType = UIKeyboardTypeNumberPad;
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                    
                case 3:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.pack];
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                case 5:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.code];
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                case 6:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.pos];
                    [cell showRightBtnWithTextStr:@"扫码"];
                    [cell setTextPStr:@"请填写..."];
                    [cell.rightBtn addTarget:self action:@selector(posQR) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 7:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.produce_from];
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                case 8:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.buy_from];
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
//                case 9:
//                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.tubosInputStr];
//                    [cell notShowRightBtn];
//                    [cell setTextPStr:@"有/无"];
//                    break;
                case 10:
                    cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.willImportModel.owner];
                    [cell notShowRightBtn];
                    [cell setTextPStr:@"请填写..."];
                    break;
                default:
                    [cell notShowRightBtn];
                    break;
            }
            return cell;
        }
       
    }

 
    
   /**
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
    */
}

//只更新高度不会更数据 防hblock的反复触发
- (void)reHeightNoReData{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    //[self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
#pragma mark =========
- (void)getTextSave:(UITextField *)textField{
    //@[@"品牌"0,@"品牌型号"1,@"购买价格"2,@"盒/支"3,@"数量"4,@"码5",@"位置6",@"原产地7",@"购买地8"]
    switch (textField.tag - cell_tf_BaseTag ) {
        case 0:
        case 1:
            break;
        case 2:
            self.willImportModel.buy_price = [NSDecimalNumber decimalNumberWithString:textField.text];
            break;
        case 4:
            self.willImportModel.cigar_piece = [textField.text integerValue];
            break;
            
        case 3:
            self.willImportModel.pack = textField.text;
            break;
        case 5:
            self.willImportModel.code = textField.text;
            break;
        case 6:
            self.willImportModel.pos = textField.text;
            break;
        case 7:
            self.willImportModel.produce_from = textField.text;
            break;
        case 8:
            self.willImportModel.buy_from = textField.text;
            break;
//        case 9:
//            self.willImportModel.tubosInputStr = textField.text;
//            break;
        case 10:
            self.willImportModel.owner = textField.text;
            break;
        default:
            break;
    }
}
#pragma mark ===
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    if (self.saveBrandModel.Id<=0) {
        Y_SVP_SHOW_INFO_MES(@"请选择品牌！");
        return;
    }
    if (self.saveBrandTypeModel.Id<=0) {
        Y_SVP_SHOW_INFO_MES(@"请选择品牌型号！");
        return;
    }
    if (self.willImportModel.cigar_piece<=0) {
        Y_SVP_SHOW_INFO_MES(@"入库数量不能为空！");
        return;
    }
    if (self.willImportModel.buy_price<=0) {
        Y_SVP_SHOW_INFO_MES(@"价格不能为空！");
        return;
    }
//    if ([self.willImportModel.tubosInputStr isEqualToString:@"有"]) { 
//        //self.willImportModel.tubos = YES;
//        self.willImportModel.tubos = 1;
//    }else{
//        self.willImportModel.tubos = 0;
//       // self.willImportModel.tubos = NO;
//    }
    self.willImportModel.brand_id = self.saveBrandModel.Id;
    self.willImportModel.brand_type_id = self.saveBrandTypeModel.Id;
    NSDictionary *willSendDic = [self.willImportModel mj_keyValuesWithIgnoredKeys:@[@"tubosInputStr"]];
    [[PosAndBrandInfoAddTools share]orderImportWithInfoDic:willSendDic.mutableCopy withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
        if (succ) {    
            Y_SVP_SHOW_SUCCESS_MES(@"入库成功！");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            Y_SVP_SHOW_SUCCESS_MES(@"入库失败！");
        }
    }];
    
    
//    {
//        "brand_id" = 1;
//        "brand_type_id" = 1;
//        "buy_from" = "\U58a8\U897f\U54e5";
//        "buy_price" = 1001;
//        "cigar_piece" = 12;
//        code = "84194e17-9cfb-468d-ba7d-b46d0e876580";
//        pack = "\U76d2";
//        pos = "1-1-1";
//        "produce_from" = "\U58a8\U897f\U54e5";
//    }
//    Optional(["brand_type_id": 1, "buy_from": 墨西哥, "buy_price": 1001, "produce_from": 墨西哥, "code": 84194e17-9cfb-468d-ba7d-b46d0e876580, "pos": 1-1-1, "pack": 盒, "cigar_piece": 12, "brand_id": 1]))k/insertBrand } { Status Code: 500, Headers {
//    "Content-Length" =     (
//        0
//    );
//    Date =     (
//        "Fri, 26 Jul 2024 10:33:49 GMT"
//    );
//} }
    
}
- (void)tubosInfoChange:(UISwitch *)sender{
    if (sender.isOn == YES) {
        NSLog(@"tubosInfoChange 点击状态 已打开");
        self.willImportModel.tubos = 1;
    }else{
        NSLog(@"tubosInfoChange 非点击状态 已关闭");
        self.willImportModel.tubos = 0;

    }
}

#pragma mark ==
- (void)posQR{
  DLog()
WEAKSELF
    [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    NSLog(@"第一次授权成功");
                    WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                        NSLog(@"QR resultStr - %@",resultStr);
                        [weakSelf getQrStr:resultStr];
                    };
                    [weakSelf.navigationController pushViewController:qrVC animated:YES];
                    self.hidesBottomBarWhenPushed = NO;//返回页无需tabbar 本行隐藏
                } else {
                    NSLog(@"第一次授权失败");
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            NSLog(@"SGPermissionStatusAuthorized");
            WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
            weakSelf.hidesBottomBarWhenPushed = YES;
            qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                NSLog(@"QR resultStr - %@",resultStr);
                [weakSelf getQrStr:resultStr];
            };
            [weakSelf.navigationController pushViewController:qrVC animated:YES];
//             self.hidesBottomBarWhenPushed = NO;//返回页无需tabbar 本行隐藏


        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            [weakSelf failed];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            [weakSelf unknown];
        }
    }];
    
}

- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}
- (void)unknown {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}
#pragma mark ===
- (void)getQrStr:(NSString *)res{
//    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = YES;//扫码pos后显示了tabbar 主动隐藏tabbar
    if (res.length == 0) {
        Y_SVP_SHOW_INFO_MES(@"不符合规则的二维码！");
        return;
    }else{
    }
    
    //NSString *posstr = [self.qrResDic objectForKey:QR_pos];
    self.willImportModel.pos = [CigarQRTool rRStr_GetPosWithStr:res];
    NSLog(@"pos will fill pos-%@", self.willImportModel.pos);
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]]  withRowAnimation:UITableViewRowAnimationAutomatic];

}

@end
