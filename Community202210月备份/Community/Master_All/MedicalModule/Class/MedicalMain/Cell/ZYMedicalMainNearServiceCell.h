//
//  ZYMedicalMainNearServiceCell.h
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "MedicalServiceBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYMedicalMainNearServiceCell : UITableViewCell
- (void)fillDataWithServiceModel:(MedicalServiceBaseModel *)model;
@end

NS_ASSUME_NONNULL_END
