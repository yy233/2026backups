//
//  IMGoChatVcTool.h
//  Socialize
//
//  Created by 余莹 on 2023/7/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//通知跳转去某用户的友圈粉圈fid页面
#define Notice_Name_GotoImOneUserInfoVc  @"Notice_Name_GotoImOneUserInfoVc"

NS_ASSUME_NONNULL_BEGIN

@interface IMGoChatOneUserInfoVcTool : NSObject
+ (void)gotoImOneUserInfoViewControllerWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo withusePushVc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
