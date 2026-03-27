//
//  GuestInfoWillRegisterModel.m
//  Community
//
//  Created by 余莹 on 2020/12/16.
//

#import "GuestInfoWillRegisterModel.h"

@implementation GuestInfoWillRegisterModel
+ (void)addGuestInfoRegistWithParm:(NSMutableDictionary *)parm withReturnResult:(BaseDicAndSuccessBoolBlock)returnBlock{
    /**
     url=http://192.168.12.107:6001/api/v1/proprietor/visitor____{ 成功后密码和时间限制
        code = 0;
        data =     {
            isBuildingAccess = 1;
            isCommunityAccess = 2;
            password = 1213281;
            timeLimit = 1440;
            token = 298c56e13e41497190dfe01959ccce80;
        };
        message = "<null>";
    }
     */
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_Add withParams:parm finished:^(id responsObject, NSError *error) {
        BaseDicAndSuccessBoolBlock block = returnBlock;
        NSString *msg = @"添加失败";
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                msg = [NSString stringWithFormat:@"%@",Y_ResponsObject_messageStr];
                block(Y_ResponsObject_dataDic, YES);
            }else{
                msg = [NSString stringWithFormat:@"%@",Y_ResponsObject_messageStr];
                block(@{},NO);
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
            block(@{},NO);
        }
    }];
}
+ (void)showDetailGuestInfoRegistWithParm:(NSMutableDictionary *)parm withReturnResult:(ReturnShowModelResultBlock)returnBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Visitor_ShowDetail withParams:parm finished:^(id responsObject, NSError *error) {
        ReturnShowModelResultBlock block = returnBlock;
        GuestInfoWillRegisterModel *model = [[GuestInfoWillRegisterModel alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                model = [GuestInfoWillRegisterModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                block(YES,model);
            }else{
                block(NO,model);
                 Y_SVP_SHOW_ERR_MESSAGE;
            }
        }else{
            block(NO,model);
            Y_SVP_SHOW_ERR_DESCRIPTION;
        }
    }];
}
@end
