//
//  Y_NetWorkBaseTool.m
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import "Y_NetWorkBaseTool.h"
#import "ConnectUrl.h"
#import "YTimeStamp.h"
#import "NSString+ArvinCategory.h"
#import "ZYImageCompressTool.h"
#define DELETE_Method @"DELETE"
#define POST_Method   @"POST"
#define GET_Method    @"GET"
#define PUT_Method    @"PUT"

 

@interface Y_NetWorkBaseTool ()
@property (nonatomic,strong) NSMutableDictionary *headerInfoDic;
@property (nonatomic,strong) NSMutableDictionary *datas;
@end



static Y_NetWorkBaseTool *netWorkTools = nil;

@implementation Y_NetWorkBaseTool
- (NSMutableDictionary *)headerInfoDic{
    if(!_headerInfoDic){
        _headerInfoDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _headerInfoDic;
}
- (NSMutableDictionary *)datas{
    if(!_datas){
        _datas = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _datas;
}
#pragma mark === === === === === === === === === === === === === === === ===

+ (Y_NetWorkBaseTool *)sharedTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        netWorkTools = [[self alloc]initWithBaseURL:nil];
        netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
        netWorkTools.requestSerializer.timeoutInterval = 20;
        netWorkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",@"image/jpeg", @"image/png", @"application/problem+json", @"application/x-www-form-urlencoded",nil];
        //netWorkTools.requestSerializer = [AFHTTPRequestSerializer serializer];
        netWorkTools.requestSerializer = [AFJSONRequestSerializer serializer];
        
    });
    
    return netWorkTools;
    
}

#pragma mark === === === === === === === === === === === === === === === ===


- (NSString *)addTokenWithAllLongUrl:(NSString *)allLongUrl{
    
    NSString *strToken = @"";

    if([ShareUserInfo share].userInfo.token != nil){
        strToken = [ShareUserInfo share].userInfo.token;
        [netWorkTools.requestSerializer setValue: [ShareUserInfo share].userInfo.token forHTTPHeaderField:@"token"];

    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
        strToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    }
    NSLog(@"HTTPRequestHeaders ======= dic= %@ ",netWorkTools.requestSerializer.HTTPRequestHeaders)
    [self netWorkWithHeaderInfoDic];
    return strToken;
}

#pragma mark === === === === === === ===
 
- (NSDictionary *)netWorkWithHeaderInfoDic{
    //    NSDictionary *headerDic = self.headerInfoDic;
    
    
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *mac = deviceID;//@"0xxx";
    NSString *timestamp = [YTimeStamp getNowTimeTimestamp_haoMiao];
    
//    [YTimeStamp getNowTimeTimestamp_miao];
//    [YTimeStamp getNowTimeTimestamp_miao_ShiQu];
//    [YTimeStamp getCurrentTimeStr_nianToMiao];
    
    NSString *token = [ShareUserInfo share].userInfo.token.length > 0 ? [ShareUserInfo share].userInfo.token : @"";
    NSString *acceptLanguage = [ShareLocale shared].nowLocaleTypeStr.length>0 ? [ShareLocale shared].nowLocaleTypeStr : @"";
    
    NSDictionary *headerDic  = @{
        @"mac":mac,
        @"timestamp":timestamp,
        @"token":token,
        @"Accept-language":acceptLanguage,
        @"accept-language":acceptLanguage,
        @"language":acceptLanguage,
        @"Language":acceptLanguage,
     };
    
    DLog(@"将要使用的 netWorkWithHeaderInfoDic --headerDic= %@",headerDic);
    
    //token
    NSString *now_token = [netWorkTools.requestSerializer valueForHTTPHeaderField:@"token"];
    if(isNil(now_token) || (![now_token isEqualToString:token])){//空 或 不一样
        [netWorkTools.requestSerializer setValue:token   forHTTPHeaderField:@"token"];
    }
    //mac
    NSString *now_mac = [netWorkTools.requestSerializer valueForHTTPHeaderField:@"mac"];
    if(isNil(now_mac) || (![now_mac isEqualToString:mac])){//空 或 不一样
        [netWorkTools.requestSerializer setValue:mac   forHTTPHeaderField:@"mac"];
    }
    //timeI
    NSString *now_timestamp = [netWorkTools.requestSerializer valueForHTTPHeaderField:@"timestamp"]; //空 或 不一样
    if(isNil(now_timestamp) || (![now_timestamp isEqualToString:timestamp])){
    }
    [netWorkTools.requestSerializer setValue:timestamp   forHTTPHeaderField:@"timestamp"];
    //langu
    NSString *now_language = [netWorkTools.requestSerializer valueForHTTPHeaderField:@"accept-language"];
    if(isNil(now_language) || (![now_language isEqualToString:acceptLanguage])){//空 或 不一样
        [netWorkTools.requestSerializer setValue:acceptLanguage   forHTTPHeaderField:@"accept-language"];
    }

    NSLog(@"总header -----  HTTPRequestHeaders ====netWorkWithHeaderInfoDic=== dic= %@ ",netWorkTools.requestSerializer.HTTPRequestHeaders)

    
    return headerDic;
}

