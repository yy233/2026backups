//
//  YTimeStamp.m
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import "YTimeStamp.h"

@implementation YTimeStamp

/***
 格式
 YTimeStamp.m:88      getNowTimeTimestamp_haoMiao =  1685010526000
 YTimeStamp.m:63      getNowTimeTimestamp2 =  1685010527
 YTimeStamp.m:51      getNowTimeTimestamp =  1685010526
 YTimeStamp.m:27      getCurrentTimes =  2023-05-25 18:28:46
 
 */
+(NSString*)getCurrentTimeStr_nianToMiao{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"getCurrentTimes =  %@",currentTimeString);
    
    return currentTimeString;
    
}
+(NSString *)getNowTimeTimestamp_miao_ShiQu{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"getNowTimeTimestamp =  %@",timeSp);
    return timeSp;
    
}

+(NSString *)getNowTimeTimestamp_miao{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSLog(@"getNowTimeTimestamp2 =  %@",timeString);
    return timeString;
}

//获取当前时间戳  （以毫秒为单位） 常用数据

+(NSString *)getNowTimeTimestamp_haoMiao{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    //NSLog(@"getNowTimeTimestamp_haoMiao =  %@",timeSp);
    return timeSp;
    
}


//给到当前时间月份日期小时分钟的文本str时间字符串
+(NSString *)getNowTimeTimesMDHMStr{
    NSString *okStr = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MMddHHMM"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    okStr = [formatter stringFromDate: [NSDate now]];
    //设置时区,这个对于时间的处理有时很重要
    return  okStr;
}


//转换为获取时间戳  （以毫秒为单位）

+(NSString *)getTimeTimestamp_haoMiao_Date:(NSDate *)sendDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
//   sendDate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[sendDate timeIntervalSince1970]*1000];
    NSLog(@"getNowTimeTimestamp_haoMiao =  %@",timeSp);
    return timeSp;
    
}

//date转换为展示时间字符串

+(NSString *)getTimeShwoStr_Date:(NSDate *)sendDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSInteger interval = fabs([sendDate timeIntervalSinceNow]);

    /**
     if(interval < 24*60*60){
         [formatter setDateFormat:@"dd HH:mm:ss"];
     }else{
         [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
     }
     */
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //0902格式更换
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSString *showStr = [formatter stringFromDate:sendDate];
    return showStr;
    
}


#pragma mark ==== 某时间str的时间戳

+ (NSString *)getTimeIvWithTimeStr_YMDHMS:(NSString *)timeStr{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];

    NSDate* thisDate = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[thisDate timeIntervalSince1970]*1000];
    //NSLog(@"getTimeIvWithTimeStr_YMDHMS =  %@",timeSp);
 
    return timeSp;
}

#pragma mark ==== 某时间str -转换为 另一个格式的时间Str
+ (NSString *)getTimeMDHMSUseTimeYMDHMSstr:(NSString *)timeStr{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSDateFormatter *formatterNoY = [[NSDateFormatter alloc] init] ;
    [formatterNoY setDateStyle:NSDateFormatterMediumStyle];
    [formatterNoY setTimeStyle:NSDateFormatterShortStyle];
    [formatterNoY setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatterNoY setTimeZone:timeZone];
    
    NSDate* thisDate = [formatter dateFromString:timeStr];
    NSString* thisNewTimeStr = [formatterNoY stringFromDate:thisDate];
    //NSLog(@"getTimeMDHMSUseTimeYMDHMSstr =  %@",thisNewTimeStr);
    return thisNewTimeStr;
}


