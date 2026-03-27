//
//  ImExOrderOtherTool.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import <Foundation/Foundation.h>
#import "ImportOrderFillVC.h"
#import "ExportOrderFillVC.h"
#import "MoveStockPosVC.h"


#import "ListBaseViewController.h"
#import "CigarQRTool.h"
NS_ASSUME_NONNULL_BEGIN

//@[@"入库",@"出库",@"新增品牌",@"新增品牌型号",@"新增位置",@"移动库存",@"出入库统计"];

typedef enum : NSUInteger {
    ImorExOrder_SubType_ImAction = 0,
    ImorExOrder_SubType_ExAction,
    ImorExOrder_SubType_AddNewBrands,
    ImorExOrder_SubType_AddNewBrandSubTypes,
    ImorExOrder_SubType_AddNewPos, //库
    ImorExOrder_SubType_AddNewPos_Cib,//柜子
    ImorExOrder_SubType_AddNewPos_Leve,//层
    ImorExOrder_SubType_MoveStockPos,//移动
    ImorExOrder_SubType_TatalInfoShow,
} ImorExOrder_SubType;


@interface ImExOrderOtherTool : NSObject

@end

@interface IEOvcShowUseModel : NSObject
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *icon;
@property (nonatomic,assign) ImorExOrder_SubType type;
@end




NS_ASSUME_NONNULL_END
