//
//  ChatManagerData.m
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import "ChatManagerData.h"
#import "ChatSeverConnectionBegin.h"
//#define kMobile              [JGSaveIdShare sharedUserInfo].registrationID
#define kMobile              @"mobile"
//#define OPEN_ID              @"dd7186834b30422984643cb446ba0055"
//#define AES_KEY              @"dabd408a37ae486ea42dee52c6bd83bf"
//#define AES_IV               @"cvm472mmvb7ei5z6"
//-----
//#define  secret_key          @"I|e7=N&?MUP?AnSwa0XNfXn^NewMsK:z"
//#define  secret_iv           @"363}&ODSGrEuC9p6"

//0918
static NSString * ImPhoneType = @"ios";
static NSString * ImOsInfo = @"com.zhsj.ios.ehome";

//0903改openid
#define OPEN_ID              @"open_7dcad41c19c24e7da0a61ab465c58bc0"
//0903更改key iv
#define  AES_KEY          @"I|e7=N&?MUP?AnSwa0XNfXn^NewMsK:z"
#define  AES_IV           @"363}&ODSGrEuC9p6"

#define  IM_Message_Mobul_MD5_Use_KEY     @"[13464$8$0_*_^^_L"

#import "ChatAESTool.h"

#import "ChatMd5WillModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
//
#import "RSA.h"
#import "ChatServiceGetDataDecModel.h"

//
static NSString *kSend_File_Key = @"Z]q?opaKvcFX8Ie9{S-g#~H$H@hhIK,2";
static NSString *kSend_File_Obj = @"9991";

//
static NSString *const kDBShmFileName = @"manifest.sqlite-shm";

static  NSString *const kRSA_PubKey= @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnDjCyZsLMglbAzdvePlWjThebAEs4ypASwQLFavAEOE7695nyZHImVIiRa+AVWLAYNrup1DkK/CQwzS09r0Llzq3tr2syMFSn8jCzDPSOcstyjI9dFRkNb/rRD6BYh1Y/Ute/G7LLMc+BRs6TiParbTeUgaUSiM0+1GEAyrPDkMhezSJa8hYMBPelhuoOMz3tZFHDAtT3xwnpk9LXJnjrozHY3znWl4SB62JTMoJLBI5g/IkGaEOPAooNvajLwSbbzHOugHUSNQ33b1OQBL3tELWt/EtGMcbXwTWrmuDxf6K+UA37HiDW/ppEtXpAdvSCHBhRipU3q70SWRC+x1BswIDAQAB";

static  NSString *const kRSA_PrivKey=@"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCcOMLJmwsyCVsDN294+VaNOF5sASzjKkBLBAsVq8AQ4Tvr3mfJkciZUiJFr4BVYsBg2u6nUOQr8JDDNLT2vQuXOre2vazIwVKfyMLMM9I5yy3KMj10VGQ1v+tEPoFiHVj9S178bsssxz4FGzpOI9qttN5SBpRKIzT7UYQDKs8OQyF7NIlryFgwE96WG6g4zPe1kUcMC1PfHCemT0tcmeOujMdjfOdaXhIHrYlMygksEjmD8iQZoQ48Cig29qMvBJtvMc66AdRI1DfdvU5AEve0Qta38S0YxxtfBNaua4PF/or5QDfseINb+mkS1ekB29IIcGFGKlTervRJZEL7HUGzAgMBAAECggEAQwe3zHlSHG4XNxIaKnYRxRZirUTz1aTTYVyixPGkv5lk9JfBQKPkxqSPQAdFsV1l3ikSLYhv3sqh0qBS5WvIBWOUYDySXrFUmmqx6pxxn4qmYxObesabGNT4RZfsPAULoeMtJnMDinsTCW3dXpnTwqTQn7Fi/0yL9ynK0vETVrKW/LsweY2OhOtDo2/EsLKEE6j9kuA5Vxj+vjpuego4TJZf+b91OzFHaqh98l8/wKDEh1rV/HQkC/tsp3m7C3Ktf81azwQSCR8McgDSFKFVD8ckpi+qtwFDwixh2d7kXursnDE33Obi0dkT6VUrj+BMgUB3B/lnVW7lMa7fw7BEQQKBgQD776NK/uTW0cCK4vJBakAuPc1/ApgblJYIO+X4GGpdZe4T4ffAgFZb1MXdwAIjayMdppDfhygDOcpq248UzYCFtA+I71UZg2NhhQDpgbFFZZqpFC0uC4bbJh2NGAbiDi01IMjvY7mEYLxVGjRcASgu9JaEtxrsPWnNOmGv+BEEZQKBgQCevd+imOV4mzIcbuNo/M3/9jnBhRBZp1yg/RTxxzOnlAMFOIyEV5qWaKeleplEN1ofgVPkJpdWBffZlsa5Fd2V0VI+iqquRRpozLUSwm3YBgGlncETKkYypPuktvEQu2SRI0hqkC+q7ZZxLC90DHcTJmCrLPQH2ThiHnxoKgMQNwKBgAY0WqMoL96Sf9lryWePBFGfOAZeu/xB5ogBYaKAh24RapGWyRE2l+nfDZhueB8DLnQ2e+7lVzjtHW0QRy/N99JTIubObhwYvkPSkLkvdnwtCmgLlSlDI2kWQTgOVW0PyFE8o3Yx0InQEBNQd+WkKacuYt6V29XhlU92lp1M0K55AoGAUZc8XCGESMJUNmMUhgDyjO5s7zfKmJo6NRD/8+m0dhzQlJ1lNBym+0odaSOjpXlh3DGoAeuH+5Iju3YQ/E7tzrSBNl4lrl8cXONi6pp+xPsJW6vC8mvXGu7L3PSe4T/ASA0/im5D4fIuUksotNg3V+Nw6mq3n1UZ8uzCevOlEW8CgYBGKOuX7JyILKM5tW+Gy+U1HILYHRVAhb1lKXI+SjnaW6q0cQjXN7h7XWaciAWksDnn+yd8S+qZBveOGN+CF9VlcnKj6QXFWoqrUQvB5/RSeMri6Zcs4RyhPL7y1nFjZFASgkhujNIfX74Ctv8O/6l4hyPpy2cV7NER9rM79SrWAw==";


@interface ChatManagerData ()
@end
@implementation ChatManagerData

+ (void)useAesGetRsa{
}
/**
 *一：交换秘钥（分为两步）
 1、交换服务端的AES key和iv （目的是为获得服务端的AES key 和 iv）
 */
+ (void)sendUserImId:(NSString *)ImId  andGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (ImId.length==0) {
        Y_SVP_SHOW_ERR_MES(@"暂不支持即时通讯");
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //0902增加imPassword+推送id
    //@"XXX"
    NSString *jgRId = [JGSaveIdShare sharedUserInfo].registrationID;
    [dic setValue:jgRId forKey:@"pushId"];//推送
    [dic setValue:JG_Appkey forKey:@"appkey"];//极光推送appkey
    [dic setValue:ImPhoneType forKey:@"phoneType"];
    [dic setValue:ImOsInfo forKey:@"osInfo"];//数据待增   //@"iOS"
    NSString *password = [ShareUserInfo sharedUserInfo].userInfo.imPassword;
//     [dic setValue:@"test_0009" forKey:@"userToken"];
//    [dic setValue:@"1234" forKey:@"password"];
    [dic setValue:ImId forKey:@"userToken"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:OPEN_ID forKey:@"open_id"];
    [dic setValue:kMobile forKey:@"deviceMark"];
    NSString *pubK = kRSA_PubKey;
//    [ShareSaveAesAndRsa sharedUserInfo].slefRsa_PublicKey = pubK;
    [dic setValue:pubK forKey:@"clientRsaPublicKey"];//客户端的RSA的公钥

   
    //转json
    NSString *jsonStr = [Tool jsonStrWithDic:dic];
    //aes加密
    NSString *jsonAesOk = [ChatAESTool chatTypeEncryptAESLocallyStoredKeyAndIvWithConnectStr:jsonStr];
    //md5签名
    ChatMd5WillModel *md5willModel = [[ChatMd5WillModel alloc]init];
    md5willModel.data = jsonAesOk;
    md5willModel.device_mark = kMobile;
    md5willModel.open_id = OPEN_ID;
    md5willModel.secretKey = AES_KEY;
    md5willModel.time = [ToolOfTimeChangeFormat currentTimeStr];
    NSString *md5willStr = [NSString stringWithFormat:@"data=%@&open_id=%@&secretKey=%@&time=%@&", md5willModel.data, md5willModel.open_id,  md5willModel.secretKey, md5willModel.time ];
    NSString *md5Ok = [ChatAESTool chatMD5ForString:md5willStr];
    //
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:OPEN_ID forKey:@"open_id"];
    [parms setValue:kMobile forKey:@"deviceMark"];
    [parms setValue:jsonAesOk forKey:@"data"];//aes
    [parms setValue:md5Ok forKey:@"signature"];//md5
    [parms setValue:md5willModel.time forKey:@"time"];//md5里的时间戳
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_ChangSeverAES withParams:parms finished:^(id responsObject, NSError *error) {//154success
       
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                [self getServiceDataWithDic:responsObject  andGetWebSocketInfoBlcok:dicBlock];
            }else{
                DLog(@"   %@",error);
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
           // Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}


/**
 *保存动态的服务器aeskeyiv
 */
+ (void)getServiceDataWithDic:(NSMutableDictionary *)res  andGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *resDataStr =  res[@"data"];
    //rsa解密
    NSString *privKey = kRSA_PrivKey;
//    [ShareSaveAesAndRsa sharedUserInfo].slefRsa_PrivateKey = privKey;
    //rsa密钥解密data
    NSString * decWithPrivKey = [RSA decryptString:resDataStr privateKey:privKey];
    NSDictionary *dataDic = [Tool dictionaryWithJsonString:decWithPrivKey];
    
    ChatServiceGetDataDecModel *getDataDecModel = [ChatServiceGetDataDecModel mj_objectWithKeyValues:dataDic];
    //得到key iv     //保存更新
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Key = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.serverAesKey];
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.aesIv];;
    //保存token id
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.userToken];
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.userUuid];;
    DLog(@"_____得到key iv  %@   %@",  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Key,  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv);
    DLog(@"_____得到imutoken = %@   uuid= %@",  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken,  [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid);
    //0902增token
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.token];
    [[NSUserDefaults standardUserDefaults] setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token     forKey:@"chatUseContactTheMerchantHeader_Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //下一个接口
    [self sendCleivAESInfo:getDataDecModel andGetWebSocketInfoBlcok:dicBlock];
    
}
/**
 2、交换客户端的AES key（目的是将客户端的AES key 送到服务端）
 
 */
