//
//  GuestInfoWillRegisterModel.h
//  Community
// //  访客 1.(登记时OK按钮 处理数据时用) 访客 2.(查询某登记时 数据获取后 初步处理数据 即将展示时用)
//  Created by 余莹 on 2020/12/16.
//

#import <Foundation/Foundation.h>
@class  GuestInfoWillRegisterModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReturnResultBlock)(BOOL,NSString *);
typedef void(^ReturnShowModelResultBlock)(BOOL, GuestInfoWillRegisterModel*);

@interface GuestInfoWillRegisterModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;//电话待增
@property (nonatomic,strong) NSString *address;//地址 展示时使用
@property (nonatomic,assign) NSInteger reason;//访问原因 code
@property (nonatomic,strong) NSString *reasonStr;//访问原因name 展示时使用
@property (nonatomic,strong) NSString *contact;//电话
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *carPlate;//车牌待增

@property (nonatomic,assign) NSInteger carType;//类型待增
@property (nonatomic,strong) NSString *carTypeStr;//车类型 展示时使用

@property (nonatomic,assign) NSInteger isCommunityAccess;
@property (nonatomic,strong) NSString *isCommunityAccessStr;

//@property (nonatomic,assign) NSInteger isBuildingAccess;
//@property (nonatomic,strong) NSString *isBuildingAccessStr;
@property (nonatomic,strong) NSString *isCarBanAccessStr;
@property (nonatomic,assign) NSInteger isCarBanAccess;//0917去掉楼宇门禁 增车辆门禁

@property (nonatomic,assign) NSInteger buildingId;//楼栋
@property (nonatomic,assign) NSInteger communityId;
//随行
@property (nonatomic,strong) NSMutableArray *visitorPersonRecordList;
@property (nonatomic,strong) NSMutableArray *visitingCarRecordList;
//二维码数据和ID是同一个
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,assign) NSInteger id;
//
@property (nonatomic,assign) NSInteger carAlternativePaymentStatus;//是否代缴 01
@property (nonatomic,assign) NSInteger expireStatus;//访客码是否过期 01

//20220316
@property (nonatomic,copy) NSString *unitId;//==承接pid
@property (nonatomic,copy) NSString *houseId;

+ (void)addGuestInfoRegistWithParm:(NSMutableDictionary *)parm withReturnResult:(BaseDicAndSuccessBoolBlock)returnBlock;//添加访客
+ (void)showDetailGuestInfoRegistWithParm:(NSMutableDictionary *)parm withReturnResult:(ReturnShowModelResultBlock)returnBlock;//查看访客
@end
/**
 "communityId":1,
     "buildingId":1,
     "name":"测试人员",
     "address":"天王星C座22楼2201",
     "reason":"emmm没想好",
     "contact":"15178763584",
     "startTime":"2020-11-10",
     "endTime":"2020-11-12",
     "isCommunityAccess":1,
     "isBuildingAccess":1,
     "visitorPersonRecordList":
 visitingCarRecordList
 
 address = "天王星C座22楼2201";
 buildingId = 1;
 carPlate = "京AAAE86";
 carType = 1;
 carTypeStr = "微型车";
 checkStatus = 0;
 checkTime = "<null>";
 communityId = 1;
 contact = 15178763584;
 createTime = "2020-12-12 09:21:46";
 deleted = 0;
 endTime = "2020-11-12";
 id = 970499916173312;
 idCard = "<null>";
 isBuildingAccess = 1;
 isCommunityAccess = 1;
 name = "测试人员";
 reason = 1;
 reasonStr = "一般来访";
 refuseReason = "<null>";
 startTime = "2020-11-10";
 uid = test123;
 updateTime = "<null>";
 visitedTime = "<null>";
 visitingCarRecordList =         (
                 {
         carPlate = "渝AAAE86";
         carType = 1;
         carTypeStr = "微型车";
         createTime = "<null>";
         deleted = "<null>";
         id = 970500113305600;
         updateTime = "<null>";
         visitorId = "<null>";
     },
                 {
         carPlate = "渝BBAE86";
         carType = 2;
         carTypeStr = "小型车";
         createTime = "<null>";
         deleted = "<null>";
         id = 970500113305601;
         updateTime = "<null>";
         visitorId = "<null>";
     }
 );
 visitorPersonRecordList =         (
                 {
         createTime = "<null>";
         deleted = "<null>";
         id = 970500033613824;
         mobile = 13222222001;
         name = "随从1";
         updateTime = "<null>";
         visitorId = "<null>";
     },
                 {
         createTime = "<null>";
         deleted = "<null>";
         id = 970500033613825;
         mobile = 13222222002;
         name = "随从2";
         updateTime = "<null>";
         visitorId = "<null>";
     }
 );
};
message = "<null>";
 */
NS_ASSUME_NONNULL_END
