//
//  LifeCostWuyeModel.h
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostWuyeModel : NSObject

@property (nonatomic,strong) NSString *houseId;
@property (nonatomic,strong) NSString *rise;//费用名称 
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *tripartiteOrder;//已经支付账单后有的键值
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *beginTime;//开始记账的时间

@property (nonatomic,assign) double totalMoney;
//
@property (nonatomic,assign) BOOL isChooseSelectedType;//给UI用的选择状态数据
//
/**
//10.07
 {
associatedType = 1;
beginTime = "2021-07-01";
buildType = 1;
communityId = 1;
coupon = 0;
createTime = "2021-09-25 14:10:11";
deduction = 0;
deleted = 0;
feeRuleId = 105015179049308160;
hide = 1;
id = 105048403548966914;
idStr = 105048403548966914;
orderNum = 0001163255021178979;
orderStatus = 1;
orderTime = "2021-08-25";
overTime = "2021-07-31";
payTime = "2021-09-30 10:48:36";
payType = 2;
penalSum = 124000;
propertyFee = 15500;
rise = "帆软社区-高层物业服务费";
statementStatus = 0;
targetId = 87343605911523330;
totalMoney = 139500;
type = 2;
uid = test123;
updateTime = "2021-09-30 08:33:39";
},

//旧
 {
houseId = 153123123124314;
id = 50476268268949504;
idStr = 50476268268949504;
orderTime = "2021-04-28";
totalMoney = "307.5";
},

 */
@end

NS_ASSUME_NONNULL_END
