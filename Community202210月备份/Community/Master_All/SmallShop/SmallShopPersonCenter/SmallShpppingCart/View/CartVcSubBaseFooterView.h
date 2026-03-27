//
//  CartVcSubBaseFooterView.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "SmallShopCartSubPayDtoModel.h"
NS_ASSUME_NONNULL_BEGIN

 

@interface CartVcSubBaseFooterView : UIView
@property (nonatomic,strong) UIButton *allChooseBtn;
@property (nonatomic,strong) UIButton *payBtn;
@property (nonatomic,strong) UILabel  *moneyTitleL;
@property (nonatomic,strong) UILabel  *moneyL;
@property (nonatomic,strong) UILabel  *payDtoInfoL;
- (void)fillPayDtoInfoLWithPayDto:(SmallShopCartSubPayDtoModel *)payDtoModel;
- (void)footerViewIsRedOrangeBackColor;
@end

NS_ASSUME_NONNULL_END
