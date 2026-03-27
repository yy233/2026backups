//
//  ZYRedCardListModel.h
//  Community
//
//  Created by ZY on 2021/6/7.
//

#import <Foundation/Foundation.h>

@class ZYRedCardListDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYRedCardListModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ZYRedCardListDataModel *> *data;

@end


@interface ZYRedCardListDataModel : NSObject

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, strong) NSNumber *money;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *validityTime;

@property (nonatomic, copy) NSString *activitieUuid;

@property (nonatomic, assign) NSInteger statesUS;

@end

NS_ASSUME_NONNULL_END
