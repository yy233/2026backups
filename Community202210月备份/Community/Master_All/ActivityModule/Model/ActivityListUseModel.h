//
//  ActivityListUseModel.h
//  Community
//
//  Created by 余莹 on 2022/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListUseModel : NSObject
//activityStatus    1预发布，2报名进行中，3报名已结束，5活动已结束,6未开始
//status    状态1已报名0未报名
@property (nonatomic,assign) NSInteger activityStatus; //1预发布，2报名进行中，3报名已结束，5活动已结束,6未开始
@property (nonatomic,assign) NSInteger status;//报名或未报名
@property (nonatomic,assign) BOOL isCancel;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *theme;//标题
@property (nonatomic,copy) NSString *contactMobile;
@property (nonatomic,copy) NSString *content;//活动内容
@property (nonatomic,copy) NSString *instructions;//活动须知
@property (nonatomic,copy) NSString *picture;
//@property (nonatomic,copy) NSString *pictures;//逗号分隔
@property (nonatomic,strong) NSArray *pictures;//数组
@property (nonatomic,copy) NSString *beginApplyTime;//报名开始时间
@property (nonatomic,copy) NSString *overApplyTime;//报名结束时间
@property (nonatomic,copy) NSString *beginActivityTime;//活动开始时间
@property (nonatomic,copy) NSString *overActivityTime;//活动结束时间
 @property (nonatomic,assign) NSInteger surplusNumber;//剩余报名数量
@property (nonatomic,assign) NSInteger applyCount;//活动已报名总人数
@property (nonatomic,assign) NSInteger count;//活动名额
@property (nonatomic,copy) NSString *sponsor;//主办方
@property (nonatomic,copy) NSString *address;//活动地址
@property (nonatomic,copy) NSString *mobile;//个人信息电话
@property (nonatomic,copy) NSString *name;//个人信息名字


@property (nonatomic,assign) CGFloat lon;//经度
@property (nonatomic,assign) CGFloat lat;//纬度
;

/**
 {
activityStatus = 1;
beginActivityTime = "2022-02-01 00:00:00";
beginApplyTime = "2022-01-15 00:00:00";
communityId = 0;
content = "测试活动内容
";
count = 1;
createTime = "2022-01-14 09:23:58";
deleted = 0;
id = 145201422634455040;
idStr = 145201422634455040;
isCancel = 0;
overActivityTime = "2022-02-03 00:00:00";
overApplyTime = "2022-01-17 00:00:00";
picture = "http://192.168.12.49:8090/zhsj/base/api/file/down/load?f=a9500b94-b840-4ecb-ab9f-962b61ecfe9a,http://222.178.212.29:9000/sys-activity/d5c9050c52664685b4c5a58370599707";
pictures =                 (
"http://192.168.12.49:8090/zhsj/base/api/file/down/load?f=a9500b94-b840-4ecb-ab9f-962b61ecfe9a",
"http://222.178.212.29:9000/sys-activity/d5c9050c52664685b4c5a58370599707"
);
releaseStatus = 1;
status = 0;
surplusNumber = 1;
theme = "测试活动标题";
type = 1;
updateTime = "2022-03-28 11:15:54";
},
 {
 */

@end

NS_ASSUME_NONNULL_END
