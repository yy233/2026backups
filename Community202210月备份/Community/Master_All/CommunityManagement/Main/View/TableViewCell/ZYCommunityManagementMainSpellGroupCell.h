//
//  ZYCommunityManagementMainSpellGroupCell.h
//  Community
//
//  Created by ZY on 2022/4/7.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityManagementMainSpellGroupCellDelegate <NSObject>

- (void)contentVEvent;

@end

@interface ZYCommunityManagementMainSpellGroupCell : UITableViewCell

@property (nonatomic, weak) id<ZYCommunityManagementMainSpellGroupCellDelegate> delegate;

@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupDetailModel *model;

@end

NS_ASSUME_NONNULL_END
