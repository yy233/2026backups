//
//  ExportOrderQRLastShowVC.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/31.
//

#import <Foundation/Foundation.h>
#import "ExportAddThingOfAllGoodsitemsListVC.h"
NS_ASSUME_NONNULL_BEGIN

//包含继续扫码按钮
@interface ExportOrderQRLastShowVC : UIViewController
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray <BrandStockInFoModel *> *productCodeSearchOkShowThisTimesModelArr;
@property (nonatomic,strong) NSString *productCodeStr;
@property (nonatomic,copy) AddWillExportGoodsBlock goodsModelArrBlock;
@end

/**
 NSString *productCodeStr =  [self.qrResDic objectForKey:QR_product];
 //根据产品码查询到这个库存数据
 WEAKSELF
 [[GetDatasTool share]getProductInfoWithProductCodeId:productCodeStr
                               withTypesListWithBlock:^(BOOL succ, NSArray * _Nonnull dataList) {
     BrandStockInFoModel *qrModel;
     if ([dataList isKindOfClass:[NSArray class]] || [dataList isKindOfClass:[NSMutableArray class]]) {
         qrModel  = [BrandStockInFoModel mj_objectWithKeyValues:dataList.firstObject];
     } else if ([dataList isKindOfClass:[NSDictionary class]] || [dataList isKindOfClass:[NSMutableDictionary class]]){
         qrModel  = [BrandStockInFoModel mj_objectWithKeyValues:dataList];
     }else{
         return;
     }
     ExportOrderQRLastShowVC *vc = [[ExportOrderQRLastShowVC alloc]init];
     vc.goodsModelArrBlock = ^(NSMutableArray * _Nonnull goodsModelArr) { //BrandStockInFoModel
         STRONGSELF
         NSLog(@"获得的待出库购物车数据 model 选中--  %@",goodsModelArr);
         if (goodsModelArr.count>0) {
             strongSelf.dataSourceSourceArr = goodsModelArr;
             //strongSelf.tfCanEditBool = NO; 允许更改
             [strongSelf.tableView reloadData];
         }
     };
     [self.navigationController pushViewController:vc animated:YES]; //当前页刷新还是去列表页做出库改数量做卖价格调整动作
 }];*/

NS_ASSUME_NONNULL_END
