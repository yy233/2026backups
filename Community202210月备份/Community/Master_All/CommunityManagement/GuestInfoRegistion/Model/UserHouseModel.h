//
//  UserHouseModel.h
//  Community
// 访客界面查询业主自己所有小区房屋 
//  Created by 余莹 on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserHouseModel : NSObject
@property (nonatomic,strong) NSString *address;//展示文本部分
@property (nonatomic,strong) NSString *communityName;//小区名
@property (nonatomic,strong) NSString *checkStatus;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger deleted;
//@property (nonatomic,assign) NSInteger houseId;//没
@property (nonatomic,assign) NSInteger buildingId;//楼栋门禁需要
@property (nonatomic,assign) NSInteger communityId;//小区门禁需要
//0401
@property (nonatomic,strong) NSString *owner;//业主名
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,assign) NSInteger pid;


//20220316
@property (nonatomic,copy) NSString *pidStr; //就是unitId

@property (nonatomic,copy) NSString *houseId;

@end
/*
 
 
 address = "2\U680b2\U5355\U51431\U5c42bd24fa08-8207-11eb-b";
 buildingId = 4;
 communityId = 1;
 communityName = "\U5e06\U8f6f\U793e\U533a";
 id = 114;
 idStr = 114;
 owner = "\U4f59\U83b9";
 pid = 4;
 
 
 //__UserHouseModel__
 address = "2栋2单元1层1-10";
 checkStatus = "<null>";
 communityId = 1;
 communityName = "帆云小区";
 createTime = "<null>";
 deleted = "<null>";
 houseId = 114;
 id = "<null>";
 uid = "<null>";
 updateTime = "<null>";
},
     {
 address = "2栋2单元1层1-11";
 checkStatus = "<null>";
 communityId = 2;
 communityName = "联想社区";
 createTime = "<null>";
 deleted = "<null>";
 houseId = 115;
 id = "<null>";
 uid = "<null>";
 updateTime = "<null>";
 ///////后
 
 
 address = "2\U680b2\U5355\U51431\U5c421-10";
 building = "<null>";
 buildingId = 1;
 code = "<null>";
 comment = "<null>";
 communityId = 1;
 communityName = "\U5e06\U4e91\U5c0f\U533a";
 createTime = "<null>";
 deleted = "<null>";
 door = "<null>";
 floor = "<null>";
 id = 114;
 pid = 4;
 type = "<null>";
 unit = "<null>";
 updateTime = "<null>";
 */
NS_ASSUME_NONNULL_END
