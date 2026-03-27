//
//  HealthBaseDataSaveModel.h
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#import <Foundation/Foundation.h>

@class DevGetNowUsersDevInfoModel;
@class DevGetRecentHealthModel;

NS_ASSUME_NONNULL_BEGIN

@interface HealthBaseDataSaveNowUseModel : NSObject
@property (nonatomic,strong) NSString *nowUserId;
@property (nonatomic,strong) NSMutableDictionary *nowUserDevInfoDic;
@property (nonatomic,strong) NSMutableDictionary *nowUserHealthInfoDic;
@property (nonatomic,strong) DevGetNowUsersDevInfoModel *nowUserDevInfoModel;
@property (nonatomic,strong) DevGetRecentHealthModel *nowRecentHealthModel;
@property (nonatomic,assign) BOOL nowUserInfoChangeBool;
@end

NS_ASSUME_NONNULL_END
