//
//  ChatAddFriendTool.h
//  Socialize
//
//  Created by 余莹 on 2023/8/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//通知跳转去某用户的友圈粉圈fid页面
#define Notice_Name_AddOnePersion    @"Notice_Name_AddOnePersion"
#define Notice_Name_ChatGroupQRTool  @"Notice_Name_ChatGroupQRTool"

typedef void(^CheckChatGroupApplicationList)( NSMutableArray * _Nullable  getAlList,NSInteger noRedCount,BOOL success );

NS_ASSUME_NONNULL_BEGIN

@interface ChatAddFriendTool : NSObject
+ (void)addOnePersonWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo  withusePushVc:(UIViewController *)vc;

@end


@interface ChatGroupQRTool : NSObject
+ (void)groupToolQrWithGroupID:(NSString *)groupID withGroupImg:(UIImage *)gimg withGroupName:(NSString *)groupName  withusePushVc:(UIViewController *)vc;


+ (void)cheackGroupHaveReqListDataWithBlock:(CheckChatGroupApplicationList)block;
@end

NS_ASSUME_NONNULL_END
