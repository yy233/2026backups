//
//  ZYParkingStallRelevantStallModel.h
//  Community
//
//  Created by ZY on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingStallRelevantStallModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 车位号（可以进行购买  产权车位）
@property (nonatomic, copy) NSString *carPositionNumber;

// 车位编号
@property (nonatomic, copy) NSString *carPositionSerialNumber;

@end

NS_ASSUME_NONNULL_END
