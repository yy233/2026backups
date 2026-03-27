//
//  HouseRepairVC.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HouseRepair_List_DealType_All=0,
    HouseRepair_List_DealType_Will=1,
    HouseRepair_List_DealType_Ing=2,
    HouseRepair_List_DealType_End=3,
    HouseRepair_List_DealType_Dismiss=4,
} HouseRepair_List_DealType;//列表当前顶部btn所选择的list属性

typedef enum : NSUInteger {
    HouseRepair_Status_Will=0, //待处理
    HouseRepair_Status_Ing=1,  //处理中
    HouseRepair_Status_End=2,  //处理完成
    HouseRepair_Status_Dismiss=3,  //驳回
} HouseRepair_Status;//当前cell的status状态
@interface HouseRepairListVC : BaseTableViewController
@property (nonatomic,assign) HouseRepair_List_DealType nowListType;
@end

NS_ASSUME_NONNULL_END
