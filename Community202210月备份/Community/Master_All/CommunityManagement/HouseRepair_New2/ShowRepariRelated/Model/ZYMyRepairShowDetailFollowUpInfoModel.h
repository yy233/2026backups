//
//  ZYMyRepairShowDetailFollowUpInfoModel.h
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import <Foundation/Foundation.h>

@class ZYMyRepairShowDetailFollowUpInfoListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYMyRepairShowDetailFollowUpInfoModel : NSObject <YYModel>

// 唯一标识id
@property (nonatomic, copy) NSString *ID;

// 工单ID
@property (nonatomic, copy) NSString *repairOrderId;

// 创建时间
@property (nonatomic, copy) NSString *createTime;

// 操作类型
@property (nonatomic, assign) NSInteger opType;

// 操作类型字符串
@property (nonatomic, copy) NSString *opTypeStr;

// 备注信息
@property (nonatomic, copy) NSString *remark;

// 图片
@property (nonatomic, copy) NSString *recordImg;

// 语音地址
@property (nonatomic, copy) NSString *voiceUrl;

// 语音时长
@property (nonatomic, assign) NSInteger voiceLength;

// 信息列表
@property (nonatomic, strong) NSArray<ZYMyRepairShowDetailFollowUpInfoListModel *> *infoVOS;

// 图片列表
@property (nonatomic, strong) NSArray *imgs;

// ---自定义---
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat contentCollectionViewHeight;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) NSInteger isPlay;

@end


@interface ZYMyRepairShowDetailFollowUpInfoListModel : NSObject

// 信息
@property (nonatomic, copy) NSString *info;

// 是否包含电话
@property (nonatomic, assign) BOOL hasMobile;

// 电话号码
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
