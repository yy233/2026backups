//
//  ZYLifeCostHouseholdCell.h
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import <UIKit/UIKit.h>
#import "ZYLifeCostHouseholdModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYLifeCostHouseholdCellDelegate <NSObject>

- (void)deleteButtonEventWithModel:(ZYLifeCostHouseholdListModel *)model;

@end

@interface ZYLifeCostHouseholdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) ZYLifeCostHouseholdListModel *model;

@property (nonatomic, weak) id<ZYLifeCostHouseholdCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
