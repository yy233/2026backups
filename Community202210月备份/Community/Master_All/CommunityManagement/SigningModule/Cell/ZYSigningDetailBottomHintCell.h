//
//  ZYSigningDetailBottomHintCell.h
//  Community
//
//  Created by ZY on 2021/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSigningDetailBottomHintCellDelegate <NSObject>

- (void)rentButtonClickedEvent;

@end

@interface ZYSigningDetailBottomHintCell : UITableViewCell

@property (nonatomic, weak) id<ZYSigningDetailBottomHintCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
