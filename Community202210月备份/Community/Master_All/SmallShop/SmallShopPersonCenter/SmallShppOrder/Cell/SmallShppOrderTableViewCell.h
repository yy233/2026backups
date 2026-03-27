//
//  SmallShppOrderTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <UIKit/UIKit.h>

#import "SmallShopOrderHeader.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *SmallShppOrderTableViewCell_I = @"SmallShppOrderTableViewCell";

@interface SmallShppOrderTableViewCell : BaseTableViewCell

- (void)fillDataWithOrderModel:(SmallShppOrderModel *)orderModel;
@end

NS_ASSUME_NONNULL_END
