//
//  AccessListModel.m
//  Community
// communityAccess 社区门禁类型
// buildingAccess  楼栋门禁类型
//  Created by 余莹 on 2020/12/15.
//

#import "AccessListModel.h"

@implementation AccessListModel
+ (void)getCommunityAccessListWithBlock:(ListArrBlock)listArrBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_communityAccess withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"%@",Y_ResponsObject_dataArr);
                      ListArrBlock block = listArrBlock;
                      block(Y_ResponsObject_dataArr);
                });
            }else{
            }
        }else{
            
        }
    }];
}
+ (void)getBuildingAccessListWithBlock:(ListArrBlock)listArrBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_buildingAccess withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"%@",Y_ResponsObject_dataArr);
                      ListArrBlock block = listArrBlock;
                      block(Y_ResponsObject_dataArr);
                });
            }else{
            }
        }else{
        }
    }];
}
@end
