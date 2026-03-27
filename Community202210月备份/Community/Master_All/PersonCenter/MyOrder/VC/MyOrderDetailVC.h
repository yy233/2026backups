//
//  MyOrderDetailVC.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "MyOrderTool.h"
#import "MyOrderDetailVcBaseTextTableViewCell.h"
#define  MyOrderDetailVcBaseTextTableViewCell_Identifier               @"MyOrderDetailVcBaseTextTableViewCell"
#import "MyOrderDetailVcTopBtnsTableViewCell.h"
#define  MyOrderDetailVcTopBtnsTableViewCell_Identifier                @"MyOrderDetailVcTopBtnsTableViewCell"
#import "MyOrderDetailVcSendInfoTableViewCell.h"
#define  MyOrderDetailVcSendInfoTableViewCell_Identifier               @"MyOrderDetailVcSendInfoTableViewCell"
#import "MyOrderDetailVcCostMoneyTableViewCell.h"
#define  MyOrderDetailVcCostMoneyTableViewCell_Identifier              @"MyOrderDetailVcCostMoneyTableViewCell"
#import  "MyOrderListVcDishesTableViewCell.h"
#define   MyOrderListVcDishesTableViewCell_Identifier                  @"MyOrderListVcDishesTableViewCell"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDetailVC : BaseTableViewControllerNotNoticeWithUI
@property (nonatomic,assign) MyOrderListCell_Type listType;
@property (nonatomic,strong) NSMutableArray *dingdanSectionTitleArr;
@property (nonatomic,strong) NSMutableArray *peiSongSectionTitleArr;
@property (nonatomic,strong) NSMutableArray *dingdanSectionContentArr;
@property (nonatomic,strong) NSMutableArray *peiSongSectionContentArr;
@property (nonatomic,strong) MyOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