+ (void)sendCleivAESInfo:(ChatServiceGetDataDecModel *)getDataDecModel andGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *userUuid = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.userUuid];
    NSString *userToken = [TextShowWithModelStr textShowWithModelStr:getDataDecModel.userToken];
    //_______data aes
    NSMutableDictionary *willAesDic = [[NSMutableDictionary alloc]init];
    [willAesDic setValue:userUuid forKey:@"userUuid"];
    [willAesDic setValue:userToken forKey:@"userToken"];
    [willAesDic setValue:AES_KEY forKey:@"clientAesKey"];
    
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    //转json
    NSString *jsonStr = [Tool jsonStrWithDic:willAesDic];
    //aes加密
    NSString *jsonAesOk = [ChatAESTool chatTypeEncryptAESUseServiceKeyIvAndLocalTimeStr:timeStr withStr:jsonStr];//用的key iv 用变化的
    //_______ uuid aes加密 用本地aeskey和Iv
    NSString *uuidAesOk = [ChatAESTool chatTypeEncryptAESLocallyStoredKeyAndIvWithConnectStr:userUuid];//用本地的
    
    //md5签名
    ChatMd5WillModel *md5willModel = [[ChatMd5WillModel alloc]init];
    md5willModel.data = jsonAesOk;
    md5willModel.device_mark = kMobile;
    md5willModel.open_id = OPEN_ID;
    md5willModel.secretKey = AES_KEY;
    md5willModel.time = timeStr;
    NSString *md5willStr = [NSString stringWithFormat:@"data=%@&device_mark=%@&open_id=%@&operator=%@&secretKey=%@&time=%@&", md5willModel.data, md5willModel.device_mark, md5willModel.open_id,uuidAesOk , md5willModel.secretKey, md5willModel.time ];//deviceMark
    NSString *md5Ok = [ChatAESTool chatMD5ForString:md5willStr];
    
    //
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:OPEN_ID forKey:@"open_id"];
    [parms setValue:kMobile forKey:@"deviceMark"];
    [parms setValue:jsonAesOk forKey:@"data"];//aes
    [parms setValue:uuidAesOk forKey:@"operator"];//aes
    [parms setValue:md5Ok forKey:@"signature"];//md5
    [parms setValue:timeStr forKey:@"time"];//md5里的时间戳
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_ChangClientAES withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                [self saveImInfoWithResDic:responsObject andGetWebSocketInfoBlcok:dicBlock];
                //NSLog(@"%@",responsObject[@"msg"]);
            }else{
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
           // Y_SVP_SHOW_ERR_DESCRIPTION
        }
       
    }];
}
+ (void)saveImInfoWithResDic:(NSMutableDictionary *)dic andGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *dataStr  =   dic[@"data"];
    NSString *timeStr =  dic[@"time"];
    
    NSString *aesDecStr = [ChatAESTool  chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:timeStr withStr:dataStr];//[ChatAESTool chatTypeChangeServiceDecryptDataWithStr:dataStr];
    
    NSDictionary *dataDic = [Tool dictionaryWithJsonString:aesDecStr];
    NSString*ip = dataDic[@"tcp_ip"];
    NSString*post = dataDic[@"tcp_port"];
    DLog(@"%@ %@ %@",aesDecStr ,ip ,post);//{"tcp_ip":"222.178.212.29","tcp_port":19872}
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].tcp_ip = ip;
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].tcp_port = post;
    [self getWebSocketInfoAndGetWebSocketInfoBlcok:dicBlock];
}

+ (void)getWebSocketInfoAndGetWebSocketInfoBlcok:(BaseDicAndSuccessBoolBlock)dicBlock{
    //
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    //@"XXX"
    NSString *pushId = [JGSaveIdShare sharedUserInfo].registrationID;//推送id
    //md5签名
    ChatMd5WillModel *md5willModel = [[ChatMd5WillModel alloc]init];
 
    md5willModel.device_mark = kMobile;
    md5willModel.open_id = OPEN_ID;
    md5willModel.secretKey = AES_KEY;
    md5willModel.time = timeStr;
    NSString *md5willStr = [NSString stringWithFormat:@"device_mark=%@&open_id=%@&pushId=%@&secretKey=%@&uToken=%@&",md5willModel.device_mark, md5willModel.open_id,pushId, md5willModel.secretKey,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken];//deviceMark
    NSString *md5Ok = [ChatAESTool chatMD5ForString:md5willStr];
    NSString *url = [NSString stringWithFormat:@"ws://%@:%@/zh_im/websocket",[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].tcp_ip,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].tcp_port];
    NSString *endStr = [NSString stringWithFormat:@"uToken=%@&sign=%@&pushId=%@&open_id=%@&device_mark=%@",[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken,md5Ok,pushId,md5willModel.open_id, md5willModel.device_mark] ;

    NSString* strOfIrlEncodingStr = [Tool URLEncodedString:endStr];
    NSString *allUrlStr = [NSString stringWithFormat:@"%@?param=%@",url,strOfIrlEncodingStr];
    NSLog(@"---getWebSocketInfoAndGetWebSocketInfoBlcokr = %@ \n ==================utoken str == %@",allUrlStr,strOfIrlEncodingStr);
    
    dicBlock(@{@"url":allUrlStr},YES);
}


 

#pragma  mark ========================================================================  收到的 socket数据 解析
/**
 *解析收到的socket数据
 */
+ (NSString *)useMessageDicGetDecStr:(NSDictionary *)dic{
    NSString *dataStr = @"";
    if ([[dic objectForKey:@"code"] intValue] == 154) {
        NSString *data = [NSString stringWithString: isNotNil([dic objectForKey:@"data"])?[dic objectForKey:@"data"]:@""];
        NSString *time = [NSString stringWithString:[dic objectForKey:@"time"]];
        if ( isNil(data) || [data isEqualToString:@""] ) {
            return @"";
        }
        //解密 本地的key+ data_time+服务器iv
        NSString *aesDecStr = [ChatAESTool chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:time withStr:data];
        
        return aesDecStr;
    }else{
        dataStr = @"数据解析过程中出现错误";
    }
    
    return dataStr;
}
/**
 *解析收到的socket数据 处理code==0的解析
 */
+ (NSString *)useMessageDicGetDecStrWhenCodeIsZero:(NSDictionary *)dic{
    NSString *dataStr = @"";
    if ([[dic objectForKey:@"code"] intValue] == 0) {
        NSString *data = [NSString stringWithString: isNotNil([dic objectForKey:@"data"])?[dic objectForKey:@"data"]:@""];
        NSString *time = [NSString stringWithString:[dic objectForKey:@"time"]];
        if ( isNil(data) || [data isEqualToString:@""] ) {
            return @"";
        }
        //解密 本地的key+ data_time+服务器iv
        NSString *aesDecStr = [ChatAESTool chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:time withStr:data];
        
        return aesDecStr;
    }else{
        dataStr = @"数据有误";
    }
    
    return dataStr;
}
#pragma  mark ========================================================================  好友相关 _  请求数据获取 列表数据获取
/**
 *获取好友请求的数据列表
 */
//0909改
/**

+ (void)getImFriendReqInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    //time时间戳
    
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid  forKey:@"from_user"];
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetSelfFriendReqList withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                NSString *getResListInfoRes =   [self useMessageDicGetDecStr:responsObject];
                NSArray *reqFarr = [Tool arrWithJson:getResListInfoRes];
                block(reqFarr,YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
                block(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@[],NO);
        }
       
    }];
}
 */
//获取好友请求的数据列表 查询好友通知列表
+ (void)getImFriendReqInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/friend/listFriendNotify";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(1) forKey:@"pageNum"];
    [bodyDic setValue:@(99999) forKey:@"pageSize"];
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                //数组类型
                NSDictionary *getHavePageDic = [Tool dictionaryWithJsonString:getDecStr];
                NSArray *getArr = [[getHavePageDic allKeys]containsObject:@"data"] ? [NSArray arrayWithArray:[getHavePageDic objectForKey:@"data"]] : @[];
                block(getArr,YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                block(@[],NO);
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}


/**
 *获取好友列表

+ (void)getFriendInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid  forKey:@"from_user"];
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetSelfFriendAllList withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                NSString *getFriendListInfoRes =   [self useMessageDicGetDecStr:responsObject];
                NSArray *farr = [Tool arrWithJson:getFriendListInfoRes];
                block(farr,YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
                block(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@[],NO);
        }
       
    }];
}
 * */
 //0915 好友列表
