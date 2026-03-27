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
} requestMethod;

@interface ToolOfNetWork : AFHTTPSessionManager
+ (ToolOfNetWork *)sharedTools;
//post
- (void)YrequestPostURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLStrWithAllURLNoParmsNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostAllLongURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostHouseRepairOneImageWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished;
- (void)YrequestPostImagesWithAllLongURL:(NSString *)url withParams:(NSMutableDictionary *)params fileImgData:(NSMutableArray *)fileArr fileNameStr:(NSString *)name imgNameAllStr:(NSString *)imgName  finished:(void (^)(id  responsObject,NSError *error))finished;
- (void)YrequestPostImagesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileImgData:(NSMutableArray *)fileArr fileNameStr:(NSString *)name imgNameAllStr:(NSString *)imgName  finished:(void (^)(id  responsObject,NSError *error))finished;//图片的
//get
- (void)YrequestGetURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestGetURLNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestGetURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
//delte
- (void)YrequestDeletURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestDeletURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
//body传值型
- (void)YrequestDeletURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostmageDataBodyTypeWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished;
//put
- (void)YrequestPutURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPutURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
//给换手机号用的接口
- (void)YrequestHaveAuthTokenWithPutURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params withAuthToken:(NSString *)authTokenStr finished:(void (^)(id responsObject,NSError *error))finished;
//三方登录用的
- (void)YrequestThirdLoginURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
//图片的
- (void)YrequestPostCarImageDataWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileData:(NSMutableArray *)fileArr finished:(void (^)(id  responsObject,NSError *error))finished;

//___________ 商城用的
- (void)YrequestGetURLNotMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestDeletURLNoMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
//___________ 聊天用的
- (void)YrequestGetURLNotMainQueueWtihChatTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLNotMainQueueWtihChatTypeUrl:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
- (void)YrequestPostURLNoMainQueueWithBodyNotParmsWithChatTypeUrl:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark == Chat总文件DataArr处理
//暂时未用
//- (void)YrequestPostChatTypeSendFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileDataArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;


#pragma mark ==  文件上传 （2022 0622 新版） mp4在用
- (void)YrequestPostChatTypeSendFileWithOneDataPathFilesWithUpURL:(NSString *)url
                                                withFfileConfigId:(NSString *)fileConfigId
                                                         withNonce:(NSString *)nonce
                                                         withSign:(NSString *)sign
                                                        withParams:(NSMutableDictionary *)params
                                                         filePathStr:(NSString *)filePathStr
                                                       upfileNameStr:(NSString *)name
                                                         finished:(void (^)(id  responsObject,NSError *error))finished;
#pragma mark == 路径文件类 上传 （1026新版） (语音在用)
- (void)YrequestPostChatTypeSendWithOneDataPathFilesNewSystemWithURL:(NSString *)url withChatSessionId:(NSString *)chatSessionId
                                                       withChatToken:(NSString *)token withOnlyReq:(NSString *)onlyReq withSign:(NSString *)sign withParams:(NSMutableDictionary *)params
                                                         filePathStr:(NSString *)filePathStr
                                                       upfileNameStr:(NSString *)name
                                                            finished:(void (^)(id  responsObject,NSError *error))finished;
//1025 图片上传接口 新版本
- (void)YrequestPostChatTypeSendImgFilesNewSystemWithURL:(NSString *)url withChatSessionId:(NSString *)chatSessionId   withChatToken:(NSString *)token withOnlyReq:(NSString *)onlyReq withSign:(NSString *)sign withParams:(NSMutableDictionary *)params fileImgArr:(NSMutableArray *)fileImgArr upfileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
//图片
- (void)YrequestPostChatTypeSendImgFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
//语音
//- (void)YrequestPostChatTypeSendVoiceFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileVoiceArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
//语音
- (void)YrequestPostChatTypeSendVoiceFilesWithURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileVoiceArr fileNameStr:(NSString *)name  filePacthUrl:(NSURL *)theFilePathUrl  finished:(void (^)(id  responsObject,NSError *error))finished;

#pragma mark ====消息聊天大类的数据请求 新

// 消息聊天大类的数据请求 新ALLURL body传值型+ headertoken自定数据
- (void)YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark === 消息推送所用列表相关

// 消息推送所用列表 ALLURL body传值型+ headertoken自定数据
- (void)YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;


#pragma mark === 
//全URL 不加base 下载文件并保存
- (void)YrequestDownloadFilePostURLNotMainQueueWithAll:(NSString *)allUrl withSavePathUrl:(NSURL *)savePathUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;

#pragma mark ==
#pragma mark -- ALLURL get not main  __allurl
- (void)YYrequestALLURLGetNotMainQueue:(NSString *)allUrl withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark -- ALLURL post not main
- (void)YYrequestALLURLPostNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark -- ALLURL get not main
-(void)YrequestGetALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark -- ALLURL post not main  把parms 拼接成url里带着传
- (void)YrequestPostPinURLStrWithAllURLNoParmsNotMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL post body
- (void)YrequestPostALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
// ALLURL body传值型+ headertoken自定数据
//- (void)YrequestPostALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body withHeaderTokenInfo:(id)headerToken finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL delete
- (void)YrequestDeleteALLURL:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL delete body
- (void)YrequestDeleteALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL put
- (void)YrequestPUTALLURLNoMainQueue:(NSString *)url withParams:(NSMutableDictionary *)params finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL put body
- (void)YrequestPUTALLURLNoMainQueueWithBodyNotParms:(NSString *)url  withBody:(id)body finished:(void (^)(id responsObject,NSError *error))finished;
#pragma mark - ALLURL image
- (void)YrequestImgFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
#pragma mark - ALLURL images Market
- (void)YrequestMarketImgFilesArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params fileDataArr:(NSMutableArray *)fileImgArr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
#pragma mark - ALLURL 语音
- (void)YrequestVoiceFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params filePathStr:(NSString *)filePathStr fileNameStr:(NSString *)name  finished:(void (^)(id  responsObject,NSError *error))finished;
#pragma mark - ALLURL video
- (void)YrequestVideoFileArrWithALLURL:(NSString *)url withParams:(NSMutableDictionary *)params filePath:(NSURL *)filePath finished:(void (^)(id  responsObject,NSError *error))finished;

@end
