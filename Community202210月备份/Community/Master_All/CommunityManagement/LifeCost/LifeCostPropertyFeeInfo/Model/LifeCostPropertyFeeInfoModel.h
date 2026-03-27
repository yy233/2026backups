//
//  LifeCostPropertyFeeInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import "LifeCostPropertyFeeInfoSubEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPropertyFeeInfoModel : NSObject
//@property (nonatomic,strong) NSString *roomName;
//@property (nonatomic,strong) LifeCostPropertyFeeInfoSubEntityModel *entity;
/**
 code = 0;
 data =     {
     entity =         {
         communityId = 1;
         createTime = "2021-06-09 00:00:00";
         deleted = 0;
         houseId = 1243123411;
         id = 65696555432284160;
         idStr = 65696555432284160;
         orderNum = 000101316800007636;
         orderStatus = 0;
         orderTime = "2021-06-09";
         penalSum = "1.18";
         propertyFee = "58.9";
         statementStatus = 0;
         totalMoney = "60.08";
         uid = 6d6d2a3e42b14afa88de5e2faf6acfae;
         updateTime = "2021-07-08 00:00:03";
     };
     roomName = "E栋3层e-3-3-1";
 };
 message = "查询成功";
}
(lldb)
 */
//1007 新_________
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *overTime;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,strong) NSString *rise;
@property (nonatomic,strong) NSString *feeRuleName;

@property (nonatomic,assign) double propertyFee;//物业费
@property (nonatomic,assign) double penalSum;//违约金
@property (nonatomic,assign) double totalMoney;

@property (nonatomic,assign) double coupon;//折扣
@property (nonatomic,strong) NSString *beginTime;//时间


//NSString *deductionMoeny = [NSString stringWithFormat:@"¥%0.2f",model.deduction]
//NSString *couponMoeny = [NSString stringWithFormat:@"¥%0.2f",model.coupon];//折

@end

NS_ASSUME_NONNULL_END
