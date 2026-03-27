//
//  PersionSosData.h
//  Community
//
//  Created by 余莹 on 2021/11/27.
//

#import <Foundation/Foundation.h>

#import "SosAddressBookFamilyModel.h"
#import "SosAddressBookAgencyModel.h"

#define NoticeName_SosAddressUpData    @"SosAddressUpData"
//static NSString *NoticeName_SosAddressUpData = @"SosAddressUpData";

#define kAgencyOneObjKey       @"agency"
#define kFamilyListKey       @"familyList"


NS_ASSUME_NONNULL_BEGIN

@interface PersionSosData : NSObject
//
+ (void)getFamileWithBlock:(BaseListArrAndSuccessBoolBlock)block;
//紧急呼救sos
+ (void)sosOfNowFamilyId:(NSString *)familyIdStr withBlock:(BaseDicAndSuccessBoolBlock)block;
//sos找路 获取存的 地址终点信息
+ (void)sosfindTheWayWithGetAnAddressInfowithBlock:(BaseDicAndSuccessBoolBlock)block;
//sos提交 地址终点信息
+ (void)sosSaveAnNewDestinationAddressWithParms:(NSMutableDictionary *)parms  withBlock:(BaseDicAndSuccessBoolBlock)block;
//通讯录
+ (void)getFamilysAndAgencysListOfNowFamilyId:(NSString *)familyIdStr WithBlock:(BaseDicAndSuccessBoolBlock)block;

// 家属
+ (void)addFamilysOfNowFamilyId:(NSString *)familyIdStr withNameStr:(NSString *)nameStr withMobile:(NSString *)mobileStr  withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)editFamilysOfNowFamilyId:(NSString *)familyIdStr withNameStr:(NSString *)nameStr withMobile:(NSString *)mobileStr withChangeInfoId:(NSString *)changeInfoId withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)editFamilysOfNowFamilyId:(NSString *)familyIdStr   withDeletInfoId:(NSString *)deletInfoId withBlock:(BaseDicAndSuccessBoolBlock)block;

// 机构
+ (void)addAgencyOfNowFamilyId:(NSString *)familyIdStr withAgencyIdStr:(NSString *)agencyIdStr  withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)editAgencyOfNowFamilyId:(NSString *)familyIdStr withAgencyIdStr:(NSString *)agencyIdStr   withOldWillChangeInfoId:(NSString *)changeInfoId withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)editAgencysOfNowFamilyId:(NSString *)familyIdStr  withDeletInfoId:(NSString *)deletInfoId withBlock:(BaseDicAndSuccessBoolBlock)block;

//医疗店铺查询部分 在医疗data内#import "MedicalShopRelatedData.h"


@end

NS_ASSUME_NONNULL_END
