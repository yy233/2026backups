//
//  DownLoadRequest.m
//  VoidTest
//
//  Created by 余莹 on 2021/5/24.
//
//#define ZFileDownloadPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MyDownloadFile.caf"]
#define ZFileDownloadPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MyDownloadFile.wav"]


#import "DownLoadRequest.h"
 
 
typedef void (^ProgressBlock)(void);
typedef void (^SucceedBlock)(void);
typedef void (^FailureBlock)(void);

@interface DownLoadRequest ()
 
/**
 *  请求
 */
@property (strong , nonatomic)  NSURLConnection * Connection;
 
/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle  * writeHandle;
 
/**
 *  下载链接
 */
@property (nonatomic, copy) NSString * URL;
 
/**
 *  存放路径
 */
@property (nonatomic, copy) NSString * path;
 
/**
 *  进度回调
 */
@property(nonatomic, copy) ProgressBlock progressBlock;
 
/**
 *  下载成功回调
 */
@property (nonatomic, copy) SucceedBlock succeedBlock;
 
/**
 *  下载失败回调
 */
@property (nonatomic, copy) FailureBlock  failureBlock;
 
/**
 *  总的长度
 */
@property (nonatomic, assign) NSInteger  totalexpectedContentLength;
 
/**
 *  当前已经写入的长度
 */
@property (nonatomic, assign) NSInteger  totalReceivedContentLength;
 
@end
 
@implementation DownLoadRequest
 
- (instancetype)initWithURL:(NSString *)URL Path:(NSString *)path
{
    self = [super init];
    if (self) {
        _path  = path;
        _URL = URL;
    }
    return self;
}
 
/**
 * 开始下载
 */
-(void)BegindownProgress:(void (^)(long long totalReceivedContentLength, long long totalContentLength))progress Succeed:(void(^)(NSString * URL, NSString * path))succeed Failure:(void(^)(void))failure
{
    __weak __typeof (self)weakself = self;
    [self setProgressBlockWithProgress:progress];
    self.succeedBlock=^()
    {
        succeed(weakself.URL, weakself.path);
    };
    self.failureBlock = ^{
        failure();
    };
    [self startLoad];
}
 
//进度条回调
-(void)setProgressBlockWithProgress:(void (^)(long long totalReceivedContentLength, long long totalContentLength))progress
{
    __weak __typeof (self)weakself = self;
    self.progressBlock = ^{
        if (progress != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(weakself.totalReceivedContentLength, weakself.totalexpectedContentLength);
            });
        }
    };
}
 
/**
 * 建立音频下载请求
 */
-(void)HTTPDownLoadReaquest
{
    NSURL *url=[NSURL URLWithString:self.URL];
    //创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.Connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
  
}
 
/**
 * 断点请求
 */
-(void)HTTPDownLoadPoint
{
    NSURL *url=[NSURL URLWithString:_URL];
    //创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *range = [NSString stringWithFormat:@"bytes=%llu-",[self fileSizeForPath:_path]];
    [request setValue:range forHTTPHeaderField:@"Range"];
    //使用代理发送异步请求
    self.Connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
 
/**
 * 获取文件路径
 */
- (long long)fileSizeForPath:(NSString *)path
{
    long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new];
    if ([fileManager fileExistsAtPath:path])
    {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict)
        {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}
 
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_path]) {

        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:_path error:nil];
    }
}
 
/**
 * 取消下载
 */
-(void)cancelLoad
{
    [self.Connection cancel];
}
 
/**
 * 开始下载
 */
-(void)startLoad
{
    [self.Connection cancel];
    if ([self fileSizeForPath:_path] > 0)
    {
//        NSLog(@"HTTPDownLoadPoint断点下载 ———— 本地文件长度fileSize =%lld ",[self fileSizeForPath:_path])
//        [self HTTPDownLoadPoint];
        [self deleteAllFile];
        NSLog(@"HTTPDownLoadReaquest建立音频下载请求替代断点 ———— 本地文件长度fileSize =%lld ",[self fileSizeForPath:_path])
        [self HTTPDownLoadReaquest];
   
    }
    else
    {
        NSLog(@"HTTPDownLoadReaquest建立音频下载请求 ———— 本地文件长度fileSize =%lld ",[self fileSizeForPath:_path])
        [self HTTPDownLoadReaquest];
    }
    [self.Connection start];
}
 
/*
 *当接收到服务器的响应（连通了服务器）时会调用
 */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.totalexpectedContentLength = 0;
    self.totalReceivedContentLength = 0;
    if ([self fileSizeForPath:_path] == 0)
    {
        // 创建一个用来写数据的文件句柄对象
        NSFileManager* mgr = [NSFileManager defaultManager];
        [mgr createFileAtPath:_path contents:nil attributes:nil];
 
    }
    self.totalReceivedContentLength = [self fileSizeForPath:_path];//总接收内容长度totalReceivedContentLength
    self.totalexpectedContentLength = response.expectedContentLength + [self fileSizeForPath:_path]; //总预期内容长度totalexpectedContentLength
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:_path];
    NSLog(@"总预期内容长度totalexpectedContentLength  == %ld  \n总接收内容长度totalReceivedContentLength == %ld",(long)self.totalexpectedContentLength,(long)self.totalReceivedContentLength);
}
 
/*
 *当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    self.totalReceivedContentLength += data.length;
    self.progressBlock();
    NSLog(@"写入中。 接收长度 == %ld",self.totalReceivedContentLength);
}
 
/*
 *当服务器的数据加载完毕时就会调用
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"写入完成 预期= %ld  接收= %ld",(long)self.totalexpectedContentLength,(long)self.totalReceivedContentLength);
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    self.succeedBlock();

}
 
/*
 *请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求错误（失败）的时候调用（请求超时 断网 没有网 ，一般指客户端错误）");
    self.failureBlock();
}
 

@end
