//
//  GuestInfoModel.h
//  Community
//  随行人员 + 访客listCell
//  Created by 余莹 on 2020/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuestInfoModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *name; //来访人姓名
@property (nonatomic,strong) NSString *mobile;//随行人电话 + editVc电话数据处理部分
@property (nonatomic,assign) BOOL deleted;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *uid;

// 访客总列表
@property (nonatomic,strong) NSString *contact;//来访人联系方式
@property (nonatomic,strong) NSString *startTime;//来访时间
@property (nonatomic,strong) NSString *endTime;//来访时间
//1026 增加临时通行二维码键值
@property (nonatomic,assign) NSInteger carType;//  审核方式，1业主审核，2物业审核
@property (nonatomic,assign) NSInteger checkStatus;  //  是否审核，0未审核，1通过，2拒绝
@property (nonatomic,assign) NSInteger status;//    状态 1.待入园 2.已入园 3.已出园 4.已失效
@property (nonatomic,assign) NSInteger tempCodeStatus; //是否是临时通行码;0:不是;1是
@property (nonatomic,assign) NSInteger effectiveTime;//临时通行码有效时间分钟数
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) NSInteger reason;  //1.一般来访 2.应聘来访 3.走亲访友 4.客户来访
@property (nonatomic, copy) NSString *reasonStr; //来访事由文本

/** 访客总列表
 {
address = "天王星C座22楼2201";
buildingId = 1;
carPlate = "京AAAE86";
carType = 1;
carTypeStr = "<null>";
checkStatus = 0;
checkTime = "<null>";
communityId = 1;
contact = 15178763584;
createTime = "2020-12-16 11:13:36";
deleted = 0;
endTime = "2020-11-12";
id = 2448196135686144;
idCard = "<null>";
isBuildingAccess = 1;
isCommunityAccess = 1;
name = "测试人员";
reason = 1;
reasonStr = "<null>";
refuseReason = "<null>";
startTime = "2020-11-10";
uid = test123;
updateTime = "<null>";
visitedTime = "<null>";
visitingCarRecordList = "<null>";
visitorPersonRecordList = "<null>";
}*/

/*
 随行
 createTime = "2020-12-15 14:47:01";
 deleted = 0;
 id = 2139517217804288;
 mobile = 18183132000;
 name = "姓名";
 uid = test123;
 updateTime = "<null>";
 */
@end

NS_ASSUME_NONNULL_END
