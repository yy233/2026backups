//
//  BaseViewController+NavColorNotMain.h
//  Community
//
//  Created by 余莹 on 2021/10/12.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController (NavColorNotMain)
- (void)changeNavBackColorWithDIsCountBlueAndWW;//深色 内容蓝色 ，浅色 白色
- (void)changeNavBackColorWithDIsCountBlueAndGW;//深色 内容蓝色 ，浅色 灰白色
- (void)changeNavBackColorWithDDAndWW;//深色 重蓝色 ，浅色 白色
- (void)changeNavBackColorWithDDndWIsGW;//深色 重蓝色 ，浅色 非白偏灰色 （就是原本baseNav）
@end

NS_ASSUME_NONNULL_END
