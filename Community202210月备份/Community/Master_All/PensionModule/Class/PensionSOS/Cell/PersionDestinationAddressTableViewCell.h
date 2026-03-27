//
//  PersionDestinationAddressTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/12/3.
//

#import <UIKit/UIKit.h>
#import "PensionSOSEmergencyCallTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface PersionDestinationAddressTableViewCell : PensionSOSEmergencyCallTableViewCell
- (void)showFindWayStr:(NSString *)findWayAddressStr withHaveLatLongiInfoBool:(BOOL)haveInfo;

@end

NS_ASSUME_NONNULL_END
