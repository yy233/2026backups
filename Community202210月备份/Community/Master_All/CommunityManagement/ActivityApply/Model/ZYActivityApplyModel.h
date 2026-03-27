//
//  ZYActivityApplyModel.h
//  Community
//
//  Created by ZY on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class ZYActivityApplyDataModel, ZYActivityApplyDataListModel;;

NS_ASSUME_NONNULL_BEGIN

@interface ZYActivityApplyModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYActivityApplyDataModel *data;

@end


@interface ZYActivityApplyDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYActivityApplyDataListModel *> *list;

@end


@interface ZYActivityApplyDataListModel : NSObject <YYModel>

// 排序
@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

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

@end

NS_ASSUME_NONNULL_END
