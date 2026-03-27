//
//  ZYPensionMainActivityModel.h
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import <Foundation/Foundation.h>

@class ZYPensionMainActivityDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionMainActivityModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYPensionMainActivityDataModel *> *data;

@end


@interface ZYPensionMainActivityDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 用户id
@property (nonatomic, copy) NSString *userUuid;

// 用户聊天id
@property (nonatomic, copy) NSString *imId;

// 姓名
@property (nonatomic, copy) NSString *userName;

// 年龄
@property (nonatomic, assign) NSInteger age;

// 出生年月
@property (nonatomic, copy) NSString *birthday;

// 头像
@property (nonatomic, copy) NSString *avatarImages;

// 活动内容
@property (nonatomic, copy) NSString *activityDesc;

// 活动类型
@property (nonatomic, copy) NSString *activityTypeCode;

// 活动类型名
@property (nonatomic, copy) NSString *activityTypeName;

// 图片路径
@property (nonatomic, copy) NSString *picUrl;

// 是否好友
@property (nonatomic, assign) BOOL isFriend;

// 是否自己
@property (nonatomic, assign) BOOL isUser;

// 经度
@property (nonatomic, copy) NSString *longitude;

// 纬度
@property (nonatomic, copy) NSString *latitude;

// 语音路径
@property (nonatomic, copy) NSString *voiceUrl;

// 语音大小
@property (nonatomic, assign) NSInteger voiceFileSize;

// 语音时长
@property (nonatomic, assign) NSInteger voiceTime;

// 距离
@property (nonatomic, strong) NSNumber *distance;

// 发布时间
@property (nonatomic, copy) NSString *publishTime;

// 发布转化的时间
@property (nonatomic, copy) NSString *publishTimed;

// 自定义属性
// 顺序
@property (nonatomic, assign) NSInteger order;

// 是否正在播放
@property (nonatomic, assign) BOOL isPlay;

// 是否主页
@property (nonatomic, assign) BOOL isMain;

// 是否选中大头针
@property (nonatomic, assign) BOOL isAnnotation;

@end

NS_ASSUME_NONNULL_END
