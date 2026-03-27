//
//  ExportAddThingOfAllGoodsitemsListVC.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/22.
// 父类为主页 查找后点击加号 放到出库车的功能

#import <UIKit/UIKit.h>
#import "AllStockRoomThingsShowVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AddWillExportGoodsBlock)(NSMutableArray * goodsModelArr);  ///< *> BrandStockInFoModel 主页列表类型数据 和创建订单出库数据

@interface ExportAddThingOfAllGoodsitemsListVC : AllStockRoomThingsShowVC
//@property (nonatomic,strong) BrandStockInFoModel *productCodeSearchModel;
@property (nonatomic,copy) AddWillExportGoodsBlock goodsModelArrBlock;
@end

NS_ASSUME_NONNULL_END
