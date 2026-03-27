//
//  ToolOfTimeChangeFormat.m
//  Community
//
//  Created by 余莹 on 2020/12/7.
//

#import "ToolOfTimeChangeFormat.h"

@implementation ToolOfTimeChangeFormat

+ (NSString *)getWeakNameWordsWithNum:(NSInteger)index{
    //
    
    
    switch (index) {
        case 0:
            return @"日";
            break;
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
            
        default:
            return @"无效符号";
            break;
    }
    
    return @"无效符号";
}

//系统英文中文 暂不用这个方法
+ (NSArray *)arrOfWeekStr{
    //
    //    NSDateFormatter *formatter = [NSDateFormatter new];
    //    NSMutableArray *days = [[formatter veryShortWeekdaySymbols] mutableCopy];
    //    return days;
    //    /**
    //     S,
    //     M,
    //     T,
    //     W,
    //     T,
    //     F,
    //     S*/
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray * array =  dateFormatter.veryShortWeekdaySymbols;
    NSArray * array2 =  dateFormatter.veryShortStandaloneWeekdaySymbols;
    NSLog(@"arrOfWeekStr = %@",array);
    return array;
}


/**
 得到某年某月的天数
 */
+ (NSInteger)getSumOfDaysInMonth:(NSString *)year month:(NSString *)month{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    NSString * dateStr = [NSString stringWithFormat:@"%@-%@",year,month];
    NSDate * date = [formatter dateFromString:dateStr];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}
/**
 当前时间
 */
