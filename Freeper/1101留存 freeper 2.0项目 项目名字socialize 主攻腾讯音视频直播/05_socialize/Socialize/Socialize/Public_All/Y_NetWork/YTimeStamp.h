//
//  YTimeStamp.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTimeStamp : NSObject
+(NSString*)getCurrentTimeStr_nianToMiao;

+(NSString*)getNowTimeTimestamp_miao_ShiQu;
+(NSString*)getNowTimeTimestamp_miao;
+(NSString *)getNowTimeTimestamp_haoMiao;//毫秒 13位 |*1000微秒16位
//给到当前时间月份日期小时分钟的文本str时间字符串
+(NSString *)getNowTimeTimesMDHMStr;
//转换为获取时间戳  （以毫秒为单位）
+(NSString *)getTimeTimestamp_haoMiao_Date:(NSDate *)sendDate;
//date转换为展示时间字符串
+(NSString *)getTimeShwoStr_Date:(NSDate *)sendDate;
+ (NSString *)getTimeIvWithTimeStr_YMDHMS:(NSString *)timeStr;
//某时间str - 另一个格式的时间Str
+ (NSString *)getTimeMDHMSUseTimeYMDHMSstr:(NSString *)timeStr;
//某时间Iv -转换为timeStr
+ (NSString *)getMDhmsTimeStrUseiInfoTime:(NSInteger )timeIv;
//某时间Ivstr -转换为timeStr Y-s
+ (NSString *)getYMDhmsTimeStrUseInfoTimeIvStr:(NSString *)timeIvstr; 

//某时间Iv -转换为timeStr ——MHS
+ (NSString *)getHMSTimeStrUseDaoJiShiTimeIv:(NSInteger )timeIv;
+ (NSString *)getDHMSTimeStrUseDaoJiShiTimeIv:(NSInteger )timeout;
//
+ (NSInteger)timeIvZhuan13w:(NSInteger)timeIv;
+ (NSInteger)timeIvZhuan10w:(NSInteger)timeIv;
@end

NS_ASSUME_NONNULL_END
