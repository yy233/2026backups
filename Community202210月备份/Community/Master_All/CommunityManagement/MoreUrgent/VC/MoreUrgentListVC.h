//
//  MoreUrgentListVC.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreUrgentListVC : BaseTableViewController
//顶部总小区列表跳转相关数据
@property (nonatomic,assign) BOOL isTopInfoVcDetailListVc;
@property (nonatomic,assign) NSInteger communityId;
@end

NS_ASSUME_NONNULL_END
