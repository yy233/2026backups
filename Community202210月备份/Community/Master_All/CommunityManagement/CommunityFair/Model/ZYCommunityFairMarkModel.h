//
//  ZYCommunityFairMarkModel.h
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import <Foundation/Foundation.h>

@class ZYCommunityFairMarkDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairMarkModel : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray<ZYCommunityFairMarkDataModel *> *data;

@end


@interface ZYCommunityFairMarkDataModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *communityId;

@end

NS_ASSUME_NONNULL_END
