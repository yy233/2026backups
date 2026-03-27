//
//  ToolOfTimeChangeFormat.h
//  Community
//
//  Created by 余莹 on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolOfTimeChangeFormat : NSObject
+ (NSString *)getWeakNameWordsWithNum:(NSInteger)index;
+ (NSInteger)getSumOfDaysInMonth:(NSString *)year month:(NSString *)month;
+ (NSArray *)arrOfWeekStr;
/**
 当前时间str
 */
+ (NSString *)shortStrOfnowTimeWithYearAndMonth;
+ (NSString *)shortStrOfnowTimeWithYearAndMonthAndDay;
+ (NSString *)longStrOfnowTimeWithAllInfo;
+ (NSString *)longStrOfnowTimeWithYearMonthDayHhMmInfo;
+ (NSString *)shortStrOfNowTimeWithYearAndMonthCN;

//"2022-05-19 16:25:40"; 转 5月19日
+ (NSString *)shortChineseStrOfMonthDayStr:(NSString *)timeLongStr;
//"2022-05-19 16:25:40"; 转 5月19日 16:25
+ (NSString *)longChineseStrOfMonthDayHMStr:(NSString *)timeLongStr;


+ (NSString *)dateStrOfYearMonthDayInvStr:(NSDate *)dateInvStr;
+ (NSDate *)dateOfYearMonthDayStr:(NSString *)timeStr;

/**
 时间Date
 */
//+ (NSDate *)dateOfYearMonthDayStr:(NSString *)timeStr;
+ (NSDate *)dateOfYearMonthStr:(NSString *)timeStr;
/**
// 获取这个月第一天是星期几？这一天
// */
//+ (NSInteger)firstDayOfMonthInt;
///**
// 获取某月第一天是星期几 ？这一天
// */
//+ (NSInteger)firstDayOfYearAndMonthData:(NSDate*)date;

//获取日期date对应月的第一天日期
+ (NSString *)getMonthFirstDayWithDate:(NSDate *)date format:(NSString *)aformat;
//获取日期date对应月的最后一天日期
+ (NSString *)getMonthLastDayWithDate:(NSDate *)date format:(NSString *)aformat;
//获取对应日期是周几
+ (NSInteger)getWeekDayFromDate:(NSDate *)date;

/*
 年月str 获取下月/上月的str
 */
+ (NSString *)getLastMonthWithYearAndMonthStr:(NSString *)strOfYearAndMonth;
+ (NSString *)getNextMonthWithYearAndMonthStr:(NSString *)strOfYearAndMonth;

//中文样式
+ (NSString *)timeGetZNFormatWithLineTimeStr:(NSString *)lineStr;
//分割线样式
+ (NSString *)timeGetLineFormatWithZnTimeStr:(NSString *)znStr;
//分割线样式 yyyy年MM月 转 yyyy-MM
+ (NSString *)timeGetYearLineMonthFormatWithZnTimeYearMonthStr:(NSString *)znStr;

//urgentList 紧急消息的列表time
+ (NSString *)urgentListTimeFormatWithStr:(NSString *)timeStr;//"2020-11-19 14:19:16";
+ (NSString *)smallTimeFormatWithLongTimeStr:(NSString *)timeStr;//"2020-11-19 14:19:16";转成短的
//随行人员车辆的列表time 暂不用显示
+ (NSString *)accompanyListTimeFormatWithStr:(NSString *)timeStr;
//生活趣事
+ (NSString *)funNewsListTimeFormatWithStr:(NSString *)timeStr;


#pragma mark ==
//判断是不是今天
+ (BOOL )checkIsThisDayWithTheDateStr:(NSString *)string;
    
#pragma mark ==

/**
 时间戳字符串转年月日 固定转换格式(年-月-日 时:分:秒 毫秒)

 @param date 时间戳字符串
 @return 年 月 日 时 分 秒 毫秒
 */
+ (NSString *)dateToString:(NSString *)date;
/**
 时间戳字符串转年月日 固定格式

 @param dateStr 时间戳字符串(eg:1368082020)
 @return 年月日
 */
+ (NSString *)stringToDate:(NSString *)dateStr;

/**
 年月日转时间戳字符串 自定义格式(yyyy-MM-dd hh:mm:ss zzz)

 @param date 时间戳字符串
 @param format 格式(yyyy-MM-dd hh:mm:ss zzz)
 @return 时间戳字符串
 */
+ (NSString *)dateToString:(NSString *)date Format:(NSString *)format;
/**
 年月日转时间戳字符串

 @param dateStr 字符串(2001-11-11 12:11:44 565)
 @param format 格式(yyyy-MM-dd hh:mm:ss zzz)
 @return 时间戳时间戳
 */
+ (NSString *)stringToDate:(NSString *)dateStr Format:(NSString *)format;
#pragma mark == 获取当前时间戳
//获取当前时间戳
+ (NSString *)currentTimeStr;
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str;
//字符串转时间戳 如：2017-4-10 17:15  //没有秒
+ (NSString *)getTimeStrWithShortYearMonthDayHouseMinString:(NSString *)str;
//时间戳转成时间日期str
+ (NSString *)getDataStrWithStr:(NSString *)intervalString;
#pragma mark ==
//获取x日期的前一天日期
+ (NSString *)getOneDayToLastOneDayStrWithXDayStr_YearMonthDay:(NSString *)xDayStr;
//获取x日期的后一天日期
+ (NSString *)getOneDayToNextOneDayStrWithXDayStr_YearMonthDay:(NSString *)xDayStr;
#pragma mark ==
//获取当前日期开始的七天日期
+ (NSMutableArray *)getCurrentDayToLastServeDay;

@end
    
    NS_ASSUME_NONNULL_END
