//
//  ZYSealImageModel.h
//  Community
//
//  Created by ZY on 2021/5/13.
//

#import <Foundation/Foundation.h>

@class ZYSealImageDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSealImageModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYSealImageDataModel *data;

@end


@interface ZYSealImageDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *suffix;

@property (nonatomic, assign) BOOL deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
