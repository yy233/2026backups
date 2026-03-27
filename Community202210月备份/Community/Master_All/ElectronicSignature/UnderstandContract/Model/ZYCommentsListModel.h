//
//  ZYCommentsListModel.h
//  Community
//
//  Created by ZY on 2021/5/24.
//

#import <Foundation/Foundation.h>

@class ZYCommentsListDataModel, ZYCommentsListDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommentsListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYCommentsListDataModel *data;

@end


@interface ZYCommentsListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYCommentsListDataListModel *> *list;

@end


@interface ZYCommentsListDataListModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL deleted;

@property (nonatomic, copy) NSString *informationUuid;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *userUuid;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
