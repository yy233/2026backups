//
//  BaseHaveTableViewViewController.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseHaveTableViewViewController : BaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

NS_ASSUME_NONNULL_END
