//
//  ChatVoiceDataDealTool.m
//  Community
//
//  Created by 余莹 on 2021/5/21.
//

#import "ChatVoiceDataDealTool.h"
#import "LVRecordTool.h"
#import "ChatManagerData.h"
#import "ChatVoiceDataDealChangeCafToAmr.h"

 
@interface ChatVoiceDataDealTool ()<LVRecordToolDelegate>
/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

//
@property (nonatomic,strong) NSString *thisRecordVoiceName;//录音用的名字
@property (nonatomic,strong) NSString *thisPlayVoiceName;//播放用的名字
@property (nonatomic,strong) NSString *nowChatSessId;//发送上传使用的聊天会话参数
@end

@implementation ChatVoiceDataDealTool
singleton_implementation(share)
#pragma mark ============
///**
// 录音 开始
// */
//- (void)voiceStartRecord{
// //stringByAppendingPathComponent  路径相关拼接 字符串变量时 有/
//    /**
//     * 改成了固定的录音地址
//     *NSString *subVoiceNameStr = [NSString stringWithFormat:@"%@.caf",[ToolOfTimeChangeFormat currentTimeStr]];//名字加字母前缀
//     self.thisRecordVoiceName = [@"EHome" stringByAppendingPathComponent:subVoiceNameStr];
//     self.thisRecordVoiceName = [NSString stringWithFormat:@"EHome%@.caf",[ToolOfTimeChangeFormat currentTimeStr]];//名字加字母前缀
//     [self.recordTool filleVoiceName:self.thisRecordVoiceName];
//     *
//     *
//     */
//    [self.recordTool startRecording];
//}
//
//
//#pragma mark ============
///**
// 录音 结束
// */
//- (void)voiceEndRecord{
//    [self.recordTool stopRecording];
//    //结束录制后 处理文件 发送文件
//    [self performSelector:@selector(recordEndDeal) withObject:nil afterDelay:0.1];//延时
//}
//
/**
 录音 开始
 */
- (void)voiceStartRecordWithChatSessionId:(NSString *)chatSessionIdStr{
    self.nowChatSessId = chatSessionIdStr;
    [[LGSoundRecorder shareInstance]startSoundRecord:nil recordPath:Ehome_Voice_RecordFileUrl_Str];
}


#pragma mark ============
/**
 录音 结束
 */
- (void)voiceEndRecordWithIsSendInfoBool:(BOOL)isSendInfoBool{
    [[LGSoundRecorder shareInstance]stopSoundRecord:nil];
    if (isSendInfoBool) {//取消录音 （去发送｜｜取消发送）
        //结束录制后 处理文件 发送文件
        [self performSelector:@selector(recordEndDeal) withObject:nil afterDelay:0.1];//延时
    }

}
 
- (void)recordEndDeal{
    [self chatWillSendVoiceFile];
}

/**
 发送文件 成功后 发送dic
 */

- (void)chatWillSendVoiceFile{
    //caf格式时使用 暂时保留
//  改成固定的录音地址
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *filePath = [path stringByAppendingPathComponent: self.thisRecordVoiceName];
//    NSURL *recordFileUrl = [NSURL fileURLWithPath:filePath];
                         
//    WEAKSELF
//     [ChatManagerData chatWillSendOneVoiceFileWithVoicePathUrl:Ehome_Voice_RecordFileUrl withGetDicBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            DLog(@"结束录制后 发送文件");
//
//            NSString *getFileUUIDStr = [[dic allKeys]containsObject:@"uuid"] ? [dic objectForKey:@"uuid"] : @"";//用url  用uuid 后续再看
//            if (getFileUUIDStr.length>0) {
//                weakSelf.voiceGetWillSendFileUUIDBlock(getFileUUIDStr);
//            }
//        }
//    }];
         
    
        //car转amr格式
        NSString *cafPathStr = Ehome_Voice_RecordFileUrl_Str;
        [ChatVoiceDataDealChangeCafToAmr  changeCafToAmrWithCafPath:cafPathStr withCafToAmrBlock:^(NSString *newPathStr, BOOL success) {
            NSURL *willSendPathUrl = Ehome_Voice_RecordFileUrl ;
            if (success) {
                willSendPathUrl = Ehome_Voice_RecordFileUrl_Amr;
    
            }else{
                Y_SVP_SHOW_ERR_MES(@"语音转型失败");
                return;
            }
//            WEAKSELF
//             [ChatManagerData chatWillSendOneVoiceFileWithVoicePathUrl:willSendPathUrl withGetDicBlock:^(NSDictionary * dic, BOOL success) {
//                if (success) {
//                    DLog(@"结束录制后 发送文件");
//
//                    NSString *getFileUUIDStr = [[dic allKeys]containsObject:@"uuid"] ? [dic objectForKey:@"uuid"] : @"";//用url  用uuid 后续再看
//                    if (getFileUUIDStr.length>0) {
//                        weakSelf.voiceGetWillSendFileUUIDBlock(getFileUUIDStr);
//                    }
//                }
//            }];
            //1026新
            if (self.nowChatSessId.length==0) {
                return;
            }
            WEAKSELF
            [ChatManagerData chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:self.nowChatSessId withSendOneVoiceFileWithVoicePathUrl:willSendPathUrl withGetDicBlick:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"结束录制后 发送文件 已发送 = %@",dic);
                    if (isNotNil( weakSelf.voiceGetWillSendDicBlock)) {
                        weakSelf.voiceGetWillSendDicBlock(dic);
                    }
             
//                    NSString *getFileUUIDStr = [[dic allKeys]containsObject:@"uuid"] ? [dic objectForKey:@"uuid"] : @"";//用url  用uuid 后续再看
//                    if (getFileUUIDStr.length>0) {
//                        weakSelf.voiceGetWillSendFileUUIDBlock(getFileUUIDStr);
//                    }
                }
            }];
        }];
    
    
   
}

 

#pragma mark ============
/**
 * 播放
 */
- (void)voicePlayWithName:(NSString *)playName{
    self.thisPlayVoiceName = playName;
    [self.recordTool filleVoiceName:self.thisPlayVoiceName];
    [self.recordTool playRecordingFile];
}
#pragma mark ============

- (LVRecordTool *)recordTool{
    if (!_recordTool) {
        _recordTool = [LVRecordTool sharedRecordTool];
    }
    return _recordTool;
}


@end
