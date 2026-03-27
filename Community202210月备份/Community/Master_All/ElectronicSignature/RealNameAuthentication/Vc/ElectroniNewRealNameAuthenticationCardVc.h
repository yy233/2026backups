//
//  ElectroniNewRealNameAuthenticationVc.h
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import <UIKit/UIKit.h>
#import "ElectroniRealNameAuthenticationBaseHeaderView.h"//共用的实名认证headerview
#import "BaseTableViewFooterView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ElectroniNewRealNameAuthenticationCardVc : BaseViewControllerNotNoticeWithUI
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ElectroniRealNameAuthenticationBaseHeaderView *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

NS_ASSUME_NONNULL_END
