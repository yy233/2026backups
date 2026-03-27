//
//  MainCenterMenuListViewModel.m
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import "MainCenterOneMenuListViewModel.h"

@implementation MainCenterOneMenuListViewModel
+ (void)getCenterOneMenuListArrWithMenuBlock:(MenuListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_MENU_LIST
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                MenuListBlock menuListBlock = block;
                menuListBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//URL_MORE_MENU
+ (void)getMoreMenuListArrWithMenuBlock:(MenuListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MORE_MENU
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                MenuListBlock menuListBlock = block;
                menuListBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//_______

#pragma mark === 新 主页菜单
+ (void)getCenterOneMenuListArrWithMenuBlockNew:(MenuListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [params setValue:@(2) forKey:@"sysType"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [params setValue:app_Version forKey:@"version"];
    //本接口待更换名字 防止新旧版本数据问题
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_MENU_LIST_V2
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                MenuListBlock menuListBlock = block;
                menuListBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//URL_MORE_MENU
+ (void)getMoreMenuListArrWithMenuBlockNew:(MenuListBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
//    [params setValue:@1 forKey:@"communityId"];//测试数据 主页更多后 页面
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MORE_MENU_V2
                                     withParams:params
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                MenuListBlock menuListBlock = block;
                menuListBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