+ (void)getFriendInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/contact/list/friend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                //数组类型 联系人列表
                NSArray *getArr =  [Tool arrWithJson:getDecStr];
                block(getArr,YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
        
                Y_SVP_SHOW_ERR_MES(msg);
                block(@[],NO);
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//0915 全部联系人
+ (void)getAllContactInfoListWithBlcok:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/contact/list";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                //数组类型 联系人列表
                NSArray *getArr =  [Tool arrWithJson:getDecStr];
                block(getArr,YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                block(@[],NO);
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma  mark ========================================================================  好友相关 _ 添加 同意 拒绝
/** 0908 新
 *添加好友 主动发送申请
 */
+ (void)addFriendWithFriendImIdStr:(NSString *)friendImIdStr withVerifyMessage:(NSString *)verifyMessage withFriendRemark:(NSString *)friendRemark{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"origin"];//通过二维码添加
    [parms setValue:friendImIdStr forKey:@"toImId"];//来源
    [parms setValue:friendRemark forKey:@"friendRemark"];//@"好友备注"
    [parms setValue:verifyMessage forKey:@"remark"]; //添加好友时的备注
    NSString *url = @"zhsj/im/user/friend/addFriend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                Y_SVP_SHOW_SUCCESS_MES(@"提交好友申请成功！");
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
           
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

/**
 *添加好友 主动发送申请
 */
/** 旧

+ (void)addFriendWithFriendUUID:(NSString *)friendUUID withVerifyMessage:(NSString *)verifyMessage withFriendRemark:(NSString *)friendRemark{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:friendRemark forKey:@"friendRemark"];//@"好友备注"
    [dic setValue:@"二维码" forKey:@"origin"];//来源
    [dic setValue:verifyMessage forKey:@"verifyMessage"];//验证消息
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    [dic setValue:OPEN_ID forKey:@"open_id"];//发起方open_id
 
    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友uuid空");
        return;
    }
    if ([friendUUID isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        Y_SVP_SHOW_ERR_MES(@"不能添加自己为好友");
        return;
    }
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self addFriendDic:parms];
}


+ (void)addFriendWithFriendUUID:(NSString *)friendUUID{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];

    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:@"" forKey:@"friendRemark"];
    [dic setValue:@"搜索" forKey:@"origin"];//来源
    [dic setValue:@"" forKey:@"verifyMessage"];//验证消息
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    [dic setValue:OPEN_ID forKey:@"open_id"];//发起方open_id

    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友uuid空");
        return;
    }
    if ([friendUUID isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        Y_SVP_SHOW_ERR_MES(@"不能添加自己为好友");
        return;
    }
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self addFriendDic:parms];
}
+ (void)addFriendDic:(NSMutableDictionary *)parms{
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_AddFriend withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
       
    }];
}
 */
//旧—主动向陌生人提出好友申请—————end
/**
 *添加好友 同意
 */
//添加好友 同意0909 改
+ (void)agreeAddWithFriendNotifyId:(NSString *)friendNotifyId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (friendNotifyId.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友ID空");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:friendNotifyId forKey:@"friendNotifyId"];//好友通知id
    [self agreeAddWithDic:parms  withDicBlock:dicBlock];

}
+ (void)agreeAddWithFriendNotifyId:(NSString *)friendNotifyId withFriendRemark:(NSString *)friendRemark withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (friendNotifyId.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友ID空");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:friendNotifyId forKey:@"friendNotifyId"];//
    [parms setValue:friendRemark forKey:@"friendRemark"];//同意时，给对方的备注
    [self agreeAddWithDic:parms  withDicBlock:dicBlock];
}
+ (void)agreeAddWithDic:(NSMutableDictionary *)parms  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
 
    NSString *url = @"zhsj/im/user/friend/agreeFriend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                Y_SVP_SHOW_SUCCESS_MES(@"已提交同意！");
                dicBlock(getDic,YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/**

+ (void)agreeAddWithFriendNotifyId:(NSString *)friendUUID withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友ID空");
        return;
    }
    if ([friendUUID isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        Y_SVP_SHOW_ERR_MES(@"不能添加自己为好友");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:friendUUID forKey:@"friendNotifyId"];//好友通知id
    [self agreeAddWithDic:parms  withDicBlock:dicBlock];
}
+ (void)agreeAddWithFriendNotifyId:(NSString *)friendUUID withFriendRemark:(NSString *)friendRemark withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友ID空");
        return;
    }
    if ([friendUUID isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        Y_SVP_SHOW_ERR_MES(@"不能添加自己为好友");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:friendUUID forKey:@"friendNotifyId"];//
    [parms setValue:friendUUID forKey:@"friendRemark"];//同意时，给对方的备注
    [self agreeAddWithDic:parms  withDicBlock:dicBlock];
}
+ (void)agreeAddWithDic:(NSMutableDictionary *)dic  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"zhsj/im/user/friend/agreeFriend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:dic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic,YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

 */
 
/**

+ (void)agreeAddWithFriendUUID:(NSString *)friendUUID withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [self agreeAddWithFriendUUID:friendUUID withFriendRemark:@"" withDicBlock:dicBlock];
}
+ (void)agreeAddWithFriendUUID:(NSString *)friendUUID withFriendRemark:(NSString *)friendRemark withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@"默认备注" forKey:@"friendRemark"];
    [dic setValue:friendRemark forKey:@"friendRemark"];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友uuid空");
        return;
    }
    if ([friendUUID isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {
        Y_SVP_SHOW_ERR_MES(@"不能添加自己为好友");
        return;
    }
    [self agreeAddWithDic:dic withTimeStr:timeStr withDicBlock:dicBlock];
   
}
+ (void)agreeAddWithDic:(NSMutableDictionary *)dic withTimeStr:(NSString *)timeStr withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_AgreeFriend withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                dicBlock(@{},YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
       
    }];
}
 */
//旧 --添加好友 同意  ______end
/**
 *添加好友 拒绝
 */

+ (void)rejectAddWithFriendNotifyId:(NSString *)friendNotifyId withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"zhsj/im/user/friend/rejFriend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:friendNotifyId forKey:@"friendNotifyId"];//
    [parms setValue:@"" forKey:@"rejMsg"];//拒绝信息
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                Y_SVP_SHOW_SUCCESS_MES(@"已拒绝!");
                dicBlock(@{},YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
           
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

/**
 *添加好友 拒绝
+ (void)rejectAddWithFriendNotifyId:(NSString *)friendUUID withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@"不同意加好友的备注_拒绝" forKey:@"rejMessage"];
    [dic setValue:@"" forKey:@"rejMessage"];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_RejectFriend withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}
 * */
//旧 -- 添加好友 拒绝-- end

/**
 *修改好友备注
 */
/**
 0907 改接口
 + (void)changeFriendRemarkWithFriendUUID:(NSString *)friendUUID withFriendRemark:(NSString *)friendRemark withDic:(BaseDicAndSuccessBoolBlock)block{
     
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
     //time时间戳
     NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
     
     [dic setValue:friendRemark forKey:@"new_to_user_remark"];//@"好友备注"
     [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
     [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
     if (friendUUID.length==0) {
         Y_SVP_SHOW_ERR_MES(@"好友id为空");
         return;
     }
     if (friendRemark.length==0) {
         Y_SVP_SHOW_ERR_MES(@"备注不能为空");
         return;
     }
     NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
     [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_ChangeFriendRemark withParams:parms finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (Y_Success_Or_ErrCode==154) {
                 DLog(@"   %@",responsObject);
                 NSLog(@"%@",responsObject[@"msg"]);
                 NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 Y_SVP_SHOW_SUCCESS_MES(msg);
                 block(@{},YES);
             }else{
                 DLog(@"   %@",error);
                 NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 Y_SVP_SHOW_ERR_MES(msg);
                 block(@{},NO);
             }
         }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
             block(@{},NO);
         }
         
     }];
 }
 */

//修改好友备注
+ (void)changeFriendRemarkWithFriendNotUuidIsIDStr:(NSString *)idStr withFriendRemark:(NSString *)friendRemark withDic:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/contact/updateContactRemark";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
//    [bodyDic setValue:friendUUID forKey:@"id"];
    
    [bodyDic setValue:idStr forKey:@"id"];
    [bodyDic setValue:friendRemark forKey:@"friendRemark"];
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                block( getDic , YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                block(@{},NO);
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];

}

/**
 *删除好友
 */
+ (void)deletFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/friend/deleteFriend";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:friendNotUuidIsInfoId forKey:@"id"];//联系人id（只能删除用户类型，群聊暂时不能删除，公众号暂时不能删除）
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                block( getDic , YES);
                Y_SVP_SHOW_SUCCESS_MES(@"删除好友成功！");
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                block(@{},NO);
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

//旧版本使用
/**
 
+ (void)deletFriendWithFriendUUID:(NSString *)friendUUID withDic:(BaseDicAndSuccessBoolBlock)block{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    if (friendUUID.length==0) {
        Y_SVP_SHOW_ERR_MES(@"好友id为空");
        return;
    }
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_DeletFriend withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                DLog(@"   %@",responsObject);
                NSLog(@"%@",responsObject[@"msg"]);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                block(@{},YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
                block(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            block(@{},NO);
        }
        
    }];
}
*/

/**
 拉黑好友+ 移除黑名单

 */
+ (void)backFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/friend/joinBlackList";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:friendNotUuidIsInfoId forKey:@"id"];//联系人id
    [self backOrWhiteSetFriendWithParms:bodyDic withAllUrl:allUrl withDic:block];
}
+ (void)whiteFriendWithFriendNotUuidIsInfoId:(NSString *)friendNotUuidIsInfoId withDic:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"zhsj/im/user/friend/removeBlackList";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:friendNotUuidIsInfoId forKey:@"id"];//联系人id
    [self backOrWhiteSetFriendWithParms:bodyDic withAllUrl:allUrl withDic:block];
}
+ (void)backOrWhiteSetFriendWithParms:(NSMutableDictionary *)bodyDic withAllUrl:(NSString *)allUrl withDic:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                block( getDic , YES);
                Y_SVP_SHOW_SUCCESS_MES(@"设置成功！");
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                
                Y_SVP_SHOW_ERR_MES(msg);
                block(@{},NO);
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
//黑好友+ 移除黑名单--end
#pragma  mark ======================================================================== 发送数据打包

/**普通加密打包 */
/**房屋商铺租赁时 需要非好友状态情况的聊天申请
 + (void)chatNomalEncryptionWithDic:(NSMutableDictionary *)parmsDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
     NSString *url = @"zh_im/customer-service/customerService/open/contactTheMerchant"; //房屋商铺租赁时 需要非好友状态情况的聊天申请
     NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
     NSMutableDictionary *parms = [self allWillSendParmsCreateWithDataDic:parmsDic withTimeStr:timeStr];
     [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:url withParams:parms finished:^(id responsObject, NSError *error) {//154success
        
         if (isNotNil(responsObject)) {
             if (Y_Success_Or_ErrCode==154) {
               //解密
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                 NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                 dicBlock( getDic , YES);
             }else{
                 DLog(@"   %@",error);
                 NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 Y_SVP_SHOW_ERR_MES(msg);
                 dicBlock(@{},NO);
             }
         }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
         
     }];
 }
 */
//0906改为
//房屋商铺租赁时 需要非好友状态情况的聊天申请
+ (void)chatNomalEncryptionWithDic:(NSMutableDictionary *)parmsDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{//
    NSString *url = @"zhsj/im/user/contact/strangerChat"; //房屋商铺租赁时 需要非好友状态情况的聊天申请
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url); 
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parmsDic finished:^(id responsObject, NSError *error) { //154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock( getDic , YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}


#pragma mark == 发送信息数据整合 ack

/**
 *receiveAck类型
 */
 
+ (void)chatWillSnedReceiveAckwithGetMsgDic:(NSDictionary *)getMsgDic withBlock:(BaseDicBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //______
    if ([[getMsgDic allKeys]containsObject:@"to_group"]) {//存在to_group --群组会话的ack
        [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"to_user"];//群类型 回复ack用自己的id不用群id
    }
    if ([[getMsgDic allKeys]containsObject:@"to_user"]) {//存在to_user --好友会话的ack｜或者系统通知 用已有touser
        [dic setValue:[NSString stringWithString:getMsgDic[@"to_user"]] forKey:@"to_user"];
    }
    NSString *sequence_id = @"";
    if ([[getMsgDic allKeys]containsObject:@"sequence_id"]) {
        sequence_id = [NSString stringWithString: getMsgDic[@"sequence_id"]];//非消息类型时 没有 sequence_id
    }
    //
    NSString *from_user = [NSString stringWithString: getMsgDic[@"from_user"]];
    NSString *ackMsg_id = [NSString stringWithString: getMsgDic[@"msg_id"]];
    //
    NSMutableDictionary *receiveAckDic = [[NSMutableDictionary alloc]init];
    [receiveAckDic setValue:sequence_id forKey:@"sequence_id"];
    [receiveAckDic setValue:ackMsg_id      forKey:@"msg_id"];
    [receiveAckDic setValue:kMobile forKey:@"device_mark"];
    [dic setValue:receiveAckDic forKey:kWebSocketMsgTypeKey_ReceiveAck];
    //
    [dic setValue:kWebSocketMsgTypeObj_ReceiveAck forKey:@"msg_type"];
    [dic setValue:from_user forKey:@"from_user"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];

    //
    [dic setValue:kMobile forKey:@"device_mark"];
    [dic setValue:timeStr forKey:@"create_time"];
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    //DLog(@"————ask数据—dic—-%@",dic);
    //NSLog(@"————ask数据 发送数据 == %@",parms);
    dicBlock(parms);
}
#pragma mark ---

/**
 *发送心跳
 */
+ (void)chatWithSendPingTypeWithBlock:(BaseListArrBlock)arrBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSString *msgId = [Tool toolCreateRandomUuidSmall] ;
    NSDictionary *pingDic = @{
        @"creat_time":timeStr,
        @"from_user":[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.account,
        @"msg_id":msgId,
        @"msg_type":kWebSocketMsgTypeObj_PING,
        @"to_user":@"0",
        @"data":@{},
        @"extra_data":@{}
    };
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:pingDic.mutableCopy withTimeStr:timeStr];
    //DLog(@"ping 数据——%@",pingDic);
    arrBlock(@[pingDic, parms]);
    
}
#pragma mark == 发送信息数据整合 文本
/**
 *文字类型 _好友会话发送
 */
