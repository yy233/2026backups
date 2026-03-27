//
//  VersionListTool.h
//  Community
//
//  Created by 余莹 on 2021/5/31.
//

#import <Foundation/Foundation.h>
typedef void(^ShowSanfangViewBoolBlock)(BOOL succes, BOOL isShowBool);
NS_ASSUME_NONNULL_BEGIN

@interface VersionShowOrHiddenTool : NSObject
/**
 当前版本是否显示三方登录
 */
+ (void)getVersionInfoBoolWithBool:(ShowSanfangViewBoolBlock)showViewBoolBlock;

/**
 当前版本是否需要提醒用户升级
 */
+ (void)getShowUpdataSignInfoWithBlock:( void(^)(BOOL success,BOOL isMastUpdataBool,NSString *showVersionNumStr,NSString *showVersionMsg) )boolBlock;
@end

NS_ASSUME_NONNULL_END
