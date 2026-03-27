//
//  ZYSOSAddressBookCell.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "SosAddressBookFamilyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZYSOSAddressBookCellDelegate <NSObject>

- (void)telButtonEventWithPhoneStr:(NSString *)phoneStr;

@end

@interface ZYSOSAddressBookCell : UITableViewCell

@property (nonatomic, weak) id<ZYSOSAddressBookCellDelegate> delegate;
- (void)fillDataWithFamilyModel:(SosAddressBookFamilyModel *)model;
@end 

NS_ASSUME_NONNULL_END
