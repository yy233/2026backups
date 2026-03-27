//
//  ZYCaschesTool.m
//  Community
//
//  Created by ZY on 2021/10/20.
//

#import "ZYCaschesTool.h"
#import "YYWebImage.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@implementation ZYCaschesTool

singleton_implementation(share)

// 获取缓存数据大小
- (NSString *)getCacheSize {
    //得到缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    //首先判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        for (NSString * fileName in childFile) {
            //缓存文件绝对路径
            NSString * absolutPath = [path stringByAppendingPathComponent:fileName];
            size = size + [manager attributesOfItemAtPath:absolutPath error:nil].fileSize;
        }
        //计算SDWebimage5的缓存和系统缓存总和
        size = size + [[SDImageCache sharedImageCache] totalDiskSize];
    }
    
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSInteger discCache = cache.diskCache.totalCost;
    NSInteger memoryCache = cache.memoryCache.totalCost;
//    double yywebImageCacheSize =  (discCache + memoryCache) / 1024.0 / 1024.0;
//    NSLog(@"yywebImageCacheSize缓存大小：%@", [NSString stringWithFormat:@"%.2fM", yywebImageCacheSize]);
    
    size = size + (discCache + memoryCache);
    double returnSize = size / 1024.0 / 1024.0;

    return [NSString stringWithFormat:@"%.2fM", returnSize];
}

// 清除数据
- (void)cleanCacheWithSuccess:(void (^)(BOOL success))successBlock {
    //获取缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    //判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        //逐个删除缓存文件
        for (NSString *fileName in childFile) {
            NSString * absolutPat = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutPat error:nil];
        }
        //清除yywebimage缓存
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        
        //删除sdwebimage的缓存
        [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:^{
            //这里是又调用了得到缓存文件大小的方法，是因为不确定是否删除了所有的缓存，所以要计算一遍，展示出来
            if ([[self getCacheSize] isEqualToString:@"0.00M"]) {
                if (successBlock) {
                    successBlock(YES);
                }
            } else {
                if (successBlock) {
                    successBlock(NO);
                }
            }
        }];
    }
}

@end
