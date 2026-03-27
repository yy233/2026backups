//
//  ZYPensionSOSContentCell.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPensionSOSContentCellDelegate <NSObject>

- (void)urgencyButtonEvent;

- (void)findWayButtonEvent;

- (void)addressBookButtonEvent;

@end

@interface ZYPensionSOSContentCell : UITableViewCell

@property (nonatomic, weak) id<ZYPensionSOSContentCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
