//
//  ZYHouseRepairIssueUploadModel.h
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYHouseRepairIssueUploadModel : NSObject

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 报事报修人
@property (nonatomic, copy) NSString *name;

// 联系电话
@property (nonatomic, copy) NSString *phone;

// 报事报修内容
@property (nonatomic, copy) NSString *problem;

// 图片地址
@property (nonatomic, copy) NSString *repairImg;

// 报事报修类别id
@property (nonatomic, copy) NSString *typeId;

// 区域id或者房屋id
@property (nonatomic, copy) NSString *regionId;

// 报事报修地址
@property (nonatomic, copy) NSString *address;

// 1公共区域 2非公共区域
@property (nonatomic, assign) NSInteger regionType;

// 预约时间
@property (nonatomic, copy) NSString *appointmentTime;

// 语音地址
@property (nonatomic, copy) NSString *voiceUrl;

// 语音时长
@property (nonatomic, assign) NSInteger voiceLength;


// ---自定义数据---
// 社区名
@property (nonatomic, copy) NSString *communityName;

// 工单类型名
@property (nonatomic, copy) NSString *typeName;

// 是否播放
@property (nonatomic, assign) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
