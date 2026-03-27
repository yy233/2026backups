//
//  ToolOfNetWork.h
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef enum : NSUInteger {
    GET,
    POST
} requestGetOrPostMethod;

 
@interface ToolOfNetWork : AFHTTPSessionManager
+ (ToolOfNetWork *)sharedTools;

- (void)endXml;//切换到非xml的解析
- (void)needxml;
-(void)YrequestXmlURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
-(void)YrequestDeleteURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

-(void)YrequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

-(void)YrequestURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

-(void)YrequestURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id responsObject,NSError *error))finished;


@end
