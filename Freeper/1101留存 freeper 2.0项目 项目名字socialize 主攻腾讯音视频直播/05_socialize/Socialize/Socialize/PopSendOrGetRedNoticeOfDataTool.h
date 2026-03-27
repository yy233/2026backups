//
//  PopSendOrGetRedNoticeOfDataTool.h
//  Socialize
//
//  Created by 余莹 on 2023/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *URL_My_wallet_list =@"/auth/wallet/list";//我的钱包列表
static NSString *URL_redEnvelope_create = @"/auth/redEnvelope/create";//红包 - 创建红包
static NSString *URL_redEnvelope_snatch = @"/auth/redEnvelope/snatch";//红包 - 抢红包
static NSString *URL_redEnvelope_detail = @"/auth/redEnvelope/detail";//红包 - 详情
static NSString *URL_redEnvelope_liveReward = @"/auth/redEnvelope/liveReward"; //打赏主播
static NSString *URL_getMyBalance = @"/api/v1/proprietor/user/account/balance"; //用户余额



@interface PopSendOrGetRedNoticeOfDataTool : NSObject
+ (void)redEnvGetWalletListWithBolock:(BaseListArrAndSuccessBoolBlock)block; 
+ (void)redEnvCreateWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)redEnvSnatchWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)redEnvDetailWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)redEnvLiveRewardWithData:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
//+ (void)checkMyHaveBalanceWithBlock:(BaseDicAndSuccessBoolBlock)block;

@end




@interface RedEvnInfoModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *reUno;//红包唯一编号 redEnvelope id
@property (nonatomic,copy) NSString *address;
@property (nonatomic,assign) NSInteger category;//红包类型， 0、运气红包， 1、均分红包，2、定向红包。 定向红包可不传
@property (nonatomic,copy) NSString *channelId;//    群ID 被发送方用户ID
@property (nonatomic,copy) NSString *activityId;//   直播频道ID
@property (nonatomic,copy) NSString *contractAddress;//合约地址
@property (nonatomic,copy) NSString *cover;//封面
@property (nonatomic,copy) NSString *expireTs;
@property (nonatomic,copy) NSString *gotAmount;
@property (nonatomic,copy) NSString *gotCount;
@property (nonatomic,assign) NSInteger pieces;//红包个， 定向红包不传
@property (nonatomic,copy) NSNumber *amount;//红包金额， 定向红包不传
@property (nonatomic,copy) NSString *rowCreate;
@property (nonatomic,copy) NSString *rowUpdate;
@property (nonatomic,copy) NSNumber *scene;//红包模块， 0、聊天， 1、直播
@property (nonatomic,copy) NSString *senderMsg;//发送者信息
@property (nonatomic,copy) NSString *title;//红包标题
@property (nonatomic,copy) NSString *uno;
@property (nonatomic,copy) NSString *signature;//签名字符串
@property (nonatomic,copy) NSString *time;//时间戳
@property (nonatomic,strong) NSArray *receiver;
//创建返回数据
@property (nonatomic,copy) NSNumber *total;//红包金额， 定向红包不传
@property (nonatomic,copy) NSString *wid;

/**
 category = 0;
 channelId = csGPjHpV9COT;
 contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
 cover = "https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";
 expireTs = 1695110320315;
 id = 16;
 pieces = 1;
 scene = 0;
 senderMsg = "aaaaaaaaaa.free";
 title = "恭喜发财，大吉大利";
 total = 32;
 uno = 20230918075840300640810;
 wid = 651446;
 };*/

@end


#pragma mark == 抢到红包后
@interface RedEvn_gotRecordArrObjModel : NSObject

@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *imId;
@property (nonatomic,copy) NSString *lifeImages;
@property (nonatomic,copy) NSString *profileImageUrl;
@property (nonatomic,copy) NSString *gotAmount;

@end

@interface RedEvn_gotRecordDataModel : NSObject
@property (nonatomic,strong) NSArray *gotRecord;
//@property (nonatomic,strong) NSArray<RedEvn_gotRecordArrObjModel *> *gotRecord;
@property (nonatomic,strong) RedEvnInfoModel *redEnvelope;

@end
/**
 https://test.freeper.l-z.vip:61125/auth/redEnvelope/snatch____{
    data =     {
        gotRecord =         (
                        {
                address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
                domain = "aaaaaaaaaa.free";
                gotAmount = 2;
                imId = ueVPpA2rSrKnT;
                lifeImages = "";
                profileImageUrl = "https://test.freeper.l-z.vip:61131/avatar/2023-08/5/1jFW9OF_720_543_32751_gmi.jpg";
                username = "";
            }
        );
        redEnvelope =         {
            address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
            category = 0;
            channelId = csGPjHpV9COT;
            contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
            cover = "https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";
            expireTs = 1695111079926;
            gotAmount = 0;
            gotCount = 0;
            id = 19;
            pieces = 1;
            rowCreate = "2023-09-18 08:11:19";
            rowUpdate = "2023-09-18 08:11:19";
            scene = 0;
            senderMsg = "aaaaaaaaaa.free";
            state = 0;
            title = "恭喜发财，大吉大利";
            total = 31;
            uno = 20230918081119910829700;
            wid = 651446;
        };
    };
    message = success;
    status = 200;
    timestamp = 1695090366980;*/

NS_ASSUME_NONNULL_END
