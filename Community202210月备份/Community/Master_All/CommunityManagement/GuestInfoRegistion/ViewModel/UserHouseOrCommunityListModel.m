//
//  UserHouseListModel.m
//  Community
//
//  Created by 余莹 on 2020/12/16.
//

#import "UserHouseOrCommunityListModel.h"

@implementation UserHouseOrCommunityListModel
//作为业主家属租客身份所拥有的房屋列表
+ (void)getUserAllHouseListWithBlock:(ListArrBlock)listArrBlock{
    //
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_User_HouseList_IsAll withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                ListArrBlock block = listArrBlock;
                block(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//只是作为业主身份所拥有的房屋列表
+ (void)getUserHouseListWhenIsYeZhuWithBlock:(ListArrBlock)listArrBlock{
    //URL_Get_User_HouseList_IsAll
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_User_HouseList_IsYeZu withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                ListArrBlock block = listArrBlock;
                block(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

+ (void)getUerAllCommunityListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    //作为业主家属租客身份所拥有的小区列表
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_User_CommunityList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                if (isNil(Y_ResponsObject_dataArr)) {//主页用到时 若游客点击则不该传入数据
                    block(@[],YES);
                    return;
                }
                block(Y_ResponsObject_dataArr,YES);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
                block(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@[],NO);
        }
    }];
}
+ (void)getUerAllCommunityListWhenMyRightIsYeZhuWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    //只是作为业主身份所拥有的小区列表
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_User_communityUserList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                if (isNil(Y_ResponsObject_dataArr)) {//主页用到时 若游客点击则不该传入数据
                    block(@[],YES);
                    return;
                }
                block(Y_ResponsObject_dataArr,YES);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
                block(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@[],NO);
        }
    }];
}
@end
