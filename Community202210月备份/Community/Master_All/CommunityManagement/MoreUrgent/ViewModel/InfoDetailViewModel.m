//
//  InfoDetailViewModel.m
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import "InfoDetailViewModel.h"

@implementation InfoDetailViewModel
+ (void)getTopOrUrgentInfoDetailWithParms:(NSMutableDictionary *)parm WithModelBlock:(InfoModelBlock)modelBlock{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_MAIN_TopOrUregent_MESSAGE_DETAIL_INFO withParams:parm finished:^(id responsObject, NSError *error) {
        InfoModelBlock block = modelBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataDic,YES);
            }else{
                block(@{},NO);
            }
        }else{
            block(@{},NO);
        }
    }];
    
}
@end
