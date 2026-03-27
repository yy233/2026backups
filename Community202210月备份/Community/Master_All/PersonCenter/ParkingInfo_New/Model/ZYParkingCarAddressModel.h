//
//  ZYParkingCarAddressModel.h
//  Community
//
//  Created by ZY on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingCarAddressModel : NSObject

// 停车位置类别 0地面 0地下
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
