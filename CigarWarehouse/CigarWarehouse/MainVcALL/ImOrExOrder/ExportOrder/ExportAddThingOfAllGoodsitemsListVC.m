//
//  ExportAddThingOfAllGoodsitemsListVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/22.
//

#import "ExportAddThingOfAllGoodsitemsListVC.h"

@interface ExportAddThingOfAllGoodsitemsListVC ()
@property (nonatomic,strong) NSMutableArray *saveWillExGoodsArr;//存储当前待出库 加入到购物车的Model数据
@end

@implementation ExportAddThingOfAllGoodsitemsListVC
- (NSMutableArray *)saveWillExGoodsArr{
    if (!_saveWillExGoodsArr) {
        _saveWillExGoodsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveWillExGoodsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CC_Brown_D;
//    if (isNotNil(self.productCodeSearchModel)) {
//        self.saveWillExGoodsArr = @[self.productCodeSearchModel].mutableCopy;
//        self.dataSourceArr = @[self.productCodeSearchModel].mutableCopy;
//        self.topTypesChooseView.isShowBool_brans = NO;
//        [self.collectionView reloadData];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.subCellIsShowAddBtn = YES;//cell显示
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithTitle:@"去结算" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    //    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"出库物品添加完成"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
    self.title = @"添加出库物品到购物车";
    self.navigationItem.hidesBackButton = YES;
}

- (void)rightNavAction{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //    });
    //CreateOrdersModel * goodsModel = [[CreateOrdersModel alloc]init];
    
    if (isNotNil(self.goodsModelArrBlock)) {
        if (self.saveWillExGoodsArr.count>0) {
            self.goodsModelArrBlock(self.saveWillExGoodsArr);

        } else {
            self.goodsModelArrBlock(self.saveWillExGoodsArr);
           
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ====  addbtnAction
- (void)dealBuyAddBtnChooseModel:(BrandStockInFoModel *)model{
    //做卖价格和数量提交到购物车
    
    
    //价格数量填入弹出框
    
    NSString *titls = [NSString stringWithFormat:@"%@的成本价格为%@\n当前支数%ld",
                       [TextShowWithModelStr textShowWithModelStr:model.Name.s],[TextShowWithModelStr textShowWithModelStr:model.BuyPrice],model.Pieces];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titls
                                                                             message:@"请填写卖出价格和数量" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加取消类型按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    //添加常规类型按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击确认");
        NSDecimalNumber *money = 0;
        NSInteger num = 0;
        if (alertController.textFields.firstObject.text.length>0 ) {
            money = [NSDecimalNumber decimalNumberWithString:alertController.textFields.firstObject.text];
        } else {
            Y_SVP_SHOW_INFO_MES(@"请填写卖价");
        }
        if (alertController.textFields.lastObject.text.length>0 ) {
            num = [alertController.textFields.lastObject.text integerValue];
        } else {
            Y_SVP_SHOW_INFO_MES(@"请填写数量");
        }
        if(num > model.Pieces){
            Y_SVP_SHOW_ERR_MES(@"库存不足！请更改数量");
            return;
        }
        model.BuyPrice = money;
        model.Pieces = num;
        [self addWillExNewModel:model];
        
    }]];
    
    //添加文本框1
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"1 tf");
    }];
    //添加文本框2
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"2 tf");
    }];
    alertController.textFields.firstObject.keyboardType = UIKeyboardTypeDecimalPad;
    alertController.textFields.lastObject.keyboardType  = UIKeyboardTypeNumberPad;
    alertController.textFields.firstObject.placeholder = @"卖出价格";
    alertController.textFields.lastObject.placeholder = @"出库数量";
    
    //显示
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}

- (void)addWillExNewModel:(BrandStockInFoModel *)model{
    
    for (int i = 0 ; i < self.saveWillExGoodsArr.count; i++) {
        BrandStockInFoModel *objM  = self.saveWillExGoodsArr[i];
        if (objM.Id == model.Id) {
            [self.saveWillExGoodsArr replaceObjectAtIndex:i withObject:model];
            Y_SVP_SHOW_SUCCESS_MES(@"已经更新!");
            return;//已经添加 --做更改动作
        }
    }
    //非重复
    [self.saveWillExGoodsArr addObject:model];
    Y_SVP_SHOW_SUCCESS_MES(@"添加成功，待出库。");
}




//重写
//self.topTypesChooseView.isShowBool_Pos = YES;

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    return nil;
}
@end
