//
//  NUIManager.m
//  阿里语音demo
//
//  Created by 余莹 on 2021/12/8.
//

#import "NUIManager.h"
 
#import "NUI/nuisdk.framework/Headers/NeoNui.h"
#import "NUI/audio/NlsVoiceRecorder.h"
#import "NuiSdkUtils.h"

#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>

#import "NUITokenInfoModel.h"
 
static NSString *app_Key =      @"00aJ6YTKAum6C5BT";
//static NSString *app_token =    @"2202177b4f2a439aa8534675b30247c7";


static BOOL save_wav = NO;
static BOOL save_log = NO;

@interface NUIManager () <NlsVoiceRecorderDelegate, NeoNuiSdkDelegate>
@property(nonatomic,strong) NeoNui* nui;
@property(nonatomic,strong) NlsVoiceRecorder *voiceRecorder;
@property(nonatomic,strong) NuiSdkUtils *utils;
@property(nonatomic,strong) NSMutableData *recordedVoiceData;



@end
@implementation NUIManager

-(void)dealloc{
    TLog(@" /n NUIManager dealloc %s",__FUNCTION__);
    [_nui nui_release];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initAll];
    }
    return self;
}
- (void)initAll{
    
    _voiceRecorder = [[NlsVoiceRecorder alloc] init];//录音的
    _voiceRecorder.delegate = self;

    _utils = [NuiSdkUtils alloc];
 
    [self initNui];
  
}

- (void)initNui{
    if (_nui == NULL) {
        _nui = [NeoNui get_instance];
        _nui.delegate = self;
    }
    //请注意此处的参数配置，其中账号相关需要在Utils.m getTicket 方法中填入后才可访问服务
    NSString * initParam = [self genInitParams];
    /** nui_initialize
         * 初始化SDK，SDK为单例，请先释放后再次进行初始化。请勿在UI线程调用，可能引起阻塞。
         * @param parameters: 初始化参数，参见接口说明文档
         * @param level: log打印级别，值越小打印越多
         * @param save_log: 是否保存log为文件，存储目录为parameter中的debug_path字段值
         * @return 参见错误码
         */

    [_nui nui_initialize:[initParam UTF8String] logLevel:LOG_LEVEL_VERBOSE saveLog:save_log];
    NSString * parameters = [self genParams];
    /**
         * 以JSON格式设置参数
         * @param params: 参数信息请参见接口说明文档
         * @return 参见错误码
         */
    [_nui nui_set_params:[parameters UTF8String]];
}

- (void)beginNui{
    NSLog(@"beginNui");
    if (_nui != nil) {
        [_nui nui_dialog_start:MODE_P2T dialogParam:NULL];
    } else {
        TLog(@"in StartButHandler no nui alloc");
    }
   
}
- (void)endNui{
    NSLog(@"endNui");
    self.recordedVoiceData = nil;
    
    if (_nui != nil) {
        [_nui nui_dialog_cancel:NO];
        [_voiceRecorder stop:YES];
    }
}

