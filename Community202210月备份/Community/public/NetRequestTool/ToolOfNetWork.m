//
//  ToolOfNetWork.m
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "ToolOfNetWork.h"
#import "ConnectUrl.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatManagerData.h"
#import "ChatSeverConnectionBegin.h"
#define kMobile              @"mobile"
//#define kMobile              [JGSaveIdShare sharedUserInfo].registrationID


@interface ToolOfNetWork ()
@property (nonatomic,strong) NSMutableDictionary *datas;
@end


static ToolOfNetWork * netWorkTools = nil;
#define DELETE_Method @"DELETE"
#define POST_Method @"POST"
#define GET_Method @"GET"
#define PUT_Method @"PUT"

typedef enum : NSUInteger {
    URL_Module_Type_Define,
    URL_Module_Type_Community,
    URL_Module_Type_Chat,
//    URL_Module_Type_BlueTouth,
    URL_Module_Type_Pension,
    URL_Module_Type_PensionBlueTouchDev,
} URL_Module_Type;

@implementation ToolOfNetWork



+ (ToolOfNetWork *)sharedTools {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkTools = [[self alloc] initWithBaseURL:nil];
        netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
        netWorkTools.requestSerializer.timeoutInterval = 20;
        netWorkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",@"image/jpeg", @"image/png", @"application/problem+json", @"application/x-www-form-urlencoded",nil];
        //        netWorkTools.requestSerializer = [AFHTTPRequestSerializer serializer];
        netWorkTools.requestSerializer = [AFJSONRequestSerializer serializer];
        
    });
    return netWorkTools;
}
#pragma mark ===token
//- (void)addTokenWithURL_Module_Type:(URL_Module_Type)mtype{
    /**
     if([ShareUserInfo sharedUserInfo].token!=nil){
         [netWorkTools.requestSerializer setValue: [ShareUserInfo sharedUserInfo].token forHTTPHeaderField:@"token"];
     }
     if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
         [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
     }
         
     */
- (NSString *)addTokenWithAllLongUrl:(NSString *)allLongUrl{
    URL_Module_Type  mtype = URL_Module_Type_Define;
//    if ([allLongUrl containsString:BASE_TrusangBlueToothData_BaseUrl]) {
//        mtype = URL_Module_Type_BlueTouth;
//    }else
    if ([allLongUrl containsString:BASE_Chat_Default] || [allLongUrl containsString:BASE_Chat_NewUse_Change_BaseURL] ) {
        mtype = URL_Module_Type_Chat;
    }else  if ([allLongUrl containsString:BASE_URL]) {
        mtype = URL_Module_Type_Community;
    }
//    else if ([allLongUrl containsString:kPensionBaseUrl]) {
//        mtype = URL_Module_Type_Pension;
//    }
    else if ([allLongUrl containsString:BASE_TrusangBlueToothData_BaseUrl]) {
        mtype = URL_Module_Type_PensionBlueTouchDev;
    }
    else{
    }
    NSString *strToken = @"";

    if([ShareUserInfo sharedUserInfo].token!=nil){
        strToken = [ShareUserInfo sharedUserInfo].token;
        [netWorkTools.requestSerializer setValue: [ShareUserInfo sharedUserInfo].token forHTTPHeaderField:@"token"];
   
    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
        strToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    }
    /**
     switch (mtype) {
 //        case URL_Module_Type_BlueTouth:
 //        {
 //            strToken = @"50cd33fb-8d67-4403-a821-5ef629a0a70f";
 //            [netWorkTools.requestSerializer setValue:strToken  forHTTPHeaderField:@"token"];
 //        }
 //            break;
         case URL_Module_Type_Pension:
         {
  
             strToken = @"E_16afa74d-4a69-47c0-a9f0-459d415570f7";
             [netWorkTools.requestSerializer setValue:strToken  forHTTPHeaderField:@"token"];
         }
             break;
         case URL_Module_Type_PensionBlueTouchDev:
         {
            
             strToken = @"E_2ca1da47-e1d4-497d-a6c4-95b1946b004c"; //117839044238512128
             [netWorkTools.requestSerializer setValue:strToken  forHTTPHeaderField:@"token"];
         }
             break;
             
         default:
         {
             if([ShareUserInfo sharedUserInfo].token!=nil){
                 strToken = [ShareUserInfo sharedUserInfo].token;
                 [netWorkTools.requestSerializer setValue: [ShareUserInfo sharedUserInfo].token forHTTPHeaderField:@"token"];
            
             }
             if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
                 strToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                 [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
             }
           
         }
             break;
     }
     */
    NSLog(@"addTokenWithAllLongUrl  \n now token= %@",strToken);
    return strToken;
}
- (void)addAuthToken{
    //ShareUserInfo token //重置密码时 用token装了下authToken
    if([ShareUserInfo sharedUserInfo].token!=nil){
        [netWorkTools.requestSerializer setValue: [ShareUserInfo sharedUserInfo].token forHTTPHeaderField:@"authToken"];
    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
        [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"authToken"];
    }
}
- (void)addAuthTokenWithStr:(NSString *)authToken{
    if(authToken.length>0 ){
        [netWorkTools.requestSerializer setValue:authToken  forHTTPHeaderField:@"authToken"];
    }
}
 
