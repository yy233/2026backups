//
//  MainTableViewRecommendedServiceHourseEstateCell.h
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainCellRecommendedServiceHourseEstateDelegate <NSObject>
- (void)cellHourseEstateSubBtnTouchIndex:(NSInteger)index;
- (void)cellHourseEstateSubTableViewTouchIndexPath:(NSIndexPath *)indexPath;
@end
@interface MainTableViewRecommendedServiceHourseEstateCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,weak) id <MainCellRecommendedServiceHourseEstateDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
