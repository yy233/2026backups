//
//  ExportOrderFillVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import "ExportOrderFillVC.h"
#import "PosAndBrandInfoAddTools.h"
#import "ExportAddThingOfAllGoodsitemsListVC.h"

@interface ExportOrderFillVC ()
@property (nonatomic,assign) BOOL tfCanEditBool;
@property (nonatomic,strong) NSString *thisOrderBuyer;

@end

@implementation ExportOrderFillVC
//UIScrollView不能响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待出库购物车";
    self.tfCanEditBool = YES;//添加页直接添加model返回后的不可修改编辑处理
    [self addNavItem];
    [self initData];
    self.tableView.separatorColor = [UIColor clearColor];
}
#pragma mark ====  nav
- (void)addNavItem{
    
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithTitle:@"去添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
}
- (void)rightNavAction{
    
    WEAKSELF
    ExportAddThingOfAllGoodsitemsListVC *vc = [[ExportAddThingOfAllGoodsitemsListVC alloc]init];
    vc.goodsModelArrBlock = ^(NSMutableArray * _Nonnull goodsModelArr) { //BrandStockInFoModel
        STRONGSELF
        NSLog(@"获得的待出库购物车数据 model 选中--  %@",goodsModelArr);
        if (goodsModelArr.count>0) {
            strongSelf.dataSourceSourceArr = goodsModelArr;
            //strongSelf.tfCanEditBool = NO; 允许更改
            [strongSelf.tableView reloadData];
        }
        [self baseListEpVc];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ========
- (void)initData{
    self.thisOrderBuyer = @"";
    self.tableView.tableHeaderView = [UIView new];
    self.dataSourceTitleArr = @[@"品牌/型号",@"卖价",@"出库支数",@"购买者"].mutableCopy;//购买者可忽略不填入
    
    //扫码有效数据来的 跳转
    if ([self.qrResDic allKeys].count>0 && [[self.qrResDic allKeys]containsObject:QR_product]) {//扫码出库
        NSString *productCodeStr =  [self.qrResDic objectForKey:QR_product];
        if (productCodeStr.length >0) {
            [self goToQRSHowDataListWithCodeStr:productCodeStr];
            return;
        }else{
            
        }
    }else{
    }
    //非扫码出库 基础界面
    [self baseListEpVc];
}
- (void)baseListEpVc{
    //非扫码出库 基础界面
    if (self.dataSourceSourceArr.count == 0) {
        BrandStockInFoModel *bm = [[BrandStockInFoModel alloc]init];
        bm.Code = @"";
        bm.BuyPrice = @0.0;
        bm.Pieces = 0;
        [self.dataSourceSourceArr addObject:bm];
    }
    [self.tableView reloadData];
    
}
- (void)goToQRSHowDataListWithCodeStr:(NSString *)productCodeStr{
    WEAKSELF
    ExportOrderQRLastShowVC *vc = [[ExportOrderQRLastShowVC alloc]init];
    vc.productCodeStr = productCodeStr;
    vc.goodsModelArrBlock = ^(NSMutableArray * _Nonnull goodsModelArr) { //BrandStockInFoModel
        STRONGSELF
        NSLog(@"获得的待出库购物车数据 model 选中--  %@",goodsModelArr);
        if (goodsModelArr.count>0) {
            strongSelf.dataSourceSourceArr = goodsModelArr;
            //strongSelf.tfCanEditBool = NO; 允许更改
            [strongSelf.tableView reloadData];
        }
        [self baseListEpVc];
    };
    [self.navigationController pushViewController:vc animated:YES]; //当前页刷新还是去列表页做出库改数量做卖价格调整动作

}
 


#pragma mark =======
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    DLog(@"%@ \n %@",self.dataSourceTitleArr,self.dataSourceSourceArr);
//   BrandStockInFoModel 转 <CreateOrdersModel *
    NSMutableArray *willSendArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (BrandStockInFoModel *bm in self.dataSourceSourceArr) {
        CreateOrdersModel *cm = [[CreateOrdersModel alloc]init];
        cm.buyer = self.thisOrderBuyer;
        //cm.orderCode = [TextShowWithModelStr textShowWithModelStr:bm.Code];//code不填
        cm.price = [bm.BuyPrice floatValue]; //成本价格为显示键值给予传递位置 拿到的是已经出库时的报价 本页可自定义写报价
        cm.quantity = bm.Pieces;//数量
        cm.stock_id = bm.Id;//库数据ID
        NSDictionary *cDic = [cm mj_keyValues];
        [willSendArr addObject:cDic];
    }
    if (willSendArr.count<=0) {
        return;
    }
    
    [[PosAndBrandInfoAddTools share]orderListExportWithInfoArr:willSendArr withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
        if (succ) {
            Y_SVP_SHOW_SUCCESS_MES(@"出库成功！");
            [self.navigationController popViewControllerAnimated: YES];
        }
    }];
    
}

