//
//  ZYOwnersVoteListModel.h
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import <Foundation/Foundation.h>

@class ZYOwnersVoteListDataModel, ZYOwnersVoteListDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYOwnersVoteListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYOwnersVoteListDataModel *data;

@end


@interface ZYOwnersVoteListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYOwnersVoteListDataListModel *> *list;

@end


@interface ZYOwnersVoteListDataListModel : NSObject <YYModel>

// 排序
@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

// 主题
@property (nonatomic, copy) NSString *theme;

// 内容
@property (nonatomic, copy) NSString *content;

// 开始时间
@property (nonatomic, copy) NSString *beginTime;

// 结束时间
@property (nonatomic, copy) NSString *overTime;

@end

NS_ASSUME_NONNULL_END
