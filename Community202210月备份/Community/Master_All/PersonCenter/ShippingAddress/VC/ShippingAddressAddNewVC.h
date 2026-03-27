//
//  ShippingAddressAddNewVC.h
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShippingAddressAddNewVC : BaseTableViewController //NotNoticeWithUI
@property (nonatomic,assign) BOOL isAddType;
@property (nonatomic,strong) NSString *isEditWithAddressUuidStr;
@end

NS_ASSUME_NONNULL_END
