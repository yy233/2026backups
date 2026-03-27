//
//  ShareZhiBoOfOtherTool.h
//  Socialize
//
//  Created by 余莹 on 2023/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShareZhiBoOfOtherTool : NSObject
+ (void)getThisZhiBoInfoWithUseActivityId:(NSString *)activityID withMyRoleIsZhuBoBool:(BOOL)isZhuBoBool WithWillUsePushUseVc:(UIViewController *)puVc;
@end

NS_ASSUME_NONNULL_END
