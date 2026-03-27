//
//  ZYSmallShopMainMenuCell.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopMainMenuCellDelegate <NSObject>

//- (void)sharedContainerViewEvent;

- (void)bargainShopViewEvent;

- (void)convenienceSerViceViewEvent;

@end

@interface ZYSmallShopMainMenuCell : UITableViewCell

@property (nonatomic, strong) ZYSmallShopMainModel *model;

@property (nonatomic, weak) id<ZYSmallShopMainMenuCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
