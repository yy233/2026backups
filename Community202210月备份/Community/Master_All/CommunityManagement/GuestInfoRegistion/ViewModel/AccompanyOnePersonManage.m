//
//  AccompanyOnePersonManage.m
//  Community
//
//  Created by 余莹 on 2020/12/15.
//

#import "AccompanyOnePersonManage.h"

@implementation AccompanyOnePersonManage
+ (void)personAddWithOneModel:(GuestInfoModel *)guestInfoModel withReturn:(AccompayPersonReturnBlock)reutrnBlock{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:guestInfoModel.name forKey:@"name"];
    [parm setValue:guestInfoModel.mobile forKey:@"mobile"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_Accompany_Person_AddAndOther withParams:parm finished:^(id responsObject, NSError *error) {
        AccompayPersonReturnBlock block  = reutrnBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(YES);
            }else{
                block(NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//+ (void)personDeletWithOneModel:(GuestInfoModel *)guestInfoModel withReturn:(AccompayPersonReturnBlock)reutrnBlock{
//    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//    [parm setValue:@(guestInfoModel.id) forKey:@"id"];
//    //del
//    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueue:URL_Visitor_Accompany_Person_AddAndOther withParams:parm finished:^(id responsObject, NSError *error) {
//        AccompayPersonReturnBlock block  = reutrnBlock;
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                block(YES);
//            }else{
//                block(NO);
////                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            block(NO);
////            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
+ (void)personDeletWithOneModel:(GuestInfoModel *)guestInfoModel withReturn:(AccompayPersonReturnBlock)reutrnBlock{
    NSMutableArray *body = [NSMutableArray arrayWithArray:@[@(guestInfoModel.id)]];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWithBodyNotParms:URL_Visitor_Accompany_Person_AddAndOther withBody:body finished:^(id responsObject, NSError *error) {
        AccompayPersonReturnBlock block  = reutrnBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(YES);
            }else{
                block(NO);
//                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
+ (void)personUpdateWithOneOldModel:(GuestInfoModel *)oldModel newModel:(GuestInfoModel *)newModel withReturn:(AccompayPersonReturnBlock)reutrnBlock{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(oldModel.id) forKey:@"id"];
    [parm setValue:newModel.name forKey:@"name"];
    [parm setValue:newModel.mobile forKey:@"mobile"];//key值较多 不用模型转dic
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:URL_Visitor_Accompany_Person_AddAndOther withParams:parm finished:^(id responsObject, NSError *error) {
        AccompayPersonReturnBlock block  = reutrnBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(YES);
            }else{
                block(NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
+ (void)personDeletWithModelArr:(NSMutableArray *)guestModelArr withReturn:(AccompayPersonReturnBlock)reutrnBlock{
    NSMutableArray *body = [NSMutableArray array];
    [guestModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GuestInfoModel *model = guestModelArr[idx];
        [body addObject:@(model.id)];
    }];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWithBodyNotParms:URL_Visitor_Accompany_Person_AddAndOther withBody:body finished:^(id responsObject, NSError *error) {
        AccompayPersonReturnBlock block  = reutrnBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(YES);
            }else{
                block(NO);
//                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
@end
