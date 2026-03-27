//
//  ZYElectronicSignatureToolOfNetWork.h
//  Community
//
//  Created by ZY on 2021/4/10.
//

#import "AFURLSessionManager.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicSignatureToolOfNetWork : AFHTTPSessionManager

+ (ZYElectronicSignatureToolOfNetWork *)sharedTools;

// 实名验证
- (void)realNameRequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

// get传参
- (void)electronicSignatureRequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

// body传值型
- (void)electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;

// 上传图片
- (void)electronicSignatureImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;

// 批量上传图片
- (void)electronicSignatureImgFilesArrWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;

// 上传图片100KB以内
- (void)electronicSignature100KBImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;

@end

NS_ASSUME_NONNULL_END