#pragma mark -- post
- (void)YrequestPostURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    if ([url isEqualToString:URL_USER_RESET_PASSWORD]) {
        [self addAuthToken];//重置密码
    }else if([url isEqualToString:URL_USER_LOGIN]){
    }else{
        NSString *allLongUrlStr = Y_BASEURL(url);
        [self addTokenWithAllLongUrl:allLongUrlStr];
    }
    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:Y_BASEURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
    
}
#pragma mark -- post not main
- (void)YrequestPostURLNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    //____________originalTask
    NSURLSessionDataTask *originalTask = [self.datas objectForKey:url];
    if ([url containsString:@"const"] || [url containsString:@"banner"] || [url containsString:@"locate "]  || [url containsString:@"listRepairOrder"] || [url containsString:@"addTempCode"]) {//常量查询类型 banner 经纬度获取小区数据 报修报事
        originalTask = nil;
    }
    if (originalTask) {
        DLog(@"—————————————— 短时间重复的请求 url=%@ \n parms=%@",url,params);
        return;
    }else{
        DLog(@"—————————————— 普通的请求 url=%@ \n parms=%@",url,params);
    }
    [originalTask cancel];
    //____________originalTask

    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
       
        NSURLSessionDataTask *  dataTask =  [self POST:Y_BASEURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
                [self.datas removeObjectForKey:url];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
                [self.datas removeObjectForKey:url];
            });
        }];
        [self.datas setValue:dataTask forKey:url];
    });
}
#pragma mark -- post not main  把parms 拼接成url里带着传
- (void)YrequestPostURLStrWithAllURLNoParmsNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSString *allParmsUrl = [ConnectUrl connectUrl:params url:url];
    NSLog(@"\n--------------\n POST_\n params=RLStrWithAllURL空Parms==%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(allParmsUrl));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:Y_BASEURL(allParmsUrl) parameters:@{} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
//body传值型
- (void)YrequestPostAllLongURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //____________originalTask
        NSURLSessionDataTask *originalTask = [self.datas objectForKey:url];
        if ([url containsString:@"const"] || [url containsString:@"banner"] || [url containsString:@"locate "] || [url containsString:@"addTempCode"]) {// 量查询类型 banner 经纬度获取小区数据
            originalTask = nil;
        }
        if (originalTask) {
            DLog(@"—————————————— 短时间重复的请求 url=%@ \n body=%@",url,body);
            return;
        }else{
            DLog(@"—————————————— 普通的请求 url=%@ \n body=%@",url,body);
        }
        [originalTask cancel];
        //____________
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:allLongUrlStr parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // body
        NSError* error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
        if ([bodyData length] > 0 && error == nil){
            [request setHTTPBody:bodyData];
        }else{
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
            finished(nil,error);
            return;
        }
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: %@", [[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
                [self.datas removeObjectForKey:url];
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                finished(nil,error);
                [self.datas removeObjectForKey:url];
            }
        }];
        [self.datas setValue:dataTask forKey:url];
        [dataTask resume];
    });
        
}
//body传值型
- (void)YrequestPostURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //____________originalTask
        NSURLSessionDataTask *originalTask = [self.datas objectForKey:url];
        if ([url containsString:@"const"] || [url containsString:@"banner"] || [url containsString:@"locate "] || [url containsString:@"addTempCode"] ) {// 量查询类型 banner 经纬度获取小区数据
            originalTask = nil;
        }
        if (originalTask) {
            DLog(@"—————————————— 短时间重复的请求 url=%@ \n body=%@",url,body);
            return;
        }else{
            DLog(@"—————————————— 普通的请求 url=%@ \n body=%@",url,body);
        }
        [originalTask cancel];
        //____________
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:Y_BASEURL(url) parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // body
        NSError* error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
        if ([bodyData length] > 0 && error == nil){
            [request setHTTPBody:bodyData];
        }else{
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
            finished(nil,error);
            return;
        }
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms url=%@ Reply JSON: %@",allLongUrlStr, [[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
                [self.datas removeObjectForKey:url];
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms  url=%@ Error: %@, %@, %@",allLongUrlStr, error, response, responseObject);
                finished(nil,error);
                [self.datas removeObjectForKey:url];
            }
        }];
        [self.datas setValue:dataTask forKey:url];
        [dataTask resume];
    });
        
}
#pragma mark -- get
-(void)YrequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n GET__ \n params=%@___url=%@\n--------------\n",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self GET:Y_BASEURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                
                finished(nil,error);
            });
        }];
    });
}
#pragma mark -- get not main
-(void)YrequestGetURLNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n GET__ \n params=%@___url=%@\n--------------\n",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:Y_BASEURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
- (void)YrequestGetURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:GET_Method  URLString:Y_BASEURL(url) parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // body
        NSError* error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
        if ([bodyData length] > 0 && error == nil){
            [request setHTTPBody:bodyData];
        }else{
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
            finished(nil,error);
            return;
        }
        //
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: %@", responseObject);
                finished(responseObject,nil);
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                finished(nil,error);
            }
        }];
        [dataTask resume];
    });
        
}
#pragma mark === 图片
#pragma mark -- post send img
-(void)YrequestPostCarImageDataWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:Y_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (UIImage *photo in fileArr) {
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:@"carImage" fileName:@"carImage.png" mimeType:@"image/png"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
                
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
                
            });
            
        }];
    });
    
}
-(void)YrequestPostHouseRepairOneImageWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:Y_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            for (UIImage *photo in fileArr) {
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
            }

        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);

            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);

            });

        }];
    });
    
}

