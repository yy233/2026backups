//
//  ZYRentSigningPayWayCell.h
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "ZYRentSigningPayWayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYRentSigningPayWayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZYRentSigningPayWayModel *model;

@end

NS_ASSUME_NONNULL_END
