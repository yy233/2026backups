//
//  BaseAddressWillUseBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/2.
//

#import <UIKit/UIKit.h>
#import "SmallShopAddressData.h"

NS_ASSUME_NONNULL_BEGIN


static NSString *BaseAddressWillUseBtnTableViewCell_I = @"BaseAddressWillUseBtnTableViewCell";

typedef void(^TouchUseBtnBlock)(void);

@interface BaseAddressWillUseBtnTableViewCell : UITableViewCell

@property (nonatomic,copy) TouchUseBtnBlock touchUseBtnBlock;

- (void)fillHistoryAddressStr:(NSString *)address andPhoneStr:(NSString *)phoneStr;

@end

NS_ASSUME_NONNULL_END
