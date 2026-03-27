//
//  TempCodeRelated.m
//  Community
//
//  Created by 余莹 on 2021/10/26.
//

#import "TempCodeRelated.h"

@implementation TempCodeRelated

+ (void)addTempCodeWithCommunityId:(NSString *)communityId withTimeType:(TempCodeTime_Type)timeType withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = @"proprietor/visitor/v2/addTempCode";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:communityId forKey:@"communityId"];
    switch (timeType) {
        case TempCodeTime_Type_30:
            [parms setValue:@(30) forKey:@"effectiveTime"];
            break;
        case TempCodeTime_Type_60:
            [parms setValue:@(60) forKey:@"effectiveTime"];
            break;
        case TempCodeTime_Type_90:
            [parms setValue:@(90) forKey:@"effectiveTime"];
            break;
        default:
            break;
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
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
