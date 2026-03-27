//
//  MainRecommendedServiceHourseEstateCellViewModel.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "MainRecommendedServiceHourseEstateCellViewModel.h"

@implementation MainRecommendedServiceHourseEstateCellViewModel

+ (void)getRentServiceHourseRightNewsInfoListArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = @"proprietor/community/inform/latest";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.copy finished:^(id responsObject, NSError *error) {
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
