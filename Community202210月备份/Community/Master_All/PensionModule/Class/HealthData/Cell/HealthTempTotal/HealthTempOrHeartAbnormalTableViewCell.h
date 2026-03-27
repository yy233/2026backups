//
//  HealthTempAbnormalTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import <UIKit/UIKit.h>
#import "HealthTempHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthTempOrHeartAbnormalTableViewCell : HealthBaseTotalDataContTouchTableViewCell
- (void)fillDataWithTempAbnormalModel:(HealthGetOneAbnormalModel *)model;
- (void)fillDataWithHeartAbnormalModel:(HealthGetOneAbnormalModel *)model;
@end

NS_ASSUME_NONNULL_END
