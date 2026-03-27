//
//  VersionInfoTool.m
//  Community
//
//  Created by 余莹 on 2021/5/26.
//

#import "VersionInfoTool.h"

@implementation VersionInfoTool
singleton_implementation(share)

- (void)showViewBoolBlock:( ShowViewBoolBlock )showBlock{
    // 获取本地版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; //info.plist里的 version
        
        // 取得AppStore信息
        NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@", @"1559148512"];

//    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
//            
//        if (isNotNil(responsObject)) {
//            // 拿上面的URL走get请求，下面是简单的数据处理
//            NSArray *resultArr = responsObject[@"results"];
//            NSDictionary *resultsDict = resultArr.firstObject;
//                
//            // app store 最新版本号
//            if (isNil(resultsDict)) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    showBlock(NO);
//                });
//                return;
//            }else{
//                NSString *AppStoreVersion = resultsDict[@"version"];
//                    
//                // AppStore版本号大于当前版本号
//                if ([AppStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
//                        // 已上线 手机不是最新版
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        showBlock(YES);
//                    });
//                 }else if ([AppStoreVersion compare:currentVersion options:NSNumericSearch] == NSOrderedAscending) {
//                        //该版本 还未上线
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         showBlock(NO);
//                     });
//                 } else {
//                     // 已上线 手机是最新版
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         showBlock(YES);
//                     });
//                       
//                 }
//            }
//            
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                showBlock(NO);
//            });
//        }
//  
//       
//    }];
}
@end
