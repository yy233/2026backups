//
//  ZYParkingHouseModel.h
//  Community
//
//  Created by ZY on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingHouseModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 用户id
@property (nonatomic, copy) NSString *uid;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 房屋id
@property (nonatomic, copy) NSString *houseId;

// 姓名
@property (nonatomic, copy) NSString *name;

// 房屋全称
@property (nonatomic, copy) NSString *belongHouse;

@end

NS_ASSUME_NONNULL_END
