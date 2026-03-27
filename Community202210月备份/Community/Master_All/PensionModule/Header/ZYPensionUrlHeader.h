//
//  ZYPensionUrlHeader.h
//  Community
//
//  Created by ZY on 2021/11/23.
//

#ifndef ZYPensionUrlHeader_h
#define ZYPensionUrlHeader_h

// 养老基础接口
#define kPensionBaseUrl    BASE_URL_OnlyAsOfPort


// ------------------事件提醒-------------------
// 列表查询
#define kEventListUrl @"zhsj/yiliao/myself/event/list"

// 查询所有事件
#define kAllEventListUrl @"zhsj/yiliao/myself/event/pageList"

// 事件提醒详情
#define kEventDetailUrl @"zhsj/yiliao/myself/event/getOne"

// 新增事件提醒
#define kAddEventUrl @"zhsj/yiliao/myself/event/save"

// 修改事件提醒
#define kUpdateEventUrl @"zhsj/yiliao/myself/event/update"

// 删除事件提醒
#define kDeleteEventUrl @"zhsj/yiliao/myself/event/delete"

// 启停事件提醒
#define kEventStatusUrl @"zhsj/yiliao/myself/event/status"


// ------------------家人档案-------------------
// 家人档案列表
#define kFamilyListUrl @"zhsj/yiliao/myself/family/list"

// 家人档案详情
#define kFamilyDetailUrl @"zhsj/yiliao/myself/family/getOne"

// 新增家人档案
#define kAddFamilyUrl @"zhsj/yiliao/myself/family/save"

// 修改家人档案
#define kUpdateFamilyUrl @"zhsj/yiliao/myself/family/update"

// 删除家人档案
#define kDeleteFamilyUrl @"zhsj/yiliao/myself/family/delete"

// 关系公共常量
#define kFamilyTypeSourceUrl @"zhsj/yiliao/myself/source/typeSource"

// 发送验证码
#define kFamilySendCodeUrl @"zhsj/yiliao/myself/family/sendCode"

// 上传头像
#define kUploadFamilyHeadUrl @"zhsj/yiliao/myself/family/upload"

// 查询社区房间成员亲属信息
#define kFamilyMembersUrl @"api/v1/proprietor/user/house/selectMembers"

// 导入家人
#define kImportFamilyUrl @"zhsj/yiliao/myself/family/importFamily"


// ------------------老年活动-------------------
// 查询活动类型
#define kActivityTypeListUrl @"zhsj/oldactivity/activity/queryActivityTypeList"

// 新增活动
#define kAddActivityUrl @"zhsj/oldactivity/activity/publishActivity"

// 删除活动
#define kDeleteActivityUrl @"zhsj/oldactivity/activity/deleteActivity"

// 查询附近所有的活动
#define kNearAllActivityUrl @"zhsj/oldactivity/activity/queryActivityList"

// 分页查询所有的活动
#define kAllActivityListUrl @"zhsj/oldactivity/activity/pageListed"

// 查看当前用户活动列表
#define kUserActivityListUrl @"zhsj/oldactivity/activity/getUserActivityList"

// 活动人所在地
#define kQueryActivityAddressUrl @"zhsj/oldactivity/activity/queryActivity"


// ------------------我的养老-------------------
// 用户信息
#define kPensionUserInfoUrl @"zhsj/yiliao/myself/user/details"


// ------------------文件上传-------------------
// 单个上传
#define kPensionFileUploadUrl @"zhsj/base/api/file/up/load"

// 批量上传
#define kPensionFilesUploadUrl @"zhsj/base/api/file/up/load/batch"

#endif /* ZYPensionUrlHeader_h */
