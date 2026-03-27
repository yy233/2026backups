//
//  ZYChooseTemporaryTimePopView.h
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import <UIKit/UIKit.h>

@protocol ZYChooseTemporaryTimePopViewDelegate <NSObject>

- (void)thirtyMinutesButtonEvent;

- (void)sixtyMinutesButtonEvent;

- (void)ninetyMinutesButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYChooseTemporaryTimePopView : UIView

@property (nonatomic, weak) id<ZYChooseTemporaryTimePopViewDelegate> delegate;

- (void)showChooseTemporaryTimePopView;

@end

NS_ASSUME_NONNULL_END
