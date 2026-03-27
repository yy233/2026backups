//
//  HouseRepairPageBaseListVC.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "MyRepairPageBaseListVC.h"
typedef enum : NSUInteger {
    HouseRepair_PageList_Type_All  =9999,
    HouseRepair_PageList_Type_Will =0,
    HouseRepair_PageList_Type_Ing  =1,
    HouseRepair_PageList_Type_End  =2,
    HouseRepair_PageList_Type_HasBeenRejected  =3,
} HouseRepair_PageList_Type;//    状态（0 待处理 1 处理中 2 已完成  已驳回3） 【工单状态:0 待处理 1已接单 2处理中 4已完结】
 
 
NS_ASSUME_NONNULL_BEGIN


@interface HouseRepairPageBaseListVC : BaseTableViewController
@property (nonatomic,assign) HouseRepair_PageList_Type nowListType;
@end

NS_ASSUME_NONNULL_END
