//
//  DownLoadRequest.h
//  VoidTest
//
//  Created by 余莹 on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadRequest : NSObject
/**
 *  URL   下载链接
 *  Path  下载存放路径,如果程序退出,下次传入的路径和上一次一样,可以继续断点下载
 */
- (instancetype)initWithURL:(NSString *)URL Path:(NSString *)path;
 
/**
 * 下载回调
 */
-(void)BegindownProgress:(void (^)(long long totalReceivedContentLength, long long totalContentLength))progress Succeed:(void(^)(NSString * URL, NSString * path))succeed Failure:(void(^)(void))failure;
 
/**
 * 取消下载
 */
-(void)cancelLoad;
 
/**
 * 开始下载
 */
-(void)startLoad;
 
//-(void)deleteAllFile;

@end

NS_ASSUME_NONNULL_END