#pragma mark ==
- (void)YrequestPostImagesWithAllLongURL:(NSString *)url withParams:(NSMutableDictionary *)params fileImgData:(NSMutableArray *)fileArr fileNameStr:(NSString *)name imgNameAllStr:(NSString *)imgName  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr =  url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,allLongUrlStr);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:allLongUrlStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileArr) {
                if ([imgName containsString:@"store"]) {//仓储小店的订单投诉类型
                    NSData *data =  [ZYImageCompressTool  image200KBCompressWithImg:photo];
                    [formData appendPartWithFileData:data name:name fileName:imgName mimeType:@"image/png"];
                }else{
                    NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                    [formData appendPartWithFileData:data name:name fileName:imgName mimeType:@"image/png"];
                }
             
            }

        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);

            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);

            });

        }];
    });
    
}
#pragma mark ==
- (void)YrequestPostImagesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileImgData:(NSMutableArray *)fileArr fileNameStr:(NSString *)name imgNameAllStr:(NSString *)imgName  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:Y_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileArr) {
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:name fileName:imgName mimeType:@"image/png"];
            }

        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);

            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);

            });

        }];
    });
    
}
-(void)YrequestPostImageDataWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:Y_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (UIImage *photo in fileArr) {
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:@"carImage" fileName:@"carImage.png" mimeType:@"image/png"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
                
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
                
            });
            
        }];
    });
    
}
-(void)YrequestPostmageDataBodyTypeWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method URLString:Y_BASEURL(url) parameters:nil error:nil];
            request.timeoutInterval = 20;
            // 设置header
            [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            // body
            NSError* error = nil;
            NSData *bodyData = UIImageJPEGRepresentation(fileArr.firstObject, 0.2);
            if ([bodyData length] > 0 && error == nil){
                [request setHTTPBody:bodyData];
            }else{
                NSLog(@"  dataJson nil");
                finished(nil,error);
                return;
            }
            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@" WithBodyN uploadProgress: %@", uploadProgress);
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@" WithBodyN downloadProgress: %@", downloadProgress);
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@" thBodyN Reply JSON: %@", responseObject);
                    finished(responseObject,nil);
                }else{
                    NSLog(@" BodyN Error: %@, %@, %@", error, response, responseObject);
                    finished(nil,error);
                }
            }];
            [dataTask resume];
        });
 
    
}


#pragma mark == delet

- (void)YrequestDeletURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self DELETE:Y_BASEURL(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
- (void)YrequestDeletURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self DELETE:Y_BASEURL(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}
//body传值型
- (void)YrequestDeletURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//AFHTTPSessionManager
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:DELETE_Method URLString:Y_BASEURL(url) parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
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
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"1DeletURLNoMainQueueWithBodyN uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"1DeletURLNoMainQueueWithBodyN downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"1DeletURLNoMainQueueWithBodyN Reply JSON: %@", responseObject);
                finished(responseObject,nil);
            }else{
                NSLog(@"1DeletURLNoMainQueueWithBodyN Error: %@, %@, %@", error, response, responseObject);
                finished(nil,error);
            }
        }];
        [dataTask resume];
    });
        
}
#pragma mark == PUT
- (void)YrequestPutURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n PUT  _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self PUT:Y_BASEURL(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
- (void)YrequestPutURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    [self addAuthToken];
    NSLog(@"\n--------------\n PUT  _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self PUT:Y_BASEURL(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}
//给换手机号用的接口 非登录状态的时候用的
- (void)YrequestHaveAuthTokenWithPutURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params withAuthToken:(NSString *)authTokenStr finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    [self addAuthTokenWithStr:authTokenStr];
    NSLog(@"\n--------------\n PUT  _\n params=%@_\n url=%@ \n--------------\n ",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self PUT:Y_BASEURL(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",Y_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",Y_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}
//addAuthTokenWithStr

#pragma mark === 三方登录用的
-(void)YrequestThirdLoginURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSLog(@"YrequestThirdLoginURL__%@______%@",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finished(nil,error);
            });
        }];
    });
}




#pragma  mark =============    商城 另一个baseurl

