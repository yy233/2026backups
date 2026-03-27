//
//  MoneyWalletVcLateTopView.h
//  Community
//
//  Created by 余莹 on 2021/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MoneyWalletVcLateTopViewDelegate <NSObject>
- (void)goToTiXianBtnAction;
@end

@interface MoneyWalletVcLateTopView : UIView
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *titleLabelRight;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *tiXianBtn;

@property (nonatomic,weak) id <MoneyWalletVcLateTopViewDelegate> delegate;
- (void)fillDataWithYuE:(double)yue;

@end

NS_ASSUME_NONNULL_END
