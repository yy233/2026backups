//
//  ListBaseTableViewCell.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable ListBaseTableViewCell_I = @"ListBaseTableViewCell";
static NSString * _Nullable ListBaseTableViewCell_ShowBtn_I = @"ListBaseTableViewCell_ShowBtn_I";
static NSString * _Nullable ListBaseTableViewCell_Switch_I = @"ListBaseTableViewCell_Switch";



NS_ASSUME_NONNULL_BEGIN

@interface ListBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UIButton *rightBtn;
- (void)showRightBtnWithTextStr:(NSString *)str;
- (void)notShowRightBtn;
- (void)setTextPStr:(NSString *)pStr;
@end

//铝管用的
@interface ListBaseTableViewCell_Switch : UITableViewCell
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UISwitch *swi;
@end
NS_ASSUME_NONNULL_END
