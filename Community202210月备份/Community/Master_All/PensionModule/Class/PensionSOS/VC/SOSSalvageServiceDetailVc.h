//
//  SOSSalvageServiceDetailVc.h
//  Community
//
//  Created by 余莹 on 2021/12/6.
//

#import <UIKit/UIKit.h>
#import "HealthDataSubBaseTableViewController.h"
#import "PersionSosData.h"
#import "ZYFamilyArchiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SOSSalvageServiceDetailVc : HealthDataSubBaseTableViewController
@property (nonatomic, strong) SosAddressBookAgencyModel *thisNowShowAgencyModel;
@property (nonatomic, assign) BOOL isEditType;
@property (nonatomic, strong) SosAddressBookAgencyModel *thisOldArchiveModel;
@property (nonatomic, strong) ZYFamilyArchiveModel *saveNowFamilyModel; 

@end

NS_ASSUME_NONNULL_END
