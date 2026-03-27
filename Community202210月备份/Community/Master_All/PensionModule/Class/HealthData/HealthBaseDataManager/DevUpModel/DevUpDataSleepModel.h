//
//  DevUpDataSleepModel.h
//  Community
//
//  Created by 余莹 on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevUpDataSleepModel : NSObject
@property (nonatomic,strong) NSString *familyMemberId;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger stepCount;
@property (nonatomic,assign) NSInteger sleepStatus;
@end

/**
 "familyMemberId": "fdsfgdsgrae", //家人id
 "stepCount": 77, //睡眠步数
 "sleepStatus": 1, //睡眠状态（1 开始入睡 2 浅睡 3 深睡 4 清醒 5 快速眼动）
 "createTime": 1636600753510 //睡眠时间（类型是long类型）

},
 */
NS_ASSUME_NONNULL_END
