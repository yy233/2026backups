//
//  ZYOwnersVotePlanModel.h
//  Community
//
//  Created by ZY on 2021/8/25.
//

#import <Foundation/Foundation.h>

@class ZYOwnersVotePlanDataModel, ZYOwnersVotePlanDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYOwnersVotePlanModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYOwnersVotePlanDataModel *data;

@end


@interface ZYOwnersVotePlanDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger haveTotal;

@property (nonatomic, strong) NSArray<ZYOwnersVotePlanDataListModel *> *list;

@end


@interface ZYOwnersVotePlanDataListModel : NSObject

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) NSInteger code;

@end

NS_ASSUME_NONNULL_END