#pragma mark === === === === === === === === === === === === === === === === ===


- (void)changeSuccessResInfowithsuccessTypefinished:(void (^)(id responsObject,NSError *error))finished
                                  andsuccessTypeRep:(id  _Nullable )responseObject
{
    
    
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSLog(@"[responseObject isKindOfClass:[NSDictionary class]] yes 处理判断");
        NSString *resJSonStr = [[Y_ToolOfOthers jsonStrWithDic:responseObject] changeFailSourceUrlOfImgUrl];
        NSLog(@"resJSonStr = %@",resJSonStr);
        NSDictionary *resDic = [Y_ToolOfOthers dictionaryWithJsonString:resJSonStr];
        finished(resDic,nil);
        
    }else if ([responseObject isKindOfClass:[NSArray class]]){
        NSString *resJSonStr = [[Y_ToolOfOthers jsonWithArr:responseObject] changeFailSourceUrlOfImgUrl];
        finished([Y_ToolOfOthers arrWithJson:resJSonStr],nil);
        
    }else if ([responseObject isKindOfClass:[NSString class]]){
        NSString *resJSonStr = [responseObject changeFailSourceUrlOfImgUrl];
        finished(resJSonStr,nil);
    }else{
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    }
    
}
#pragma mark === === === === === === === === === === === === === === === === ===
#pragma mark --      -- get not main  __allurl
- (void)YYrequestALLURLGetNotMainQueue:(NSString *)allUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = allUrl;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n---YYrequestALLURLGetNotMainQueue-----get not main------\n GET__ \n params=%@___ allurl= %@ \n--------------\n",params, allUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:allUrl parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"_YYrequestALLURLGetNotMainQueue__\n allurl =%@____%@",allUrl,[[responseObject description]kdtk_stringByReplaceingUnicode]);
                
                [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"__YYrequestALLURLGetNotMainQueue__\n allurl =%@___%@",allUrl,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}

#pragma mark -- ALLURL get
-(void)YrequestGetALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n-----YrequestGetALLURL---------\n GET__ \n params=%@___url=%@\n--------------\n",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self GET:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"__YrequestGetALLURL_\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
                
                [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___YrequestGetALLURL_\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                
                finished(nil,error);
            });
        }];
    });
}

#pragma mark -- ALLURL post*******🧡
- (void)YYrequestALLURLPostNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n----YYrequestALLURLPostNotMainQueue----------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"__YYrequestALLURLPostNotMainQueue _\n url=%@____ %@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            
            [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"__YYrequestALLURLPostNotMainQueue __\n url=%@___error.code =%ld error.des%@",url,error.code, [[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}

#pragma mark -- ALLURL post  把parms 拼接成url里带着传
- (void)YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSString *allParmsUrl = [ConnectUrl connectUrl:params url:url];
    NSLog(@"\n--YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:allParmsUrl parameters:@{} headers: netWorkTools.requestSerializer.HTTPRequestHeaders  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"_YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue__\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"___YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue_\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}

#pragma mark - ALLURL post body
// ALLURL body传值型
- (void)YrequestPostALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    NSString *saveThisTokenStr = [self addTokenWithAllLongUrl:allLongUrlStr];
    //____________
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:url parameters:nil error:nil];
    request.timeoutInterval = 20;
    // 设置header
//    [request setValue:[ShareUserInfo share].userInfo.token  forHTTPHeaderField:@"token"];//ALLURl
    [request setValue:saveThisTokenStr  forHTTPHeaderField:@"token"];//ALLURl
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // body
    NSError* error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
    if ([bodyData length] > 0 && error == nil){
        [request setHTTPBody:bodyData];
    }else{
        NSLog(@"YrequestPostALLURLNoMainQueueWithBodyNotParms dataJson nil");
        finished(nil,error);
        return;
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"YrequestPostALLURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"YrequestPostALLURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"YrequestPostALLURLNoMainQueueWithBodyNotParms Reply JSON: %@ %@", [[responseObject description]kdtk_stringByReplaceingUnicode], url);
            [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
            [self.datas removeObjectForKey:url];
        }else{
            NSLog(@"YrequestPostALLURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, [[responseObject description] kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            [self.datas removeObjectForKey:url];
        }
    }];
    [self.datas setValue:dataTask forKey:url];
    [dataTask resume];
}

#pragma mark - ALLURL delete
- (void)YrequestDeleteALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    [self DELETE:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"_YrequestDeleteALLURL__\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"__YrequestDeleteALLURL__\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        });
    }];
}

#pragma mark - ALLURL delete body
// body传值型 delete ALLURL
- (void)YrequestDeleteALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    NSString *saveThisTokenStr = [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:DELETE_Method URLString:url parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        
        [request setValue:saveThisTokenStr  forHTTPHeaderField:@"token"];//ALLURl
//        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // body
        NSError* error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
        if ([bodyData length] > 0 && error == nil){
            [request setHTTPBody:bodyData];
        }else{
            NSLog(@"1DeletURLNoMainQueue dataJson nil");
            finished(nil,error);
            return;
        }
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"YrequestDeleteALLURLNoMainQueueWithBodyNotParms   uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"YrequestDeleteALLURLNoMainQueueWithBodyNotParms  downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YrequestDeleteALLURLNoMainQueueWithBodyNotParms Reply JSON: %@ %@", responseObject, url);
                [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
            }else{
                NSLog(@"YrequestDeleteALLURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                finished(nil,error);
            }
        }];
        [dataTask resume];
    });
}