//+ (void)chatWillSendTextTypeWithStr:(NSString *)chatTextStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseDicBlock)dicBlock{
+ (void)chatWillSendTextTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatTextStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{

    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatTextStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    [dic setValue:textDic forKey:@"text"];
    [dic setValue:otherUuid forKey:@"to_user"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"text" forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
    
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——%@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
#pragma mark ---
 
/**
 *文字类型 _群聊
 */
+ (void)chatWillSendTextTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatTextStr withGroupUUId:(NSString *)groupUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatTextStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:textDic forKey:@"text"];
    [dic setValue:groupUuid forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"text" forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
    
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————群 聊天数据——%@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
/**
 *文字类型 _群组发送 (弃用)
 */
+ (void)chatWillSendTextTypeWithStr:(NSString *)chatTextStr withGroupId:(NSString *)groupId withBlock:(BaseDicBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatTextStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:textDic forKey:@"text"];
    [dic setValue:groupId forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"text" forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————群 聊天数据——%@",dic);
    dicBlock(parms);
}
 

#pragma mark == 发送信息数据整合 位置

+ (void)chatWillSendLocateAddressWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withLati:(CGFloat)lati withLongi:(CGFloat)longi withaddressTextStr:(NSString *)addresstextStr wtihFriendId:(NSString *)otherUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *oneTypeDataDic = [[NSMutableDictionary alloc]init];
    [oneTypeDataDic setValue:[NSString stringWithFormat:@"%lf",lati] forKey:@"latitude"];
    [oneTypeDataDic setValue:[NSString stringWithFormat:@"%lf",longi] forKey:@"longitude"];
    [oneTypeDataDic setValue:addresstextStr forKey:@"addr_str"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDataDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:oneTypeDataDic forKey:@"position"];
    [dic setValue:otherUuid forKey:@"to_user"];
//    [dic setValue:groupId forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"position" forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"位置 聊天数据——%@",dic);
    arrBlock(@[dic, parms]);
}
+ (void)chatWillSendLocateAddressWithChatMsgBaseInto:(NSMutableDictionary *)chatInfoDic withlat:(CGFloat)lati withLongi:(CGFloat)longi withaddressTextStr:(NSString *)addresstextStr wtihGroupId:(NSString *)groupId withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *oneTypeDataDic = [[NSMutableDictionary alloc]init];
    [oneTypeDataDic setValue:[NSString stringWithFormat:@"%lf",lati] forKey:@"latitude"];
    [oneTypeDataDic setValue:[NSString stringWithFormat:@"%lf",longi] forKey:@"longitude"];
    [oneTypeDataDic setValue:addresstextStr forKey:@"addr_str"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDataDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:oneTypeDataDic forKey:@"position"];
    [dic setValue:groupId forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"position" forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatInfoDic allKeys].count>0) {
        if ([[chatInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"位置 聊天数据——%@",dic);
    arrBlock(@[dic, parms]);
}

#pragma mark == 发送信息数据整合 图片
//(新版的在底部 挨着上传接口)

/**
 好友会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withStr:(NSString *)chatSendImgUrlStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatSendImgUrlStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:textDic forKey:@"image"];
    [dic setValue:otherUuid forKey:@"to_user"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:kWebSocketMsgTypeObj_Image forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——%@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
/**
 群会话-发送图片类型
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic WithStr:(NSString *)chatSendImgUrlStr withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatSendImgUrlStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:textDic forKey:@"image"];
    [dic setValue:groupUuid forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:kWebSocketMsgTypeObj_Image forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————群 聊天数据——%@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}

#pragma mark == 发送信息数据整合 voice

 //1026 voice新
+ (void)chatWillSendVoiceTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withFileDic:(NSDictionary *)voiceFileDic withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *oneTypeDic = [[NSMutableDictionary alloc]init];
    NSArray *chatVocieDicKeyArr = [voiceFileDic allKeys];
    for (NSString *keyStr in chatVocieDicKeyArr) {
        if ( [keyStr containsString:@"name"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"file_name"];
        }
        if ( [keyStr containsString:@"size"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"file_size"];
        }
        if ( [keyStr containsString:@"md5"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"md5"];
        }
        if ( [keyStr containsString:@"secret"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"secret"];
        }
        if ( [keyStr containsString:@"type"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"type"];
        }
        if ( [keyStr isEqualToString:@"url"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"url"];
        }
        if ( [keyStr isEqualToString:@"smallUrl"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"small_url"];
        }
        if ( [keyStr isEqualToString:@"uuid"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"uuid"];
        }
        if ( [keyStr isEqualToString:@"fuuid"]) {
            [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"fuuid"];
        }
    }
    
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:oneTypeDic forKey:@"voice"];
    [dic setValue:otherUuid forKey:@"to_user"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:kWebSocketMsgTypeObj_Voice forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——图片数据发送 %@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}

/**
 群会话-发送voice类型 1026新
 */
//1026 voice新
+ (void)chatWillSendVoiceTypeWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withVoiceFileDic:(NSDictionary *)voiceFileDic withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
   //time时间戳
   NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
   
   NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
   //
   NSMutableDictionary *oneTypeDic = [[NSMutableDictionary alloc]init];
   NSArray *chatVocieDicKeyArr = [voiceFileDic allKeys];
   for (NSString *keyStr in chatVocieDicKeyArr) {
       if ( [keyStr containsString:@"name"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"file_name"];
       }
       if ( [keyStr containsString:@"size"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"file_size"];
       }
       if ( [keyStr containsString:@"md5"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"md5"];
       }
       if ( [keyStr containsString:@"secret"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"secret"];
       }
       if ( [keyStr containsString:@"type"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"type"];
       }
       if ( [keyStr isEqualToString:@"url"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"url"];
       }
       if ( [keyStr isEqualToString:@"smallUrl"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"small_url"];
       }
       if ( [keyStr isEqualToString:@"uuid"]) {
           [oneTypeDic setValue:[voiceFileDic objectForKey:keyStr] forKey:@"uuid"];
       }
     
   }
   
   //加data
   NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDic];
   [dic setValue:dataJsonDic forKey:@"data"];
   //加data——end
   //
   [dic setValue:oneTypeDic forKey:@"voice"];
    [dic setValue:groupUuid forKey:@"to_group"];
   [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
   [dic setValue:timeStr forKey:@"create_time"];
   [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
   [dic setValue:kWebSocketMsgTypeObj_Voice forKey:@"msg_type"];
   [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];

    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
   NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
   DLog(@"————好友 聊天数据——图片数据发送 %@",dic);
   arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
/**
 好友会话-发送voice类型
 */
+ (void)chatWillSendVoiceFileUUIDWithFileUUIDStr:(NSString *)chatSendVoiceFileUUIDStr withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
    [textDic setValue:chatSendVoiceFileUUIDStr forKey:@"content"];//文件的uuid
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:textDic forKey:kWebSocketMsgTypeObj_Voice];
    [dic setValue:kWebSocketMsgTypeObj_Voice forKey:@"msg_type"];
    
    [dic setValue:otherUuid forKey:@"to_user"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——%@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
/**
 群会话-发送voice类型
 */

+ (void)chatWillSendVoiceFileUUIDWithFileUUIDStr:(NSString *)chatSendVoiceFileUUIDStr withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
   //time时间戳
   NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
   
   NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
   //
   NSMutableDictionary *textDic = [[NSMutableDictionary alloc]init];
   [textDic setValue:chatSendVoiceFileUUIDStr forKey:@"content"];
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:textDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
   //
    [dic setValue:textDic forKey:kWebSocketMsgTypeObj_Voice];
    [dic setValue:kWebSocketMsgTypeObj_Voice forKey:@"msg_type"];
    
    [dic setValue:groupUuid forKey:@"to_group"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
   
   NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
   DLog(@"————群 聊天数据——%@",dic);
   arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
#pragma mark ========================================================================  好友相关 发送数据 封装

+ (NSMutableDictionary *)friendSendParmsCreateWithDataDic:(NSMutableDictionary *)dic
                                              withTimeStr:(NSString *)timeStr{
       return [self allWillSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
}

#pragma  mark ========================================================================。聊天消息 发送数据 封装
+ (NSMutableDictionary *)chatSendMsgParmsCreateWithDataDic:(NSMutableDictionary *)dic
                                               withTimeStr:(NSString *)timeStr{
 
    return [self allWillSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
}

#pragma  mark ========================================================================。 群组 相关 封装
+ (NSMutableDictionary *)groupSendParmsCreateWithDataDic:(NSMutableDictionary *)dic
                                               withTimeStr:(NSString *)timeStr{
    return [self allWillSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
}
#pragma  mark ========================================================================。 用户修改 相关 封装
+ (NSMutableDictionary *)userInfoSendParmsCreateWithDataDic:(NSMutableDictionary *)dic
                                               withTimeStr:(NSString *)timeStr{
    return [self allWillSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
}
#pragma  mark ========================================================================  发送数据 md5等总数据 封装
+ (NSMutableDictionary *)allWillSendParmsCreateWithDataDic:(NSMutableDictionary *)dic
                                               withTimeStr:(NSString *)timeStr{
    
    if ([[dic allKeys]containsObject:@"msg_type"]) {//会话内聊天类型 增加昵称和头像建
        //20220321
        [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.nickName forKey:@"from_acc_name"];
        [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl forKey:@"from_acc_headImg"];
        [dic setValue:@{}  forKey:@"extra_data"]; 
    }
    

    //转json
    NSString *jsonStr = [Tool jsonStrWithDic:dic];
    //aes加密
    NSString *jsonAesOk = [ChatAESTool chatTypeEncryptAESUseServiceKeyIvAndLocalTimeStr:timeStr withStr:jsonStr];//用的key iv 用变化的
    //_______ uuid aes加密 用本地aeskey和Iv
    NSString *uuidAesOk = [ChatAESTool chatTypeEncryptAESLocallyStoredKeyAndIvWithConnectStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid];
    //md5签名
    ChatMd5WillModel *md5willModel = [[ChatMd5WillModel alloc]init];
    md5willModel.data = jsonAesOk;
    md5willModel.device_mark = kMobile;
    md5willModel.open_id = OPEN_ID;
    md5willModel.secretKey = AES_KEY;
    md5willModel.time = timeStr;
    NSString *md5willStr = [NSString stringWithFormat:@"data=%@&device_mark=%@&open_id=%@&operator=%@&secretKey=%@&time=%@&", md5willModel.data, md5willModel.device_mark, md5willModel.open_id,uuidAesOk , md5willModel.secretKey, md5willModel.time ];//deviceMark
    //NSLog(@"**** chat 总数据 封装 dic==%@,| \n md5willStr=%@ ****",dic,md5willStr);
    NSString *md5Ok = [ChatAESTool chatMD5ForString:md5willStr];
    
    //总数据打包
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:OPEN_ID forKey:@"open_id"];
    [parms setValue:kMobile forKey:@"deviceMark"];
    [parms setValue:jsonAesOk forKey:@"data"];//aes
    [parms setValue:uuidAesOk forKey:@"operator"];//aes
    [parms setValue:md5Ok forKey:@"signature"];//md5
    [parms setValue:timeStr forKey:@"time"];//md5里的时间戳

    return parms;
}

#pragma  mark ======================================================================== 信息 拉取｜删除｜撤回｜同步|未读消息提成已读消息｜相关接口

/**
 *会话信息 拉取 ｜｜  同步所有会话7天
 */
+ (void)getAllConversationFor7DaysWithBlock:(BaseListArrAndSuccessBoolBlock)dicBlock{ 
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kMobile forKey:@"deviceMark"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_AllSessionsFor7Days withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getAllArr =  [Tool arrWithJson:getDecStr];
                dicBlock(getAllArr,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@[],NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/**
 *拉取所有未读消息（全部会话列表 - 时间排序）
 */
/**
+ (void)getAllSessionsNotReadFor7DaysWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:kMobile forKey:@"deviceMark"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self allWillSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_AllSessionsFor7DaysAllUnreadMessages withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getHistoryMsgAllArr =  [Tool arrWithJson:getDecStr];
                listBlock(getHistoryMsgAllArr,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                listBlock(@[],NO);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            listBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

 */

//0908改成 获取用户会话列表（排除公众号 --
+ (void)getAllSessionsNotReadFor7DaysWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
   // NSString *url = @"zhsj/im/message/session/page/excludePublic";  //和zhsj/im/message/session/page 的结构是一样的 220326部数据的接口不在聊天內用
    NSString *url = @"zhsj/im/message/session/page/excludePublic";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                //数组类型 联系人列表
                NSDictionary *getHavePageDic = [Tool dictionaryWithJsonString:getDecStr];
                NSArray *getArr = [[getHavePageDic allKeys]containsObject:@"data"] ? [NSArray arrayWithArray:[getHavePageDic objectForKey:@"data"]] : @[];
                listBlock(getArr,YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                listBlock(@[],NO);
            }
        }else{
            listBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
    
}
//*未读消息转转成已读消息  改为清空未读
+ (void)chatHistoryNotReadChangeToReadedWithUnRedDic:(NSMutableDictionary *)unRedDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_ImMessageListOrOneMessage_Clear);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:unRedDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"总推送消息菜单清除 数据unRedDic=%@--- %@",unRedDic,dic);
//                    NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];;
                    dicBlock(dic,success);
                }else{
                    dicBlock(@{},NO);
                }
            }];
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
            dicBlock(@{},NO);
            
        }
    }];

}
/**
 *未读消息转转成已读消息
 */
