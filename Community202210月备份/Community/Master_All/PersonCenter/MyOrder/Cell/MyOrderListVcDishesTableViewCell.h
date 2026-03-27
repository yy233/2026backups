//
//  MyOrderListVcDishesTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "MyOrderListVcBaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListVcDishesTableViewCell : MyOrderListVcBaseTableViewCell
@property (nonatomic,strong) UIImageView *dishesImgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *oldMoneyL;
@property (nonatomic,strong) UILabel *nowMoneyL;
@property (nonatomic,strong) UILabel *numberL;

- (void)fillDataWithCommModel:(MyOrderModelSubCommodityModel *)model; 

@end

NS_ASSUME_NONNULL_END
