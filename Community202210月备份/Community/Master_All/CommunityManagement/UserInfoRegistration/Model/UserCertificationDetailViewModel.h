//
//  UserCertificationDetailViewModel.h
//  Community
//
//  Created by 余莹 on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCertificationDetailViewModel : NSObject

+ (void)mainUserDeletRelationWithRelationId:(NSInteger)relationId withBlock:(BaseDicAndSuccessBoolBlock)block;//业主 家属id  删除接口
+ (void)deletCarWithVcShowTypeBoolIsMainOrFamile:(BOOL)isMainUserBool withCarId:(NSInteger)carId withBlock:(BaseDicAndSuccessBoolBlock)block;//业主车 家属车 删除接口


@end

NS_ASSUME_NONNULL_END