//+ (void)chatHistoryNotReadChangeToReadedWithUnRedDic:(NSMutableDictionary *)unRedDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
////    [unRedDic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
//    NSMutableDictionary *parms = [self allWillSendParmsCreateWithDataDic:unRedDic withTimeStr:timeStr];
//    [self chatHistoryNotReadChangeToReadedWithWillSendParms:parms withBlock:dicBlock];
//}
+ (void)chatHistoryNotReadChangeToReadedWithWillSendParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_UnreadMessagesChangeToReadedStatus withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
                DLog(@"-转已读OK--%@",msg)
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}
#pragma mark === 新历史消息
/**
*聊天信息 拉取  历史消息 换成总 //___总推送类分页消息 同 chatvc历史消息 一样接口
*/
/**

 // 分类型列表消息数据 用toUser对方聊天号获取
 + (void)initImMessageListWithToUser:(NSString *)toUser withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
     NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
     [bodyDic setValue:@(1)   forKey:@"pageNum"];
     [bodyDic setValue:toUser forKey:@"toUser"];
     [self getImMessageListWithToUserWithBodyDic:bodyDic withArrBlcok:block];
 }
 + (void)upDataImMessageListWithToUser:(NSString *)toUser withPageNum:(NSInteger)pageNum withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
     NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
     [bodyDic setValue:@(pageNum) forKey:@"pageNum"];
     [bodyDic setValue:toUser     forKey:@"toUser"];
     [self getImMessageListWithToUserWithBodyDic:bodyDic withArrBlcok:block];
 }
 + (void)getImMessageListWithToUserWithBodyDic:(NSMutableDictionary *)bodyDic withArrBlcok:(BaseListArrAndSuccessBoolBlock)block{
     [bodyDic setValue:@(Y_PAGE_SIZE) forKey:@"pageSize"];
     [bodyDic setValue:@(1)           forKey:@"format"]; //作用于last_chat_msg字段    * format 为0 表示使用之前的消息格式      * format 为1 表示使用新版的消息格式
     NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_getMessageChatSubPage);
     [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                 if (success) {
                     DLog(@"总推送消息菜单 --- %@",dic);
                     NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];;
                     block(arr,success);
                 }
             }];
         }else{
             Y_SVP_SHOW_ERR_DESCRIPTION;
         }
     }];
 }
 */
+ (void)getOneFriendChatHistoryMsgListWithFriendUUIDNewInfo:(NSString *)friendUUID withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(2)   forKey:@"order"]; //  order  排序方式（1、按照 seq 升序 2、按照 seq 降序），默认按照 seq 降序**｜历史消息只能用2｜**
    [bodyDic setValue:@(1)   forKey:@"pageNum"];
    [bodyDic setValue:@(9999)   forKey:@"pageSize"];//每页显示条数(暂做全部数据一次加载)
    //size 字段暂时空 做全部数据
    [bodyDic setValue:friendUUID forKey:@"toUser"];
    [self getOneFriendChatHistoryMsgListWithDicNewInfo:bodyDic withBlock:block];//新版的数据
//    [self getOneFriendChatHistoryMsgOldInfoListWithDic:bodyDic withBlock:block];//旧版数据
}
+ (void)getOneFriendChatHistoryMsgListWithPageNum:(NSInteger)pageNum withPageSize:(NSInteger)size WithFriendUUIDNewInfo:(NSString *)friendUUID withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc]init];
    [bodyDic setValue:@(2)   forKey:@"order"]; //  order  排序方式（1、按照 seq 升序 2、按照 seq 降序），默认按照 seq 降序 **｜历史消息只能用2｜**
    [bodyDic setValue:@(pageNum)   forKey:@"pageNum"];
    [bodyDic setValue:@(size)   forKey:@"pageSize"];//每页显示条数(暂做全部数据一次加载)
    //size 字段暂时空 做全部数据
    [bodyDic setValue:friendUUID forKey:@"toUser"];
    [self getOneFriendChatHistoryMsgListWithDicNewInfo:bodyDic withBlock:block];//新版的数据
//    [self getOneFriendChatHistoryMsgOldInfoListWithDic:bodyDic withBlock:block];//旧版数据
}
//新版本格式
+ (void)getOneFriendChatHistoryMsgListWithDicNewInfo:(NSMutableDictionary *)bodyDic withBlock:(BaseListArrAndSuccessBoolBlock)block{
    [bodyDic setValue:@(1)           forKey:@"format"]; //作用于last_chat_msg字段    * format 为0 表示使用之前的消息格式      * format 为1 表示使用新版的消息格式
    [self getOneFriendChatHistoryMsgListWithAllDic:bodyDic withBlock:block];
}
//旧版本格式
+ (void)getOneFriendChatHistoryMsgOldInfoListWithDic:(NSMutableDictionary *)bodyDic withBlock:(BaseListArrAndSuccessBoolBlock)block{
    [bodyDic setValue:@(0)           forKey:@"format"]; //作用于last_chat_msg字段    * format 为0 表示使用之前的消息格式      * format 为1 表示使用新版的消息格式
    [self getOneFriendChatHistoryMsgListWithAllDic:bodyDic withBlock:block];
}
+ (void)getOneFriendChatHistoryMsgListWithAllDic:(NSMutableDictionary *)bodyDic withBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(Message_Push_Module_ImURL_getMessageChatSubPage);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    DLog(@"历史msg --- %@",dic);
                    NSArray *arr =  [[dic allKeys] containsObject:@"data"]? [NSArray arrayWithArray:[dic objectForKey:@"data"]] : [[NSArray alloc]init];//messages
                 
                    block(arr,YES);
                }else{
                    block(@[],NO);
                }
            }];
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION;
            block(@[],NO);
        }
    }];
}
/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读 -- 好友会话
 */
+ (void)getOneFriendChatHistoryMsgListWithFriendUUID:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@(0) forKey:@"sequence_id"]; //返回的消息中是否要包含当前sequence_id的这条消息==no==0
    [dic setValue:@(0) forKey:@"containSequence_id"];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self getOneFriendOrOneGroupHistoryWithParm:parms withBlock:dicBlock];
}
 
/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读 -- 群聊会话
 */
+ (void)getOneGroupChatHistoryMsgListWithGroupUUID:(NSString *)groupUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{//普通的群相关接口用to_user，群聊天通信时用to_group
    [self getOneFriendChatHistoryMsgListWithFriendUUID:groupUUID withBlock:dicBlock];
}
+ (void)getOneFriendOrOneGroupHistoryWithParm:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_oneSyncChatMsgList withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getHistoryMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getHistoryMsgAllDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}

/**
 *消息位点同步(一个会话) 同步两个消息位点之间的数据 7天之內
 */
+ (void)getOneFriendChatMsgListWithBeginSeqId:(NSString *)beginSeqId withEndSeqId:(NSString *)endSeqId withFriendUUID:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:beginSeqId forKey:@"begin_sequence_id"];
    [dic setValue:endSeqId forKey:@"end_sequence_id"];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_oneSyncChatMsgListBySequenceIdBetween withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getHistoryMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getHistoryMsgAllDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/** 20220323
 * msg已读状态提交 (后台数据 不做svp提示)
 */
+ (void)chatInfoSetReadedTypeWithDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(URL_Chat_MsgSetReadedType);
    [[ToolOfNetWork sharedTools]YrequestImInfoPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:infoDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                if (success) {
                    dicBlock(responsObject,YES);
                    NSLog(@" 聊天 已读状态设置 成功 %@ %@",infoDic,responsObject);
                }else{
                    dicBlock(@{},NO);
                }
            }];
        }else{
            dicBlock(@{},NO);
        }
    }];

    
    
//    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
//    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:infoDic withTimeStr:timeStr];
//    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_MsgSetReadedType withParams:parms finished:^(id responsObject, NSError *error) {//154success
//        if (isNotNil(responsObject)) {
//            if (Y_Success_Or_ErrCode==154) {
//                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
//                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
//                dicBlock(getDic,YES);
//                //NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                NSLog(@" 聊天 已读状态设置 成功 %@ %@",infoDic,getDic);
//            }else{
//                dicBlock(@{},NO);
//                NSString *msg = @"请求错误";
//                if ([[responsObject allKeys] containsObject:@"msg"]) {
//                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
//                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
//                }
//               //Y_SVP_SHOW_ERR_MES(msg);
//            }
//        }else{
//            dicBlock(@{},NO);
//            //Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//
//    }];
}
/**
 * 撤回一条消息
 */
 + (void)chatInfoWithUndoOneMessageWithSequenceId:(NSString *)sequenceId withFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:sequenceId forKey:@"sequence_id"];
    [dic setValue:kMobile forKey:@"deviceMark"];
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_withdrawOneMessage withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}

/**
 * 删除一条消息
 */
 + (void)chatInfoDeletOneMessageWithSequenceId:(NSString *)sequenceId withFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:sequenceId forKey:@"sequence_id"];
    [dic setValue:@(0) forKey:@"delAll"];//是否删除所有
    [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
    NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_deleteOneMessage withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}

/**
 * 删除整个会话
 */
+ (void)chatInfoDeletOneConversationWithFriendId:(NSString *)friendUUID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
   //time时间戳
   NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
   
   NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
 
   [dic setValue:@(1) forKey:@"delAll"];//是否删除所有
   [dic setValue:friendUUID forKey:@"to_user"];//对方uuid
   [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//发起方uuid
   NSMutableDictionary *parms = [self friendSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
   [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_deleteEntireConversation withParams:parms finished:^(id responsObject, NSError *error) {//154success
       if (isNotNil(responsObject)) {
           if (Y_Success_Or_ErrCode==154) {
               NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
               NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
               dicBlock(getDic,YES);
               NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
               Y_SVP_SHOW_SUCCESS_MES(msg);
           }else{
               dicBlock(@{},NO);
//               NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
               NSString *msg = @"请求错误";
               if ([[responsObject allKeys] containsObject:@"msg"]) {
                   msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
               }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                   msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
               }
               Y_SVP_SHOW_ERR_MES(msg);
           }
       }else{
           dicBlock(@{},NO);
           Y_SVP_SHOW_ERR_DESCRIPTION
       }
       
   }];
   
}
//deleteEntireConversation删除整个会话 改为使用本接口 删除会话列表
+ (void)chatSessionDeleteWithBodyDic:(NSMutableDictionary *)bodyDic withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    /**
     [bodyDic setValue:@(1) forKey:@"format"];
     format(默认是1)
     1  删除列表保留历史记录
     2  删除列表删除历史记录
     */
    NSString *url = @"zhsj/im/message/session/delete";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:bodyDic  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock( getDic , YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}


#pragma  mark ============================================================================================================================== 群
/**
 *建群
 */

+ (void)chatCreatGroupWithOnlyMeInfoWithGroupName:(NSString *)groupName withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{

    [self chatCreatGroupWithGroupName:groupName withFriendsUuidArr:@[] withDicBlock:dicBlock];
}
+ (void)chatCreatGroupWithGroupName:(NSString *)groupNameStr withFriendsUuidArr:(NSArray *)friendsUuidArr withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:friendsUuidArr forKey:@"userUuidList"];
    [dic setValue:groupNameStr forKey:@"groupName"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_CreatGroup withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                DLog(@"---建群--%@",getDic);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}
/**
 *拉人进群
 */
+ (void)chatAddOtherFriendIntoTheGroupWithGroupId:(NSString *)groupUuid WithOhterFriendIdArr:(NSMutableArray *)othterFriendIdArr withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];//群组和管理员才可以用此方法
    [dic setValue:groupUuid forKey:@"groupUuid"];
    [dic setValue:othterFriendIdArr forKey:@"friendsList"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GroupAddNewMember withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic ,YES);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
//                DLog(@"---拉人进群--%@",getDic);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}


/**
 *修改群名称
 */