- (void)YrequestGetURLNotMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n GET__ \n params=%@___url=%@\n--------------\n",params,URL_ALL_BuniessService(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:URL_ALL_BuniessService(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",URL_ALL_BuniessService(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",URL_ALL_BuniessService(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}

- (void)YrequestDeletURLNoMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self DELETE:URL_ALL_BuniessService(url) parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",URL_ALL_BuniessService(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",URL_ALL_BuniessService(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}
- (void)YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = Y_BASEURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,URL_ALL_BuniessService(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:URL_ALL_BuniessService(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url= %@ ____%@",URL_ALL_BuniessService(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url= %@ ___%@",URL_ALL_BuniessService(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}

#pragma  mark =============    聊天 另一个baseurl
- (void)addTokenWithChatType{
    /**
     暂时不使用 等确定了来
     if([ShareUserInfo sharedUserInfo].token!=nil){
         [netWorkTools.requestSerializer setValue: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token forHTTPHeaderField:@"token"];
     }
     if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"chatUseContactTheMerchantHeader_Token"])) {
         [netWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"chatUseContactTheMerchantHeader_Token"] forHTTPHeaderField:@"token"];
     }
     */
    
}
- (void)YrequestGetURLNotMainQueueWtihChatTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
//    [self addTokenWithChatType];
    NSLog(@"\n--------------\n GET__ \n params=%@___url=%@\n--------------\n",params,URL_ChatBaseURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:URL_ChatBaseURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",URL_ChatBaseURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",URL_ChatBaseURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
- (void)YrequestPostURLNotMainQueueWtihChatTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    [self addTokenWithChatType];
    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,URL_ChatBaseURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:URL_ChatBaseURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n url=%@____%@",URL_ChatBaseURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n url=%@___%@",URL_ChatBaseURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}
//body传值型
- (void)YrequestPostURLNoMainQueueWithBodyNotParmsWithChatTypeUrl:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
         NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:URL_ChatBaseURL(url) parameters:nil error:nil];
        request.timeoutInterval = 20;
        // 设置header
        [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // body
        NSError* error = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
        if ([bodyData length] > 0 && error == nil){
            [request setHTTPBody:bodyData];
        }else{
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
            finished(nil,error);
            return;
        }
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: %@", responseObject);
                finished(responseObject,nil);
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                finished(nil,error);
            }
        }];
        [dataTask resume];
    });
        
}
//#pragma mark == Chat总文件DataArr处理
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"file" error:nil];

//- (void)YrequestPostChatTypeSendFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileDataArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
//    [self addToken];
//    [params setValue:@"" forKey:@"description"];
//    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n fileDataArr=%@\n-------------\n ",params,URL_ChatBaseURL(url) ,fileDataArr);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//        [self POST:URL_ChatBaseURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            for (NSData *onefileData in fileDataArr) {
////                [formData appendPartWithFormData:onefileData name:name];
//                [formData appendPartWithFileData:onefileData name:name fileName:@"file.png" mimeType:@"image/png"];
//                //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"file" error:nil];
//            }
//
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"%@",uploadProgress);
//            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
//                finished(responseObject,nil);
//
//            });
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
//                finished(nil,error);
//
//            });
//
//        }];
//    });
//
//}
//#pragma mark == Chat总文件DataArr处理
//- (void)YrequestPostChatTypeSendFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileDataArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
//    [self addToken];
//    [params setValue:@"" forKey:@"description"];
//    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@  \n fileDataArr=%@\n--------------\n ",params,URL_ChatBaseURL(url),fileDataArr);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method URLString:URL_ChatBaseURL(url) parameters:params error:nil];
//            request.timeoutInterval = 20;
//            // 设置header
//            [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            request.allHTTPHeaderFields = @{@"Content-Type":[NSString stringWithFormat:@"multipart/form-data"]};
//            // body
//            NSError* error = nil;
//            for (NSData *bodyData in fileDataArr) {
//                if ([bodyData length] > 0 && error == nil){
//                    [request setHTTPBody:bodyData];
//                }else{
//                    NSLog(@"  dataJson nil");
//                    finished(nil,error);
//                    return;
//                }
//            }
//            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@" WithBodyN uploadProgress: %@", uploadProgress);
//            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//                NSLog(@" WithBodyN downloadProgress: %@", downloadProgress);
//            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    NSLog(@" thBodyN Reply JSON: %@", responseObject);
//                    finished(responseObject,nil);
//                }else{
//                    NSLog(@" BodyN Error: %@, %@, %@", error, response, responseObject);
//                    finished(nil,error);
//                }
//            }];
//            [dataTask resume];
//        });
//
//}
//#pragma mark == Chat总文件DataArr处理
//- (void)YrequestPostChatTypeSendFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileDataArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
//    [self addToken];
//    [params setValue:@"" forKey:@"description"];
//    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@  \n fileDataArr=%@\n--------------\n ",params,URL_ChatBaseURL(url),fileDataArr);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method URLString:URL_ChatBaseURL(url) parameters:params error:nil];
//            request.timeoutInterval = 20;
//            // 设置header
//            //
//            [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
//            [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            // body
//            NSError* error = nil;
//            for (NSData *bodyData in fileDataArr) {
//                if ([bodyData length] > 0 && error == nil){
//                    [request setHTTPBody:bodyData];
//                }else{
//                    NSLog(@"  dataJson nil");
//                    finished(nil,error);
//                    return;
//                }
//            }
//            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@" WithBodyN uploadProgress: %@", uploadProgress);
//            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//                NSLog(@" WithBodyN downloadProgress: %@", downloadProgress);
//            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    NSLog(@" thBodyN Reply JSON: %@", responseObject);
//                    finished(responseObject,nil);
//                }else{
//                    NSLog(@" BodyN Error: %@, %@, %@", error, response, responseObject);
//                    finished(nil,error);
//                }
//            }];
//            [dataTask resume];
//        });
//
//}
 
//- (void)YrequestPostChatTypeSendFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileDataArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
//    [self addToken];
//    [params setValue:@"" forKey:@"description"];
//    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,URL_ChatBaseURL(url));
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method URLString:URL_ChatBaseURL(url) parameters:params error:nil];
//            request.timeoutInterval = 20;
//            // 设置header
//            [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];
//            [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            // body
//            NSError* error = nil;
//            NSData *bodyData = UIImageJPEGRepresentation(fileDataArr.firstObject, 0.2);
//            if ([bodyData length] > 0 && error == nil){
//                [request setHTTPBody:bodyData];
//            }else{
//                NSLog(@"  dataJson nil");
//                finished(nil,error);
//                return;
//            }
//            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@" WithBodyN uploadProgress: %@", uploadProgress);
//            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//                NSLog(@" WithBodyN downloadProgress: %@", downloadProgress);
//            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                if (!error) {
//                    NSLog(@" thBodyN Reply JSON: %@", responseObject);
//                    finished(responseObject,nil);
//                }else{
//                    NSLog(@" BodyN Error: %@, %@, %@", error, response, responseObject);
//                    finished(nil,error);
//                }
//            }];
//            [dataTask resume];
//        });
//
//
//}

#pragma mark ==  文件上传 （2022 0622 新版） mp4在用
- (void)YrequestPostChatTypeSendFileWithOneDataPathFilesWithUpURL:(NSString *)url
                                                withFfileConfigId:(NSString *)fileConfigId
                                                         withNonce:(NSString *)nonce
                                                         withSign:(NSString *)sign
                                                        withParams:(NSMutableDictionary *)params
                                                         filePathStr:(NSString *)filePathStr
                                                       upfileNameStr:(NSString *)name
                                                            finished:(void (^)(id  responsObject,NSError *error))finished{
    
    [self addTokenWithChatType];
    //
    NSMutableDictionary *chatNewHeader = [[NSMutableDictionary alloc]init];
    [chatNewHeader setValue:nonce forKey:@"nonce"]; //请求随机数
    [chatNewHeader setValue:sign forKey:@"sign"];
    [chatNewHeader setValue:fileConfigId forKey:@"fileConfigId"];
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /** 文件哈希值要一样 在上一个处理data时加了optionsNSDataReadingUncached即可。 获取data 上传data时用一样的方式  md5后才是一样的 。（以下两种上传post都可以正常上传）
         
     
        [self POST:URL_ChatBaseURLNewBase8090(url) parameters:params headers:chatNewHeader constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSError *err = nil;
            NSData *data  = [NSData dataWithContentsOfURL:[UrlWithString getURLWithStr:filePathStr] options:NSDataReadingUncached error:&err];
            NSString *fileHashNow = [FileMd5Hash computeHashForData:data];//CC_MD5_DIGEST_LENGTH
            NSLog(@"语音 文件上传 当前哈希值=%@ parmaDic=%@",fileHashNow,params);
            if (err) {
                NSLog(@"语音 文件上传 聊天语音 error %@",err.description);//   NSFileReadNoSuchFileError = 260,//文件读取无此类文件错误
                
            }else{
                NSLog(@"语音 文件上传 聊天语音  notErr%@  \n databety = %lu",err.description,(unsigned long)data.length);
                [formData appendPartWithFileData:data name:@"file" fileName:@"filevoice.caf" mimeType:@"amr/caf/wmr"];
                finished(nil,nil);
                return;
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"语音上传 进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___语音上传 success ____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___语音上传 failure ____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            
        }];
         */
        NSString *allUrl =  URL_ChatBaseURL(url);
        NSLog(@"上传 视频上传 url= %@",allUrl);
          [self POST:URL_ChatBaseURL(url) parameters:params headers:chatNewHeader constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSLog(@"路径文件类 上传  视频上传——————path地址   %@",filePathStr)
         if (isNil(filePathStr)) {
             finished(nil,nil);
             return;
         }
         [formData appendPartWithFileURL:[UrlWithString getURLWithStr:filePathStr] name:@"file" error:nil];
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"%@",uploadProgress);
         NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"  视频上传  theFilePathUrl地址= %@",filePathStr);
         NSLog(@"___success____ %@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
         finished(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"__ 视频上传  _failure____ %@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
         finished(nil,error);
         
     }];
         
        /** */
      
    });
    
};
#pragma mark == 路径文件类 上传 （1026新版） (语音在用)
- (void)YrequestPostChatTypeSendWithOneDataPathFilesNewSystemWithURL:(NSString *)url withChatSessionId:(NSString *)chatSessionId
                                                       withChatToken:(NSString *)token withOnlyReq:(NSString *)onlyReq withSign:(NSString *)sign withParams:(NSMutableDictionary *)params
                                                         filePathStr:(NSString *)filePathStr
                                                       upfileNameStr:(NSString *)name
                                                            finished:(void (^)(id  responsObject,NSError *error))finished{
    
    [self addTokenWithChatType];
    //
    NSMutableDictionary *chatNewHeader = [[NSMutableDictionary alloc]init];
    [chatNewHeader setValue:token forKey:@"token"];
    [chatNewHeader setValue:kMobile forKey:@"device"];
    [chatNewHeader setValue:onlyReq forKey:@"onlyReq"]; //请求随机数onlyReq
    [chatNewHeader setValue:sign forKey:@"sign"];
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /** 文件哈希值要一样 在上一个处理data时加了optionsNSDataReadingUncached即可。 获取data 上传data时用一样的方式  md5后才是一样的 。（以下两种上传post都可以正常上传）
         
     
        [self POST:URL_ChatBaseURLNewBase8090(url) parameters:params headers:chatNewHeader constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSError *err = nil;
            NSData *data  = [NSData dataWithContentsOfURL:[UrlWithString getURLWithStr:filePathStr] options:NSDataReadingUncached error:&err];
            NSString *fileHashNow = [FileMd5Hash computeHashForData:data];//CC_MD5_DIGEST_LENGTH
            NSLog(@"语音 文件上传 当前哈希值=%@ parmaDic=%@",fileHashNow,params);
            if (err) {
                NSLog(@"语音 文件上传 聊天语音 error %@",err.description);//   NSFileReadNoSuchFileError = 260,//文件读取无此类文件错误
                
            }else{
                NSLog(@"语音 文件上传 聊天语音  notErr%@  \n databety = %lu",err.description,(unsigned long)data.length);
                [formData appendPartWithFileData:data name:@"file" fileName:@"filevoice.caf" mimeType:@"amr/caf/wmr"];
                finished(nil,nil);
                return;
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"语音上传 进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___语音上传 success ____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___语音上传 failure ____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            
        }];
         */
          [self POST:URL_ChatBaseURL(url) parameters:params headers:chatNewHeader constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSLog(@"路径文件类 上传 语音上传/视频上传——————path地址   %@",filePathStr)
         if (isNil(filePathStr)) {
             finished(nil,nil);
             return;
         }
         [formData appendPartWithFileURL:[UrlWithString getURLWithStr:filePathStr] name:@"file" error:nil];
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"%@",uploadProgress);
         NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@" 语音上传/视频上传  theFilePathUrl地址= %@",filePathStr);
         NSLog(@"___success____ %@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
         finished(responseObject,nil);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"___failure____ %@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
         finished(nil,error);
         
     }];
         
        /** */
      
    });
    
};

