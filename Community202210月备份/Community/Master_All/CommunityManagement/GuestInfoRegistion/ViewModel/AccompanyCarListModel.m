//
//  AccompanyCarListModel.m
//  Community
//  随行车辆
//  Created by 余莹 on 2020/12/15.
//
//#define Page_Size 20
#define Page_Size 9999
#import "AccompanyCarListModel.h"

@implementation AccompanyCarListModel
+ (void)getAccompayCarInitListWithBlock:(ListArrBlock)listArrBlock{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(1) forKey:@"page"];
    [parm setValue:@(Page_Size) forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_Accompany_Car_List withParams:parm finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *responsDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *personArr = [NSArray arrayWithArray:responsDic[@"records"]];
                ListArrBlock block = listArrBlock;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(personArr);
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//（增删改的时候 错位or得重新刷新 不好处理） 此 弃用
+ (void)getAccompayCarUpdatMoreListWithBlock:(ListArrBlock)listArrBlock nowPageNum:(NSInteger)pageNum{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(pageNum) forKey:@"page"];
    [parm setValue:@(Page_Size) forKey:@"size"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_Accompany_Car_List withParams:parm finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *responsDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *personArr = [NSArray arrayWithArray:responsDic[@"records"]];
                ListArrBlock block = listArrBlock;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(personArr);
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