+ (void)chatGroupNameChangeWithNewNameStr:(NSString *)groupName withGroupId:(NSString *)groupUuid  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:groupName forKey:@"groupName"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GroupChangeName withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                DLog(@"---群昵称更改--%@",getDic);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
    

}
/**
 *设置群备注
 */
+ (void)chatGroupSetRemarkWithRemarkStr:(NSString *)remark withGroupId:(NSString *)groupUuid  withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:remark forKey:@"remarks"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GroupSetRemarks withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
                DLog(@"---群备注 更改--%@",getDic);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}
 
/**
 *获取某群的全部成员列表
 */
+ (void)chatGroupAllMemberListWithGroupId:(NSString *)groupUuid withlistBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetGroupAllMemberList withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getAllArr =  [Tool arrWithJson:getDecStr];
                listBlock(getAllArr,YES);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                listBlock(@[],NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            listBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/**
 排除在群聊里面的好友列表后剩余的好友列表 (在某群 做拉人操作时用的)
 */
+ (void)chatGroupAddNewMemberWillExcludeGroupUserStayFriendWithGroupId:(NSString *)groupUuid withlistBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetExcludeGroupUserStayFriends withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getAllArr =  [Tool arrWithJson:getDecStr];
                listBlock(getAllArr,YES);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                listBlock(@[],NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            listBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

/**获取当前群自己设置的信息
 */
+ (void)chatGroupOwnSetInfoWithGroupId:(NSString *)groupUuid withlistBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetGroupInfoToMe withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getDic ,YES);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/**
 *获取用户所有群聊
 */
+ (void)chatGetAllGroupListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
 
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GetAllGroupList withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getArr =  [NSArray arrayWithArray:[Tool arrWithJson:getDecStr]];
                DLog(@"--all-群--%@",getArr);
                listBlock(getArr ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                listBlock(@[],NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            listBlock(@[],NO);
        }
        
    }];
}
/**
 *拉好友到某群组
 */
+ (void)chatGroupAddFriendWithGroupId:(NSString *)groupId withFriendIdArr:(NSMutableArray *)friendUuidArr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:groupId  forKey:@"groupUuid"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:friendUuidArr  forKey:@"friendsList"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GroupAddFriends withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr]; 
                DLog(@"--群--%@",getDic);
                dicBlock(getDic ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}
/**
 群聊 踢人 管理员/群主可踢
 */
+ (void)chatGroupRemoveMemberWithGroupId:(NSString *)groupId withMemberIdArr:(NSMutableArray *)willRemoveUuidArr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:groupId  forKey:@"groupUuid"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:willRemoveUuidArr  forKey:@"getKickedUserUuidList"];
    NSMutableDictionary *parms = [self groupSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_GroupRemoveMember withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                DLog(@"--群--%@",getDic);
                dicBlock(getDic ,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
            dicBlock(@{},NO);
        }
        
    }];
}


/**
 *聊天信息 拉取 ｜｜ 消息位点同步(一个会话 7天内 不区分已读未读    群组
 */
+ (void)getOneFriendChatMsgListWithGroupID:(NSString *)groupID withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
     //to_group   to_user == 群组相关的键值 在发送信息时用 其他接口时的key可以用to_user
    [self getOneFriendChatHistoryMsgListWithFriendUUID:groupID withBlock:dicBlock];
}

#pragma mark ==  视频上传 发送数据组装等

//0622新
+ (void)sendMp4WithFileUrl:(NSURL *)fileUrl withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *willUseMainUrlStr = [NSString stringWithFormat:@"%@",@"zhsj/base/api/file/upLoad/"];
    NSString *nonce = [Tool toolCreateRandomUuidSmall];//请求随机数
    
    NSError *err = nil;
    NSData *anData = [NSData dataWithContentsOfFile:fileUrl options:NSDataReadingUncached error:&err];
    if (err) {
        Y_SVP_SHOW_ERR_MES(@"视频文件错误");
        dicBlock(@{},NO);
        return;
    }else{
    }
    NSString *fileHash = [FileMd5Hash computeHashForData:anData];//CC_MD5_DIGEST_LENGTH
    NSString *willMd5_SignStr = [NSString stringWithFormat:@"%@\n%@\n%@",kSend_File_Key,nonce,fileHash];
    NSString *sign = [ChatAESTool chatMD5ForString:willMd5_SignStr];
    
    NSString *uploadFileUrl = [NSString stringWithFormat:@"%@%@/%@/%@",willUseMainUrlStr,kSend_File_Obj,nonce,sign];
    NSLog(@"视频上传 发送数据组装 url == %@ \n\n",uploadFileUrl);
    
    
    /**
     [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:uploadFileUrl withBody:@{@"file":anData} finished:^(id responsObject, NSError *error) {
         if (isNotNil(responsObject)) {
             if (Y_Success_Or_ErrCodeKeyIntV==0) {//文件类型的回复在data里不需要解析可以直接用
                 NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                 dicBlock(getDic,YES);
             }else{
                 dicBlock(@{},NO);
 //                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                 NSString *msg = @"请求错误";
                 if ([[responsObject allKeys] containsObject:@"msg"]) {
                     msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                     msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                 }
                 Y_SVP_SHOW_ERR_MES(msg);
             }
         }else{
             dicBlock(@{},NO);
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
     }];
     */

    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendFileWithOneDataPathFilesWithUpURL:uploadFileUrl
//     [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendFileWithOneDataPathFilesWithUpURL:willUseMainUrlStr
                                                                        withFfileConfigId:kSend_File_Obj
                                                                                withNonce:nonce
                                                                                 withSign:sign
                                                                               withParams:@{}.mutableCopy
                                                                              filePathStr:fileUrl.absoluteString
                                                                            upfileNameStr:@"file"
                                                                                 finished:^(id responsObject, NSError *error) {
        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
                //                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];


}
+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId andWithMovieBaseUrl:(NSURL *)movieUrl withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *onlyReq = [Tool toolCreateRandomUuidSmall];//请求随机数 onlyReq
    NSString *token = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];    //chat token
    NSString *device = kMobile;
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    
    if (isNil(movieUrl) || movieUrl.absoluteString.length <= 0) {
        dicBlock(@{},NO);
        return;
    }
 
    NSError *err = nil;
    NSData *anData = [NSData dataWithContentsOfFile:movieUrl options:NSDataReadingUncached error:&err];
    if (err) {
        Y_SVP_SHOW_ERR_MES(@"视频文件错误");
        dicBlock(@{},NO);
        return;
    }else{
        
    }
    NSString *fileHash = [FileMd5Hash computeHashForData:anData];//CC_MD5_DIGEST_LENGTH
  /**
   description=img
   &device=mobile
   &fileHash=
   &onlyReq=
   &security_secret=
   &sessionId=
   &token=
   */
                                                                                                                                       
    //上传接口的sign 处理后  进行md5来获得
    NSString *willMd5_SignStr = [NSString stringWithFormat:@"description=%@&device=%@&fileHash=%@&onlyReq=%@&security_secret=%@&sessionId=%@&token=%@",kWebSocketMsgTypeObj_Video, device,fileHash, onlyReq ,IM_Message_Mobul_MD5_Use_KEY,chatSessionId,token];
    NSString *sign = [ChatAESTool chatMD5ForString:willMd5_SignStr];
    //
    [parms setValue:kWebSocketMsgTypeObj_Video forKey:@"description"];
    [parms setValue:fileHash forKey:@"fileHash"];
    [parms setValue:sign forKey:@"sign"];

    if (chatSessionId.length>0) {
        [parms setValue:chatSessionId forKey:@"sessionId"];
    }
    NSLog(@"1026新版本文件上传 视频 fileHash=%@ \n  willMd5_SignStr %@ \n parms=%@",fileHash,willMd5_SignStr,parms);
    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendWithOneDataPathFilesNewSystemWithURL:URL_Chat_SendFileGetFileDicNewSystem
                                                               withChatSessionId:chatSessionId
                                                                   withChatToken:token
                                                                     withOnlyReq:onlyReq
                                                                      withSign:sign
                                                                      withParams:parms
                                                                      filePathStr:movieUrl.absoluteString
                                                                   upfileNameStr:@"file"
                                                                        finished:^(id responsObject, NSError *error) {
                                                                                                                        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark == 视频end
#pragma  mark ================= 1025文件上传 （接口更换 换了键值增加了的接口）
+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId andWithImg:(UIImage *)willSendImg withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *onlyReq = [Tool toolCreateRandomUuidSmall];//请求随机数 onlyReq
    NSString *token = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];    //chat token
    NSString *device = kMobile;
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    //fileHash 图片文件
   // NSData *anImgData = UIImagePNGRepresentation(willSendImg);
    //NSData *anImgData = UIImageJPEGRepresentation(willSendImg, 0.2);//这里不做大小处理
    //NSString *fileHash = [FileMd5Hash computeHashForData:anImgData];//CC_MD5_DIGEST_LENGTH
    
    NSData *data = [ZYImageCompressTool image200KBCompressWithImg:willSendImg];//220328压缩到200k
    NSString *fileHash = [FileMd5Hash computeHashForData:data];//CC_MD5_DIGEST_LENGTH
    
  
  /**
   description=img
   &device=mobile
   &fileHash=
   &onlyReq=
   &security_secret=
   &sessionId=
   &token=
   */
                                                                                                                                       
    //上传接口的sign 处理后  进行md5来获得
    NSString *willMd5_SignStr = [NSString stringWithFormat:@"description=%@&device=%@&fileHash=%@&onlyReq=%@&security_secret=%@&sessionId=%@&token=%@",@"img", device,fileHash, onlyReq ,IM_Message_Mobul_MD5_Use_KEY,chatSessionId,token];
