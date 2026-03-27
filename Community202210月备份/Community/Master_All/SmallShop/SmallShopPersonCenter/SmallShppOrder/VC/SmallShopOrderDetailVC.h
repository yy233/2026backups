//
//  SmallShopOrderDetailVC.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "SmallShopOrderHeader.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SmallShopOrderDetailVC_Type_Goods    =1,    //商品
    SmallShopOrderDetailVC_Type_Service  =2,    //服务
    SmallShopOrderDetailVC_Type_Container=3     //货柜
} SmallShopOrderDetailVC_Type;


@interface SmallShopOrderDetailVC : SmallShopBaseTableViewController 
@property (nonatomic,assign) SmallShopOrderDetailVC_Type nowDetailVcShowType;//类型
@property (nonatomic,assign) NSInteger thisOrderId;
@property (nonatomic,strong) SmallShppOrderModel *listModel;
@end

NS_ASSUME_NONNULL_END
