//
//  LifeCostNewCostTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LifeCostNewCostTableViewCellDelegate <NSObject>
- (void)touchNewCostCellItemWithNum:(NSInteger)index;
@end

@interface LifeCostNewCostTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,weak) id <LifeCostNewCostTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
