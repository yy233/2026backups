//
//  HouseRepairTypeViewModel.m
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import "HouseRepairTypeViewModel.h"


@implementation HouseRepairTypeViewModel
+ (void)getTypeListWithRepairType:(Repair_Type_PersonalOrPublic)type
                    withListBlock:(ListTypeArrBlock)listBlock{

    NSDictionary *parms = @{@"typeId":@(type)};
    ListTypeArrBlock block = listBlock;
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_House_Repair_TypeList withParams:parms.mutableCopy finished:^(id responsObject, NSError *error) {
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