#pragma mark === 出库数据 多个 section
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceSourceArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitleArr.count;
}
#pragma mark =========
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   UIView *shv =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
    shv.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    return shv;
}
#pragma mark ========= cell


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_I];
    if (!cell) {
        cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_I];
    }
 
    BrandStockInFoModel *bm = self.dataSourceSourceArr[indexPath.section];
    cell.textF.tag = cell_tf_BaseTag + indexPath.row + 100*indexPath.section;
    cell.textF.delegate = self;
    cell.textF.userInteractionEnabled = self.tfCanEditBool;
    cell.titL.text = self.dataSourceTitleArr[indexPath.row];
    cell.textF.keyboardType = UIKeyboardTypeDefault;
    switch (indexPath.row) {//@[@"品牌/型号",@"价格",@"出库支数",@"购买者"]
        case 0:
            if (bm.Name.v == YES) {
                cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:bm.Name.s];
            } else {
                cell.textF.text = @"";
            }
            break;
            
        case 1:
            cell.textF.text = [TextShowWithModelStr textShowWithModelStr:bm.BuyPrice];//金额 数字加点
            cell.textF.keyboardType = UIKeyboardTypeDecimalPad;
            break;
            
        case 2:
            cell.textF.text = [NSString stringWithFormat:@"%ld",bm.Pieces];//数量 键盘只有数字
            cell.textF.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 3:
            cell.textF.text = self.thisOrderBuyer; //购买者
            break;
        default:
      
            break;
    }
    
    return cell;
    
   /**
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
    */
}

#pragma mark =========
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.tfCanEditBool == NO) {
        return;//不可输入
    }
    NSInteger rowNum = (textField.tag - cell_tf_BaseTag)%100;
    //NSInteger sectionNum = (textField.tag - cell_tf_BaseTag)/100;
    
    if (rowNum == 3) {
        self.thisOrderBuyer = textField.text;
        [self.tableView reloadData];//更新了购买者名字后 要统一刷新当前行 完成输入时
    } else {
        [self getTextSave:textField];
    }


}
- (void)getTextSave:(UITextField *)textField{
    //  cell.textF.tag = cell_tf_BaseTag + indexPath.row + 100*indexPath.section;
    if (self.tfCanEditBool == NO) {
        return;//不可输入
    }
    NSInteger rowNum = (textField.tag - cell_tf_BaseTag)%100;
    NSInteger sectionNum = (textField.tag - cell_tf_BaseTag)/100;
    
    BrandStockInFoModel *bm = self.dataSourceSourceArr[sectionNum];
    switch (rowNum) {
        case 0:
            bm.Name.s = textField.text;
            break;
        case 1:
        {
            NSNumber *n1 = @0.0;
            n1 = [[NSDecimalNumber alloc]initWithString:textField.text];
            bm.BuyPrice = n1;
        }
          
            break;
        case 2:
            bm.Pieces = [textField.text integerValue];
            break;
        case 3:
            self.thisOrderBuyer = textField.text;//购买者名字单独总数据
            break;
            
        default:
            break;
    }
    [self.dataSourceSourceArr replaceObjectAtIndex:sectionNum withObject:bm];
    
  
}
 

@end
