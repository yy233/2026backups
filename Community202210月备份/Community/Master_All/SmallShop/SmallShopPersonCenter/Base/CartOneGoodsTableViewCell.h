//
//  CartOneGoodsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "BaseOneGoodsTableViewCell.h"
#import "SmallShopCartListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *CartOneGoodsTableViewCell_I = @"CartOneGoodsTableViewCell";
static NSString *CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell_I = @"CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell";
static NSString *CartOneGoodsNotLeftChooseBtnTableViewCell_I = @"CartOneGoodsNotLeftChooseBtnTableViewCell";
static NSString *CartOneServiceNotLeftChooseBtnTableViewCell_I = @"CartOneServiceNotLeftChooseBtnTableViewCell";



typedef void(^TouchChooseBtnBlock)(UIButton * chooseBtn);
typedef void(^TouchAddBtnBlock)(NSInteger nowCount);
typedef void(^TouchDeletBtnBlock)(NSInteger nowCount);

#pragma mark == //购物车列表页使用
@interface CartOneGoodsTableViewCell : BaseOneGoodsTableViewCell

@property (nonatomic,copy) TouchChooseBtnBlock touchChooseBtnBlock;
@property (nonatomic,copy) TouchAddBtnBlock touchAddBtnBlock;
@property (nonatomic,copy) TouchDeletBtnBlock touchDeletBtnBlock;


- (void)fillCartListOneGoodsInfoWithModel:(SmallShopCartListModel *)model;
- (void)changeChoooseBtnSelectedType:(BOOL)isSelected;
- (void)addBtnAndDeletBtnUserInteractionEnabledSetNo;//订单代付钱的状态下 不可改变数量

@end

#pragma mark == //购物车 结算页使用
@interface CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell : CartOneGoodsTableViewCell

@end

#pragma mark == //单个商品的商品购买结算页使用

@interface CartOneGoodsNotLeftChooseBtnTableViewCell : CartOneGoodsTableViewCell

- (void)fillCartPayDetailVcSubGoodsArrFirstInfoOfDetailVCModeInfoWithModel:(SmallShopCartListModel *)showUseModel; //(结算页 单个商品的数据)

@end

#pragma mark == //单个服务的商品购买结算页使用

@interface CartOneServiceNotLeftChooseBtnTableViewCell : CartOneGoodsNotLeftChooseBtnTableViewCell

@end

NS_ASSUME_NONNULL_END
