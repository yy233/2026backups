//
//  ActivityDetailVCTableViewController.h
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "BaseTableViewController.h"
#import "ActivityListUseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailVC : BaseTableViewController
@property (nonatomic,strong) ActivityListUseModel *listModel;//普通列表传入
@property (nonatomic,strong) NSString *infoIDStr;//消息类型的ID传入入口
@end

NS_ASSUME_NONNULL_END
