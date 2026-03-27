//
//  ChatVoiceDataDealChangeCafToAmr.m
//  Community
//
//  Created by 余莹 on 2021/6/26.
//

#import "ChatVoiceDataDealChangeCafToAmr.h"

@implementation ChatVoiceDataDealChangeCafToAmr
 
+ (void)changeCafToAmrWithCafPath:(NSString *)cafPath withCafToAmrBlock:(CafToAmrBlock)block{
//    NSData *amrData  = [[LGSoundRecorder shareInstance]convertCAFtoAMR:cafPath];
//    if (amrData.length==0) {
//        NSLog(@"CafToAmr 失败");
//        block(@"",NO);
//        return;
//    }
//    [amrData writeToFile:Ehome_Voice_RecordFileUrl_Amr_Str atomically:YES];
    
    NSString *cafPathStr = Ehome_Voice_RecordFileUrl_Str;//录音caf 已存在的语音
    NSString *willSaveAmrPahtStr = Ehome_Voice_RecordFileUrl_Amr_Str; //将要保存amr转型结束后的地址
    BOOL succeedWithCafChangeToAmr =   [[LGSoundRecorder shareInstance] cafChangeToAmrWithHaveCafPathStr:cafPathStr andWillSaveAmrPahtStr:willSaveAmrPahtStr];
    if (succeedWithCafChangeToAmr) {
//        [[LGAudioPlayer sharePlayer] playAudioWithNotIndexURLString:willSaveAmrPahtStr];//播放。转型时 发送 暂不播放
    }else{
        NSLog(@"caf转amr失败 暂用caf上传");
        block(Ehome_Voice_RecordFileUrl_Str,NO);
        return;
    }
    
    
    block(Ehome_Voice_RecordFileUrl_Amr_Str,YES);
    return;
}

@end
