//
//  LifeCostWillPayBaseDetailVC.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>

#import "PayOrderDetailAllTypeHeader.h"
#import "LifeCostWillPayBaseDetailMainTopView.h"
#import "LifeCostPayOrderGetWithSuccessOrFailModel.h"
#import "LifeCostPayActionSuccessOrFailWebVC.h"


#define  H_TopView         (200)

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostWillPayBaseDetailVC : BaseViewController
@property (nonatomic,strong) LifeCostWillPayBaseDetailMainTopView *topView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *oneSectionTitleArr;
@property (nonatomic,strong) NSMutableArray *onwSectionDataArr;



@end

NS_ASSUME_NONNULL_END
