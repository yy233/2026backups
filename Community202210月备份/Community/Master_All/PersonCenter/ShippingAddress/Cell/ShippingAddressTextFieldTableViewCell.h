//
//  ShippingAddressTextFieldTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShippingAddressTextFieldTableViewCellDelegate <NSObject>
- (void)getTextFieldTag:(NSInteger)tag withTextStrWithStr:(NSString *)str;
@end

@interface ShippingAddressTextFieldTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel  *titleL;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,weak) id <ShippingAddressTextFieldTableViewCellDelegate> textFieldDelegate;
@end

NS_ASSUME_NONNULL_END
