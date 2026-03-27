//
//  RelationshipListModel.m
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import "RelationshipListModel.h"

@implementation RelationshipListModel
+ (void)getRelationshipListWithBlock:(ListArrBlock)listArrBlock{
    ListArrBlock block = listArrBlock;
    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_Get_relationship withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
              DLog(@"%@",Y_ResponsObject_dataArr);
                block(Y_ResponsObject_dataArr);
            }else{
            }
        }else{
            //
        }
    }];
}
@end
