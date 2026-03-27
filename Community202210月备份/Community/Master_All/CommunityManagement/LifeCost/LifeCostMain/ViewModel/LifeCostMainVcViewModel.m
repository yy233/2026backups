//
//  LifeCostMainVcViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import "LifeCostMainVcViewModel.h"

@implementation LifeCostMainVcViewModel

//
+ (void)getLifeCostMyCostArrWith:(BaseListArrAndSuccessBoolBlock)listBlock{
    
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Life_MyCost_list withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
//
+ (void)getLifeCostAddNewCostArrWithCotyid:(NSInteger)cityId  with:(BaseListArrAndSuccessBoolBlock)listBlock {

    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Life_AddNewCost_List withParams:@{@"cityId":@(cityId)}.mutableCopy finished:^(id responsObject, NSError *error) {
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