#pragma mark - ALLURL PUT
- (void)YrequestPUTALLURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    [self PUT:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
        NSLog(@"YrequestPUTALLURLNoMainQueue_s___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
        NSLog(@"YrequestPUTALLURLNoMainQueue_f____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
    }];
}

#pragma mark - ALLURL put body
- (void)YrequestPUTALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished {
    NSString *allLongUrlStr = url;
    NSString *saveThisTokenStr = [self addTokenWithAllLongUrl:allLongUrlStr];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:PUT_Method URLString:url parameters:nil error:nil];
    request.timeoutInterval = 20;
    // 设置header
//    [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
    [request setValue:saveThisTokenStr  forHTTPHeaderField:@"token"];//ALLURl
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // body
    NSError* error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
    if ([bodyData length] > 0 && error == nil){
        [request setHTTPBody:bodyData];
    }else{
        NSLog(@"1DeletURLNoMainQueue dataJson nil");
        finished(nil,error);
        return;
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"YrequestPUTALLURLNoMainQueueWithBodyNotParms 1DeletURLNoMainQueueWithBodyN uploadProgress: %@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"YrequestPUTALLURLNoMainQueueWithBodyNotParms 1DeletURLNoMainQueueWithBodyN downloadProgress: %@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"1DeletURLNoMainQueueWithBodyN Reply JSON: %@ %@", responseObject, url);
            [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];// finished(responseObject,nil);
        }else{
            NSLog(@"1DeletURLNoMainQueueWithBodyN Error: %@, %@, %@", error, response, responseObject);
            finished(nil,error);
        }
    }];
    [dataTask resume];
}

#pragma mark - ALLURL image

- (void)YrequestImgFileArrNotOtherInfoWithALLURL:(NSString *)url imgFileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"YrequestImgFileArrWithALLURL urlstr = %@", url);
    __block NSString * nameBBBB  = name;
    
    [self POST:url parameters:@{} headers: netWorkTools.requestSerializer.HTTPRequestHeaders  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *photo in fileImgArr) {
            NSData *data = [ZYImageCompressTool imageCompress:photo];
            [formData appendPartWithFileData:data name:@"file" fileName:nameBBBB mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}


- (void)YrequestImgFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"YrequestImgFileArrWithALLURL urlstr = %@", url);
    __block NSString * nameBBBB  = name;
    [self POST:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *photo in fileImgArr) {
            NSData *data = [ZYImageCompressTool imageCompress:photo];
//            [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
            [formData appendPartWithFileData:data name:@"file" fileName:nameBBBB mimeType:@"image/png"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}

#pragma mark - ALLURL images Market
- (void)YrequestMarketImgFilesArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"YrequestMarketImgFilesArrWithALLURL urlstr = %@", url);
    [self POST:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *photo in fileImgArr) {
            NSData *data = [ZYImageCompressTool imageCompress:photo];
            [formData appendPartWithFileData:data name:@"images" fileName:@"image.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}

#pragma mark - ALLURL 语音
- (void)YrequestVoiceFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params filePathStr:(NSString *)filePathStr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished {
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"YrequestVoiceFileArrWithALLURL urlstr = %@", url);
    [self POST:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:filePathStr];
        if (isNotNil(data)) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"amr/caf/wmr"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}

#pragma mark - ALLURL video
- (void)YrequestVideoFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params filePath:(NSURL *)filePath finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"YrequestVideoFileArrWithALLURL urlstr = %@", url);
    [self POST:url parameters:params headers: netWorkTools.requestSerializer.HTTPRequestHeaders  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.mp4" mimeType:@"video/quicktime"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        [self changeSuccessResInfowithsuccessTypefinished:finished andsuccessTypeRep:responseObject];//  finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}


//全URL 不加base 下载文件并保存
- (void)YrequestDownloadFilePostURLNotMainQueueWithAll:(NSString *)allUrl withSavePathUrl:(NSURL *)savePathUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{

    // 创建request对象
      NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:allUrl]];
      // 使用URLSession来进行网络请求
      // 创建会话配置对象
      NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
      // 创建会话对象
      NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
      // 创建会话任务对象
      NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (data) {

               // 下载完成，保存到本地
               NSString *savestr = savePathUrl.absoluteString;
               NSLog(@" YrequestDownloadFilePostURLNotMainQueueWithAll 下载完成，保存到本地%@",savestr);
               [data writeToFile:savestr atomically:YES];
               finished(@"success",nil);
           }
           if (error) {
               finished(nil,error);
           }
       }];

      // 创建的task都是挂起状态，需要resume才能执行
      [task resume];
}
@end
