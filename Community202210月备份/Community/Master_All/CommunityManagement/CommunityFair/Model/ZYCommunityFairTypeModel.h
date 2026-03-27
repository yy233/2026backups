//
//  ZYCommunityFairTypeModel.h
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import <Foundation/Foundation.h>

@class ZYCommunityFairTypeDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairTypeModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray<ZYCommunityFairTypeDataModel *> *data;

@end


@interface ZYCommunityFairTypeDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *communityId;

@end

NS_ASSUME_NONNULL_END