#pragma mark == img chat 聊天图片数据上传 (1025 新版) //220328 图片压缩更改
 
- (void)YrequestPostChatTypeSendImgFilesNewSystemWithURL:(NSString *)url withChatSessionId:(NSString *)chatSessionId withChatToken:(NSString *)token withOnlyReq:(NSString *)onlyReq withSign:(NSString *)sign withParams:(NSMutableDictionary *)params fileImgArr:(NSMutableArray *)fileImgArr upfileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    [self addTokenWithChatType];
    //
    NSMutableDictionary *chatNewHeader = [[NSMutableDictionary alloc]init];
    [chatNewHeader setValue:token forKey:@"token"];
    [chatNewHeader setValue:kMobile forKey:@"device"];
    [chatNewHeader setValue:onlyReq forKey:@"onlyReq"]; //请求随机数onlyReq
    [chatNewHeader setValue:sign forKey:@"sign"];
    //
    NSLog(@"\n--------------\n POST ImageData _\n params = %@_ \n url= %@ \n --------------\n ",params,URL_ChatBaseURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:URL_ChatBaseURLNewBase8090(url) parameters:params headers:chatNewHeader constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileImgArr) {
//                NSData *data = UIImageJPEGRepresentation(photo, 0.2);//1025大小哈希data都要匹配0.2
                NSData *data = [ZYImageCompressTool image200KBCompressWithImg:photo]; //聊天发送图片上一级别 做哈希前已经做了压缩目前用200k內 为防止签名错误 这里也要压缩到200k內
                [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"图片上传 进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___图片上传 success ____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___图片上传 failure ____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            
        }];
    });
    
}

#pragma mark == img chat 聊天图片数据上传
- (void)YrequestPostChatTypeSendImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    [self addTokenWithChatType];
    [params setValue:@"" forKey:@"description"];
    NSLog(@"\n--------------\n POST ImageData _\n params=%@_\n url=%@ \n--------------\n ",params,URL_ChatBaseURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:URL_ChatBaseURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileImgArr) {
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                });
            NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            
        }];
    });
    
}

#pragma mark == 语音
//- (void)YrequestPostChatTypeSendVoiceFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileVoiceArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{    [self addToken];
//    [params setValue:@"" forKey:@"description"];
//    NSLog(@"\n--------------\n POST voice _\n params=%@_\n url=%@ \n--------------\n ",params,URL_ChatBaseURL(url));
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self POST:URL_ChatBaseURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            for (id voiceFile in fileVoiceArr) {
//                NSData *data = nil;
//                [formData appendPartWithFileData:data name:@"file" fileName:@"file.mp3" mimeType:@"amr/mp3/wmr"];
//            }
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"%@",uploadProgress);
//            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
//            finished(responseObject,nil);
//
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
//            finished(nil,error);
//
//        }];
//    });
//
//}
//语音 文件上传 聊天语音
- (void)YrequestPostChatTypeSendVoiceFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileVoiceArr fileNameStr:(NSString *)name  filePacthUrl:(NSURL *)theFilePathUrl finished:(void (^)(id  responsObject,NSError *error))finished{
    
    NSString *allLongUrlStr = URL_ChatBaseURL(url);
    [self addTokenWithAllLongUrl:allLongUrlStr];
    [params setValue:@"" forKey:@"description"];
    NSLog(@"\n--------------\n POST voice _\n params=%@_\n url=%@ \n  --------------\n ",params,URL_ChatBaseURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:URL_ChatBaseURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSLog(@" 语音上传——————path地址   %@",theFilePathUrl)
//
            if (isNil(theFilePathUrl)) {
                finished(nil,nil);
                return;
            }
            [formData appendPartWithFileURL:theFilePathUrl name:@"file" error:nil];
            
            //test 未能读取数据，因为它的格式不正确。
//            NSError *err = nil;
//            NSData *data  = [NSData dataWithContentsOfURL:theFilePathUrl options:NSDataReadingUncached error:&err];
//            if (err) {
//                NSLog(@"语音 文件上传 聊天语音 error %@",err.description);//   NSFileReadNoSuchFileError = 260,//文件读取无此类文件错误
//
//            }else{
//                NSLog(@"语音 文件上传 聊天语音  notErr%@  \n databety = %lu",err.description,(unsigned long)data.length);
//                [formData appendPartWithFileData:data name:@"file" fileName:@"filevoice.caf" mimeType:@"amr/caf/wmr"];
//                finished(nil,nil);
//                return;
//            }
          
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"语音上传 theFilePathUrl地址=%@",theFilePathUrl);
            NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
            
        }];
    });
    
}

