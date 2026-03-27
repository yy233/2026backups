//
//  ZYSmallShopGoodsData.m
//  Community
//
//  Created by ZY on 2022/4/21.
//

#import "ZYSmallShopGoodsData.h"

@implementation ZYSmallShopGoodsData

+ (void)isSmallShopGoodsOpen:(ZYCompletionBlock)completionBlock {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopIsOpenUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (Y_IS_Success) {
                NSArray *array = responsObject[@"data"];
                if (array.count > 0) {
                    [userDefaults setValue:@"1" forKey:@"isSmallShopGoodsOpen"];
                    completionBlock(responsObject, YES);
                }else {
                    [userDefaults setValue:@"0" forKey:@"isSmallShopGoodsOpen"];
                    completionBlock(responsObject, NO);
                }
            }else {
                [userDefaults setValue:@"0" forKey:@"isSmallShopGoodsOpen"];
                completionBlock(responsObject, NO);
            }
        });
    }];
}

@end
