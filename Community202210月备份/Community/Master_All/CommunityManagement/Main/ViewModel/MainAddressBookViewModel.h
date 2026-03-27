//
//  MainAddressBookViewModel.h
//  Community
//
//  Created by 余莹 on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddressBookListBlock)(NSMutableArray *);
typedef void(^AddressBookDetailPhoneBlock)(NSMutableArray *);

@interface MainAddressBookViewModel : NSObject

+ (void)getAddressBookListArrWithBlock:(AddressBookListBlock)block;
+ (void)getAddressBookDetailPhoneArrWithDepartmentId:(NSInteger)departmentId
                                    detailPhoneblock:(AddressBookDetailPhoneBlock)block;
+ (void)getAddressBookTopShowInfoWithCommunityId:(NSInteger)communityId
                                       withBlock:(BaseDicAndSuccessBoolBlock)block; 
@end
NS_ASSUME_NONNULL_END
