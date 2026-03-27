//
//  LifeCostPropertyFeeListVcBottomPayInfoView.h
//  Community
//
//  Created by 余莹 on 2021/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LifeCostPropertyFeeListVcBottomPayInfoViewDelegate <NSObject>
//全选
- (void)bottomViewTouchAllChooseBtnWithSelectedBool:(BOOL)selectedBool;
//支付
- (void)bottomViewTouchPayBtnWithMoneyNum:(double)moneyN;

@end

@interface LifeCostPropertyFeeListVcBottomPayInfoView : UIView
@property (nonatomic,strong) UIButton *chooseBtn;

- (void)fillBottomViewAllMoney:(double)moneyD;
@property (nonatomic,weak) id <LifeCostPropertyFeeListVcBottomPayInfoViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
