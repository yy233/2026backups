//
//  ZYCommunityFairDetailCarouselCell.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairDetailModel.h"

@protocol ZYCommunityFairDetailCarouselCellDelegate <NSObject>

- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairDetailCarouselCell : UITableViewCell

@property (nonatomic, strong) ZYCommunityFairDetailDataModel *model;

@property (nonatomic, weak) id<ZYCommunityFairDetailCarouselCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
