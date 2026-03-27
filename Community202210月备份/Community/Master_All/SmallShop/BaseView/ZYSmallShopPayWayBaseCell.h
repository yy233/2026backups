//
//  ZYSmallShopPayWayBaseCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopPayWayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopPayWayBaseCell : UITableViewCell

@property (nonatomic, strong) ZYSmallShopPayWayModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