//下载文件
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
               NSLog(@"下载完成，保存到本地%@",savestr);
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
#pragma mark ===
#pragma mark --      -- get not main  __allurl
- (void)YYrequestALLURLGetNotMainQueue:(NSString *)allUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = allUrl;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n GET__ \n params=%@___ allurl= %@ \n--------------\n",params, allUrl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self GET:allUrl parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"___\n allurl =%@____%@",allUrl,[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSLog(@"____\n allurl =%@___%@",allUrl,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            });
        }];
    });
}

#pragma mark -- ALLURL get
-(void)YrequestGetALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n GET__ \n params=%@___url=%@\n--------------\n",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
                
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                
                finished(nil,error);
            });
        }];
    });
}

#pragma mark -- ALLURL post
- (void)YYrequestALLURLPostNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
            finished(nil,error);
        }];
    });
}

#pragma mark -- ALLURL post  把parms 拼接成url里带着传
- (void)YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSString *allParmsUrl = [ConnectUrl connectUrl:params url:url];
    NSLog(@"\n--------------\n POST_\n params=%@_\n url=%@ \n--------------\n ",params,url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self POST:allParmsUrl parameters:@{} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
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
//    [request setValue:[ShareUserInfo sharedUserInfo].token  forHTTPHeaderField:@"token"];//ALLURl
    [request setValue:saveThisTokenStr  forHTTPHeaderField:@"token"];//ALLURl
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // body
    NSError* error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted  error:&error];
    if ([bodyData length] > 0 && error == nil){
        [request setHTTPBody:bodyData];
    }else{
        NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
        finished(nil,error);
        return;
    }
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: %@ %@", [[responseObject description]kdtk_stringByReplaceingUnicode], url);
            finished(responseObject,nil);
            [self.datas removeObjectForKey:url];
        }else{
            NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, [[responseObject description] kdtk_stringByReplaceingUnicode]);
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
    [self DELETE:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
            finished(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
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
            NSLog(@"1DeletURLNoMainQueueWithBodyN uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"1DeletURLNoMainQueueWithBodyN downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"1DeletURLNoMainQueueWithBodyN Reply JSON: %@ %@", responseObject, url);
                finished(responseObject,nil);
            }else{
                NSLog(@"1DeletURLNoMainQueueWithBodyN Error: %@, %@, %@", error, response, responseObject);
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
    [self PUT:url parameters:params headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject,nil);
        NSLog(@"___\n url=%@____%@",url,[[responseObject description]kdtk_stringByReplaceingUnicode]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finished(nil,error);
        NSLog(@"____\n url=%@___%@",url,[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
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
        NSLog(@"1DeletURLNoMainQueueWithBodyN uploadProgress: %@", uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"1DeletURLNoMainQueueWithBodyN downloadProgress: %@", downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"1DeletURLNoMainQueueWithBodyN Reply JSON: %@ %@", responseObject, url);
            finished(responseObject,nil);
        }else{
            NSLog(@"1DeletURLNoMainQueueWithBodyN Error: %@, %@, %@", error, response, responseObject);
            finished(nil,error);
        }
    }];
    [dataTask resume];
}

#pragma mark - ALLURL image
- (void)YrequestImgFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    NSString *allLongUrlStr = url;
    [self addTokenWithAllLongUrl:allLongUrlStr];
    NSLog(@"urlstr = %@", url);
    [self POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *photo in fileImgArr) {
            NSData *data = [ZYImageCompressTool imageCompress:photo];
            [formData appendPartWithFileData:data name:@"file" fileName:@"file.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        finished(responseObject,nil);
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
    NSLog(@"urlstr = %@", url);
    [self POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *photo in fileImgArr) {
            NSData *data = [ZYImageCompressTool imageCompress:photo];
            [formData appendPartWithFileData:data name:@"images" fileName:@"image.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        finished(responseObject,nil);
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
    NSLog(@"urlstr = %@", url);
    [self POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:filePathStr];
        if (isNotNil(data)) {
            [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"amr/caf/wmr"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        finished(responseObject,nil);
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
    NSLog(@"urlstr = %@", url);
    [self POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.mp4" mimeType:@"video/quicktime"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"___success____%@",[[responseObject description] kdtk_stringByReplaceingUnicode]);
        finished(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"___failure____%@",[[error.localizedDescription description] kdtk_stringByReplaceingUnicode]);
        NSLog(@"Error: %@", error);
        finished(nil,error);
    }];
}

#pragma mark ====消息聊天大类的数据请求 新

// 消息聊天大类的数据请求 新ALLURL body传值型+ headertoken自定数据
- (void)YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    
    [ChatManagerData toolImMesssageInfoBodyStrWithParmsDic:[NSMutableDictionary dictionaryWithDictionary:body] withHeaderUseSBlock:^(NSString * _Nonnull onlyReq, NSMutableDictionary * _Nonnull parms) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            //____________
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:url parameters:nil error:nil];
            request.timeoutInterval = 20;
            // 设置header
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //header
            NSString *tokenS = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];
            [request setValue:tokenS forHTTPHeaderField:@"token"];
            [request setValue:kMobile forHTTPHeaderField:@"device"];
            [request setValue:onlyReq forHTTPHeaderField:@"onlyReq"]; //请求随机数onlyReq
            // body
            NSError* error = nil;
//            NSString *parmsJsonStr = [Tool jsonStrWithDic:parms];
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parms options:NSJSONWritingPrettyPrinted  error:&error];
            if ([bodyData length] > 0 && error == nil){
                [request setHTTPBody:bodyData];
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
                finished(nil,error);
                return;
            }
            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON______Im: %@ %@", [[responseObject description]kdtk_stringByReplaceingUnicode], url);
                    BOOL msgIsChange = NO;
                    //即时通讯专用的新版本接口 处理1003未登录
                    //更换文本
                    if (isNotNil(responseObject)) {
                        if ([[responseObject objectForKey:@"err_code"] intValue] == Im_err_code_Num_NotOnLineMsg) {
                            if ( [IsLoginTool share].save_Login_Type == IS_Login_NotLogin ||  [IsLoginTool share].save_Login_Type == IS_Login_Tourists) {//非登录的状态（UI层级界面上面为非登录）--不再弹出这种1003提示 不做后续
                                return;
                            }
                            NSString *msg = [NSString stringWithString:[responseObject objectForKey:@"err_msg"]];
                            if ([msg containsString:@"未登录"] || [msg containsString:@"没有登录"]) {
                                msgIsChange = YES;
                                msg = @"用户通讯功能正在进行登录，成功后，用户请重新刷新数据";
                                NSArray *keyArr = [responseObject allKeys];
                                NSMutableDictionary *newReDic = [[NSMutableDictionary alloc]init];
                                for (id keyStr in keyArr) {
                                    if ([keyStr isEqualToString:@"err_msg"]) {
                                        [newReDic setValue:msg forKey:keyStr];
                                    }else{
                                        [newReDic setValue:[responseObject objectForKey:keyStr] forKey:keyStr];
                                    }
                                }
                                finished(newReDic,nil);
                                //做通讯连接
                                [[ChatSeverConnectionBegin share]initChatWithSocketNeedInfoAndOpenSocket];
                            }
                        }
                    }
                    if (msgIsChange == NO) {
                        finished(responseObject,nil);
                    }
                    [self.datas removeObjectForKey:url];
                }else{
                    NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                    finished(nil,error);
                    [self.datas removeObjectForKey:url];
                }
            }];
            [self.datas setValue:dataTask forKey:url];
            [dataTask resume];
        });
    }];

   
        
}
#pragma mark === 消息推送所用列表相关 聊天其他功能接口用到的

