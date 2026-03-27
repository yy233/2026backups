//
//  MyRepairPageBaseListVC.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MyRepair_PageList_Show_Type_All  =0,
    MyRepair_PageList_Show_Type_Will =1,
    MyRepair_PageList_Show_Type_Ing  =2,
    MyRepair_PageList_Show_Type_End  =3,
    
} MyRepair_PageList_Show_Type;//展示使用的状态键     【工单状态:0 待处理 1已接单 2处理中 4已完结】数据状态


@interface MyRepairPageBaseListVC : BaseTableViewController
@property (nonatomic,assign) MyRepair_PageList_Show_Type nowListType;

@end

NS_ASSUME_NONNULL_END
