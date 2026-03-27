//
//  ZYLifeCostData.m
//  Community
//
//  Created by ZY on 2022/1/10.
//

#import "ZYLifeCostData.h"
#import "ZYLifeCostHouseholdModel.h"

@implementation ZYLifeCostData

#pragma mark - 户号管理
// 户号列表
+ (void)lifeCostHouseholdListWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostHouseholdListUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 新增分组
+ (void)lifeCostAddGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostAddGroupUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 修改分组
+ (void)lifeCostUpdateGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostUpdateGroupUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除分组
+ (void)lifeCostDeleteGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostDeleteGroupUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 绑定户号
+ (void)lifeCostAddHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostAddHouseholdUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 修改户号
+ (void)lifeCostModifyHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostModifyHouseholdUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 删除户号
+ (void)lifeCostDeleteHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block {
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostDeleteHouseholdUrl] withBody:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(responsObject, YES);
            }else {
                block(@{}, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            block(@{}, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
