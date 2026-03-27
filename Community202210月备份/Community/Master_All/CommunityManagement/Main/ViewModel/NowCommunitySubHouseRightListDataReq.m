//
//  NowCommunitySubHouseRightList.m
//  Community
//
//  Created by 余莹 on 2021/8/17.
//

#import "NowCommunitySubHouseRightListDataReq.h"

@implementation NowCommunitySubHouseRightListDataReq
//
+ (void)nowCommunitySubHouseRight{
    NSString *url = @"proprietor/user/control";
    NSMutableDictionary *parms = @{@"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)}.mutableCopy;
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel = [CommitRightAllDataModel mj_objectWithKeyValues:dic];
             }else{
                  
                 Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
