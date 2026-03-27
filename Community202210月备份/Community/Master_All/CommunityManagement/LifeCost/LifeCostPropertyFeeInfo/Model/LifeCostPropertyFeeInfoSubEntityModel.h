//
//  LifeCostPropertyFeeInfoSubEntityModel.h
//  Community
//
//  Created by 余莹 on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPropertyFeeInfoSubEntityModel : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *updateTime;

@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger orderStatus;
@property (nonatomic,assign) NSInteger statementStatus;


@property (nonatomic,assign) double penalSum;
@property (nonatomic,assign) double propertyFee;
@property (nonatomic,assign) double totalMoney;
/**
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
 */
@end

NS_ASSUME_NONNULL_END
