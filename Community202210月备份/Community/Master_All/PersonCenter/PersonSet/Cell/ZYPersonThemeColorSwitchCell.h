//
//  ZYPersonThemeColorSwitchCell.h
//  Community
//
//  Created by ZY on 2021/10/19.
//

#import <UIKit/UIKit.h>

@protocol ZYPersonThemeColorSwitchCellDelegate <NSObject>

- (void)whiteButtonEvent;

- (void)blackButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYPersonThemeColorSwitchCell : UITableViewCell

@property (nonatomic, assign) ZYThemeType themeType;

@property (nonatomic, weak) id<ZYPersonThemeColorSwitchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
