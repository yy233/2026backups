//
//  DataRequestTools.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "DataRequestTools.h"

@implementation DataRequestTools
+ (void)codeRequestWithParmeters:(NSDictionary *)parameters succ:(requestSuccess)succ fail:(requestFailure)fail;
{
    NSString *url = URL_USER_SEND_CODE;
    [NetworkManager getRequestURL:url withCache:NO withParaments:parameters withDownloadProgress:^(float progress) {
    } withSuccessBlock:^(HttpResult * _Nullable result) {
        if (succ) succ(result);
    } withFailure:^(NSError * _Nullable error) {
        if (fail) fail(error);
    }];
}
+ (void)registWithParmeters:(NSDictionary *)parameters succ:(requestSuccess)succ fail:(requestFailure)fail;
{
    NSString *url = URL_USER_SEND_CODE;
    [NetworkManager postRequestURL:url withCache:NO withParaments:parameters withDownloadProgress:^(float progress) {
    } withSuccessBlock:^(HttpResult * _Nullable result) {
        if (succ) succ(result);
    } withFailure:^(NSError * _Nullable error) {
        if (fail) fail(error);
    }];
}
@end
