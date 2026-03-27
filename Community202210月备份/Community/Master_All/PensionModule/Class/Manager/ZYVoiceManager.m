//
//  ZYVoiceManager.m
//  Community
//
//  Created by ZY on 2021/12/6.
//

#import "ZYVoiceManager.h"
#import "DownLoadRequest.h"

@interface ZYVoiceManager ()

@property (strong, nonatomic) DownLoadRequest *down;

@end

@implementation ZYVoiceManager
singleton_implementation(share)

- (void)voiceDownLoadWithFileUrlStr:(NSString *)fileUrlStr AndIsPlay:(BOOL)isPlay {
    NSString *willSavePathStr = [NSString stringWithFormat:@"EHome%@.amr", fileUrlStr];
    NSString *oneP = [willSavePathStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *twoP = [oneP stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
    NSString *thrP = [twoP stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    NSString *pathStr =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: thrP];
    //有音频文件数据就不下载 直接播放
    NSTimeInterval timeIntV = [[LGAudioPlayer sharePlayer] getPathStrVoiceDurationNumWithPathStr:pathStr];
    if (timeIntV > 0) {
        NSLog(@"有音频文件数据就不下载 直接播放");
        if (isPlay) {
            [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:pathStr];
        }
       return;
    }
    
    // 没有该文件，需要下载后播放
    [self voiceDownDataWithAlLUrlStr:fileUrlStr andPathStr:pathStr AndIsPlay:isPlay];
}

- (void)voiceDownDataWithAlLUrlStr:(NSString *)urlStr andPathStr:(NSString *)pathStr AndIsPlay:(BOOL)isPlay {
        self.down = nil;
        self.down = [[DownLoadRequest alloc] initWithURL:urlStr Path:pathStr];//将要存储的位置
        [self.down BegindownProgress:^(long long totalReceivedContentLength, long long totalContentLength) {
            NSLog(@"下载--- totalReceivedContentLength  %lld  totalContentLength =%lld",totalReceivedContentLength,totalContentLength);
        } Succeed:^(NSString *URL, NSString *path) {
            NSLog(@"Succeed path %@",path);
            if (isPlay) {
                NSTimeInterval timeIntV = [[LGAudioPlayer sharePlayer]getPathStrVoiceDurationNumWithPathStr:path];
                    NSLog(@"\n 这个音频时长:%lf", timeIntV);
                if (timeIntV <= 0) {
                    Y_SVP_SHOW_ERR_MES(@"音频数据下载失败 暂不可播放");
                    return;
                }
                [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:path];
            }
        } Failure:^{
            NSLog(@"下载失败");
            if (isPlay) {
                Y_SVP_SHOW_ERR_MES(@"音频数据 下载失败！");
            }
        }];
}

@end
