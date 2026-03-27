//
//  MainUrgentMessageListViewModel.m
//  Community
//
//  Created by 余莹 on 2020/11/18.
//

#import "MainUrgentMessageListViewModel.h"

@implementation MainUrgentMessageListViewModel
//主页
+ (void)getCenterUrgentMessageListDataWithListBlock:(UrgentMessageListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    NSDictionary *communityIdDic = @{@"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.id)};
    NSDictionary *communityIdDic = @{@"acctId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [params setValue:@(1) forKey:@"page"];
    [params setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [params setValue:communityIdDic forKey:@"query"];
    [self getListWithParm:params withListBlock:block];
}
//更多按钮后的list init 弃用
//+ (void)getCenterUrgentMoreMessageListInitData:(UrgentMessageListBlock)block{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
//    NSDictionary *communityIdDic = @{@"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.id)};
//    [params setValue:@(1) forKey:@"page"];
//    [params setValue:@(Y_PAGE_SIZE) forKey:@"size"];
//    [params setValue:communityIdDic forKey:@"query"];
//    [self getListWithParm:params withListBlock:block];
//}
//更多按钮后的list  当前社区紧急消息
+ (void)getCenterUrgentMoreMessageListUpDateWithPageNum:(NSInteger)pageNum listBlock:(UrgentMessageListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

//    NSDictionary *communityIdDic = @{@"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.id)};
    NSDictionary *communityIdDic = @{@"acctId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [params setValue:@(pageNum) forKey:@"page"];
    [params setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [params setValue:communityIdDic forKey:@"query"];
    [self getListWithParm:params withListBlock:block];
}

//顶部 总社区小区 详情消息列表
+ (void)getTopInfoDetailUrgentListInitDataWithCommunityId:(NSInteger)communityID listBlock:(UrgentMessageListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    NSDictionary *communityIdDic = @{@"communityId":@(communityID)};
    NSDictionary *communityIdDic = @{@"acctId":@(communityID)};
    [params setValue:@(1) forKey:@"page"];
    [params setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [params setValue:communityIdDic forKey:@"query"];
    [self getListWithParm:params withListBlock:block];
}
+ (void)getTopInfoDetailUrgentListUpDateWithCommunityId:(NSInteger)communityID WithPageNum:(NSInteger)pageNum listBlock:(UrgentMessageListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

//    NSDictionary *communityIdDic = @{@"communityId":@(communityID)};
    NSDictionary *communityIdDic = @{@"acctId":@(communityID)};
    [params setValue:@(pageNum) forKey:@"page"];
    [params setValue:@(Y_PAGE_SIZE) forKey:@"size"];
    [params setValue:communityIdDic forKey:@"query"];
    [self getListWithParm:params withListBlock:block];
}
+ (void)getListWithParm:(NSMutableDictionary *)params withListBlock:(UrgentMessageListBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MAIN_URGENT_MESSAGE
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        UrgentMessageListBlock messageListBlock = block;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                messageListBlock(Y_ResponsObject_dataArr,YES);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
//                messageListBlock(Y_ResponsObject_dataArr,NO);
                messageListBlock(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
//            messageListBlock(Y_ResponsObject_dataArr,NO);
            messageListBlock(@[],NO);
        }
        
    }];
}
@end
