//
//  DevUpDataTemperatureModel.h
//  Community
//
//  Created by 余莹 on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevUpDataTemperatureModel : NSObject
@property (nonatomic,strong) NSString *familyMemberId;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) double tmpHandler;
@property (nonatomic,assign) double tmpForehead;
@end

/**
 "familyMemberId": "fdsfgdsgrae", //家人id
 "tmpHandler": 35.7, //手腕温度
 "tmpForehead": 37, //额头温度
 "createTime": 1636612382024 //体温时间（类型是long类型）

}
 */

NS_ASSUME_NONNULL_END
