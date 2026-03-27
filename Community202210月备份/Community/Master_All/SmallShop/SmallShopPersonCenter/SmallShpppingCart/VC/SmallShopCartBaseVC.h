//
//  SmallShopCartBaseVC.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "SmallShopBaseViewController.h"
#import "CartVcSubBaseFooterView.h"
#import "SmallShopCartSubPayDtoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartBaseVC : SmallShopBaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) CartVcSubBaseFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *goodsArr;

- (void)hiddenAllChooseOnlyBtn;//隐藏全选子按钮

- (void)hiddenAllChooseView;//隐藏全选view
- (void)showAllChooseBtnView;//显示全选view


//
- (void)fillAllMoneyNumWithOnlyMoneyStr:(NSString *)moneyStr;
- (void)fillCartListActivalInfoWithShowStr:(NSString *)payDtoLabelShowStr;
- (void)fillOneGoodsDetailThisActualInfoWithPayDto:(SmallShopCartSubPayDtoModel *)payDtoModel;
//拼团footerView颜色更改
- (void)footerViewIsRedOrangeBackColor;

@end

NS_ASSUME_NONNULL_END
