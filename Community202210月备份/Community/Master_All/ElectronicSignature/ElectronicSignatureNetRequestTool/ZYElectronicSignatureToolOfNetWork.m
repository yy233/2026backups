//
//  ZYElectronicSignatureToolOfNetWork.m
//  Community
//
//  Created by ZY on 2021/4/10.
//

#import "ZYElectronicSignatureToolOfNetWork.h"

static ZYElectronicSignatureToolOfNetWork *electronicSignatureNetWorkTools = nil;
#define POST_Method @"POST"

@implementation ZYElectronicSignatureToolOfNetWork

+ (ZYElectronicSignatureToolOfNetWork *)sharedTools {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        electronicSignatureNetWorkTools = [[self alloc] initWithBaseURL:nil];
        electronicSignatureNetWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
        electronicSignatureNetWorkTools.requestSerializer.timeoutInterval = 20;
        electronicSignatureNetWorkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",@"image/jpeg", @"image/png", @"application/problem+json", nil];
        electronicSignatureNetWorkTools.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return electronicSignatureNetWorkTools;
}

#pragma mark - get
-(void)realNameRequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    [self addToken];
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

-(void)electronicSignatureRequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    [self addToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self GET:ZY_BASEURL(url) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___\n url=%@____%@",ZY_BASEURL(url),[[responseObject description]kdtk_stringByReplaceingUnicode]);
                
                finished(responseObject,nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"____\n url=%@___%@",ZY_BASEURL(url),[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                
                finished(nil,error);
            });
        }];
    });
}

#pragma mark - body传值型
- (void)electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]  requestWithMethod:POST_Method  URLString:ZY_BASEURL(url) parameters:nil error:nil];
        NSLog(@"urlstr = %@", ZY_BASEURL(url));
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
            finished(nil,error);
            return;
        }

        NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms uploadProgress: %@", uploadProgress);
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms downloadProgress: %@", downloadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@" electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms ZY_BASEURL(url)=%@ Reply JSON: %@",ZY_BASEURL(url), [[responseObject description] kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);
            }else{
                NSLog(@"electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms ZY_BASEURL(url)=%@ Error: %@, %@, %@", ZY_BASEURL(url),[[error description] kdtk_stringByReplaceingUnicode], [[response description] kdtk_stringByReplaceingUnicode], [[responseObject description] kdtk_stringByReplaceingUnicode]);
                finished(nil,error);
            }
        }];
        [dataTask resume];
    });
}

#pragma mark - 上传图片
- (void)electronicSignatureImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    [self addToken];
    NSLog(@"urlstr = %@", ZY_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:ZY_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileImgArr) {
                NSData *data = [ZYImageCompressTool imageCompress:photo];
                NSLog(@"%luKB", data.length / 1024);
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
    });
}

// 批量上传图片
- (void)electronicSignatureImgFilesArrWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    [self addToken];
    NSLog(@"urlstr = %@", ZY_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:ZY_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileImgArr) {
                NSData *data = [ZYImageCompressTool imageCompress:photo];
                [formData appendPartWithFileData:data name:@"files" fileName:@"file.png" mimeType:@"image/png"];
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
    });
}

// 图片压缩100KB以内
- (void)electronicSignature100KBImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished{
    [self addToken];
    NSLog(@"urlstr = %@", ZY_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:ZY_BASEURL(url) parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (UIImage *photo in fileImgArr) {
                NSLog(@"图片压缩前：%luKB", UIImageJPEGRepresentation(photo, 1.0).length / 1024);
                NSData *data = [ZYImageCompressTool image100KBCompress:photo];
                NSLog(@"图片压缩后：%luKB", data.length / 1024);
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
    });
}

#pragma mark - token
- (void)addToken{
    if([ShareUserInfo sharedUserInfo].token!=nil){
        [electronicSignatureNetWorkTools.requestSerializer setValue: [ShareUserInfo sharedUserInfo].token forHTTPHeaderField:@"token"];
    }
    if (isNotNil([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])) {
        [electronicSignatureNetWorkTools.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    }
}

@end
