//
//  MainBannerListViewModel.m
//  Community
//
//  Created by 余莹 on 2020/11/18.
//

#import "MainBannerListViewModel.h"

@implementation MainBannerListViewModel

- (void)getTopBannerListDataWithListBlock:(BannerListBlock)block{
    self.bannerListBlock = block;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [params setValue:@(Banner_Position_Top) forKey:@"position"];
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURL:URL_MAIN_BANNER_LIST
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        STRONGSELF
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.bannerListBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
+ (void)getTopBannerListDataWithListBlock:(BannerListBlock)block{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [params setValue:@(Banner_Position_Top) forKey:@"position"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MAIN_BANNER_LIST
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *arr = [NSArray arrayWithArray:Y_ResponsObject_dataArr];
                block(arr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

+ (void)getShoppingBannerListDataWithListBlock:(BannerListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [params setValue:@(Banner_Position_Bottom) forKey:@"position"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_MAIN_BANNER_LIST
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                BannerListBlock bannerBlock = block;
              NSMutableArray *arr =  [[responsObject allKeys] containsObject:@"data"]?[NSMutableArray arrayWithArray:[responsObject objectForKey:@"data"]]:[NSMutableArray array];
              bannerBlock(arr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}


@end
