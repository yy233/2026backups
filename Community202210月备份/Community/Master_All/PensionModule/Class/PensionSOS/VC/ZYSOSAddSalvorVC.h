//
//  ZYSOSAddSalvorVC.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "ZYFamilyArchiveModel.h"
#import "PersionSosData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSOSAddSalvorVC : ZYPensionBaseVC
@property (nonatomic, assign) BOOL isEditTypeBool;
//
@property (nonatomic, strong) SosAddressBookFamilyModel *saveEditOrAddFamilyModel;
//
@property (nonatomic, strong) ZYFamilyArchiveModel *saveNowFamilyModel;

@end

NS_ASSUME_NONNULL_END
