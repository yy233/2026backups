//
//  NetworkManager.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSUInteger,HttpRequestType) {
    HttpRequestGet = 0,
    HttpRequestPost
};

typedef void(^requestSuccess)(HttpResult * _Nullable result);

typedef void(^requestFailure)(NSError * _Nullable error);

typedef void(^uploadProgress)(float progress);

typedef void(^downloadProgress)(float progress);
NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager
/// 单例
+(NetworkManager *)shareManager;

/// 启动网络监测
+(void)StartNetworkMonitoring;

/// 手动写入/更新缓存
/// @param jsonResponse 要写入的数据
/// @param url 请求URL
+(BOOL)saveJSONResponseCacheFile:(id)EN_jsonResponse andURL:(NSString *)EN_url;

/// 获取缓存的对象
/// @param url 请求URL
+(id)cacheJSONWithURL:(NSString *)EN_url;

/// POST数据请求
/// @param url 请求URL
/// @param cache 是否缓存
/// @param paraments 请求参数
/// @param progress 进度
/// @param success 成功Block
/// @param failure 失败Block
+(void)postRequestURL:(NSString *)EN_url withCache:(BOOL)EN_cache withParaments:(nullable NSDictionary *)EN_paraments withDownloadProgress:(downloadProgress)EN_progress withSuccessBlock:(requestSuccess)EN_success withFailure:(requestFailure)EN_failure;

+(void)getRequestURL:(NSString *)EN_url withCache:(BOOL)EN_cache withParaments:(nullable NSDictionary *)EN_paraments withDownloadProgress:(downloadProgress)EN_progress withSuccessBlock:(requestSuccess)EN_success withFailure:(requestFailure)EN_failure;

/// 取消所有网络请求
//+(void)cancelAllRequest;
//
///// 取消指定URL网络请求
///// @param requestType 请求类型
///// @param url 该请求的完整url
//+(void)cancelHttpRequestWithRequestType:(NSString *)EN_requestType withRequestUrlString:(NSString *)EN_url;
//
//+(double)cacheCount;
//
//+(void)clearCache;


@end

NS_ASSUME_NONNULL_END
