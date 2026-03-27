//
//  PersonMoneyModelData.m
//  Community
//
//  Created by 余莹 on 2021/4/9.
//

#import "PersonMoneyModelData.h"

@implementation PersonMoneyModelData
+ (void)getPersonMoneyDataWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"proprietor/user/account/all";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end

@implementation PersonMoneyModel

@end
