//
//  MoneyWalletYuEView.h
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YuEMingXiViewDelegate <NSObject>
- (void)chongZhiAction;
- (void)tiXianAction;
- (void)showMingXiAction;
@end

@interface MoneyWalletYuEView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *goShowMingXiBtn;
@property (nonatomic,strong) UIButton *tiXianBtn;
@property (nonatomic,strong) UIButton *chongZhiBtn;
- (void)fillData:(NSDictionary *)dic;
@property (nonatomic,weak) id <YuEMingXiViewDelegate> delegate; 
@end

NS_ASSUME_NONNULL_END
