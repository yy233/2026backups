//
//  ZYSOSAddressBookHospitalCell.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "SosAddressBookAgencyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSOSAddressBookHospitalCellDelegate <NSObject>

- (void)hospitalTelButtonEvent;

- (void)changeHospitalButtonEvent;

@end

@interface ZYSOSAddressBookHospitalCell : UITableViewCell

@property (nonatomic, weak) id<ZYSOSAddressBookHospitalCellDelegate> delegate;
- (void)fillDataWithAgencyModel:(SosAddressBookAgencyModel *)model;
@end

NS_ASSUME_NONNULL_END