#pragma mark ==
- (NSString *)genInitParams{

    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    NSString *bundlePath = [[NSBundle bundleWithPath:strResourcesBundle] resourcePath];
    NSString *id_string = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *debug_path = [_utils createDir];

    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    [dictM setObject:bundlePath forKey:@"workspace"];
    [dictM setObject:debug_path forKey:@"debug_path"];
    [dictM setObject:id_string forKey:@"device_id"];
    [dictM setObject:save_wav ? @"true" : @"false" forKey:@"save_wav"];
    
    //从阿里云获取appkey和token进行语音服务访问
    [dictM setObject:app_Key forKey:@"app_key"];
    
//    [dictM setObject:app_token forKey:@"token"];

    //由于token 24小时过期，可以参考getTicket实现从阿里云服务动态获取
    [_utils getTicket:dictM];
    [dictM setObject:@"wss://nls-gateway.cn-shanghai.aliyuncs.com:443/ws/v1" forKey:@"url"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

-(NSString*)genParams{
    NSMutableDictionary *nls_config = [NSMutableDictionary dictionary];
    [nls_config setValue:@YES forKey:@"enable_intermediate_result"];
//    参数可根据实际业务进行配置
//    [nls_config setValue:@YES forKey:@"enable_punctuation_prediction"];
//    [nls_config setValue:@YES forKey:@"enable_inverse_text_normalization"];
//    [nls_config setValue:@YES forKey:@"enable_voice_detection"];
//    [nls_config setValue:@10000 forKey:@"max_start_silence"];
//    [nls_config setValue:@800 forKey:@"max_end_silence"];
//    [nls_config setValue:@800 forKey:@"max_sentence_silence"];
//    [nls_config setValue:@NO forKey:@"enable_words"];
//    [nls_config setValue:@16000 forKey:@"sample_rate"];
//    [nls_config setValue:@"opus" forKey:@"sr_format"];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setObject:nls_config forKey:@"nls_config"];
    [dictM setValue:@(SERVICE_TYPE_SPEECH_TRANSCRIBER) forKey:@"service_type"];
//    如果有HttpDns则可进行设置
//    [dictM setObject:[_utils getDirectIp] forKey:@"direct_ip"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
#pragma mark ==
#pragma mark - Voice Recorder Delegate
/**
 * @discuss Recorder启动回调，在主线程中调用
 */
-(void) recorderDidStart{
    TLog(@"recorderDidStart");
}

-(void) recorderDidStop{
    [self.recordedVoiceData setLength:0];
    TLog(@"recorderDidStop");
}

-(void) voiceRecorded:(NSData*) frame{
    @synchronized(_recordedVoiceData){
        [_recordedVoiceData appendData:frame];
    }
}
//录音机无法打开或其他错误的时候会回调
-(void) voiceDidFail:(NSError*)error{
    TLog(@"recorder error ");
}


/** json 转dic*/
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil || [jsonString isEqualToString:@""]) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark - Nui Listener
-(void)onNuiEventCallback:(NuiCallbackEvent)nuiEvent
                   dialog:(long)dialog
                kwsResult:(const char *)wuw
                asrResult:(const char *)asr_result
                 ifFinish:(BOOL)finish
                  retCode:(int)code {
    TLog(@"onNuiEventCallback event %d finish %d", nuiEvent, finish);
    if (nuiEvent == EVENT_ASR_PARTIAL_RESULT || nuiEvent == EVENT_ASR_RESULT || nuiEvent == EVENT_SENTENCE_END) {
        TLog(@"ASR RESULT %s finish %d", asr_result, finish);
        NSString *result = [NSString stringWithUTF8String:asr_result];
        //[myself showAsrResult:result];
        NSLog(@"onNui result======= %@",result);
//        self.getInfoBlock(result);
        /**
         
         {"header":{"namespace":"SpeechTranscriber","name":"SentenceEnd","status":20000000,"message_id":"deaa98e25ba64a3c9c2f4e78e448c2d4","task_id":"9fa3676d5e074be0a488ddfee790a33c","status_text":"Gateway:SUCCESS:Success."},"payload":{"index":1,"time":990,"result":"医疗","confidence":0.812,"words":[],"status":20000000,"gender":"","begin_time":30,"stash_result":{"sentenceId":0,"beginTime":0,"text":"","currentTime":0,"words":[]},"audio_extra_info":"{}","sentence_id":"7f10beee9fce4a5f8aa33a945795f070","gender_score":0.0}}
         */
        NSDictionary *rDic = [self dictionaryWithJsonString:result];
        if ([[rDic allKeys] containsObject:@"payload"]) {
            NSDictionary *rP = [[NSDictionary alloc]initWithDictionary:[rDic objectForKey:@"payload"]];
            if ([[rP allKeys] containsObject:@"result"]) {
                NSString *rStr = [rP objectForKey:@"result"];
                NSLog(@" \n rSt ===%@  \n",rStr);
                if (rStr.length > 0) {
                    if (!_getInfoBlock) {
                        NSLog(@"block nil");
                    }else{
                        self.getInfoBlock(rStr);
                    }
                }
            }
        }
   
    } else if (nuiEvent == EVENT_ASR_ERROR) {
        TLog(@"EVENT_ASR_ERROR error[%d]", code);
    } else if (nuiEvent == EVENT_MIC_ERROR) {
        TLog(@"MIC ERROR");
        [_voiceRecorder stop:YES];
        [_voiceRecorder start];
    }
    //finish 为真（可能是发生错误，也可能是完成识别）表示一次任务生命周期结束，可以开始新的识别
    if (finish) {
        // UI更新代码
        NSLog(@"UI更新代码= onNuiEventCallback");
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
    }
    
    return;
}

-(int)onNuiNeedAudioData:(char *)audioData length:(int)len {
    static int emptyCount = 0;
    @autoreleasepool {
        @synchronized(_recordedVoiceData){
            if (_recordedVoiceData.length > 0) {
                int recorder_len = 0;
                if (_recordedVoiceData.length > len)
                    recorder_len = len;
                else
                    recorder_len = _recordedVoiceData.length;
                NSData *tempData = [_recordedVoiceData subdataWithRange:NSMakeRange(0, recorder_len)];
                [tempData getBytes:audioData length:recorder_len];
                tempData = nil;
                NSInteger remainLength = _recordedVoiceData.length - recorder_len;
                NSRange range = NSMakeRange(recorder_len, remainLength);
                [_recordedVoiceData setData:[_recordedVoiceData subdataWithRange:range]];
                emptyCount = 0;
                return recorder_len;
            } else {
                if (emptyCount++ >= 50) {
                    TLog(@"_recordedVoiceData length = %lu! empty 50times.", (unsigned long)_recordedVoiceData.length);
                    emptyCount = 0;
                }
                return 0;
            }

        }
    }
    return 0;
}

-(void)onNuiAudioStateChanged:(NuiAudioState)state{
    TLog(@"onNuiAudioStateChanged state=%u", state);
    if (state == STATE_CLOSE || state == STATE_PAUSE) {
        [_voiceRecorder stop:YES];
    } else if (state == STATE_OPEN){
        self.recordedVoiceData = [NSMutableData data];
        [_voiceRecorder start];
    }
}

-(void)onNuiRmsChanged:(float)rms {
    TLog(@"onNuiRmsChanged rms=%f", rms);
}

 

@end
