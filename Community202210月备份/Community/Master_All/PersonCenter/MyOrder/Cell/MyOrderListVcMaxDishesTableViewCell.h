//
//  MyOrderListVcMaxDishesTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "MyOrderListVcBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListVcMaxDishesTableViewCell : MyOrderListVcBaseTableViewCell
@property (nonatomic,strong) UIImageView *dishesImgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *numberL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *nowMoneyL;
- (void)fillDataWithOrderModel:(MyOrderModel *)model;
@end

NS_ASSUME_NONNULL_END