#pragma mark ==== 某时间Iv -转换为timeStr
+ (NSString *)getMDhmsTimeStrUseiInfoTime:(NSInteger )timeIv{
    timeIv = [self timeIvZhuan10w:timeIv];//ios用的是10位
    NSDateFormatter *formatterNoY = [[NSDateFormatter alloc] init] ;
    [formatterNoY setDateStyle:NSDateFormatterMediumStyle];
    [formatterNoY setTimeStyle:NSDateFormatterShortStyle];
    [formatterNoY setDateFormat:@"MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatterNoY setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self timeIvZhuan13w:timeIv]];
    NSString *confromTimespStr = [formatterNoY stringFromDate:confromTimesp];
    
    NSLog(@"getMDhmsTimeStrUseTimeIv =  %@",confromTimespStr);
    return confromTimespStr;
}

//某时间Ivstr -转换为timeStr Y-s
+ (NSString *)getYMDhmsTimeStrUseInfoTimeIvStr:(NSString *)timeIvstr{

    NSInteger timeIv = [self timeIvZhuan10w: [timeIvstr integerValue]];//ios用的是10位
    DLog(@"timeIvstr %@,timeIv %ld",timeIvstr,timeIv);
    NSDateFormatter *formatterNoY = [[NSDateFormatter alloc] init] ;
    [formatterNoY setDateStyle:NSDateFormatterMediumStyle];
    [formatterNoY setTimeStyle:NSDateFormatterShortStyle];
    [formatterNoY setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatterNoY setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeIv];
    NSString *confromTimespStr = [formatterNoY stringFromDate:confromTimesp];
    
    NSLog(@"getYMDhmsTimeStrUseInfoTimeIvStr =  %@",confromTimespStr);
    return confromTimespStr;
}

#pragma mark ==== 某时间Iv -转换为timeStr ——MHS
+ (NSString *)getHMSTimeStrUseDaoJiShiTimeIv:(NSInteger )timeIv{
//
//    timeIv = [self timeIvZhuan10w:timeIv];
//    NSDateFormatter *formatterNoY = [[NSDateFormatter alloc] init] ;
//    [formatterNoY setDateStyle:NSDateFormatterMediumStyle];
//    [formatterNoY setTimeStyle:NSDateFormatterShortStyle];
//    [formatterNoY setDateFormat:@"HH:mm:ss"];
//
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatterNoY setTimeZone:timeZone];
//
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self timeIvZhuan13w:timeIv]];
//    NSString *confromTimespStr = [formatterNoY stringFromDate:confromTimesp];
//
//    NSLog(@"getHMSTimeStrUseTimeIv =  %@",confromTimespStr);
//    return confromTimespStr;
    
   NSInteger timeout = timeIv;
    int days = (int)(timeout/(3600*24));
    int hours = (int)((timeout-days*24*3600)/3600);
    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
    int second = (int)timeout- (days*24*3600)-(hours*3600)-(minute*60);
    
    
    
    NSString *dStr = [NSString stringWithFormat:@"%d",days];
    NSString *hStr = [NSString stringWithFormat:@"%d",hours];
    NSString *mStr = [NSString stringWithFormat:@"%d",minute];
    NSString *sStr = [NSString stringWithFormat:@"%d",second];
    NSString *showStr = @"";
    
    if(days<=0){
        showStr = [NSString stringWithFormat:@"%@h:%@m:%@s",hStr,mStr,sStr];
    }else{
        NSString *maxHstr = [NSString stringWithFormat:@"%d",(days*24+hours)];
        showStr = [NSString stringWithFormat:@"%@h:%@m:%@s",maxHstr,mStr,sStr];
    }
    NSLog(@"getHMSTimeStrUseDaoJiShiTimeIv --- %@",showStr);
    return showStr ;
    
}

+ (NSString *)getDHMSTimeStrUseDaoJiShiTimeIv:(NSInteger )timeout{
//
//    timeIv = [self timeIvZhuan10w:timeIv];
//    NSDateFormatter *formatterNoY = [[NSDateFormatter alloc] init] ;
//    [formatterNoY setDateStyle:NSDateFormatterMediumStyle];
//    [formatterNoY setTimeStyle:NSDateFormatterShortStyle];
//    [formatterNoY setDateFormat:@"HH:mm:ss"];
//
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatterNoY setTimeZone:timeZone];
//
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self timeIvZhuan13w:timeIv]];
//    NSString *confromTimespStr = [formatterNoY stringFromDate:confromTimesp];
//
//    NSLog(@"getHMSTimeStrUseTimeIv =  %@",confromTimespStr);
//    return confromTimespStr;
    
    
    int days = (int)(timeout/(3600*24));
    int hours = (int)((timeout-days*24*3600)/3600);
    int minute = (int)(timeout-(days*24*3600)-(hours*3600))/60;
    int second = (int)timeout- (days*24*3600)-(hours*3600)-(minute*60);
    
    
    
    NSString *dStr = [NSString stringWithFormat:@"%d",days];
    NSString *hStr = [NSString stringWithFormat:@"%d",hours];
    NSString *mStr = [NSString stringWithFormat:@"%d",minute];
    NSString *sStr = [NSString stringWithFormat:@"%d",second];
    NSString *showStr = @"";
    
    if(days<=0){
        showStr = [NSString stringWithFormat:@"%@h:%@m:%@s",hStr,mStr,sStr];
    }else{
        showStr = [NSString stringWithFormat:@"%@d:%@h:%@m:%@s",dStr,hStr,mStr,sStr];
    }
    NSLog(@"getDHMSTimeStrUseDaoJiShiTimeIv --- %@",showStr);
    return showStr ;
    
}


/**
 服务端传回时间到客户端 常见是13位
 时间戳不是这样的，ios生成的时间戳是10位，所以说需要进行转换
 */

+ (NSInteger)timeIvZhuan10w:(NSInteger)timeIv{
    NSString * timeIvstr = [NSString stringWithFormat:@"%ld",timeIv];
    if(timeIvstr.length == 10){
        return timeIv;
    }else if (timeIvstr.length == 13){
        return (timeIv/1000);
    }else{
        NSLog(@"timeIvZhuan10w 进行转换 原数据 位数非10 非13");
        return 0;
    }
}

+ (NSInteger)timeIvZhuan13w:(NSInteger)timeIv{
    NSString * timeIvstr = [NSString stringWithFormat:@"%ld",timeIv];
    if(timeIvstr.length == 10){
        return (timeIv * 1000);
    }else if (timeIvstr.length == 13){
        return timeIv;
    }else{
        NSLog(@"timeIvZhuan10w 进行转换 原数据 位数非10 非13");
        return 0;
    }
}
@end
