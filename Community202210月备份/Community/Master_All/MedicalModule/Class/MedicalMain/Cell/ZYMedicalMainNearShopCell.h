//
//  ZYMedicalMainNearShopCell.h
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import "MedicalStoresBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYMedicalMainNearShopCell : UITableViewCell
- (void)fillDataWithStoreShopModel:(MedicalStoresBaseModel *)model;
@end

NS_ASSUME_NONNULL_END
