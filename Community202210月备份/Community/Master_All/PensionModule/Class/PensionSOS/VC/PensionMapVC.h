//
//  ZYPensionMapVC.h
//  Community
//
//  Created by 余莹 on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import "HealthDataSubBaseVC.h"
#import "ZYFamilyArchiveModel.h"
#import "PersionSosData.h"


#define NoticeName_SosFindWayAddressInfoChanged  @"SosFindWayAddressInfoChanged"

NS_ASSUME_NONNULL_BEGIN

@interface PensionMapVC : HealthDataSubBaseVC 
@property (nonatomic, strong) ZYFamilyArchiveModel *saveNowFamilyModel;

@end

NS_ASSUME_NONNULL_END
