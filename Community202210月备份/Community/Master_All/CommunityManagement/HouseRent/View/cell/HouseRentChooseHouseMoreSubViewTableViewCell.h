//
//  HouseRentChooseHouseMoreSubViewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  HouseRentChooseHouseMoreSubViewTableViewCellDelegate <NSObject>
- (void)chooseHouseMoreShaiXuanItemWithShaiXuanModel:(HouseRentMoreShaixuanModel*)model;
- (void)cancelHouseMoreShaiXuanItemWithShaiXuanModel:(HouseRentMoreShaixuanModel *)model; 
@end

@interface HouseRentChooseHouseMoreSubViewTableViewCell : UITableViewCell

@property (nonatomic,weak) id <HouseRentChooseHouseMoreSubViewTableViewCellDelegate>delegate;
- (void)sendAllDataSource:(NSArray *)datas andSelectedModelArr:(NSMutableArray *)arr;
@end

NS_ASSUME_NONNULL_END
