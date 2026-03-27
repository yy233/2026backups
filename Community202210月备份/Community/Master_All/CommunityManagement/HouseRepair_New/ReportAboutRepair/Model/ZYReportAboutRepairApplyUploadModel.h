//
//  ZYReportAboutRepairApplyUploadModel.h
//  Community
//
//  Created by ZY on 2022/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYReportAboutRepairApplyUploadModel : NSObject

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 报事报修人
@property (nonatomic, copy) NSString *name;

// 联系电话
@property (nonatomic, copy) NSString *phone;

// 报事报修内容
@property (nonatomic, copy) NSString *problem;

// 报事报修地址
@property (nonatomic, copy) NSString *address;

// 图片地址
@property (nonatomic, copy) NSString *repairImg;

@property (nonatomic, assign) NSInteger repairType;

// 报事报修类别 1.报修 2.报事
@property (nonatomic, assign) NSInteger customRepairType;

// 报事报修类别id
@property (nonatomic, copy) NSString *typeId;

// 语音时长
@property (nonatomic, assign) NSInteger voiceLength;

// 语音地址
@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, assign) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
