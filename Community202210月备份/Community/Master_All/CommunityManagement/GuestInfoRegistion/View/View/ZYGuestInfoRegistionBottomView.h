//
//  ZYGuestInfoRegistionBottomView.h
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import <UIKit/UIKit.h>

@protocol ZYGuestInfoRegistionBottomViewDelegate <NSObject>

- (void)addGuestButtonEvent;

- (void)temporaryQRCodeButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYGuestInfoRegistionBottomView : UIView

@property (nonatomic, weak) id<ZYGuestInfoRegistionBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
