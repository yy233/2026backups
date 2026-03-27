//
//  ChatBaseTools.h
//  Socialize
//
//  Created by 余莹 on 2023/7/8.
//

#import <Foundation/Foundation.h>

#define Notice_Name_ChatAdmainMemberArrInfo  @"Notice_Name_ChatAdmainMemberArrInfo"

NS_ASSUME_NONNULL_BEGIN

@interface ChatBaseTools : NSObject
//加系统群
+ (void)chatAddSystemGroupWithBlock:(BaseDicAndSuccessBoolBlock)block;


//全部管理员的获取
+ (void)getGroupAdmainManagerWithBlock:(BaseListArrAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
