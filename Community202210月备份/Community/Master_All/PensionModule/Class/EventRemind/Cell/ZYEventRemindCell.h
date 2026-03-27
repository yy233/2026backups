//
//  ZYEventRemindCell.h
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYEventRemindCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) ZYEventRemindModel *model;

@end

NS_ASSUME_NONNULL_END
