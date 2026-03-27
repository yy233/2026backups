//
//  ParkingCarBaseModel.h
//  Community
//
//  Created by 余莹 on 2021/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingCarBaseModel : NSObject
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger communityId;//社区id
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *carPlate;
@property (nonatomic,strong) NSString *carPositionText;//车库位置
@property (nonatomic,assign) NSInteger remainingDays;//天数
//
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger type;
//@property (nonatomic,assign) NSInteger orderNum;
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,strong) NSString *typeText;
@property (nonatomic,strong) NSString *overTime;
@property (nonatomic,assign) double money;


/**
 beginTime = "2021-08-01 00:00:00";
 carPlate = "渝AAXZ11";
 carPositionId = 724;
 carPositionText = 0078;
 communityId = 1;
 id = 30417150137208832;
 idStr = 30417150137208832;
 overTime = "2021-10-01 00:00:00";
 remainingDays = 35;
 type = 2;
 typeText = "月租车";
 */

/**
 {
     beginTime = "2021-08-01 10:48:38";
     carPlate = "\U6e1dAAAZ22";
     carPositionId = 725;
     carPositionText = 0079;
     id = 46813546846;
     idStr = 46813546846;
     money = 400;
     month = 2;
     orderNum = 6468135486431;
     overTime = "2021-09-30 10:48:43";
     type = 2;
     typeText = "\U6708\U79df\U8f66";
 }
 */
@end

NS_ASSUME_NONNULL_END
