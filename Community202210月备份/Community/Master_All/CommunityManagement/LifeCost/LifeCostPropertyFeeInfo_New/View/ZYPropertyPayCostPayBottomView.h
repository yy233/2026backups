//
//  ZYPropertyPayCostPayBottomView.h
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPropertyPayCostPayBottomViewDelegate <NSObject>

- (void)payButtonEvent;

@end

@interface ZYPropertyPayCostPayBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) id<ZYPropertyPayCostPayBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
