//
//  VoiceDownAndSavePlayManage.m
//  Community
//
//  Created by 余莹 on 2021/5/24.
//

#import "VoiceDownAndSavePlayManage.h"
#import <AVFoundation/AVFoundation.h>
#import "DownLoadRequest.h"
//#import "ZYPhoneListeningManager.h"来电监测 主动停止语音播放

@interface VoiceDownAndSavePlayManage () <AVAudioPlayerDelegate>
@property (strong, nonatomic) DownLoadRequest * down;//下载器 偏向音频 下载部分没变
//@property (strong, nonatomic) AVAudioPlayer * audio;//播放器 caf采用
@property (nonatomic,strong) NSString *willSavePath;//保存地址

@property (nonatomic,strong) NSMutableArray *saveMsgIdArr;//
//通知发出chatVoicePalyingEndNotice
@end

@implementation VoiceDownAndSavePlayManage

singleton_implementation(share);

 
#pragma mark - 来电监测 主动停止语音播放
- (void)dealloc{
    DLog(@" 离开播放页。 语音播放停止 dealloc");
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_TakeInitiativeToStopVoice);
}
- (void)addNotice{
    DLog(@"离开播放页。 语音播放主动停止");
    //离开播放页 也要主动停止
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_TakeInitiativeToStopVoice,stoVoice );//未播放完+离开播放页时 会调用两次voiceEndNoticeWithMsgId
}
- (void)stoVoice{
    if (self.saveMsgIdArr.count>0) {
        //做停止当前语音播放
        [[LGAudioPlayer sharePlayer]stopAudioPlayer];
        //停止cell动画
        NSString *firstObjFileUUID =  [NSString stringWithString:self.saveMsgIdArr.firstObject];
        if (self.saveMsgIdArr.count>=2) {
            //删除所有
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:firstObjFileUUID afterDelay:0.1];
            [self performSelector:@selector(removeAllId) withObject:nil afterDelay:0.15];
        }else{
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:firstObjFileUUID afterDelay:0.1];

            //停cell前会删除id
        }
    }
}
- (void)removeAllId{
    [self.saveMsgIdArr removeAllObjects];
}
- (void)chatVoiceDownSavePlayWithMsgId:(NSString *)msgIdStr withFileSecret:(NSString *)fileSecretStr withUrlStr:(NSString *)voiceFileUrlStr{
    [self.saveMsgIdArr addObject:msgIdStr];
    if (self.saveMsgIdArr.count>2) {
      //立刻通知停止旧的 并且删除arr first //停止1 停止2 播放3
        NSString *firstObjFileUUID =  [NSString stringWithString:self.saveMsgIdArr.firstObject];
        NSString *sectionObjFileUUID =  [NSString stringWithString:self.saveMsgIdArr[1]];
        [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:firstObjFileUUID afterDelay:0.1];
        [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:sectionObjFileUUID afterDelay:0.1];
    }else if(self.saveMsgIdArr.count==2){
        //同一个cell点击
        if ([self.saveMsgIdArr.firstObject isEqualToString:self.saveMsgIdArr.lastObject]) {//相同的 做停止操作
//            [self.audio stop];//caf的使用
            [[LGAudioPlayer sharePlayer]stopAudioPlayer];
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.firstObject afterDelay:0.1];//停止语音动画
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:0.1];//停止语音动画
            NSLog(@"两个相同的 做停止操作");
            return; //做停止操作
        }else{//不同的 停止1 播放2
            NSString *firstObjFileUUID =  [NSString stringWithString:self.saveMsgIdArr.firstObject];
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:firstObjFileUUID afterDelay:0.1];
        }
    
    }
    NSLog(@"saveFileIdArr  == %@",self.saveMsgIdArr);
    /**
     旧
     NSString *urlS =  URL_ChatBaseURL(URL_Chat_DownFileWithFileUrl);//URL_ChatBaseURLNewBase8090 新base接口
     NSString *okUrlS =  [NSString stringWithFormat:@"%@?uuid=%@",urlS ,voiceFileIdStr];
     NSString *pathStr =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: [NSString stringWithFormat:@"EHome%@.amr",voiceFileIdStr]];//用uuid时 需要带后缀 0701已经改成amr格式
     */
 
    //1026新数据 uuid改成语音的全路径
    NSString *okUrlS =  @"";
    if (fileSecretStr.length<=0) {
       okUrlS =  [NSString stringWithFormat:@"%@",voiceFileUrlStr];
    }else{
       okUrlS =  [NSString stringWithFormat:@"%@&secret=%@",voiceFileUrlStr,fileSecretStr];
    }
   
    if (okUrlS.length<=0) {
        NSLog(@"语音url空 无法播放");
        return;
    }
    NSString *willSavePathStr = [NSString stringWithFormat:@"EHome%@.amr",voiceFileUrlStr];
    NSString *oneP = [willSavePathStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *twoP = [oneP stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
    NSString *thrP = [twoP stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    NSString *pathStr =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: thrP];//替换字符再做成存储路径
    /**
     存储地址要字母开头才能存数据？
     */
//

//    if ([[ToolOfTimeChangeFormat getTimeStrWithString:@"2021-07-01 15:28:00"] doubleValue] < [[ToolOfTimeChangeFormat getTimeStrWithString:@"2021-07-01 15:30:00"]  doubleValue]) {
//        pathStr =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent: [NSString stringWithFormat:@"EHome%@.caf",voiceFileIdStr]];//用uuid时 需要带后缀 旧的caf格式
//    }
    NSLog(@"\n  ____________download___________________\n okurl=%@  \n pathStr = %@",okUrlS,pathStr);
    [self download: okUrlS withPathStr:pathStr];
}
//caf格式的数据走的下载与播放 暂时保留
//- (void)download:(NSString *)okUrlS withPathStr:(NSString *)pathStr{
//    self.willSavePath = pathStr;
//    //有音频文件数据就不下载 直接播放
//    NSURL *url = [NSURL fileURLWithPath:pathStr];
//    self.audio = nil;
//    self.audio = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    NSTimeInterval timeIntV =  self.audio.duration;
//
//    if (timeIntV>0) {
//       NSLog(@"有音频文件数据就不下载 直接播放");
//       [self.audio prepareToPlay];
//       self.audio.numberOfLoops = 0;
//       self.audio.delegate = self;
//       self.audio.volume = 1;//
//       self.audio.currentTime = 0;//可以指定从任意位置开始播放
//       [self.audio play];
//        [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:timeIntV];
//       return;
//    }else{
//        NSLog(@"\n 本地这个音频 空 去下载播放");
//        NSLog(@"\n 本地这个音频时长:%lf", timeIntV);
//    }
//
////没有该文件 需要下载后播放
//
//    [self voiceDownDataWithAlLUrlStr:okUrlS];
//}
//#pragma mark == //两个都可以下载
//- (void)voiceDownDataWithAlLUrlStr:(NSString *)okUrlS{
//        self.down = nil;
//        __weak typeof (self)weakself = self;
//        self.down = [[DownLoadRequest alloc]initWithURL:okUrlS Path:self.willSavePath];//将要存储的位置
//
//
//        [self.down BegindownProgress:^(long long totalReceivedContentLength, long long totalContentLength) {
//            NSLog(@"下载--- totalReceivedContentLength  %lld  totalContentLength =%lld",totalReceivedContentLength,totalContentLength);
//        } Succeed:^(NSString *URL, NSString *path) {
//            NSLog(@"Succeed path %@",path);
//            //
////            dispatch_time_t dipatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
////            dispatch_after(dipatchTime, dispatch_get_main_queue(), ^{
////
//                NSURL *url = [NSURL fileURLWithPath:path];
//                weakself.audio = nil;
//                weakself.audio = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//                NSTimeInterval timeIntV =  weakself.audio.duration;
//                NSLog(@"\n 这个音频时长:%lf", timeIntV);
//
//            if (timeIntV<=0) {
//                Y_SVP_SHOW_ERR_MES(@"音频数据下载失败 暂不可播放");
//                return;
//            }
//                [weakself.audio prepareToPlay];
//                weakself.audio.numberOfLoops = 0;
//                weakself.audio.delegate = weakself;
//                weakself.audio.volume = 1;//
//                weakself.audio.currentTime = 0;//可以指定从任意位置开始播放
//                [weakself.audio play];
//                [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:timeIntV];
//
////            });
//
//        } Failure:^{
//            NSLog(@"下载失败");
//            Y_SVP_SHOW_ERR_MES(@"音频数据 下载失败！");
//           weakself.audio = nil;
//        }];
//
//}

//amr格式走的下载播放
- (void)download:(NSString *)okUrlS withPathStr:(NSString *)pathStr{
    self.willSavePath = pathStr;
    //有音频文件数据就不下载 直接播放
    NSTimeInterval timeIntV = [[LGAudioPlayer sharePlayer]getPathStrVoiceDurationNumWithPathStr: pathStr];
    if (timeIntV>0) {
       NSLog(@"有音频文件数据就不下载 直接播放");
        [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:pathStr];
        [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:timeIntV];
       return;
    }else{
        NSLog(@"\n 本地这个音频 空 去下载播放");
        NSLog(@"\n 本地这个音频时长:%lf", timeIntV);
    }
    
//没有该文件 需要下载后播放

    [self voiceDownDataWithAlLUrlStr:okUrlS];
}
#pragma mark == //两个都可以下载
- (void)voiceDownDataWithAlLUrlStr:(NSString *)okUrlS{
        self.down = nil;
        __weak typeof (self)weakself = self;
        self.down = [[DownLoadRequest alloc]initWithURL:okUrlS Path:self.willSavePath];//将要存储的位置
        [self.down BegindownProgress:^(long long totalReceivedContentLength, long long totalContentLength) {
            NSLog(@"下载--- totalReceivedContentLength  %lld  totalContentLength =%lld",totalReceivedContentLength,totalContentLength);
        } Succeed:^(NSString *URL, NSString *path) {
            NSLog(@"Succeed path %@",path);
            NSTimeInterval timeIntV = [[LGAudioPlayer sharePlayer]getPathStrVoiceDurationNumWithPathStr: path];
                NSLog(@"\n 这个音频时长:%lf", timeIntV);

            if (timeIntV<=0) {
                Y_SVP_SHOW_ERR_MES(@"音频数据下载失败 暂不可播放");
                [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:0.1];//立即暂停语音cell的动画
                return;
            }
            [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:path];
            [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:timeIntV];//未播放完+离开播放页时 会调用两次voiceEndNoticeWithMsgId


        } Failure:^{
            NSLog(@"下载失败");
            Y_SVP_SHOW_ERR_MES(@"音频数据 下载失败！");
        }];
    
    
   
    

}
//- (void)voiceDownDataWithAlLUrlStr:(NSString *)okUrlS{
//    WEAKSELF
//    [[ToolOfNetWork sharedTools]YrequestDownloadFilePostURLNotMainQueueWithAll:okUrlS withSavePathUrl:[NSURL URLWithString:self.willSavePath] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
//
//        if (isNotNil(responsObject)) {
//
//                NSURL *url = [NSURL fileURLWithPath:self.willSavePath];
//                weakSelf.audio = nil;
//                weakSelf.audio = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//                NSTimeInterval timeIntV =  weakSelf.audio.duration;
//                NSLog(@"\n --这个音频时长:%lf", timeIntV);
//                [weakSelf.audio prepareToPlay];
//                weakSelf.audio.numberOfLoops = 0;
//                weakSelf.audio.delegate = weakSelf;
//                weakSelf.audio.volume = 1;//
//                weakSelf.audio.currentTime = 0;//可以指定从任意位置开始播放
//                [weakSelf.audio play];
//                [self performSelector:@selector(voiceEndNoticeWithMsgId:) withObject:self.saveMsgIdArr.lastObject afterDelay:timeIntV];
//
//
//        }else{
//            Y_SVP_SHOW_ERR_DESCRIPTION
//            weakSelf.audio = nil;
//        }
//
//    }];
//}


#pragma mark == 结束动画相关   通知
- (void)voiceEndNoticeWithMsgId:(NSString *)chatMsgId{
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatVoicePalyingEnd_NoticeName, chatMsgId);
    if ([self.saveMsgIdArr containsObject:chatMsgId]) {
        [self.saveMsgIdArr removeObject:chatMsgId];
    }
    NSLog(@"通知已发 %@  saveFileIdArr  == %@",chatMsgId,self.saveMsgIdArr);
}

#pragma mark ==
- (NSMutableArray *)saveMsgIdArr{
    WEAKSELF
    if (!_saveMsgIdArr) {
        _saveMsgIdArr = [[NSMutableArray alloc]init];
        [weakSelf addNotice];
    }
    return _saveMsgIdArr;
}
@end
