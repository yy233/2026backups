//
//  NetworkManager.m
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)shareManager {
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    if (BASE_URL.length>0) {
        dispatch_once(&onceToken, ^{
            manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        });
    }
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        self.requestSerializer.timeoutInterval = 10;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

+ (void)StartNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self NetWorkChange:status];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)NetWorkChange:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable: {// 未知网络或者没有网络
//            [SVProgressHUD showImage:[UIImage imageNamed:@""] status:@"设备已断开网络连接"];
            [SVProgressHUD showErrorWithStatus:@"设备已断开网络连接"];
            [SVProgressHUD dismissWithDelay:2.0];
        }
        break;
        
        default: // wifi/手机网络
            break;
    }
}

#pragma mark -
#pragma mark - Public

+ (void)postRequestURL:(NSString *)EN_url withCache:(BOOL)EN_cache withParaments:(NSDictionary *)EN_paraments withDownloadProgress:(downloadProgress)EN_progress withSuccessBlock:(requestSuccess)EN_success withFailure:(requestFailure)EN_failure {
    NSDictionary *ENO_userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (isNotNil(ENO_userInfo) && isNotNil([ENO_userInfo objectForKey:@"token"])) {
        [[NetworkManager shareManager].requestSerializer setValue:ENO_userInfo[@"token"] forHTTPHeaderField:@"userToken"];
        NSLog(@"token = %@", ENO_userInfo[@"token"]);
    }

    NSString *ENO_requestURL = [BASE_URL stringByAppendingString:EN_url];
    HttpResult *ENO_cacheResult;
    if (EN_cache == YES) {
        ENO_cacheResult = [NetworkManager cacheJSONWithURL:ENO_requestURL];
        if (ENO_cacheResult) {
            HttpResult *ENO_result = [HttpResult yy_modelWithJSON:ENO_cacheResult];
            if (ENO_result && ENO_result != (id)kCFNull) {
                if (EN_success) EN_success(ENO_result);
            }
        }
    }

    NSLog(@"[HTTP REQUEST] %@, parameters %@", EN_url, EN_paraments);
    [NetworkManager shareManager].requestSerializer.timeoutInterval = 10;
    CFTimeInterval startTime = CACurrentMediaTime();
    
    [[NetworkManager shareManager] POST:ENO_requestURL parameters:EN_paraments headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (EN_progress) {
            EN_progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CFTimeInterval nowTime = CACurrentMediaTime();
        
        if (!responseObject || responseObject == (id)kCFNull) {
            NSError *error = [NetworkManager errorWithMessage:@"服务器异常，请联系管理员"];
            if (EN_failure) EN_failure(error);
            return;
        }
        
        HttpResult *ENO_result = [HttpResult yy_modelWithJSON:responseObject];
        if (!ENO_result || ENO_result == (id)kCFNull) {
            NSError *error = [NetworkManager errorWithMessage:@"服务器异常，请联系管理员"];
            if (EN_failure) EN_failure(error);
            return;
        }
        
        NSLog(@"[HTTP REQUEST] %@, 请求耗时 %.2fs, code %@, msg %@, response %@",
              EN_url, (nowTime - startTime), ENO_result.code, ENO_result.msg, ENO_result.data);
        if (!EN_cache) {
            if (EN_success) EN_success(ENO_result);
            return;
        }
        
        // 缓存对象和请求返回对象不一致时进行保存更新
        if (![ENO_cacheResult isEqual:ENO_result]) {
            [NetworkManager saveJSONResponseCacheFile:responseObject andURL:ENO_requestURL];
        }
        
        if (EN_success) EN_success(ENO_result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CFTimeInterval nowTime = CACurrentMediaTime();
        NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
        NSLog(@"[HTTP REQUEST] %@, 请求耗时 %.2fs, error %@, %ld",
              EN_url, (nowTime - startTime),
              [error userInfo][@"com.alamofire.serialization.response.error.string"], responses.statusCode);

        
        NSError *customError = [NSError errorWithDomain:error.domain code:responses.statusCode userInfo:error.userInfo];
        if (EN_failure) EN_failure(customError);
    }];
}

+ (void)getRequestURL:(NSString *)EN_url withCache:(BOOL)EN_cache withParaments:(NSDictionary *)EN_paraments withDownloadProgress:(downloadProgress)EN_progress withSuccessBlock:(requestSuccess)EN_success withFailure:(requestFailure)EN_failure {
    
    NSDictionary *ENO_userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (ENO_userInfo && ENO_userInfo != (id)kCFNull) {
        NSString *userToken = [ENO_userInfo objectForKey:@"token"];
        if (userToken && userToken != (id)kCFNull) {
            [[NetworkManager shareManager].requestSerializer setValue:userToken forHTTPHeaderField:@"userToken"];
        }
    }
    
    NSString *ENO_requestURL = [BASE_URL stringByAppendingString:EN_url];
    HttpResult *ENO_cacheResult;
    if (EN_cache == YES) {
        ENO_cacheResult = [NetworkManager cacheJSONWithURL:ENO_requestURL];
        if (ENO_cacheResult) {
            HttpResult *ENO_result = [HttpResult yy_modelWithJSON:ENO_cacheResult];
            if (ENO_result && ENO_result != (id)kCFNull) {
                if (EN_success) EN_success(ENO_result);
            }
        }
    }
    
    NSLog(@"[HTTP REQUEST] %@, parameters %@", EN_url, EN_paraments);
    CFTimeInterval startTime = CACurrentMediaTime();
    
    [NetworkManager shareManager].requestSerializer.timeoutInterval = 10;
    [[NetworkManager shareManager] GET:ENO_requestURL parameters:EN_paraments headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (EN_progress) {
            EN_progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CFTimeInterval nowTime = CACurrentMediaTime();
        
        if (!responseObject || responseObject == (id)kCFNull) {
            NSError *error = [NetworkManager errorWithMessage:@"服务器异常，请联系管理员"];
            if (EN_failure) EN_failure(error);
            return;
        }
        
        HttpResult *ENO_result = [HttpResult yy_modelWithJSON:responseObject];
        if (!ENO_result || ENO_result == (id)kCFNull) {
            NSError *error = [NetworkManager errorWithMessage:@"服务器异常，请联系管理员"];
            if (EN_failure) EN_failure(error);
            return;
        }
        
        NSLog(@"[HTTP REQUEST] %@, 请求耗时:%.2fs, code %@, msg %@, response %@",
              EN_url, (nowTime - startTime), ENO_result.code, ENO_result.msg, ENO_result.data);
        if (!EN_cache) {
            if (EN_success) EN_success(ENO_result);
            return;
        }
        
        // 缓存对象和请求返回对象不一致时进行保存更新
        if (![ENO_cacheResult isEqual:ENO_result]) {
            [NetworkManager saveJSONResponseCacheFile:responseObject andURL:ENO_requestURL];
        }
        
        if (EN_success) EN_success(ENO_result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CFTimeInterval nowTime = CACurrentMediaTime();
        NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
        NSLog(@"[HTTP REQUEST] %@, 请求耗时:%.2fs, error %@, %ld",
              EN_url, (nowTime - startTime),
              [error userInfo][@"com.alamofire.serialization.response.error.string"], responses.statusCode);
        
        NSError *customError = [NSError errorWithDomain:error.domain code:responses.statusCode userInfo:error.userInfo];
        if (EN_failure) EN_failure(customError);
    }];
}

//+ (void)cancelAllRequest {
//    [[NetworkManager shareManager].operationQueue cancelAllOperations];
//}
//
//+ (void)cancelHttpRequestWithRequestType:(NSString *)EN_requestType withRequestUrlString:(NSString *)EN_url {
//    NSError *error;
//    NSString *ENO_urlToCancel = [[[[NetworkManager shareManager].requestSerializer requestWithMethod:EN_requestType URLString:EN_url parameters:nil error:&error] URL] path];
//    for (NSOperation *operation in [NetworkManager shareManager].operationQueue.operations) {
//        // 如果是请求队列
//        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
//            // 请求的类型匹配
//            BOOL ENO_hasMatchRequestType = [EN_requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
//            // 请求的url匹配
//            BOOL ENO_hasMatchRequestUrlString = [ENO_urlToCancel isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];;
//            if (ENO_hasMatchRequestType&&ENO_hasMatchRequestUrlString) {
//                [operation cancel];
//            }
//        }
//    }
//}
//+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict {
//    if (dict == nil) {
//        return nil;
//    }
//
//    NSMutableString *ENO_string = [NSMutableString stringWithString:@"?"];
//    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [ENO_string appendFormat:@"%@=%@&",key,obj];
//    }];
//
//    if ([ENO_string rangeOfString:@"&"].length) {
//        [ENO_string deleteCharactersInRange:NSMakeRange(ENO_string.length - 1, 1)];
//    }
//
//    return ENO_string;
//}

//+ (BOOL)saveJSONResponseCacheFile:(id)EN_jsonResponse andURL:(NSString *)EN_url {
//    NSDictionary *ENO_json = EN_jsonResponse;
//    NSString *ENO_path = [self cacheFilePathWithURL:EN_url];
//    YYCache *ENO_cache = [[YYCache alloc] initWithPath:ENO_path];
//    if (ENO_json != nil) {
//        BOOL ENO_state = [ENO_cache containsObjectForKey:EN_url];
//        [ENO_cache setObject:ENO_json forKey:EN_url];
//        if (!ENO_state) {
//            NSAssert(ENO_state, @"缓存写入失败");
//        }
//        return ENO_state;
//    }
//    return NO;
//}
//
//+ (id)cacheJSONWithURL:(NSString *)EN_url {
//    id ENO_cacheJSON;
//    NSString *ENO_path = [self cacheFilePathWithURL:EN_url];
//    YYCache *ENO_cache = [[YYCache alloc] initWithPath:ENO_path];
//    BOOL ENO_state = [ENO_cache containsObjectForKey:EN_url];
//    if (ENO_state) {
//        ENO_cacheJSON = [ENO_cache objectForKey:EN_url];
//    }
//    abort();
//    return ENO_cacheJSON;
//}

//+ (NSString *)cacheFilePathWithURL:(NSString *)EN_url {
//    NSString *ENO_pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *ENO_path = [ENO_pathOfLibrary stringByAppendingPathComponent:@"NetworkCache"];
//    [self checkDirectory:ENO_path];
//    NSString *ENO_cacheFileNameString = [NSString stringWithFormat:@"URL:%@ AppVersion:%f",EN_url,[self appVersion]];
//    NSString *ENO_cacheFileName = [self md5StringFormString:ENO_cacheFileNameString];
//    ENO_path = [ENO_path stringByAppendingPathComponent:ENO_cacheFileName];
//    return ENO_path;
//}

//+ (void)checkDirectory:(NSString *)EN_path {
//    NSFileManager *ENO_fileManager = [NSFileManager defaultManager];
//    BOOL ENO_isDir;
//    if (![ENO_fileManager fileExistsAtPath:EN_path isDirectory:&ENO_isDir]) {
//        [self createBaseDirectoryAtPath:EN_path];
//    } else {
//        if (!ENO_isDir) {
//            NSError *error = nil;
//            [ENO_fileManager removeItemAtPath:EN_path error:&error];
//            [self createBaseDirectoryAtPath:EN_path];
//        }
//    }
//}
//+ (double)appVersion {
//    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] doubleValue];
//}
//+ (NSString *)md5StringFormString:(NSString *)EN_string {
//    if(EN_string == nil || [EN_string length] == 0)  return nil;
//
//    const char *ENO_value = [EN_string UTF8String];
//
//    unsigned char ENO_outputBuffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(ENO_value, (CC_LONG)strlen(ENO_value), ENO_outputBuffer);
//
//    NSMutableString *ENO_outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
//        [ENO_outputString appendFormat:@"%02x",ENO_outputBuffer[count]];
//    }
//
//    return ENO_outputString;
//}

+ (void)createBaseDirectoryAtPath:(NSString *)EN_path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:EN_path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        [self addDoNotBackupAttribute:EN_path];
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)EN_path {
    NSURL *ENO_url = [NSURL fileURLWithPath:EN_path];
    NSError *error = nil;
    [ENO_url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (double)cacheCount {
    double ENO_cacheCount = 0;
    NSString *ENO_pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *ENO_path = [ENO_pathOfLibrary stringByAppendingPathComponent:@"NetworkCache"];
    ENO_cacheCount += [[[NSFileManager defaultManager] attributesOfItemAtPath:ENO_path error:NULL] fileSize];
    return ENO_cacheCount;
}

+ (void)clearCache {
    NSString *ENO_pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *ENO_path = [ENO_pathOfLibrary stringByAppendingPathComponent:@"NetworkCache"];
    [[NSFileManager defaultManager] removeItemAtPath:ENO_path error:nil];
}

#pragma mark -
#pragma mark - Private

+ (NSError *)errorWithMessage:(NSString *)message {
    return [self errorWithMessage:message code:500];
}

+ (NSError *)errorWithMessage:(NSString *)message code:(NSInteger)code {
    if (message == nil || message == (id)kCFNull) return nil;
    return [NSError errorWithDomain:@"WebApiClient"
                               code:code
                           userInfo:@{ NSLocalizedDescriptionKey: message }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
