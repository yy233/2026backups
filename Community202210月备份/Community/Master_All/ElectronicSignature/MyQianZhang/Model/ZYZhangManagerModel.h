//
//  ZYZhangManagerModel.h
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import <Foundation/Foundation.h>

@class ZYZhangManagerDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYZhangManagerModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) NSArray<ZYZhangManagerDataModel *> *data;

@end


@interface ZYZhangManagerDataModel : NSObject

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *userUuid;

@property (nonatomic, copy) NSString *fileUuid;

@property (nonatomic, copy) NSString *sealUrl;

@property (nonatomic, copy) NSString *sealName;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) BOOL deleted;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL defaultUse;

@end

NS_ASSUME_NONNULL_END
