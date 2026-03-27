//
//  ZYXianjingJuanListModel.h
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import <Foundation/Foundation.h>

@class ZYXianjingJuanListDataModel, ZYXianjingJuanListDataRecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYXianjingJuanListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYXianjingJuanListDataModel *data;

@end


@interface ZYXianjingJuanListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYXianjingJuanListDataRecordsModel *> *records;

@end


@interface ZYXianjingJuanListDataRecordsModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, assign) NSInteger deleted;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSNumber *money;

@property (nonatomic, strong) NSNumber *leastConsume;

@property (nonatomic, copy) NSString *moneyStr;

@property (nonatomic, copy) NSString *leastConsumeStr;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *expireTime;

@property (nonatomic, assign) NSInteger expired;

@end

NS_ASSUME_NONNULL_END
