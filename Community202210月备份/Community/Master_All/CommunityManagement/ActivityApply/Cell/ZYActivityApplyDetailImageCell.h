//
//  ZYActivityApplyDetailImageCell.h
//  Community
//
//  Created by ZY on 2021/8/2.
//

#import <UIKit/UIKit.h>
#import "ZYActivityApplyDetailModel.h"

@protocol ZYActivityApplyDetailImageCellDelegate <NSObject>

- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYActivityApplyDetailImageCell : UITableViewCell

@property (nonatomic, strong) ZYActivityApplyDetailDataModel *model;

@property (nonatomic, weak) id<ZYActivityApplyDetailImageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
