//
//  MainTableViewTopBannerCell.h
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTableViewTopBannerCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray <TableViewTopAndCenterBannerCellModel *>*dataSource;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@end

NS_ASSUME_NONNULL_END
