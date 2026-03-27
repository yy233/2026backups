//
//  CarTypeListModel.m
//  Community
//  车辆类型 list 接口
//  Created by 余莹 on 2020/12/9.
//

#import "CarTypeListModel.h"

@implementation CarTypeListModel
+ (void)getCarTypeListWithBlock:(ListArrBlock)listArrBlock{
  
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_Get_carType withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                ListArrBlock block = listArrBlock;
                block(Y_ResponsObject_dataArr);
            }else{
            }
        }else{
            //
        }
    }];
}

//查询邀请过的车辆列表
+ (void)getCarHistoryListWithHouseInfoCommunityId:(NSInteger)communityId withBlocl:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/visitor/v2/visitorCarHistory";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"communityId":@(communityId)}.mutableCopy finished:^(id responsObject, NSError *error) {
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
