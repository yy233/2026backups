//
//  MainUrgentMessageListViewModel.h
//  Community
//
//  Created by 余莹 on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UrgentMessageListBlock)(NSArray *,BOOL);
@interface MainUrgentMessageListViewModel : NSObject
//主页初始的紧急消息列表和对应更多按钮后的刷新
+ (void)getCenterUrgentMessageListDataWithListBlock:(UrgentMessageListBlock)block;
+ (void)getCenterUrgentMoreMessageListUpDateWithPageNum:(NSInteger)pageNum listBlock:(UrgentMessageListBlock)block;
//顶部总社区列表的点击 跳转的 某小区紧急列表数据
+ (void)getTopInfoDetailUrgentListInitDataWithCommunityId:(NSInteger)communityID listBlock:(UrgentMessageListBlock)block;
+ (void)getTopInfoDetailUrgentListUpDateWithCommunityId:(NSInteger)communityID WithPageNum:(NSInteger)pageNum listBlock:(UrgentMessageListBlock)block;

@end

NS_ASSUME_NONNULL_END
