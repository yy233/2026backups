//
//  ZYComplaintsOpinionMyAdviceModel.h
//  Community
//
//  Created by ZY on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class ZYComplaintsOpinionMyAdviceDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYComplaintsOpinionMyAdviceModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ZYComplaintsOpinionMyAdviceDataModel *> *data;

@end


@interface ZYComplaintsOpinionMyAdviceDataModel : NSObject

@property (nonatomic, copy) NSString *communityName;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *complainTime;

@end

NS_ASSUME_NONNULL_END