//    NSString *sign = [FileMd5Hash computeHashForString:willMd5_SignStr];
    NSString *sign = [ChatAESTool chatMD5ForString:willMd5_SignStr];
    //
    [parms setValue:@"img" forKey:@"description"];
    [parms setValue:fileHash forKey:@"fileHash"];
    [parms setValue:sign forKey:@"sign"];

    if (chatSessionId.length>0) {
        [parms setValue:chatSessionId forKey:@"sessionId"];
    }
    NSLog(@"1025新版本文件上传 图片 fileHash=%@ \n  willMd5_SignStr %@ \n parms=%@",fileHash,willMd5_SignStr,parms);
    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendImgFilesNewSystemWithURL:URL_Chat_SendFileGetFileDicNewSystem
                                                               withChatSessionId:chatSessionId
                                                                   withChatToken:token
                                                                     withOnlyReq:onlyReq
                                                                      withSign:sign
                                                                      withParams:parms
                                                                      fileImgArr:@[willSendImg].mutableCopy
                                                                   upfileNameStr:@"file"
                                                                        finished:^(id responsObject, NSError *error) {
                                                                                                                        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 
#pragma mark ==== 发送 图片类型 1025新
/**
 好友会话-发送图片类型 1025新
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withDic:(NSDictionary *)chatSendImgDic withFriendUUId:(NSString *)otherUuid withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *oneTypeDic = [[NSMutableDictionary alloc]init];
    NSArray *chatImgDicKeyArr = [chatSendImgDic allKeys];
    for (NSString *keyStr in chatImgDicKeyArr) {
        if ( [keyStr containsString:@"name"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"file_name"];
        }
        if ( [keyStr containsString:@"size"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"file_size"];
        }
        if ( [keyStr containsString:@"md5"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"md5"];
        }
        if ( [keyStr containsString:@"secret"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"secret"];
        }
        if ( [keyStr containsString:@"type"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"type"];
        }
        if ( [keyStr isEqualToString:@"url"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"url"];
        }
        if ( [keyStr isEqualToString:@"smallUrl"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"small_url"];
        }
    }
    
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:oneTypeDic forKey:@"image"];
    [dic setValue:otherUuid forKey:@"to_user"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:kWebSocketMsgTypeObj_Image forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——图片数据发送 %@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
}
 
/**
 群会话-发送图片类型 1025新
 */
+ (void)chatWillSendImgUrlWithChatMsgBaseInfo:(NSMutableDictionary *)chatMsgBaseInfoDic withDic:(NSDictionary *)chatSendImgDic withGroupUUId:(NSString *)groupUuid  withDicBlockAndWillSendDataDicBlock:(BaseListArrBlock)arrBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //
    NSMutableDictionary *oneTypeDic = [[NSMutableDictionary alloc]init];
    NSArray *chatImgDicKeyArr = [chatSendImgDic allKeys];
    for (NSString *keyStr in chatImgDicKeyArr) {
        if ( [keyStr containsString:@"name"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"file_name"];
        }
        if ( [keyStr containsString:@"size"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"file_size"];
        }
        if ( [keyStr containsString:@"md5"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"md5"];
        }
        if ( [keyStr containsString:@"secret"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"secret"];
        }
        if ( [keyStr containsString:@"type"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"type"];
        }
        if ( [keyStr isEqualToString:@"url"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"url"];
        }
        if ( [keyStr isEqualToString:@"smallUrl"]) {
            [oneTypeDic setValue:[chatSendImgDic objectForKey:keyStr] forKey:@"small_url"];
        }
    }
    
    //加data
    NSString *dataJsonDic = [Tool jsonStrWithDic:oneTypeDic];
    [dic setValue:dataJsonDic forKey:@"data"];
    //加data——end
    //
    [dic setValue:oneTypeDic forKey:@"image"];
    [dic setValue:groupUuid forKey:@"groupUuid"];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:timeStr forKey:@"create_time"];
    [dic setValue:[Tool toolCreateRandomUuidSmall] forKey:@"msg_id"];//随机串不可重复
    [dic setValue:kWebSocketMsgTypeObj_Image forKey:@"msg_type"];
    [dic setValue:@"mobile" forKey:@"noSynchronizedDevice"];
 
    if ([chatMsgBaseInfoDic allKeys].count>0) {
        if ([[chatMsgBaseInfoDic allKeys] containsObject:@"session_id"]) {
            [dic setValue:[chatMsgBaseInfoDic objectForKey:@"session_id"] forKey:@"session_id"];
        }
    }
    NSMutableDictionary *parms = [self chatSendMsgParmsCreateWithDataDic:dic withTimeStr:timeStr];
    DLog(@"————好友 聊天数据——图片数据发送 %@",dic);
    arrBlock(@[dic,parms]);//[文本类型结构数据 发送前datadic数据]
    
}
#pragma  mark =================chat 图片类型上传

+ (void)chatWillSendImgFileWithImg:(UIImage *)willSendImg withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [self chatWillSendFileWithImgFileArr:@[willSendImg].mutableCopy withGetDicBlock:dicBlock];
}
+ (void)chatWillSendFileWithImgFileArr:(NSMutableArray *)fileDataArr withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendImgFilesWithURL:URL_Chat_SendFileGetFileSavUrl withParams:@{}.mutableCopy fileDataArr:fileDataArr fileNameStr:@"file" finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
            
    }];
}

#pragma mark =================chat 语音类型上传
//+ (void)chatWillSendOneVoiceFileWithVoice:(id)willSendVoice withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    [self chatWillSendVoiceFileWithVoiceArr:@[willSendVoice].mutableCopy withGetDicBlock:dicBlock];
//}
//+ (void)chatWillSendVoiceFileWithVoiceArr:(NSMutableArray *)fileDataArr withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendVoiceFilesWithURL:URL_Chat_SendFileGetFileSavUrl withParams:@{}.mutableCopy fileDataArr:fileDataArr fileNameStr:@"file" finished:^(id responsObject, NSError *error) {
//        if (isNotNil(responsObject)) {
//            if (Y_Success_Or_ErrCode==154) {//文件类型的回复在data里不需要解析可以直接用
//                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
//                dicBlock(getDic,YES);
//            }else{
//                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_ERR_MES(msg);
//            }
//        }else{
//            dicBlock(@{},NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
//语音 传path的 文件上传
  
/**
 语音上传接口 1026改接口 URL_Chat_SendFileGetFileSavUrl 改成 URL_Chat_SendFileGetFileDicNewSystem
 */

+ (void)chatWillSendFileNewSystemNotHaveOrHaveSecretwithChatSessionId:(NSString *)chatSessionId  withSendOneVoiceFileWithVoicePathUrl:(NSURL *)willSendVoicePathUrl   withGetDicBlick:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *onlyReq = [Tool toolCreateRandomUuidSmall];//请求随机数 onlyReq
    NSString *token = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];    //chat token
    NSString *device = kMobile;
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
  
    if (isNil(willSendVoicePathUrl) || willSendVoicePathUrl.absoluteString.length <= 0) {
        dicBlock(@{},NO);
        return;
    }
 
    NSError *err = nil;
    NSData *anData = [NSData dataWithContentsOfFile:willSendVoicePathUrl options:NSDataReadingUncached error:&err];
    if (err) {
        Y_SVP_SHOW_ERR_MES(@"语音文件错误");
        dicBlock(@{},NO);
        return;
    }else{
        
    }
    NSString *fileHash = [FileMd5Hash computeHashForData:anData];//CC_MD5_DIGEST_LENGTH
  
  /**
   description=img
   &device=mobile
   &fileHash=
   &onlyReq=
   &security_secret=
   &sessionId=
   &token=
   */
                                                                                                                                       
    //上传接口的sign 处理后  进行md5来获得
    NSString *willMd5_SignStr = [NSString stringWithFormat:@"description=%@&device=%@&fileHash=%@&onlyReq=%@&security_secret=%@&sessionId=%@&token=%@",@"voice", device,fileHash, onlyReq ,IM_Message_Mobul_MD5_Use_KEY,chatSessionId,token];
//    NSString *sign = [FileMd5Hash computeHashForString:willMd5_SignStr];
    NSString *sign = [ChatAESTool chatMD5ForString:willMd5_SignStr];
    //
    [parms setValue:@"voice" forKey:@"description"];
    [parms setValue:fileHash forKey:@"fileHash"];
    [parms setValue:sign forKey:@"sign"];

    if (chatSessionId.length>0) {
        [parms setValue:chatSessionId forKey:@"sessionId"];
    }
    NSLog(@"1025新版本文件上传 语音 fileHash=%@ \n  willMd5_SignStr %@ \n parms=%@",fileHash,willMd5_SignStr,parms);
    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendWithOneDataPathFilesNewSystemWithURL:URL_Chat_SendFileGetFileDicNewSystem
                                                               withChatSessionId:chatSessionId
                                                                   withChatToken:token
                                                                     withOnlyReq:onlyReq
                                                                      withSign:sign
                                                                      withParams:parms
                                                                      filePathStr:willSendVoicePathUrl.absoluteString
                                                                   upfileNameStr:@"file"
                                                                        finished:^(id responsObject, NSError *error) {
                                                                                                                        
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

+ (void)chatWillSendOneVoiceFileWithVoicePathUrl:(NSURL *)willSendVoicePathUrl withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendVoiceFilesWithURL:URL_Chat_SendFileGetFileSavUrl  withParams:@{}.mutableCopy  fileDataArr:@[].mutableCopy fileNameStr:@"file" filePacthUrl:willSendVoicePathUrl finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {//文件类型的回复在data里不需要解析可以直接用
                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
                dicBlock(getDic,YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
 
 
#pragma  mark =================chat  总文件 上传 -- 非图片类型 暂未成功处理
+ (void)chatWillSendFileWithFileDataArr:(NSMutableArray *)fileDataArr withGetDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    [[ToolOfNetWork sharedTools]YrequestPostChatTypeSendFilesWithURL:URL_Chat_SendFileGetFileSavUrl withParams:@{}.mutableCopy fileDataArr:fileDataArr fileNameStr:@"file" finished:^(id responsObject, NSError *error) {
//        if (isNotNil(responsObject)) {
//            if (Y_Success_Or_ErrCode==154) {
////                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
////                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
//                NSDictionary *getDic = [[responsObject allKeys]containsObject:@"data"] ? [NSDictionary dictionaryWithDictionary:responsObject[@"data"]]: @{};
//                dicBlock(getDic,YES);
//                DLog(@"chat  总文件 上传 ======%@",getDic)
//            }else{
//                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_ERR_MES(msg);
//            }
//        }else{
//            dicBlock(@{},NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//
//    }];
}

#pragma mark ===  聊天用户背景修改
//用户聊天背景
+ (void)chatVcSetBackImgWithImgUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:imgUrlStr forKey:@"userBackgroundFilePath"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self chatVcSetBackImgWithPostUrl:URL_Chat_UserChatVcBackImgSet withParm:parms withBlock:dicBlock];
}
//当前用户群聊的聊天背景
+ (void)chatVcSetBackImgWithGroupId:(NSString *)groupId withImgUrlStr:(NSString *)imgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:imgUrlStr forKey:@"groupPersonalBackgroundFilePath"];
    [dic setValue:groupId  forKey:@"groupUuid"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self chatVcSetBackImgWithPostUrl:URL_Chat_GroupChatVcBackImgSet withParm:parms withBlock:dicBlock];
}
//聊天背景 总设置
+ (void)chatVcSetBackImgWithPostUrl:(NSString *)postUrl withParm:(NSMutableDictionary *)parms  withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:postUrl withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getMsgAllDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
#pragma mark ===  个人信息修改

/**
 *查看用户自己的信息
 */
/**
+ (void)chatUserInfoGetWithMyInfoWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_UserInfoGetWithMy withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getMsgAllDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
 */
