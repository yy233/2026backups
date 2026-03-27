//
//  LdleGoodsVC.h
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LdleGoodsVC : BaseViewController
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

NS_ASSUME_NONNULL_END
