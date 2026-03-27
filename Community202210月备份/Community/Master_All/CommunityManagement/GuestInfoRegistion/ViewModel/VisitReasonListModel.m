//
//  VisitReasonListModel.m
//  Community
//  来访事由
//  Created by 余莹 on 2020/12/11.
//

#import "VisitReasonListModel.h"

@implementation VisitReasonListModel

+ (void)getVisitReasoneListWithBlock:(ListArrBlock)listArrBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_Get_visitReason withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ListArrBlock block = listArrBlock;
                block(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
