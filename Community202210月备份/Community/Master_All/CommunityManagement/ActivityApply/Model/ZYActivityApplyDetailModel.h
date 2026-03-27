//
//  ZYActivityApplyDetailModel.h
//  Community
//
//  Created by ZY on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class ZYActivityApplyDetailDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYActivityApplyDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYActivityApplyDetailDataModel *data;

@end


@interface ZYActivityApplyDetailDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

// 0未报名 1已报名
@property (nonatomic, assign) NSInteger status;

// 主题
@property (nonatomic, copy) NSString *theme;

// 内容
@property (nonatomic, copy) NSString *content;

// 报名人数
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *communityId;

// 活动开始时间
@property (nonatomic, copy) NSString *beginActivityTime;

// 活动结束时间
@property (nonatomic, copy) NSString *overActivityTime;

// 报名开始时间
@property (nonatomic, copy) NSString *beginApplyTime;

// 报名结束时间
@property (nonatomic, copy) NSString *overApplyTime;

// 图片集合 逗号分隔
@property (nonatomic, copy) NSString *picture;

// 姓名
@property (nonatomic, copy) NSString *name;

// 电话
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
