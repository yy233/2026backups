//
//  ZYCarInvitePayBottomView.h
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCarInvitePayBottomViewDelegate <NSObject>

- (void)payButtonEvent;

@end

@interface ZYCarInvitePayBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) id<ZYCarInvitePayBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
