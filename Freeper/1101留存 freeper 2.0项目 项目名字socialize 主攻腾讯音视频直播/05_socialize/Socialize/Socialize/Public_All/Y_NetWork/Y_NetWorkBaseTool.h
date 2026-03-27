//
//  Y_NetWorkBaseTool.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@interface Y_NetWorkBaseTool : AFHTTPSessionManager
+ (Y_NetWorkBaseTool *)sharedTool;

- (void)YYrequestALLURLGetNotMainQueue:(NSString *)allUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestGetALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

#pragma mark - ALLURL post
- (void)YYrequestALLURLPostNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL post body
// ALLURL body传值型
- (void)YrequestPostALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL image

- (void)YrequestImgFileArrNotOtherInfoWithALLURL:(NSString *)url imgFileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
- (void)YrequestImgFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
- (void)YrequestPUTALLURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
@end

NS_ASSUME_NONNULL_END
