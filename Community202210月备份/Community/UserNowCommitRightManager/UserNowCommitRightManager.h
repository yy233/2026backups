//
//  UserNowCommitRightManager.h
//  Community
//
//  Created by 余莹 on 2021/8/17.
// 用户当前小区的权限house对应列表

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserNowCommitRightManager : NSObject
singleton_interface(shareManager)
 
@property (nonatomic,strong) CommitRightAllDataModel  *nowCommunitRightAllDataModel;

@end

NS_ASSUME_NONNULL_END
