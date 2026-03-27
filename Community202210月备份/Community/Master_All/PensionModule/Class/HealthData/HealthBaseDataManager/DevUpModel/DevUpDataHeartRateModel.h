//
//  DevUpDataHeartRateModel.h
//  Community
//
//  Created by 余莹 on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevUpDataHeartRateModel : NSObject
@property (nonatomic,strong) NSString *familyMemberId;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger silentHeart;
@property (nonatomic,assign) NSInteger diastolicPressure;
@property (nonatomic,assign) NSInteger systolicPressure;
@end
/**
 
 "familyMemberId": "fdsfgdsgrae", //家人id
 "silentHeart": 87, //心率
 "diastolicPressure": 77, //舒张压
 "systolicPressure": 74, //收缩压
 "createTime": 1636600753510 //心率时间（long类型）
 */

NS_ASSUME_NONNULL_END
