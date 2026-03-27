//
//  ToolOfNetWork.m
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "ToolOfNetWork.h"
static ToolOfNetWork * netWorkTools = nil;

@implementation ToolOfNetWork

+ (ToolOfNetWork *)sharedTools {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkTools = [[self alloc] initWithBaseURL:nil];
        netWorkTools.requestSerializer = [AFJSONRequestSerializer serializer];
        netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
//        netWorkTools.responseSerializer = [AFHTTPResponseSerializer serializer];
        netWorkTools.requestSerializer.timeoutInterval = 20;
        netWorkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//        netWorkTools.requestSerializer = [AFHTTPRequestSerializer serializer];
     

    });
    return netWorkTools;
}

#pragma mark -- delete
-(void)YrequestDeleteURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    [self endXml];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];//改为http的请求
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    
    if([ShareUser sharedUserInfo].token!=nil){
        NSLog(@"当前用户token%@",[ShareUser sharedUserInfo].token);
        [netWorkTools.requestSerializer setValue: [ShareUser sharedUserInfo].token forHTTPHeaderField:@"tokenId"];
        
    }
    NSLog(@"%@________%@",params,Y_BASEURL(url));
    
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [self DELETE:Y_BASEURL(url) parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

#pragma mark --  xml
-(void)YrequestXmlURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
     [self needxml];
    if([ShareUser sharedUserInfo].token!=nil){
        NSLog(@"当前用户token%@",[ShareUser sharedUserInfo].token);
        [netWorkTools.requestSerializer setValue: [ShareUser sharedUserInfo].token forHTTPHeaderField:@"tokenId"];
        
    }
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];//改为http的请求
    self.responseSerializer = [AFXMLParserResponseSerializer serializer];//xml
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/xml", nil];

    NSLog(@"params=%@_____utl=___%@",params, url );
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        
        
        [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                 netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
                finished(responseObject,nil);
                
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
                finished(nil,error);
            });
        }];
        
        
    });
}
- (void)needxml{
    
    if (netWorkTools.responseSerializer != [AFXMLParserResponseSerializer serializer]) {
        netWorkTools.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    
}
- (void)endXml{
    if (netWorkTools.responseSerializer != [AFJSONResponseSerializer serializer]) {
          netWorkTools.responseSerializer = [AFJSONResponseSerializer serializer];
    }
}


#pragma mark -- get
-(void)YrequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    
    [self endXml];
     self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//0110新增
    if([ShareUser sharedUserInfo].token!=nil){
        NSLog(@"当前用户token%@",[ShareUser sharedUserInfo].token);
        [netWorkTools.requestSerializer setValue: [ShareUser sharedUserInfo].token forHTTPHeaderField:@"tokenId"];
        
    }
    NSLog(@"params=%@_____utl=___%@",params,Y_BASEURL(url));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        
 
        [self GET:Y_BASEURL(url) parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([responseObject isKindOfClass:[NSXMLParser class]]){
                    NSError *err = [[NSError alloc]init];
                   
                    NSLog(@"__________bbbbbb______________xml格式的数据了");
                     finished(nil,nil);
                }else{
                     finished(responseObject,nil);
                }
               
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                finished(nil,error);
            });
        }];
        
    
    });
}

#pragma mark -- post
-(void)YrequestURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished{
    [self endXml];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];//改为http的请求
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    
    
    if([ShareUser sharedUserInfo].token!=nil){
        NSLog(@"当前用户token%@",[ShareUser sharedUserInfo].token);
        [netWorkTools.requestSerializer setValue: [ShareUser sharedUserInfo].token forHTTPHeaderField:@"tokenId"];
        
    }
    NSLog(@"params=%@________url=%@",params,Y_BASEURL(url));
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
     
          [self POST:Y_BASEURL(url) parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               dispatch_async(dispatch_get_main_queue(), ^{
//               NSLog(@"_______%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
              finished(responseObject,nil);
              });
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               dispatch_async(dispatch_get_main_queue(), ^{
             
              finished(nil,error);
              });
          }];
      });
    
}

-(void)YrequestURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished{
   [self endXml];
    if([ShareUser sharedUserInfo].token!=nil){
        NSLog(@"当前用户token%@",[ShareUser sharedUserInfo].token);
        [netWorkTools.requestSerializer setValue: [ShareUser sharedUserInfo].token forHTTPHeaderField:@"tokenId"];
        
    }
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self POST:Y_BASEURL(url) parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (UIImage *photo in fileArr) {
                NSString *filename = [NSString stringWithFormat:@"%@.png", [ToolOfBasic nowTime]];
                NSData *data = UIImageJPEGRepresentation(photo, 0.2);
                [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:@"image/png"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
            NSLog(@"进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"___success____%@",[[responseObject description]kdtk_stringByReplaceingUnicode]);
                finished(responseObject,nil);

            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"___failure____%@",[[error.localizedDescription description]kdtk_stringByReplaceingUnicode]);
                finished(nil,error);

            });
            
        }];
    });
    
    
}

@end