//0908改成 查看用户自己的信息
+ (void)chatUserInfoGetWithMyInfoWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    NSString *url = @"zhsj/im/user/user/info";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock( getDic , YES);
            }else{
                DLog(@"   %@",error);
//                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}
/**
 *查看他人信息 仅仅有简单的图片名字imid和性别可用 （0909新增数据 有是否允许添加键 uuid账户）
 */
//0909
+ (void)chatOtherUserInfoWithOthterImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{ 
    NSString *url = @"zhsj/im/user/user/infoByImId";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *parms = @{@"userImId":otherImId}.mutableCopy;
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock( getDic , YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
/**
 + (void)chatOtherUserInfoWithOthterImId:(NSString *)toUserId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{//to_user
     NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
     [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
     [dic setValue:toUserId forKey:@"to_user"];
     NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
     //
     [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_UserInfoGetToOther withParams:parms finished:^(id responsObject, NSError *error) {//154success
         if (isNotNil(responsObject)) {
             if (Y_Success_Or_ErrCode==154) {
                 NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                 NSDictionary *getHistoryMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                 dicBlock(getHistoryMsgAllDic,YES);
                 NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 Y_SVP_SHOW_SUCCESS_MES(msg);
             }else{
                 dicBlock(@{},NO);
                 NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                 Y_SVP_SHOW_ERR_MES(msg);
             }
         }else{
             dicBlock(@{},NO);
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
         
     }];
 }
  
 */

/**
 查询一个联系人(ImId)  有关系信息 无infoByImId 的基础信息 (还未使用 有id可用于删好友改备注等 )
 */
+ (void)chatOtherUserGetOneInfoWithImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSString *url = @"zhsj/im/user/contact/getOne";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    NSMutableDictionary *parms = @{@"toImId":otherImId}.mutableCopy;
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms  finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock( getDic , YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                Y_SVP_SHOW_ERR_MES(msg);
                dicBlock(@{},NO);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//0909新加接口
//查询联系人和自己的关系 --- 新版本取代 查询是否为好友关系
//+ (void)chatOtherUserAndOwnUserTheRelationshipInfoWithOthterImId:(NSString *)otherImId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
//    NSString *url = @"zhsj/im/user/contact/getOne";
//    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
//    NSMutableDictionary *parms = @{@"toImId":otherImId}.mutableCopy;
//}

/**
 *查询是否为好友关系
 */
+ (void)chatSearchIsOrNotFriendsWithOherUUID:(NSString *)toUserId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{//to_user
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:toUserId forKey:@"to_user"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    //
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_IsOrNotFriend withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                BOOL isOrNotFriend =  [ [self useMessageDicGetDecStr:responsObject] boolValue];
                dicBlock(@{@"isOrNotFriend":@(isOrNotFriend)},YES);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}
//1222 新增 查询是否为好友
+ (void)chatSearchIsOrNotFriendsWithImid:(NSString *)imId withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:imId forKey:@"imId"];
    NSLog(@"查询是否为好友 body %@",dic);
    if (imId.length==0) {
        return;
    }
    NSString *allUrl = BASE_Message_Push_Module_Default_URL(URL_Chat_IsOrNotFriend_New);

    [[ToolOfNetWork sharedTools] YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:dic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            
                [ChatManagerData toolImMesssageInfoResponsObject:responsObject withChangeToDicBlock:^(NSDictionary * dic, BOOL success) {
                    if (success) {
                        BOOL isOrNotFriend =   [[dic allKeys]containsObject:@"status"] ?  [ [dic objectForKey:@"status"]  boolValue]  : NO;
                        dicBlock(@{@"isOrNotFriend":@(isOrNotFriend)},YES);//状态dic + successyes
                        DLog(@"查询是否为好友 --- %@",dic);
                    }else{
                        dicBlock(@{},NO);
                    }
                }];
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
/**
 *昵称修改 
 */
+ (void)chatUserInfoChangeNickName:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [self changeUserInfoUseDic];
    [dic setValue:nickNameStr forKey:@"userNickname"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self toolSnedChangeUserInfoParmWith:parms withBlock:dicBlock];
}
/***
 个性签名修改
 */
+ (void)chatUserInfoChangeAutograph:(NSString *)autograph withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [self changeUserInfoUseDic];
    [dic setValue:autograph forKey:@"autograph"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self toolSnedChangeUserInfoParmWith:parms withBlock:dicBlock];
}
/**
 *头像修改
 */
+ (void)chatUserInfoChangeHeaderImgUrlStr:(NSString *)headerImgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [self changeUserInfoUseDic];
    [dic setValue:headerImgUrlStr forKey:@"avatarMediaId"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self toolSnedChangeUserInfoParmWith:parms withBlock:dicBlock];
}

//avatarMediaId头像路径  userNickname昵称
+ (NSMutableDictionary *)changeUserInfoUseDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
//    [dic setValue:@"" forKey:@"avatarMediaId"];
//    [dic setValue:@"" forKey:@"userNickname"];
//    [dic setValue:@"" forKey:@"autograph"];//个性签名
//    [dic setValue:@"" forKey:@"state"]; //0-不在线，1-在线
//    [dic setValue:@"" forKey:@"location"];//用户地区
//    [dic setValue:@"" forKey:@"sex"];
//    [dic setValue:@"" forKey:@"notice"];//描述
//    [dic setValue:@"" forKey:@"personalBackground"];//个人聊天背景路径
    return dic;
}
+ (void)toolSnedChangeUserInfoParmWith:(NSMutableDictionary *)parms  withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_UserInfoChangeName withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSDictionary *getHistoryMsgAllDic =  [Tool dictionaryWithJsonString:getDecStr];
                dicBlock(getHistoryMsgAllDic,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                dicBlock(@{},NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            dicBlock(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}
//________
/**
 新 更改 (昵称 头像)
 */
 
+ (void)chatUserChangeHeaderImgUrlStrNew:(NSString *)headerImgUrlStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
  
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:headerImgUrlStr forKey:@"headImgMaxUrl"];
    [parms setValue:headerImgUrlStr forKey:@"headImgSmallUrl"];
    [self charUserChangeUserInfoWithParms:parms withBlock:dicBlock];
  
}
+ (void)chatUserInfoChangeNickNameNew:(NSString *)nickNameStr withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:nickNameStr forKey:@"nickName"];
    [self charUserChangeUserInfoWithParms:parms withBlock:dicBlock];
}
+ (void)charUserChangeUserInfoWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    //
    NSString *url = @"zhsj/im/user/basicInfo/updateBasic";
    NSString *allUrl = URL_ChatBaseURLNewBase8090(url);
    [[ToolOfNetWork sharedTools]YrequestImNewChatPostALLURLNoMainQueueWithBodyNotParmsHaveNewHeader:allUrl withBody:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCodeKeyIntV==0) {
                //解密
                NSString *getDecStr =   [self useMessageDicGetDecStrWhenCodeIsZero:responsObject];
                NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
                Y_SVP_SHOW_SUCCESS_MES(@"已成功修改！");
                dicBlock(getDic,YES);
            }else{
                DLog(@"   %@",error);
                NSString *msg = [[responsObject allKeys]containsObject:@"err_msg"] ? [NSString stringWithString:[responsObject objectForKey:@"err_msg"]] : @"";//ImNewChat err没有msg 只有err_msg
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
    
}

/**
 *搜索 用uuid/昵称
 */
+ (void)chatSeatchPersonWithNickName:(NSString *)nickNameStr withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    if (nickNameStr.length<=0) {
        return;
    }
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:nickNameStr forKey:@"toUserNickname"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self toolSearchInfoParmWith:parms withBlock:listBlock];
}
//uuid搜索 大概率用于扫描后的
+ (void)chatSeatchPersonWithUUID:(NSString *)otherUUID  withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    //time时间戳
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid forKey:@"from_user"];
    [dic setValue:otherUUID forKey:@"toUserUuid"];
    NSMutableDictionary *parms = [self userInfoSendParmsCreateWithDataDic:dic withTimeStr:timeStr];
    [self toolSearchInfoParmWith:parms withBlock:listBlock];
    
}
+ (void)toolSearchInfoParmWith:(NSMutableDictionary *)parms  withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueueWtihChatTypeUrl:URL_Chat_SearchWithNickName withParams:parms finished:^(id responsObject, NSError *error) {//154success
        if (isNotNil(responsObject)) {
            if (Y_Success_Or_ErrCode==154) {
                NSString *getDecStr =   [self useMessageDicGetDecStr:responsObject];
                NSArray *getArr=  [NSArray arrayWithArray:[Tool arrWithJson:getDecStr]];
                listBlock(getArr,YES);
                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
//                Y_SVP_SHOW_SUCCESS_MES(msg);
            }else{
                listBlock(@[],NO);
//                NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                NSString *msg = @"请求错误";
                if ([[responsObject allKeys] containsObject:@"msg"]) {
                    msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
                }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                    msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
                }
                Y_SVP_SHOW_ERR_MES(msg);
            }
        }else{
            listBlock(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];
}

#pragma mark ===  通知的信息模块 加密 签名 和回调的header所用数据 + 聊天新 换了数据变了的接口
+ (void)toolImMesssageInfoBodyStrWithParmsDic:(NSMutableDictionary *)dic withHeaderUseSBlock:(ImMessageWillSendBodyAndHeaderInfoBlock)imWillSendDic{
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    NSString *tokenS = [TextShowWithModelStr textShowWithModelStr:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token];//防止nil
    [headerDic setValue:tokenS forKey:@"token"];
    [headerDic setValue:kMobile forKey:@"device"];
    NSString *randomStr = [Tool toolCreateRandomUuidSmall];//请求随机数 onlyReq
    [headerDic setValue:randomStr forKey:@"onlyReq"];
    
    //
    NSString *timeStr = [ToolOfTimeChangeFormat currentTimeStr];
    //转json
    NSString *jsonStr = [Tool jsonStrWithDic:dic];
    //aes加密
    NSString *jsonAesOk = [ChatAESTool chatTypeEncryptAESUseServiceKeyIvAndLocalTimeStr:timeStr withStr:jsonStr];//用的key iv 用变化的
   
    //留存用于data sign则需要data+md5=sign
    //md5签名
    NSString *data = jsonAesOk;
    NSString *device = kMobile;
    NSString *onlyReq = randomStr;
    NSString *security_secret = IM_Message_Mobul_MD5_Use_KEY;
    NSString *time = timeStr;
    NSString *token = tokenS;
    NSString *imMD5willStr = [NSString stringWithFormat:@"data=%@&device=%@&onlyReq=%@&security_secret=%@&time=%@&token=%@", data, device, onlyReq ,security_secret , time, token];//deviceMark
    NSString *md5Ok = [ChatAESTool chatMD5ForString:imMD5willStr];
    NSLog(@"新Im总数据 封装\n dic== %@, md5willStr = %@ , md5ok ==%@",dic,imMD5willStr,md5Ok);

    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:data forKey:@"data"];
    [parms setValue:md5Ok forKey:@"sign"];
    [parms setValue:time forKey:@"time"];
    DLog(@"\n 将用于%@",parms);
    //总数据即将用于body请求
    imWillSendDic(onlyReq,parms);
  
}

//通知的信息模块 得到数据data等 后解密成dic
+ (void)toolImMesssageInfoResponsObject:(id)responsObject  withChangeToDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock{
    if (isNotNil(responsObject)) {
        if ([[responsObject objectForKey:@"err_code"] intValue] == 0) {
            NSString *getDecStr = [self imMessageUseMessageDicGetDecStr:responsObject];
            NSDictionary *getDic =  [Tool dictionaryWithJsonString:getDecStr];
            dicBlock(getDic,YES);
        }else if ([[responsObject objectForKey:@"err_code"] intValue] == Im_err_code_Num_NotOnLineMsg){
            //"err_code" = 1003;
            //"err_msg" = "用户未登录，请进行登录";
           //ChatSeverConnectionBegin
            [[ChatSeverConnectionBegin share]initChatWithSocketNeedInfoAndOpenSocket];
            NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
            if ([msg containsString:@"未登录"] || [msg containsString:@"没有登录"]) {
                msg = @"用户通讯功能正在进行登录，成功后，请重新刷新数据";
            }
            /**
             IS_Login_NotLogin,     //未登录
             IS_Login_Tourists,     //游客
             */
            if ( [IsLoginTool share].save_Login_Type == IS_Login_NotLogin ||  [IsLoginTool share].save_Login_Type == IS_Login_Tourists) {//非登录的状态--不再弹出这种1003提示
            }else{
                Y_SVP_SHOW_INFO_MES(msg);
            }
      
        }else{
//            NSString *msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
            NSString *msg = @"请求错误";
            if ([[responsObject allKeys] containsObject:@"msg"]) {
                msg = [NSString stringWithString:[responsObject objectForKey:@"msg"]];
            }else if([[responsObject allKeys] containsObject:@"err_msg"]){
                msg = [NSString stringWithString:[responsObject objectForKey:@"err_msg"]];
            }
            Y_SVP_SHOW_ERR_MES(msg);
            DLog(@"通知的信息模块err    %@",msg);
            dicBlock(@{},NO);
        }
    }else{
      //系统得到数据错误
    }
}
+ (NSString *)imMessageUseMessageDicGetDecStr:(NSDictionary *)dic{
    NSString *dataStr = @"";
    if ([[dic objectForKey:@"code"] intValue] == 0) {
        NSString *data = [NSString stringWithString: isNotNil([dic objectForKey:@"data"])?[dic objectForKey:@"data"]:@""];
        NSString *time = [NSString stringWithString:[dic objectForKey:@"time"]];
        if ( isNil(data) || [data isEqualToString:@""] ) {
            return @"";
        }
        //解密 本地的key+ data_time+服务器iv
        NSString *aesDecStr = [ChatAESTool chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:time withStr:data];
        return aesDecStr;
    }else{
        dataStr = @"数据有误";
    }
    
    return dataStr;
}
@end
