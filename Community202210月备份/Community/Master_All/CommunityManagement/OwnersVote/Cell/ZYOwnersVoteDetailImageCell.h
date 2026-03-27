//
//  ZYOwnersVoteDetailImageCell.h
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import <UIKit/UIKit.h>
#import "ZYOwnersVoteDetailModel.h"

@protocol ZYOwnersVoteDetailImageCellDelegate <NSObject>

- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYOwnersVoteDetailImageCell : UITableViewCell

@property (nonatomic, strong) ZYOwnersVoteDetailDataModel *model;

@property (nonatomic, weak) id<ZYOwnersVoteDetailImageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
