//
//  ShippingAddressTitleAndBtnsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import <UIKit/UIKit.h>
#import "ShippingAddressTextFieldTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ShippingAddressTitleAndBtnsTableViewCellDelegate <NSObject>
- (void)touchCellTypeIsBottomCellTipType:(BOOL)isBottomCell withSubBtnIndex:(NSInteger)index;
@end

@interface ShippingAddressTitleAndBtnsTableViewCell : ShippingAddressTextFieldTableViewCell
@property (nonatomic,strong) UIView *subBtnsBackView;
- (void)fillCellBtnsCellTypeIsBottomCellTipType:(BOOL)isBottomCell withTitleArr:(NSMutableArray *)btnsTitleArr;
- (void)showSelectedIndex:(NSInteger)indx;
@property (nonatomic,weak) id <ShippingAddressTitleAndBtnsTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
