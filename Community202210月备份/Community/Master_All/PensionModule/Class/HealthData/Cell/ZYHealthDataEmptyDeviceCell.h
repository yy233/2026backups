//
//  ZYHealthDataEmptyDeviceCell.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataEmptyDeviceCellDelegate <NSObject>

- (void)buyButtonEvent;

@end

@interface ZYHealthDataEmptyDeviceCell : UITableViewCell

@property (nonatomic, weak) id<ZYHealthDataEmptyDeviceCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