+ (NSString *)longStrOfnowTimeWithAllInfo{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd  HH:mm:ss EEEE";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    [formatter setDateFormat:@"yyyy-MM"];
    NSDate * nowdate = [NSDate date];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
+ (NSString *)longStrOfnowTimeWithYearMonthDayHhMmInfo{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    [formatter setDateFormat:@"yyyy-MM"];
    NSDate * nowdate = [NSDate date];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
+ (NSString *)shortStrOfnowTimeWithYearAndMonthAndDay{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate * nowdate = [NSDate date];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
+ (NSString *)shortStrOfnowTimeWithYearAndMonth{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate * nowdate = [NSDate date];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
+ (NSString *)shortStrOfNowTimeWithYearAndMonthCN{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate * nowdate = [NSDate date];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
#pragma mark == @"yyyy-MM-dd" 互转
/**
 时间Date
 */
+ (NSDate *)dateOfYearMonthDayStr:(NSString *)timeStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate*date =[dateFormat dateFromString:timeStr];

    return date;
}
+ (NSString *)dateStrOfYearMonthDayInvStr:(NSDate *)dateInvStr{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* dateString = [formatter stringFromDate:dateInvStr];
    return dateString;
}


/**
 例子
 2020-12 会得到2020-11-30 so ： 拼接成02day ==当月1号的date
 */
+ (NSDate *)dateOfYearMonthStr:(NSString *)timeStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy-MM"];
//    NSDate*date =[dateFormat dateFromString:timeStr];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-02",timeStr]];
//    NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-07",timeStr]];
    if (timeStr.length>=10) {
        NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@",timeStr]];
        return date;
    }else{
        NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@-03",timeStr]];
        return date;
    }
}
///**
// 获取当前月第一天是星期几 今天星期几
// */
//+ (NSInteger)firstDayOfMonthInt{
////    NSDate*currentdate=[NSDate date];
////    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
////    int firstDayOfMonthInt = [[NSCalendar currentCalendar]ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:currentdate];
//
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents*comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];//
//    NSInteger weekday = [comps weekday];
//    return weekday;
//
//}
///**
// 获取某月第一天是星期几 今天星期几
// */
//+ (NSInteger)firstDayOfYearAndMonthData:(NSDate*)date{
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
//    //NSCalendarUnitWeekday 星期单位。范围为1-7 （一个星期有七天）
//    NSInteger weekday = [comps weekday];
//    NSLog(@"weekday == %ld",(long)weekday);
//    return weekday;
//}

/**
 getMonthBeginAndEndWith
 */
+ (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr{
      
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
      
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return s;
}

/**
 */
//获取日期date对应月的第一天日期
+ (NSString *)getMonthFirstDayWithDate:(NSDate *)date format:(NSString *)aformat{
    NSDate *newDate = date;
    double interval = 0;
    NSDate *firstDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL bl = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    if (bl) {
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:aformat];
        NSString *firstString = [myDateFormatter stringFromDate: firstDate];
        return firstString;
    }
    return @"";
}
//获取日期date对应月的最后一天日期
+ (NSString *)getMonthLastDayWithDate:(NSDate *)date format:(NSString *)aformat{
    NSDate *newDate = date;
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL bl = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    if (bl) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:aformat];
        NSString *lastString = [myDateFormatter stringFromDate: lastDate];
        return lastString;
    }
    return @"";
}
//获取对应日期是周几
+ (NSInteger)getWeekDayFromDate:(NSDate *)date{
    if (date==nil) {
        return 8;//无效数据
    }
    NSArray *tempWeek = @[@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    //  1、2、3、4、5、6、7 分别对应 周日、周一、周二、周三、周四、周五、周六
    NSInteger week = [comps weekday];
//    NSLog(@"-getWeekDayFromDate   --%ld",(long)week);
  //  调整后 1 代表 周一
    return  [tempWeek[week-1] integerValue] ;
    
}

+ (NSString *)getLastMonthWithYearAndMonthStr:(NSString *)strOfYearAndMonth{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [formatter dateFromString:strOfYearAndMonth];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}
+ (NSString *)getNextMonthWithYearAndMonthStr:(NSString *)strOfYearAndMonth{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [formatter dateFromString:strOfYearAndMonth];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:+1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}

/**
 格式转换
 */

//分割线样式 yyyy年MM月 转 yyyy-MM-dd 
+ (NSString *)timeGetLineFormatWithZnTimeStr:(NSString *)znStr{
    if (znStr.length>=10) {
    }else{
        znStr = [NSString stringWithFormat:@"%@02日",znStr];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate*nowdate = [formatter dateFromString:znStr];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
//中文样式 yyyy-MM-dd 转 yyyy年MM月
+ (NSString *)timeGetZNFormatWithLineTimeStr:(NSString *)lineStr{
    if (lineStr.length>=10) {
    }else{
        lineStr = [NSString stringWithFormat:@"%-@02",lineStr];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*nowdate = [formatter dateFromString:lineStr];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}
//分割线样式 yyyy年MM月 转 yyyy-MM
+ (NSString *)timeGetYearLineMonthFormatWithZnTimeYearMonthStr:(NSString *)znStr{
    if (znStr.length>=10) {
        return znStr;
    }else{
        znStr = [NSString stringWithFormat:@"%@02日",znStr];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate*nowdate = [formatter dateFromString:znStr];
    
    [formatter setDateFormat:@"yyyy-MM"];
    NSString* dateString = [formatter stringFromDate:nowdate];
    return dateString;
}

#pragma mark ==
//urgentList 紧急消息的列表time 社区趣事的详情页
+ (NSString *)urgentListTimeFormatWithStr:(NSString *)timeStr{//"2020-11-19 14:19:16";
    if (timeStr.length<19) {
        return timeStr;//规格不和
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*nowdate = [formatter dateFromString:timeStr];//nil问题hh 12时
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
    [newFormatter setDateFormat:@"MM/dd HH:mm"];
    NSString* dateString = [newFormatter stringFromDate:nowdate];
     return dateString;
    

}

//urgentList 随行人员车辆的列表time 暂不用
+ (NSString *)accompanyListTimeFormatWithStr:(NSString *)timeStr{//"2020-11-19 14:19:16";
    if (timeStr.length<19) {
        return timeStr;//规格不和
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*nowdate = [formatter dateFromString:timeStr];//nil问题hh 12时
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
    [newFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateString = [newFormatter stringFromDate:nowdate];
     return dateString;
    

}

//urgentList 紧急消息的列表time
+ (NSString *)funNewsListTimeFormatWithStr:(NSString *)timeStr{//"2020-11-19 14:19:16";
    if (timeStr.length<19) {
        return timeStr;//规格不和
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*nowdate = [formatter dateFromString:timeStr];//nil问题hh 12时
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
    [newFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [newFormatter stringFromDate:nowdate];
     return dateString;
    

}

#pragma mark ==
//判断是不是今天
+ (BOOL )checkIsThisDayWithTheDateStr:(NSString *)string{
    
    // 进行转换
    NSTimeInterval time = [string doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: time/1000];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    return isToday;
  
}
#pragma mark ==
+ (NSString *)dateToString:(NSString *)date {
   // 初始化时间格式控制器
   NSDateFormatter *matter = [[NSDateFormatter alloc] init];
   // 设置设计格式
   [matter setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
   // 进行转换
   NSTimeInterval time = [date doubleValue] + 28800;
   NSDate * Date = [NSDate dateWithTimeIntervalSince1970:time];
   NSString *dateStr = [matter stringFromDate:Date];
   return dateStr;
}
+ (NSString *)dateToString:(NSString *)date Format:(NSString *)format{
   // 初始化时间格式控制器
   NSDateFormatter *matter = [[NSDateFormatter alloc] init];
   // 设置设计格式
   [matter setDateFormat:format];
   // 进行转换
   NSTimeInterval time = [date doubleValue];
   NSDate* Date = [NSDate dateWithTimeIntervalSince1970: time/1000];
//   NSDate * Date = [NSDate dateWithTimeIntervalSince1970:time]; *1000;// *1000 是精确到毫秒，不乘就是精确到秒
   NSString *dateStr = [matter stringFromDate:Date];
   return dateStr;
}

+ (NSString *)stringToDate:(NSString *)dateStr {
   
   // 初始化时间格式控制器
   NSDateFormatter *matter = [[NSDateFormatter alloc] init];
   // 设置设计格式
   [matter setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
   NSTimeInterval time = [dateStr doubleValue];
   NSDate * Date = [NSDate dateWithTimeIntervalSince1970:time];
   // 进行转换
   NSString *date = [matter stringFromDate:Date];
   
   return date;
}
+ (NSString *)stringToDate:(NSString *)dateStr Format:(NSString *)format{
   
   // 初始化时间格式控制器
   NSDateFormatter *matter = [[NSDateFormatter alloc] init];
   // 设置设计格式
   [matter setDateFormat:format];
   NSTimeInterval time = [dateStr doubleValue];
   NSDate * Date = [NSDate dateWithTimeIntervalSince1970:time];
   // 进行转换
   NSString *date = [matter stringFromDate:Date];
   return date;
}
#pragma mark ==
//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
//字符串转时间戳 如：2017-4-10 17:15:10 
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
//字符串转时间戳 如：2017-4-10 17:15  //没有秒
+ (NSString *)getTimeStrWithShortYearMonthDayHouseMinString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
//时间戳转成时间日期str
+ (NSString *)getDataStrWithStr:(NSString *)intervalString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: [intervalString integerValue]/1000];
    
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}
#pragma mark ==
//获取x日期的前一天日期
+ (NSString *)getOneDayToLastOneDayStrWithXDayStr_YearMonthDay:(NSString *)xDayStr{
    NSDate *xDate =  [self dateOfYearMonthDayStr:xDayStr];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:xDate];//前一天
    return [self dateStrOfYearMonthDayInvStr:lastDay];
}
//获取x日期的后一天日期
+ (NSString *)getOneDayToNextOneDayStrWithXDayStr_YearMonthDay:(NSString *)xDayStr{
    NSDate *xDate =  [self dateOfYearMonthDayStr:xDayStr];
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:xDate];//后一天
    return [self dateStrOfYearMonthDayInvStr:nextDay];
 
}

//获取当前日期开始的七天日期
+ (NSMutableArray *)getCurrentDayToLastServeDay{
    NSMutableArray *weekArr = [[NSMutableArray alloc] init];
    NSDate *nowDate = [NSDate date];
    //计算从当前日期开始的七天日期
    for (int i = 0; i < 7; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:nowDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        //自定义星期显示
        dateFormatter.weekdaySymbols = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        //自定义日期显示
        dateFormatter.dateFormat = @" EEEE";
        NSString *weekStr = [dateFormatter stringFromDate:curDate];
        //        NSDictionary *dic = @{@"day":dateStr,@"week":weekStr};
        //        NSString *strTime = [NSString stringWithFormat:@"%@%@",dateStr,weekStr];
        //        NSLog(@"%@--%@",strTime,weekStr);
        [weekArr addObject:dateStr];
    }
    return weekArr;
}


+ (NSDateComponents *)getDateComponentsOfNowTime{
    
      NSCalendar *gregorian = [[NSCalendar alloc]
                               initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      // 获取当前日期
      NSDate* dt = [NSDate date];
      // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
      unsigned unitFlags = NSCalendarUnitYear |
      NSCalendarUnitMonth |  NSCalendarUnitDay |
      NSCalendarUnitHour |  NSCalendarUnitMinute |
      NSCalendarUnitSecond | NSCalendarUnitWeekday;
      // 获取不同时间字段的信息
      NSDateComponents* comp = [gregorian components: unitFlags
                                            fromDate:dt];
    return comp;
      
}

+ (NSDateComponents *)getDateComponentsOfOtherTime:(NSDate *)data{

      NSCalendar *gregorian = [[NSCalendar alloc]
                               initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
      // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
      unsigned unitFlags = NSCalendarUnitYear |
      NSCalendarUnitMonth |  NSCalendarUnitDay |
      NSCalendarUnitHour |  NSCalendarUnitMinute |
      NSCalendarUnitSecond | NSCalendarUnitWeekday;
      // 获取不同时间字段的信息
      NSDateComponents* comp = [gregorian components: unitFlags
                                            fromDate:data];
    return comp;
      
}
@end
