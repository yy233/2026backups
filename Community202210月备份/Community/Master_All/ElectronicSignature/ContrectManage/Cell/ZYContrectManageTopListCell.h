//
//  ZYContrectManageTopListCell.h
//  Community
//
//  Created by ZY on 2021/8/30.
//

#import <UIKit/UIKit.h>
#import "ZYContrectManageTopListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContrectManageTopListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, strong) ZYContrectManageTopListModel *model;

@end

NS_ASSUME_NONNULL_END
