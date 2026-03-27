//
//  IssHouseCommunityViewModel.m
//  Community
//
//  Created by 余莹 on 2021/2/26.
//

#import "IssHouseOfUserCommunityAndAddressViewModel.h"

@implementation IssHouseOfUserCommunityAndAddressViewModel
+ (void)getIssueUserCommunityWithCityId:(NSInteger)cityId getCimmunityArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = [NSString stringWithFormat:@"lease/house/allCommunity?cityid=%ld",cityId];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url  withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

///1015更换
+ (void)getIssueUserCommunityArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = [NSString stringWithFormat:@"lease/house/v2/allCommunity"];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url  withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

+ (void)getIssueUserAddressWithCommunityId:(NSInteger)commnunityId getAddressArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = [NSString stringWithFormat:@"lease/house/ownerHouse?cid=%ld",commnunityId];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url  withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
