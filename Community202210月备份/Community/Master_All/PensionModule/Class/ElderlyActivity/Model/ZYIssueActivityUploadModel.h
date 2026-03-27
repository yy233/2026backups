//
//  ZYIssueActivityUploadModel.h
//  Community
//
//  Created by ZY on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYIssueActivityUploadModel : NSObject

// 活动类型
@property (nonatomic, copy) NSString *activityTypeCode;

// 活动类型名
@property (nonatomic, copy) NSString *activityTypeName;

// 活动描述
@property (nonatomic, copy) NSString *activityDesc;

// 图片路径
@property (nonatomic, copy) NSString *picUrl;

// 语音路径
@property (nonatomic, copy) NSString *voiceUrl;

// 语音文件的大小
@property (nonatomic, assign) NSInteger voiceFileSize;

// 语音的时长 (秒)
@property (nonatomic, assign) NSInteger voiceTime;

// 经度
@property (nonatomic, assign) CGFloat longitude;

// 纬度
@property (nonatomic, assign) CGFloat latitude;

@end

NS_ASSUME_NONNULL_END
