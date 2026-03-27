//
//  MyOrderListVCHeaderShopInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListVCHeaderShopInfoTableViewCell : MyOrderListVcBaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titLeL;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UIButton *redTextBtn;//劵
- (void)fillDataWithOrderModel:(MyOrderModel *)model; 
@end

NS_ASSUME_NONNULL_END
