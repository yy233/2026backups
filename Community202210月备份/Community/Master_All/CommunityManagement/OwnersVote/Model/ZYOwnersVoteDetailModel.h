//
//  ZYOwnersVoteDetailModel.h
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import <Foundation/Foundation.h>

@class ZYOwnersVoteDetailDataModel, ZYOwnersVoteDetailDataVoteTopicEntityModel, ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYOwnersVoteDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYOwnersVoteDetailDataModel *data;

@end


@interface ZYOwnersVoteDetailDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *communityId;

@property (nonatomic, copy) NSString *theme;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *overTime;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, assign) NSInteger choose;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) ZYOwnersVoteDetailDataVoteTopicEntityModel *voteTopicEntity;

@end


@interface ZYOwnersVoteDetailDataVoteTopicEntityModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *voteId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *optionsIds;

@property (nonatomic, strong) NSArray<ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel *> *options;

@end


@interface ZYOwnersVoteDetailDataVoteTopicEntityOptionsModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *voteId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, assign) NSInteger code;

// 0未选中 1已选中
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
