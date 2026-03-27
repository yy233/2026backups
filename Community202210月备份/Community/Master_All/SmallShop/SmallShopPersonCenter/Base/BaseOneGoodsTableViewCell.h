//
//  BaseGoodsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "BaseOneServiceTableViewCell.h"
#import "SmallShopOrderDetailModelSubGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *BaseOneGoodsTableViewCell_I = @"BaseOneGoodsTableViewCell";

@interface BaseOneGoodsTableViewCell : BaseOneServiceTableViewCell
@property (nonatomic,strong) UILabel *rightCountL;
- (void)fillOrderDetailModelSubOneGoodsModel:(SmallShopOrderDetailModelSubGoodsModel *)goodsModel; 

@end

NS_ASSUME_NONNULL_END