// 消息推送所用列表 ALLURL body传值型+ headertoken自定数据
- (void)YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    
    [ChatManagerData toolImMesssageInfoBodyStrWithParmsDic:[NSMutableDictionary dictionaryWithDictionary:body] withHeaderUseSBlock:^(NSString * _Nonnull onlyReq, NSMutableDictionary * _Nonnull parms) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            //____________
            NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:url parameters:nil error:nil];
            request.timeoutInterval = 20;
            // 设置header
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //header
            NSString *tokenS = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];
            [request setValue:tokenS forHTTPHeaderField:@"token"];
            [request setValue:kMobile forHTTPHeaderField:@"device"];
            [request setValue:onlyReq forHTTPHeaderField:@"onlyReq"]; //请求随机数onlyReq
            // body
            NSError* error = nil;
//            NSString *parmsJsonStr = [Tool jsonStrWithDic:parms];
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parms options:NSJSONWritingPrettyPrinted  error:&error];
            if ([bodyData length] > 0 && error == nil){
                [request setHTTPBody:bodyData];
            }else{
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms dataJson nil");
                finished(nil,error);
                return;
            }
            NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: %@ %@", [[responseObject description]kdtk_stringByReplaceingUnicode], url);
                    finished(responseObject,nil);
                    [self.datas removeObjectForKey:url];
                }else{
                    NSLog(@"YrequestPostURLNoMainQueueWithBodyNotParms Error: %@, %@, %@", error, response, responseObject);
                    finished(nil,error);
                    [self.datas removeObjectForKey:url];
                }
            }];
            [self.datas setValue:dataTask forKey:url];
            [dataTask resume];
        });
    }];

   
        
}
#pragma mark === datas
- (NSMutableDictionary *)datas {
    if (!_datas) {
        _datas = [NSMutableDictionary dictionary];
    }
    return _datas;
}
@end
