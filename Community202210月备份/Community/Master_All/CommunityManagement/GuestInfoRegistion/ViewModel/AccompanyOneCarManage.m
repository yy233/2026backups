//
//  AccompanyOneCarManage.m
//  Community
//
//  Created by 余莹 on 2020/12/15.
//

#import "AccompanyOneCarManage.h"

@implementation AccompanyOneCarManage
+ (void)carAddWithOneModel:(CarInfoModel *)carModel withReturn:(AccompayCarReturnBlock)reutrnBlock{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:carModel.carPlate forKey:@"carPlate"];
    [parm setValue:@(carModel.carType) forKey:@"carType"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Visitor_Accompany_Car_AddAndOther withParams:parm finished:^(id responsObject, NSError *error) {
        AccompayCarReturnBlock block  = reutrnBlock;
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
+ (void)carDeletWithOneModel:(CarInfoModel *)carModel withReturn:(AccompayCarReturnBlock)reutrnBlock{
    NSMutableArray *body = [NSMutableArray arrayWithArray:@[@(carModel.id)]];//del
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWithBodyNotParms:URL_Visitor_Accompany_Car_AddAndOther withBody:body finished:^(id responsObject, NSError *error) {
        AccompayCarReturnBlock block  = reutrnBlock;
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
+ (void)carUpdateWithOneOldModel:(CarInfoModel *)oldModel
                        newModel:(CarInfoModel *)newModel
                      withReturn:(AccompayCarReturnBlock)reutrnBlock{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(oldModel.id) forKey:@"id"];
    [parm setValue:newModel.carPlate forKey:@"carPlate"];
    [parm setValue:@(newModel.carType) forKey:@"carType"];
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:URL_Visitor_Accompany_Car_AddAndOther withParams:parm finished:^(id responsObject, NSError *error) {
        AccompayCarReturnBlock block  = reutrnBlock;
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
+ (void)carDeletWithModelArr:(NSMutableArray *)carModelArr withReturn:(AccompayCarReturnBlock)reutrnBlock{
    NSMutableArray *body = [NSMutableArray array];
    [carModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CarInfoModel *model = carModelArr[idx];
        [body addObject:@(model.id)];
    }];
    [[ToolOfNetWork sharedTools]YrequestDeletURLNoMainQueueWithBodyNotParms:URL_Visitor_Accompany_Car_AddAndOther withBody:body finished:^(id responsObject, NSError *error) {
        AccompayCarReturnBlock block  = reutrnBlock;
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
