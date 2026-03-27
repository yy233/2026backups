//
//  ZYWebUrlToDictTool.m
//  Community
//
//  Created by ZY on 2022/3/23.
//

#import "ZYWebUrlToDictTool.h"

@implementation ZYWebUrlToDictTool

+ (NSDictionary *)parameterWithURL:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
 
    return parm;
}

@end
