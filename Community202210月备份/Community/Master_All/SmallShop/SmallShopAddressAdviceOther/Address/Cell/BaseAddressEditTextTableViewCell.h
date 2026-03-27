//
//  BaseAddressShowTextTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/2.
//

#import <UIKit/UIKit.h>
#import "SmallShopAddressData.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *BaseAddressEditTextTableViewCell_I = @"BaseAddressEditTextTableViewCell";

typedef void(^NowTextFStrChangeBlock)(NSString *textStr);

@interface BaseAddressEditTextTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,copy) NowTextFStrChangeBlock nowTextFStrChangeBlock;
- (void)setTextPStr:(NSString *)pStr;



@end

NS_ASSUME_NONNULL_END
