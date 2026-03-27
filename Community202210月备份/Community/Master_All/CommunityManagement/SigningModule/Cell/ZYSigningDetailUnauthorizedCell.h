//
//  ZYSigningDetailUnauthorizedCell.h
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSigningDetailUnauthorizedCellDelegate <NSObject>

- (void)contentViewTapEvent;

@end

@interface ZYSigningDetailUnauthorizedCell : UITableViewCell

@property (nonatomic, weak) id<ZYSigningDetailUnauthorizedCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
