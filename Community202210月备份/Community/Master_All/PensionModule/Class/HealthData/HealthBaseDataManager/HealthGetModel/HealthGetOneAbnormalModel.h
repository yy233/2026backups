//
//  HealthGetOneAbnormalModel.h
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HealthGetOneAbnormalModel : NSObject

@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *decimalData;
@property (nonatomic,strong) NSString *data;

/**
 data = "<null>";
 decimalData = "35.3";
 time = "17:30";
 */


@end

NS_ASSUME_NONNULL_END
