//
//  ZYParkingStallRelevantCarModel.h
//  Community
//
//  Created by ZY on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingStallRelevantCarModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 车牌
@property (nonatomic, copy) NSString *carNumber;

@end

NS_ASSUME_NONNULL_END
