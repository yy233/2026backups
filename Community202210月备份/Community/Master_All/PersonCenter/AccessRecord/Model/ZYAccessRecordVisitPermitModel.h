//
//  ZYAccessRecordVisitPermitModel.h
//  Community
//
//  Created by ZY on 2022/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYAccessRecordVisitPermitModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 姓名
@property (nonatomic, copy) NSString *name;

// 电话
@property (nonatomic, copy) NSString *mobile;

// 房屋id
@property (nonatomic, copy) NSString *houseId;

// 房屋地址
@property (nonatomic, copy) NSString *houseSite;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 社区名
@property (nonatomic, copy) NSString *communityName;

// 家属关系
@property (nonatomic, assign) NSInteger relation;

// 家属关系文本
@property (nonatomic, copy) NSString *relationName;

// 头像
@property (nonatomic, copy) NSString *avatarUrl;

// 卡机图片
@property (nonatomic, copy) NSString *faceUrl;

// 是否开启访问权限
@property (nonatomic, assign) BOOL visitPermit;

// 是否开启通知权限(本人)
@property (nonatomic, assign) BOOL noticePermit;

// 是否开启通知权限(他人)
@property (nonatomic, assign) BOOL memberNoticePermit;

@end

NS_ASSUME_NONNULL_END
