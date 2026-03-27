//
//  ShippingAddressVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShippingAddressVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *topL;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *infoL;
@property (nonatomic,strong) UIButton *editBtn;
@end

NS_ASSUME_NONNULL_END
