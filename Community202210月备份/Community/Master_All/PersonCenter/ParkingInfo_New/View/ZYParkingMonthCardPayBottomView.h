//
//  ZYParkingMonthCardPayBottomView.h
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYParkingMonthCardPayBottomViewDelegate <NSObject>

- (void)payButtonEvent;

@end

@interface ZYParkingMonthCardPayBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, weak) id<ZYParkingMonthCardPayBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
