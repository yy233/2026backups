//
//  ToolOfBasic.m
//  shusheng
//
//  Created by rimi on 16/7/9.
//  Copyright © 2016年 yuying. All rights reserved.
//

#import "ToolOfBasic.h"
#import "GTMBase64.h" //base64加密

#import "AFNetworking.h"
#import "Reachability.h"

#import "MapCGTool.h"
@implementation ToolOfBasic

#pragma wifi 

+ (AFHttpNetworkStatus)currentNetworkStatus{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus value = [reachability currentReachabilityStatus];
    switch (value) {
        case NotReachable:
            return AFHttpNotReachable;
            break;
        case ReachableViaWiFi:
            return AFHttpReachableViaWiFi;
            break;
        case ReachableViaWWAN:
            return AFHttpReachableViaWWAN;
            break;
            
        default:
            return AFHttpNotReachable;
            break;
    }
    
}

#pragma mark —————— 时间
+(NSString *)nowTime{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString * morelocationString=[dateformatter stringFromDate:senddate];
//    NSLog(@"%@",morelocationString);
    
    return morelocationString;
}

+(NSDate *)nowTimeOfDate{
    NSDate * senddate=[NSDate date];
    NSLog(@"%@",senddate);
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY-MM-dd~HH:mm:ss"];
//    NSString * morelocationString=[dateformatter stringFromDate:senddate];
//    NSLog(@"%@",morelocationString);
    
    return senddate;
}

+(NSString *)nowTimeOfLong{
    NSDate * senddate=[NSDate date];
    NSLog(@"%@",senddate);
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        dateformatter.dateFormat = @"YYYY-MM-dd HH:mm";
        NSString * morelocationString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@",morelocationString);
    
    return morelocationString;
}
#pragma mark -- 某格式时间str转->date转->某格式str
+ (NSString *)timeStrChangeNewTimeStrWithOldStr:(NSString *)oldStr{
    
    
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    // NSString * -> NSDate *
    NSDate *data = [format dateFromString:oldStr];
  
    format.dateFormat = @"yyyy MM月dd日 HH:mm";
    NSString *newString = [format stringFromDate:data];
    
    return newString;
}
#pragma mark —————— 上月下月

+ (NSDate *)dayInThePreviousMonth:(NSDate*)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSDate *)dayInTheFollowingMonth:(NSDate*)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

#pragma mark —————— 上下月str
//上月
+ (NSString *)dayInThePreviousMonthStr:(NSString *)dateS
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *oldDate = [formatter dateFromString:dateS];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:-1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:oldDate options:0];
    NSString *newDateStr = [formatter stringFromDate:newdate];
    return newDateStr;
}

//下月
+ (NSString *)dayInTheFollowingMonthStr:(NSString*)dateS
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *oldDate = [formatter dateFromString:dateS];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:1];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:oldDate options:0];
    NSString *newDateStr = [formatter stringFromDate:newdate];
    return newDateStr;
}
#pragma mark —————— 上下几天
+ (NSDate *)dayInThePreviousDayNum:(NSInteger)dayNum  beginDate:(NSDate*)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -dayNum;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSDate *)dayInTheFollowingDayNum:(NSInteger)dayNum  beginDate:(NSDate*)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = dayNum;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
}


#pragma mark —————— int 转小时分钟秒00:00:00
+ (NSString *)timeStr:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    //    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    if (hours==0&&minutes==0&&seconds==0) {
        return @"00:00:01";
    }else{
//        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds]);
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds];
    }
    
}
#pragma mark —————— 秒转小时分钟
+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
//    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    if (hours==0&&minutes==0) {
        return @"00:01";
    }else{
        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds]);
        return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
    }

}
#pragma mark —————— 秒转天小时分钟 小于1分钟记一分钟
+ (NSString *)timeDayFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    int day = (totalSeconds / 3600)/24;
    
    
//    NSInteger d = totalSeconds/60/60/24;
//    NSInteger h = totalSeconds/60/60%24;
//    NSInteger  m = totalSeconds/60%60;
//    NSInteger  s = totalSeconds%60;
 
    if (day==0&&hours==0&&minutes==0) {
        return @"01分钟";
 
    }else if(day==0&&hours==0){
//        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds]);
        return [NSString stringWithFormat:@"%02d分钟", minutes];
    }else if (day==0){
        return [NSString stringWithFormat:@"%02d小时 %02d分钟",hours, minutes];
    }else{//h-day
        int newHour = (hours-24*day);
        if (newHour==0) {
            return [NSString stringWithFormat:@"%d天 %02d分钟",day, minutes];
        }else{
           return [NSString stringWithFormat:@"%d天 %02d小时 %02d分钟",day,newHour, minutes];
        }

        
    }
    
}

+ (NSString *)timeDayFormattedOfEnglish:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    int day = (totalSeconds / 3600)/24;
    
    
    //    NSInteger d = totalSeconds/60/60/24;
    //    NSInteger h = totalSeconds/60/60%24;
    //    NSInteger  m = totalSeconds/60%60;
    //    NSInteger  s = totalSeconds%60;
    
    if (day==0&&hours==0&&minutes==0) {
        return @"01Min";
        
    }else if(day==0&&hours==0){
        //        NSLog(@"%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes,seconds]);
        return [NSString stringWithFormat:@"%02dMin", minutes];
    }else if (day==0){
        return [NSString stringWithFormat:@"%02dHour  %02dMin",hours, minutes];
    }else{//0130 h-天
        int newHour = (hours-24*day);
        if (newHour==0) {
         return [NSString stringWithFormat:@"%dDay  %02dMin",day, minutes];
        }else{
             return [NSString stringWithFormat:@"%dDay %02dHour %02dMin",day,newHour, minutes];
        }
      
        
    }
    
}

#pragma mark —————— 秒转分钟小于一分钟记一分钟
+ (NSString *)timeForMinuteswithTalSseconds:(int)totalSeconds
{
    
    
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    
    if (hours==0&&minutes==0) {
        return @"1";//一分钟
    }else{
        
        return [NSString stringWithFormat:@"%d",hours*60+minutes];
    }
    
}


#pragma mark —————— NSString 转换为 NSDate
+(NSDate *)strLongBecomeDate:(NSString *)longDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:longDateStr];
    return date;
}

+(NSDate *)strShortBecomeDate:(NSString *)shortDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:shortDateStr];
    return date;
}

#pragma mark —————— NSDate 转换为 NSString
+ (NSString *)dateBecomeLongStr:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}
+ (NSString *)dateBecomeShortStr:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}


#pragma mark —————— 前后时间串进行比较
+ (int)compareOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDayStr, anotherDayStr);
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

#pragma mark —————— 表情过滤
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark —————— 加密解密

/***
 将字符串Base64加密
 @param input 需要加密的字符串
 */
+ (NSString*)encodeBase64String:(NSString*)input{
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


/***
 解密Base64字符串
 @para m input 需要解密的字符串
 */
+ (NSString*)decodeBase64String:(NSString*)input{
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return  base64String;
}


/***
 将 data Bese64加密
 @para m  data 需要加密的data数据
 */
+ (NSString*)encodeBase64Data:(NSData*)data{
    
    
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


/***
 解密Base64 data
 @para m 要解密的data数据
 */
+ (NSString*)decodeBase64Data:(NSData*)data{
    
    
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
    
    
    
}

//+ (CLLocation *)AMapLocationFromBaiduLocation:(CLLocation *)BaiduLocation{
//    const double x_pi = M_PI * 3000.0 / 180.0;
//    double x = BaiduLocation.coordinate.longitude - 0.0065, y = BaiduLocation.coordinate.latitude - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    double AMapLongitude = z * cos(theta);
//    double AMapLatitude = z * sin(theta);
//    CLLocation *AMapLocation = [[CLLocation alloc] initWithLatitude:AMapLatitude longitude:AMapLongitude];
//    return AMapLocation;
//}


//图片拼接


+ (UIImage *) combine:(UIImage*)leftImage :(UIImage*)rightImage {
    CGFloat width = leftImage.size.width * 2;
    CGFloat height = leftImage.size.height;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, width/2, height);
    [leftImage drawInRect:rect];
    
    rect.origin.x += width/2;
    [rightImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imagez;
}

////用已知画布大小画图
//用已知画布大小画图
+ (UIImage *)combineTwoImgWithX:(int)mapImgX
                              y:(int)mapImgY
                              w:(int)w
                              h:(int)h
                       NewImage:(UIImage*)newImage
                        newPosx:(int)newPosx
                        newPosy:(int)newPosy
                           newW:(int)newW
                           newH:(int)newH
                    beforeImage:(UIImage*)beforeImage
                     beforePosx:(int)beforePosx
                     beforePosy:(int)beforePosy
                        beforeW:(int)beforeW
                        beforeH:(int)beforeH{
//    NSLog(@"拼图--BigImage=----x=%d--y=%d,w=%d,h=%d",mapImgX,mapImgY,w,h);
//    NSLog(@"拼图--newImage=%@----newPosx=%d--newPosy=%d",newImage,newPosx,newPosy);
//    NSLog(@"拼图--beforeImage=%@----beforePosx=%d--beforePosy=%d",beforeImage,beforePosx,beforePosy);
//    NSLog(@"拼图-- w=%d h=%d w=%d h=%d ----- ",beforeW,beforeH,newW,newH);
//    NSLog(@"拼图");
    CGSize bigSize = CGSizeMake(w, h);
    UIGraphicsBeginImageContext(bigSize);
    

    //before
//    CGFloat beforeWidth = beforeImage.size.width;
//    CGFloat beforeHeight = beforeImage.size.height;
    //画before
    CGRect BeforeRect = CGRectMake(beforePosx,beforePosy,beforeW, beforeH);
    [beforeImage drawInRect:BeforeRect];
    
    
    //画newImg
    //new
    //    CGFloat newWidth = newImage.size.width;
    //    CGFloat newHeight = newImage.size.height;
    CGRect newRect = CGRectMake(newPosx,newPosy,newW, newH);
    
    [newImage drawInRect:newRect];
    
    UIImage* endImage  = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *d = UIImagePNGRepresentation(endImage);
//    NSLog(@" ----img %@",endImage);
//    NSLog(@" ----imgdata %@",d);
    return endImage;
    
}

//+ (UIImage *)combineTwoImgWithX:(int)mapImgX
//                              y:(int)mapImgY
//                              w:(int)w
//                              h:(int)h
//                       NewImage:(UIImage*)newImage
//                        newPosx:(int)newPosx
//                        newPosy:(int)newPosy
//                    beforeImage:(UIImage*)beforeImage
//                     beforePosx:(int)beforePosx
//                     beforePosy:(int)beforePosy{
//     NSLog(@"拼图--BigImage=%@----x=%d--y=%d,w=%d,h=%d",newImage,mapImgX,mapImgY,w,h);
//    NSLog(@"拼图--newImage=%@----newPosx=%d--newPosy=%d",newImage,newPosx,newPosy);
//    NSLog(@"拼图--beforeImage=%@----beforePosx=%d--beforePosy=%d",beforeImage,beforePosx,beforePosy);
//    NSLog(@"拼图--beforeImageW=%f----beforeH=%f--newImageW=%f---newH=%f",beforeImage.size.width,beforeImage.size.height,newImage.size.width,newImage.size.height);
//
//    CGSize bigSize = CGSizeMake(w, h);
//    UIGraphicsBeginImageContext(bigSize);
//    
//    //画newImg
//    //new
//    CGFloat newWidth = newImage.size.width;
//    CGFloat newHeight = newImage.size.height;
//    CGRect newRect = CGRectMake(newPosx,newPosy,newWidth, newHeight);
//    [newImage drawInRect:newRect];
//    
//    //before
//    CGFloat beforeWidth = beforeImage.size.width;
//    CGFloat beforeHeight = beforeImage.size.height;
//    //画before
//    CGRect BeforeRect = CGRectMake(beforePosx,beforePosy,beforeWidth, beforeHeight);
//    [beforeImage drawInRect:BeforeRect];
//    
//    UIImage* endImage  = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    NSData *d = UIImagePNGRepresentation(endImage);
//    NSLog(@" img %@",endImage);
//    NSLog(@" imgdata %@",d);
//    return endImage;
//    
//}
//以新图大小为画布
+ (UIImage *)combineNewImage:(UIImage*)newImage
                     newPosx:(int)newPosx
                     newPosy:(int)newPosy
                 beforeImage:(UIImage*)beforeImage
                  beforePosx:(int)beforePosx
                  beforePosy:(int)beforePosy{
    
//    NSLog(@"拼图--newImage=%@----newPosx=%d--newPosy=%d",newImage,newPosx,newPosy);
//    NSLog(@"拼图--beforeImage=%@----beforePosx=%d--beforePosy=%d",beforeImage,beforePosx,beforePosy);
    //new
    CGFloat newWidth = newImage.size.width;
    CGFloat newHeight = newImage.size.height;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    //画newImg
    CGRect newRect = CGRectMake(newPosx,newPosy,newWidth, newHeight);
    [newImage drawInRect:newRect];
    
    //before
    CGFloat beforeWidth = beforeImage.size.width;
    CGFloat beforeHeight = beforeImage.size.height;
    //画before
    CGRect BeforeRect = CGRectMake(beforePosx,beforePosy,beforeWidth, beforeHeight);
    [beforeImage drawInRect:BeforeRect];
    
    UIImage* endImage  = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return endImage;
}

//

#pragma mark - 冒泡降序排序
+ (NSMutableArray *)bubbleDescendingOrderSortWithArray:(NSMutableArray *)descendingArr
{
    for (int i = 0; i < descendingArr.count; i++) {
        for (int j = 0; j < descendingArr.count - 1 - i; j++) {
            if ([descendingArr[j] intValue] < [descendingArr[j + 1] intValue]) {
                int tmp = [descendingArr[j] intValue];
                descendingArr[j] = descendingArr[j + 1];
                descendingArr[j + 1] = [NSNumber numberWithInt:tmp];
            }
        }
    }
//    NSLog(@"冒泡降序排序后结果：%@", descendingArr);
    return descendingArr;
    
}

#pragma mark - 冒泡升序排序 最大的放最后一个位置
+ (NSMutableArray *)bubbleAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr
{
//     NSLog(@"冒泡升序排序前：%@", ascendingArr);
    for (int i = 0; i < ascendingArr.count; i++) {
        for (int j = 0; j < ascendingArr.count - 1 - i;j++) {
            if ([ascendingArr[j+1]intValue] < [ascendingArr[j] intValue]) {
                int temp = [ascendingArr[j] intValue];
                ascendingArr[j] = ascendingArr[j + 1];
                ascendingArr[j + 1] = [NSNumber numberWithInt:temp];
            }
        }
    }
//    NSLog(@"冒泡升序排序后结果：%@", ascendingArr);
    
    return ascendingArr;
}



#pragma mark -- rgba->img 使用CGBitmapContextCreateImage 是UIKit的  //y轴镜像 是Graphics的
//坐标轴变过
//rgb转成img 0118
//在通过UIGraphicsGetCurrentContext得到的CGContextRef上画文字,在Retina设备上显示高清,
//但是通过CGBitmapContextCreate得到的CGContextRef上画文字,在Retina设备上显示很模糊?
//抗锯齿
+(UIImage *)getImgWithRect:(CGRect)rect charPointRgba:(unsigned char *)rgba{
   
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       8, // bitsPerComponent
                                                       4*rect.size.width, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);

/**
 CGBitmapContextCreate( ,
 ,,8, bytesPerRow,
colorSpace, uint32_t bitmapInfo)
 */
    
    CGContextSetLineCap(bitmapContext, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(bitmapContext, true);
    CGContextSetShouldAntialias(bitmapContext, true);
//    CGContextSetRenderingIntent(bitmapContext, kCGRenderingIntentPerceptual);

    
    ///--
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newUIImage = [UIImage imageWithCGImage:cgImage];
    CFRelease(colorSpace);//手动释放内存
    CGContextRelease(bitmapContext);
    free(rgba);
    //y轴镜像
    UIImage *newImgOk = [ToolOfBasic getYMirrorFlipWithImg:newUIImage];
//    NSLog(@"y轴镜像");
     return newImgOk;
    
  ///--
//    UIGraphicsBeginImageContext(rect.size);
//    // the same: UIGraphicsBeginImageContextWithOptions(outSize, NO, 1.0f);
//
//    CGContextRef cgCtx = UIGraphicsGetCurrentContext();
//    CGContextSetBlendMode(cgCtx, kCGBlendModeCopy);//全色覆盖整个图片
//
//    CGContextDrawImage(cgCtx, CGRectMake(0.0, 0.0, rect.size.width, rect.size.height), cgImage);
//
//    CGContextSetLineWidth(cgCtx, 2.0);// 设置画笔宽度
//    CGContextDrawPath(cgCtx, kCGPathStroke);
//
//    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//    return retImage;
   ///--
}
//+(UIImage *)getImgWithRect:(CGRect)rect
//             charPointRgba:(unsigned char*)rgba{
//
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef bitmapContext = CGBitmapContextCreate(
//                                                       rgba,
//                                                       rect.size.width,
//                                                       rect.size.height,
//                                                       8, // bitsPerComponent
//                                                       4*rect.size.width, // bytesPerRow
//                                                       colorSpace,
//                                                       kCGImageAlphaPremultipliedLast);
//
//
//
//    CFRelease(colorSpace);//手动释放内存
//    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
//
//
//    free(rgba);
//
//    UIImage *newUIImage = [UIImage imageWithCGImage:cgImage];
//
//    //y轴镜像
//    UIImage *newImgOk = [ToolOfBasic getYMirrorFlipWithImg:newUIImage];
//    NSLog(@"y轴镜像");
//
//    ///////
////  UIImage *reImg =  [MapCGTool transToMosaicImage:newImgOk blockLevel:1];
////   UIImage *reImg =    [MapCGTool mosaicImage:newImgOk withLevel:1];
//    return newImgOk;
//
//}

//+(UIImage *)getImgWithRect:(CGRect)rect
//             charPointRgba:(unsigned char*)rgba{
//
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef bitmapContext = CGBitmapContextCreate(
//                                                       rgba,
//                                                       rect.size.width,
//                                                       rect.size.height,
//                                                       8, // bitsPerComponent
//                                                       4*rect.size.width, // bytesPerRow
//                                                       colorSpace,
//                                                       kCGImageAlphaPremultipliedLast);
////
////
////    CGContextSetLineCap(bitmapContext, kCGLineCapRound);
////    CGContextSetAllowsAntialiasing(bitmapContext, true);
////    CGContextSetShouldAntialias(bitmapContext, true);
////    CGContextSetBlendMode(bitmapContext, kCGBlendModeHue);
//    //下面的代码创建要输出的图像的相关参数
//    CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL,rgba, 4*rect.size.width*rect.size.height, NULL);
//    CGImageRef imgRef = CGImageMaskCreate(rect.size.width, rect.size.height, 8,32, 4*rect.size.width, providerRef, NULL,NO);
//
//
//    UIImage *reUIImage = [UIImage imageWithCGImage:imgRef];
//
//    CFRelease(colorSpace);//手动释放内存
//    CFRelease(providerRef);
//    free(rgba);
//    return reUIImage;
////    float scaleFactor = [[UIScreen mainScreen] scale];
////
////    CGRect bounds = CGRectMake(0, 0,rect.size.width * scaleFactor, rect.size.height * scaleFactor);
////    CGLayerRef layer = CGLayerCreateWithContext(bitmapContext, bounds.size, NULL);
////    CGContextRef layerContext = CGLayerGetContext(layer);
////
////    CGContextScaleCTM(layerContext, scaleFactor, scaleFactor);
////    bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
////    CGContextDrawLayerInRect(bitmapContext, bounds, layer);
//////    CGContextDrawLayerInRect(bitmapContext, bounds, layerContext);
////    CGContextDrawPath(bitmapContext, kCGPathStroke);
////    CGContextSetLineWidth(bitmapContext, 6*scaleFactor);
//
////    CGContextFillPath(bitmapContext);
////    CGContextDrawPath(bitmapContext, kCGPathStroke);
//
////
////
////    UIGraphicsPushContext(bitmapContext);
////
////    CGContextTranslateCTM(bitmapContext, 0, 480);
////    CGContextScaleCTM(bitmapContext, 1.0, -1.0);
////
//    CFRelease(colorSpace);//手动释放内存
//    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
//
//
//    free(rgba);
//
//    UIImage *newUIImage = [UIImage imageWithCGImage:cgImage];
//
//    //y轴镜像
//    UIImage *newImgOk = [ToolOfBasic getYMirrorFlipWithImg:newUIImage];
//    NSLog(@"y轴镜像");
//
//    return newImgOk;
//
//   /*
//    //清晰度
//    float scaleFactor1 = [[UIScreen mainScreen] scale];
//    CGSize size1 = CGSizeMake(rect.size.width, rect.size.height);
//    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
//    CGContextRef bitmapContext1 = CGBitmapContextCreate(rgba,
//                                                        size1.width * scaleFactor1,
//                                                        size1.height * scaleFactor1,
//                                                        8,
//                                                        size1.width * scaleFactor1 * 4,
//                                                        colorSpace1,
//                                                        kCGImageAlphaPremultipliedLast);
//    CFRelease(colorSpace1);//手动释放内存
//
//    CGImageRef cgImage1 = CGBitmapContextCreateImage(bitmapContext1);//致图片失真.
//
//
//    free(rgba);
//
//    UIImage *newUIImage1 = [UIImage imageWithCGImage:cgImage1];
//
//    //y轴镜像
//    UIImage *newImgOk1 = [ToolOfBasic getYMirrorFlipWithImg:newUIImage1];
//    NSLog(@"y轴镜像");
//
//    return newImgOk1;
//    //
//     **/
//}

//+ (NSMutableArray*)twoUseDataPMallocWithData:(NSData *)data
//                             charPointMalloc:(unsigned char*)mallocPoint
//                            arrOfChangeColor:(NSMutableArray*)arrOfChangeColor
//                                           w:(int)w{
//    
//    NSMutableArray *arr = [NSMutableArray array];///成图的arr
//    NSUInteger len = [data length];
//    Byte *byteData = (Byte*)malloc(len);
//    memcpy(byteData, [data bytes], len);//内存拷贝
//    //处理arr
//    for (int i = 0; i<len; i++) {
//       
//        switch (byteData[i]) {
//        case 0://未探索
//            
//            [arr addObject:@"0"];
//            break;
//        case 1://已探索
//            [arr addObject:@"1"];
//            break;
//        case 2:
//            [arr addObject:@"2"];
//            break;
//        case 3:
//            [arr addObject:@"3"];
//            break;
//        case 4:
//            [arr addObject:@"4"];
//            break;
//        case 5://碰撞点
//            [arr addObject:@"5"];
//            break;
//        case 6:
//            [arr addObject:@"6"];
//            break;
//        case 7:
//            [arr addObject:@"7"];
//            break;
//        case 8:
//            [arr addObject:@"8"];
//            break;
//        case 9:
//            [arr addObject:@"9"];
//            break;
//        default:
//            [arr addObject:@"x"];
//            break;
//        }
//        
//    }
//    
//    //假数据 高221 宽250 3个区域的
////    [arr removeAllObjects];
////    for(int i = 0 ;i < 220*250+250;i++){
////        if (i<50*250) {
////            [arr addObject:@"0"];
////        }else if (i<100*250){
////             [arr addObject:@"1"];
////        }else if (i<130*250+80){
////            if (i%250>80) {
////               [arr addObject:@"3"];
////            }else{
////               [arr addObject:@"2"];
////            }
////
////        }else if (i<160*250+60){
////             [arr addObject:@"3"];
////        }else{
////            [arr addObject:@"0"];
////        }
////    }
//   //缝隙
//    for (int i = w; i < arr.count-1-w; i++) {//不做第一排和最后一排
//         //横向arr前后两个元素不同且不为0
//        if (![arr[i] isEqual: arr[i+1]] && ![arr[i] isEqualToString:@"0"] && ![arr[i+1] isEqualToString:@"0"]) {
//            [arr replaceObjectAtIndex:i withObject:@"0"];
//            [arr replaceObjectAtIndex:i+1 withObject:@"0"];
//        }
//        
//        //纵向arr对应img的上下像素元素不同且不为0 i+对应宽度和i-对应宽度
//        if (![arr[i] isEqual: arr[i-w]] && ![arr[i] isEqualToString:@"0"] && ![arr[i-w] isEqualToString:@"0"]) {
//            [arr replaceObjectAtIndex:i withObject:@"0"];
//            [arr replaceObjectAtIndex:i-w withObject:@"0"];
//        }
//        if (![arr[i] isEqual: arr[i+w]] && ![arr[i] isEqualToString:@"0"] && ![arr[i+w] isEqualToString:@"0"]) {
//            [arr replaceObjectAtIndex:i withObject:@"0"];
//            [arr replaceObjectAtIndex:i+w withObject:@"0"];
//        }
//        
//    }
//    
//    //处理img 区域数据的颜色部分
//    /**
//    
//     */
//    
//    
//    for (int i = 0; i < arr.count; i++) {//img
//    
//            switch ([arr[i] intValue]) {
//                case 0://未探索
//
//                    mallocPoint[4*i]   = 0;//R
//                    mallocPoint[4*i+1] = 0;//G
//                    mallocPoint[4*i+2] = 0;//B
//                    mallocPoint[4*i+3] = 0;//A
//
//                    break;
//                case 1://已探索
//                    if ([arrOfChangeColor[0]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 135;//R
////                        mallocPoint[4*i+1] = 57;//G
////                        mallocPoint[4*i+2] = 120;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //淡黄色
//                        mallocPoint[4*i]   = 255;//R
//                        mallocPoint[4*i+1] = 253;//G
//                        mallocPoint[4*i+2] = 161;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }
//
//                    break;
//                case 2:
//                    if ([arrOfChangeColor[1]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 70;//R
////                        mallocPoint[4*i+1] = 188;//G
////                        mallocPoint[4*i+2] = 62;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //浅紫色
//                        mallocPoint[4*i]   = 173;//R
//                        mallocPoint[4*i+1] = 162;//G
//                        mallocPoint[4*i+2] = 207;//B
//                        mallocPoint[4*i+3] = 255;//A
//                        
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }
//                
//                
//                    break;
//                case 3:
//                    if ([arrOfChangeColor[2]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 121;//R
////                        mallocPoint[4*i+1] = 134;//G
////                        mallocPoint[4*i+2] = 198;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //浅粉色
//                        mallocPoint[4*i]   = 237;//R
//                        mallocPoint[4*i+1] = 156;//G
//                        mallocPoint[4*i+2] = 174;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//
//                    }
//                   
//                    break;
//                case 4:
//                   
//                    if ([arrOfChangeColor[3]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 222;//R
////                        mallocPoint[4*i+1] = 99;//G
////                        mallocPoint[4*i+2] = 55;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //浅绿色
//                        mallocPoint[4*i]   = 210;//R
//                        mallocPoint[4*i+1] = 232;//G
//                        mallocPoint[4*i+2] = 161;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                        
//                    }
//
//                    
//                    break;
//                case 5:
//                    
//                    if ([arrOfChangeColor[4]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 255;//R
////                        mallocPoint[4*i+1] = 40;//G
////                        mallocPoint[4*i+2] = 0;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //亮绿色
//                        mallocPoint[4*i]   = 138;//R
//                        mallocPoint[4*i+1] = 198;//G
//                        mallocPoint[4*i+2] = 109;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                        
//                    }
//                  
//                    
//                    break;
//                case 6:
//                    if ([arrOfChangeColor[5]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 85;//R
////                        mallocPoint[4*i+1] = 85;//G
////                        mallocPoint[4*i+2] = 85;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //灰蓝色深
//                        mallocPoint[4*i]   = 71;//R
//                        mallocPoint[4*i+1] = 130;//G
//                        mallocPoint[4*i+2] = 193;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }
//                  
//                   
//                    break;
//                case 7:
//                    if ([arrOfChangeColor[6]isEqualToString:@"1"]) {
////                        mallocPoint[4*i]   = 119;//R
////                        mallocPoint[4*i+1] = 119;//G
////                        mallocPoint[4*i+2] = 119;//B
////                        mallocPoint[4*i+3] = 255;//A
//                        //灰蓝色浅
//                        mallocPoint[4*i]   = 133;//R
//                        mallocPoint[4*i+1] = 198;//G
//                        mallocPoint[4*i+2] = 214;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }else{
//                        mallocPoint[4*i]   = 125;//R
//                        mallocPoint[4*i+1] = 125;//G
//                        mallocPoint[4*i+2] = 125;//B
//                        mallocPoint[4*i+3] = 255;//A
//                    }
//                   
//                    
//                    break;
//                    //7个区域划分+0=背景色
//                case 8:
//                    mallocPoint[4*i]   = 127;//R
//                    mallocPoint[4*i+1] = 127;//G
//                    mallocPoint[4*i+2] = 127;//B
//                    mallocPoint[4*i+3] = 255;//A
//                    
//                    break;
//                case 9:
//                    mallocPoint[4*i]   = 127;//R
//                    mallocPoint[4*i+1] = 127;//G
//                    mallocPoint[4*i+2] = 127;//B
//                    mallocPoint[4*i+3] = 255;//A
//                   
//                    break;
//                default:
//                    mallocPoint[4*i]   = 127;//R
//                    mallocPoint[4*i+1] = 127;//G
//                    mallocPoint[4*i+2] = 127;//B
//                    mallocPoint[4*i+3] = 255;//A
//                    
//                    break;
//            }
//    }
//        
//   
//    return arr;
//    
//}

//地图颜色
/// - Parameters:
///   - slamData: 地图数据
///   - 0 未探索
///   - 1 已探索 @
///   - 2 机身覆盖区
///   - 3 已清扫区 @
///   - 4 障碍物点
///   - 5 碰撞点
///   - 6 手绘虚拟墙点
///   - 7 垃圾较多的点
///   - 8 充电座区
///   - 9 轨迹点 @
///   - colors: 转换后的RGB数据


+ (void)useDataPMallocWithData:(NSData *)data
               charPointMalloc:(unsigned char*)mallocPoint{
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);//内存拷贝
    if (DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode == YES) {
        
    
    ///20190228新增4*4颜色判断显示不现实 12-14显隐
                for (int i = 0; i<len; i++) {
            //        NSLog(@"i=%d,data=%d",i,byteData[i]);
                    
                    switch (byteData[i]) {
                        case 0://未探索
                            
                            mallocPoint[4*i]   = 245;//R
                            mallocPoint[4*i+1] = 245;//G
                            mallocPoint[4*i+2] = 245;//B
                            mallocPoint[4*i+3] = 255;//A
                            break;
                        case 1://已探索

                            mallocPoint[4*i]   = 245;//R
                            mallocPoint[4*i+1] = 245;//G
                            mallocPoint[4*i+2] = 245;//B
                            mallocPoint[4*i+3] = 255;//A
            //                mallocPoint[4*i]   = 207;//R
            //                mallocPoint[4*i+1] = 250;//G
            //                mallocPoint[4*i+2] = 190;//B
            //                mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 2:// 机身覆盖区
                            
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 255;//G
                            mallocPoint[4*i+2] = 255;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 3://已清扫区 @
            //                mallocPoint[4*i]   = 255;//R
            //                mallocPoint[4*i+1] = 255;//G
            //                mallocPoint[4*i+2] = 255;//B
            //                mallocPoint[4*i+3] = 255;//A
                            mallocPoint[4*i]   = 254;//R
                            mallocPoint[4*i+1] = 254;//G
                            mallocPoint[4*i+2] = 254;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 4://墙
                            mallocPoint[4*i]   = 31;//R
                            mallocPoint[4*i+1] = 31;//G
                            mallocPoint[4*i+2] = 31;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 5://碰撞点
             
                            mallocPoint[4*i]   = 31;//R
                            mallocPoint[4*i+1] = 31;//G
                            mallocPoint[4*i+2] = 31;//B
                            mallocPoint[4*i+3] = 255;//A
                            break;
                        case 6://手绘虚拟墙点
                            
                  //          mallocPoint[4*i]   = 85;//R
                //            mallocPoint[4*i+1] = 85;//G
              //              mallocPoint[4*i+2] = 85;//B
            //                mallocPoint[4*i+3] = 255;//A
                            
                            mallocPoint[4*i]   = 245;//R
                            mallocPoint[4*i+1] = 245;//G
                            mallocPoint[4*i+2] = 245;//B
                            mallocPoint[4*i+3] = 255;//A
                            break;
                        case 7:

                            mallocPoint[4*i]   = 119;//R
                            mallocPoint[4*i+1] = 119;//G
                            mallocPoint[4*i+2] = 119;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 8:

            //                mallocPoint[4*i]   = 245;//R
            //                mallocPoint[4*i+1] = 245;//G
            //                mallocPoint[4*i+2] = 245;//B
            //                mallocPoint[4*i+3] = 255;//A
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 255;//G
                            mallocPoint[4*i+2] = 255;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 9://轨迹点
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 255;//G
                            mallocPoint[4*i+2] = 255;//B
                            mallocPoint[4*i+3] = 255;//A
//                            mallocPoint[4*i]   = 103;//R
//                            mallocPoint[4*i+1] = 53;//G
//                            mallocPoint[4*i+2] = 184;//B
//                            mallocPoint[4*i+3] = 255;//A//20190305颜色深了点更换
//                            mallocPoint[4*i]   = 153;//R
//                            mallocPoint[4*i+1] = 161;//G
//                            mallocPoint[4*i+2] = 231;//B
//                            mallocPoint[4*i+3] = 255;//A
                            break;
                            
 
                            //1224新增4*4模式用到的颜色
                        case 10:
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 0;//G
                            mallocPoint[4*i+2] = 0;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 11:
                            mallocPoint[4*i]   = 127;//R
                            mallocPoint[4*i+1] = 255;//G
                            mallocPoint[4*i+2] = 0;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        
                            //20190228用后门开关控制显示与不显示 由于for数据大，不在for内部判断,写两个for，在for外判断
                        case 12://紫色
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 0;//G
                            mallocPoint[4*i+2] = 255;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 13://黄色
                            mallocPoint[4*i]   = 255;//R
                            mallocPoint[4*i+1] = 255;//G
                            mallocPoint[4*i+2] = 0;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        case 14://浅绿色
                            mallocPoint[4*i]   = 152;//R
                            mallocPoint[4*i+1] = 251;//G
                            mallocPoint[4*i+2] = 152;//B
                            mallocPoint[4*i+3] = 255;//A
                            
                            break;
                        default:
                            mallocPoint[4*i]   = 245;//R
                            mallocPoint[4*i+1] = 245;//G
                            mallocPoint[4*i+2] = 245;//B
                            mallocPoint[4*i+3] = 255;//A
                            break;
                    }
                }
    //A！=0 否则容易出现错位重叠
//    NSLog(@"内存写之前的data长度=%lu--b=",(unsigned long)data.length);
    
    }else{
        
        ///20190228新增4*4颜色判断显示不现实 12-14显隐
        for (int i = 0; i<len; i++) {
            //        NSLog(@"i=%d,data=%d",i,byteData[i]);
            
            switch (byteData[i]) {
                case 0://未探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 1://已探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    //                mallocPoint[4*i]   = 207;//R
                    //                mallocPoint[4*i+1] = 250;//G
                    //                mallocPoint[4*i+2] = 190;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 2:// 机身覆盖区
                    
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 3://已清扫区 @
                    //                mallocPoint[4*i]   = 255;//R
                    //                mallocPoint[4*i+1] = 255;//G
                    //                mallocPoint[4*i+2] = 255;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 254;//R
                    mallocPoint[4*i+1] = 254;//G
                    mallocPoint[4*i+2] = 254;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 4://墙
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 5://碰撞点
                    
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 6://手绘虚拟墙点
                    
                    //          mallocPoint[4*i]   = 85;//R
                    //            mallocPoint[4*i+1] = 85;//G
                    //              mallocPoint[4*i+2] = 85;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 7:
                    
                    mallocPoint[4*i]   = 119;//R
                    mallocPoint[4*i+1] = 119;//G
                    mallocPoint[4*i+2] = 119;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 8:
                    
                    //                mallocPoint[4*i]   = 245;//R
                    //                mallocPoint[4*i+1] = 245;//G
                    //                mallocPoint[4*i+2] = 245;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 9://轨迹点
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
//                    mallocPoint[4*i]   = 103;//R
//                    mallocPoint[4*i+1] = 53;//G
//                    mallocPoint[4*i+2] = 184;//B
//                    mallocPoint[4*i+3] = 255;//A 20190305更换成浅紫色
//                    mallocPoint[4*i]   = 153;//R
//                    mallocPoint[4*i+1] = 161;//G
//                    mallocPoint[4*i+2] = 231;//B
//                    mallocPoint[4*i+3] = 255;//A
                    break;
                    
                    
                    //10 11 也要屏蔽
//                    //1224新增4*4模式用到的颜色
//                case 10://红色正在清扫的4*4区域
//                    mallocPoint[4*i]   = 255;//R
//                    mallocPoint[4*i+1] = 0;//G
//                    mallocPoint[4*i+2] = 0;//B
//                    mallocPoint[4*i+3] = 255;//A
//
//                    break;
//                case 11: //绿色已完成的4*4区域
//                    mallocPoint[4*i]   = 127;//R
//                    mallocPoint[4*i+1] = 255;//G
//                    mallocPoint[4*i+2] = 0;//B
//                    mallocPoint[4*i+3] = 255;//A
//                    break;
                    
                    //20190228用后门开关控制显示与不显示12-14去掉 由于for数据大，不在for内部判断,写两个for，在for外判断
 
                default:
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
            }
        }

    }
}

//用了没效果
+ (UIImage *)getYMirrorWIthImg:(UIImage *)img{
    UIGraphicsBeginImageContext(img.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
     // uiImage是将要绘制的UIImage图片，width和height是它的宽高
     UIGraphicsPushContext(currentContext );
     [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
     UIGraphicsPopContext();
    UIImage *yMirror = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境

    return yMirror;
     
}
+ (UIImage *)getYMirrorFlipWithImg:(UIImage *)img{
    UIGraphicsBeginImageContext(img.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
//    CGContextFillRect(currentContext, CGRectMake(0, 0, img.size.width, img.size.height));//填充背景色，否则为全黑色；
//    CGContextSetFillColorWithColor(currentContext, [UIColor brownColor].CGColor);//填充颜色
//    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);//线框颜色
//CGContextSetLineCap(currentContext, kCGLineCapRound);
//CGContextSetAllowsAntialiasing(currentContext, true);
//CGContextSetShouldAntialias(currentContext, true);
//CGContextSetBlendMode(currentContext, kCGBlendModeHue);
    
    //设置当前绘图环境到矩形框
    CGContextClipToRect(currentContext, CGRectMake(0, 0, img.size.width, img.size.height));
 
   //翻转起来---上下颠倒用在Graphics CGContextDrawImage又会倒回去，所以此处不用
//     CGContextTranslateCTM(currentContext,0, img.size.height);//原点设置
//    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CGContextDrawImage(currentContext, CGRectMake(0, img.size.height-0-img.size.height, img.size.width, img.size.height), img.CGImage);//绘图
    
    //[image drawInRect:rect];
    
    
    UIImage *yMirrored = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    return yMirrored;
    
    
}
//CTM函数相关的四种操作--平移、旋转、缩放。
+ (UIImage *)getXMirrorFlipWithImg:(UIImage *)img{
    
    
    UIGraphicsBeginImageContext(img.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    CGContextClipToRect(currentContext, CGRectMake(0, 0, img.size.width, img.size.height));
    
    CGContextRotateCTM(currentContext, M_PI);//旋转
    //平移
    CGContextTranslateCTM(currentContext, -img.size.width, -img.size.height);
    
    
    CGContextDrawImage(currentContext, CGRectMake(0, 0, img.size.width, img.size.height), img.CGImage);//绘图
    
    //[image drawInRect:rect];
    
    UIImage *xMirrored = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    return xMirrored;
}

//两点距离？
+ (CGFloat)getLineDustanceApToBpWithPa:(CGPoint)pa
                                    pb:(CGPoint)pb{
    
    //pow()函数是求次方的
    //sqrt()函数是求平方根的
    CGFloat linedistance = 0;
    
    CGFloat xPow =  pow((pa.x-pb.x), 2);
    CGFloat yPow =  pow((pa.y-pb.y), 2);
    linedistance = sqrt(xPow+yPow);
    NSLog(@"getLineDustanceApToBpWithPa  xPow=%f  yPow=%f  line=%f",xPow,yPow,linedistance);
 
    return linedistance;
}
//点到线的距离
+ (double)calDisWithBeginPointX:(double)xB
                    BeginPointY:(double)yB
                    EndPointX:(double)xE
                    EndPointY:(double)yE
                    tapPointX:(double)xp
                    tapPointY:(double)yp
{
    double px = xE - xB;
    double py = yE - yB;
    double som = px * px + py * py;
    double u = ((xp - xB) * px + (yp - yB) * py) / som;
    if (u > 1) {
        u = 1;
    }
    if (u < 0) {
        u = 0;
    }
    //the closest point
    double x = xB + u * px;
    double y = yB + u * py;
    double dx = x - xp;
    double dy = y - yp;
    double dist = sqrt(dx*dx + dy*dy);
    NSLog(@"点到线的距离calDis==%f",dist);
    return dist;
}

//点到线的距离
//垂足交点
+(CGFloat)pedalWithBeginPoint:(CGPoint)pB
                     endPoint:(CGPoint )pE
                     tapPoint:(CGPoint)x0{
    
    CGFloat A=pE.y-pB.y;
    CGFloat B=pB.x-pE.x;
    CGFloat C=pE.x*pB.y-pB.x*pE.y;
    
    CGFloat x=(B*B*x0.x-A*B*x0.y-A*C)/(A*A+B*B);
    CGFloat y=(-A*B*x0.x+A*A*x0.y-B*C)/(A*A+B*B);
    
    //点到直线距离
    CGFloat d=(A*x0.x+B*x0.y+C)/sqrt(A*A+B*B);
    
//    CGPoint ptCross=ccp(x,y);
    NSLog(@"d======%f",d);
    NSLog(@"A=======%f,B=======%f,C=======%f",A,B,C);
    NSLog(@"垂足======x=%f,y=%f",x,y);
      NSLog(@"点到线的距离getLineDustance==%f",d);
    return d;
}

//以三个点A、B、C，计算ㄥABC为例，贴代码：
//以所得角度最大为π，因工程中AB为竖直方向固定，需要得到顺时针角度，最大2π，故添加如下：
//if (pointC.x < pointB.x) {
//    angle = M_PI*2 - angle;
//}
//AB为竖直方向固定
+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
    //a=tapP b=centerp c= 垂直直角点
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));//似乎为反余弦acos(邻边/斜边) ，cosB = （x/斜边）， acos(x／斜边)=B角的弧度
    
    //弧度转换成角度
    angle=angle*180/3.1415;
    NSLog(@"angle=%f",angle);
//    if (pointC.x < pointB.x) {//判断b角方向 当前遥控圆盘为x来区分x
//        angle = M_PI*2 - angle;//顺时针角度，最大2π
//    }
        if (pointA.y > pointB.y) {//判断b角方向 当前遥控监控圆盘为y来区分 a点即tap点在水平线下为负角 是正角=a 负角=-a-180
            NSLog(@"tapy=%f centy=%f",pointC.y,pointB.y);
            angle = -M_PI*2 - angle;//复交为
        }
     NSLog(@"tapy=%f centy=%f",pointC.y,pointB.y);

   NSLog(@"angle切换后=%f",angle);
    return angle;
}
/**
 - (void)isOnLinePoint:(CGPoint)thisPoint{
 
 int thisX = thisPoint.x;
 int thisY = thisPoint.y;
 NSLog(@"isOnLinePoint");
 for (int i = 0; i<_allArr.count; i++) {
 NSArray *arrBegP = [_allArr[i]objectForKey:BeginPoint];
 NSArray *arrEndP = [_allArr[i]objectForKey:EndPoint];
 int xB = [arrBegP.firstObject intValue];
 int yB = [arrBegP.lastObject intValue];
 int xE = [arrEndP.firstObject intValue];
 int yE = [arrEndP.lastObject intValue];
 
 int w = xB-xE;
 if (w<0) {
 w = -w;
 }
 
 int h = yB-yE;
 if (h<0) {
 h = -h;
 }
 
 CGFloat t = w/h;
 //this
 int thisW = xB-thisX;
 if (thisW<0) {
 thisW = -thisW;
 }
 int thisH = yB-thisY;
 if (thisH<0) {
 thisH = -thisH;
 }
 CGFloat thisT = thisW/thisH;
 
 //比较
 if (t==thisT) {
 if (thisX == xB && thisY==yB) {
 return;
 
 }
 if ((xB<=thisX<=xE || xB>=thisX>=xE) && (yB<=thisY<=yE || xE>=thisY>=yE) ) {
 NSLog(@"在一条直线上");
 NSLog(@"x=%d y=%d " ,thisX,thisY);
 }else{
 NSLog(@"y=%d x=%d,x %d %d ,y %d %d",thisY,thisX, xB,xE,yB,yE);
 }
 
 
 }else{
 NSLog(@"不在一条直线上");
 return;
 }
 
 
 }
 }
 */

//    一维数组转二维数组
+ (NSMutableArray *)oneArrToTwoArrWithOneArr:(NSMutableArray *)oneArr
                                        hang:(int)hang{

    
    
   
    NSLog(@"hang-->%d",hang);
    
    
    NSMutableArray *endArr= [NSMutableArray new];//新二维数组
    NSMutableArray *newArr = [NSMutableArray new];//新一维数组
    
    NSLog(@"该行数 %lu",(oneArr.count%hang));
    NSLog(@"该行数 %d",hang);
    for (int i = 1; i <oneArr.count+1; i++) {//i=0时余数为0？
        BOOL isBeiShu = NO;//(i % hang)==0 没余数 ->是倍数关系
        if (i % hang == 0) {
            isBeiShu = YES;
        }else{
            isBeiShu = NO;
        }
        if (isBeiShu) {//是倍数关系
            [newArr addObject:oneArr[i-1]];
            [endArr addObject:newArr];
             newArr = [NSMutableArray new];
            
        }else{//有余数的情况
            [newArr addObject:oneArr[i]];
        }
    }
    for (int i = 0; i< endArr.count; i++) {
        
        NSString *strOfend = [endArr[i] componentsJoinedByString:@""];
        NSString *strOfendOK = [strOfend stringByReplacingOccurrencesOfString:@"1" withString:@" "];//替换字符
        NSLog(@"endArr.i=%d,%@,",i,strOfendOK);
    }
  
    return endArr;
}

//img清晰度
//size越大清晰度越高但到原清晰度为上限，内存升的高。
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO,  [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//是否存在中文
+ (BOOL)haveChinese:(NSString *)str{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}
//数字输入应该是数字
+ (BOOL)deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


//
+ (NSString *)appNameStr{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if ((app_Name==nil)||[app_Name isEqualToString: @""]) {
        app_Name = @"扫地机";
    }
    return app_Name;
}
/**厂商品牌描述
wifi
晶果：ginkgor
冠唯（李工）：kingwer
公模机：bleamn
 
 
 晶果：ginkgor = 01
 冠唯（李工）：kingwer = 02
 倍徕恩：bleamn = 03

 
 厂商
枚举列表，比如，晶果=01，李工=02，周工=03； 产品厂家占两位
 */
/**
 使用传入值来确定主题
 */
+(int)appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZoneWithFirstRobotId:(NSString *)firstRobotIdStr{
   
   
/** 调试时的代码
    [DataManager shareDataManager].homeCellImgNameStr = @"saodijiMainCell_xiao";//扫地机测试图标
    [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
    [DataManager shareDataManager].appNameStr = @"暂无品牌名";
    [DataManager shareDataManager].appRobotTypeStr = @"blue";//type 用于图片前缀
//    [DataManager shareDataManager].appRobotTypeStr = @"green";//type 用于图片前缀
//    [DataManager shareDataManager].appRobotTypeStr = @"orange";//type 用于图片前缀
    [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfBlueT;//主题颜色存
//    [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfGreenT;//主题颜色存
//    [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfOrangeT;//主题色
//    [DataManager shareDataManager].appNowProductTypeNumStr = @"02";
    [DataManager shareDataManager].appNowProductTypeNumStr = @"01";//监控遥控等判断置
    //模式名
//    [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;
//    [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
//    [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
//
    //模式名
    [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrT;//冠维机器的模式名不同与其他名
    [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrT;
    [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrT;
    
    [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
    [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfBleam;
    [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfBleamn;
    return 1;
    */
    
    //类型字段的数组 用于添加时的判断是否支持添加更多type的扫地机
    [DataManager shareDataManager].appCanAddRobotTypeArr = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03", nil];
    //为空时 非绑定状态
    if (firstRobotIdStr.length==0||firstRobotIdStr==nil||[firstRobotIdStr isEqualToString:@"(null)"]) {
        [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = @"暂无品牌名";
        [DataManager shareDataManager].appNowProductTypeNumStr = @"00";//type区分模式和监控遥控等字段 00 01 02 03
         [DataManager shareDataManager].appRobotTypeStr = @"blue";//type 用于图片前缀
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfBlueT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;//
        [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
        return 0;
    }
    //有数值时 绑定状态
    NSString *strOfRobotComplay = [NSString stringWithFormat:@"%@",[firstRobotIdStr substringToIndex:2]];
    if ([strOfRobotComplay intValue]==0) {
        [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = @"ClearnRobot";
        [DataManager shareDataManager].appRobotTypeStr = @"blue";//type 用于图片前缀
        [DataManager shareDataManager].appNowProductTypeNumStr = @"00";//type 用于模式名和监控遥控等区分
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfBlueT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;
        [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
        
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
        //xml 1213正式服的地址都需要根据typeid拼接而成
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
        return 0;
    }else if ([strOfRobotComplay intValue]==1){
        [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
//        [DataManager shareDataManager].wifiMatchStr = @"ginkgor...";
        [DataManager shareDataManager].appNameStr = @"晶果";
        [DataManager shareDataManager].appNowProductTypeNumStr = @"01";//type
        [DataManager shareDataManager].appRobotTypeStr = @"blue";//type 用于图片前缀
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfBlueT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;
        [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
        //xml 1213正式服的地址都需要根据typeid拼接而成
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
         return 1;
    }else if ([strOfRobotComplay intValue]==2){
          [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
//        [DataManager shareDataManager].wifiMatchStr = @"kingwer...";
        [DataManager shareDataManager].appNameStr = @"冠唯";
        [DataManager shareDataManager].appNowProductTypeNumStr = @"02";//type 用于模式名和监控遥控等区分
        [DataManager shareDataManager].appRobotTypeStr = @"orange";//type 用于图片前缀
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfOrangeT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrT;//冠维机器的模式名不同与其他名
         [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrT;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrT;
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfKw;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfKw;
        
        return 2;
    }else if ([strOfRobotComplay intValue]==3){
         [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
//        [DataManager shareDataManager].wifiMatchStr = @"bleamn...";
        [DataManager shareDataManager].appNameStr = @"倍徕恩";
        [DataManager shareDataManager].appNowProductTypeNumStr = @"03";//type
        [DataManager shareDataManager].appRobotTypeStr = @"green";//type 用于图片前缀
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfGreenT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;
        [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
        
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfBleam;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfBleamn;
        
         return 3;
    }else{
     
        [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = @"ClearnRobot";
        [DataManager shareDataManager].appRobotTypeStr = @"blue";//type 用于图片前缀
        [DataManager shareDataManager].appNowProductTypeNumStr = @"00";//type 用于模式名和监控遥控等区分
        [DataManager shareDataManager].colorOfMainType = [DataManager shareDataManager].colorOfBlueT;//主题色
        //模式名
        [DataManager shareDataManager].yuyueModeArrMain = [DataManager shareDataManager].yuyueModeArrO;
        [DataManager shareDataManager].mapModeBtnTitleStrMain = [DataManager shareDataManager].mapModeBtnTitleStrO;
        [DataManager shareDataManager].mapModeArrMain = [DataManager shareDataManager].mapModeArrO;
        
        [DataManager shareDataManager].homeCellImgNameStr = [NSString stringWithFormat:@"%@_saodijiMainCell_xiao", [DataManager shareDataManager].appRobotTypeStr];//扫地机主图标
        //xml
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
         return 0;
    }
    
}
/**
 使用名字来判断主题
 */
+(int)appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone{
    NSString *strOfName = [ToolOfBasic appNameStr];
   
    if ([strOfName isEqualToString:@"扫地机"]) {
        
       [DataManager shareDataManager].homeCellImgNameStr = @"扫地机图标";//扫地机测试图标
        // [DataManager shareDataManager].homeCellImgNameStr = @"扫地机测试图标";
        [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = strOfName;
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
        return 0;
    }else if ([strOfName isEqualToString:@"晶果"]){
        [DataManager shareDataManager].homeCellImgNameStr = @"扫地机测试图标1";
//        [DataManager shareDataManager].wifiMatchStr = @"ginkgor...";
          [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = strOfName;
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
      
        return 1;
    }else if ([strOfName isEqualToString:@"李工"]||[strOfName isEqualToString:@"冠唯"]){//也是冠维
        [DataManager shareDataManager].homeCellImgNameStr = @"扫地机测试图标2";
//        [DataManager shareDataManager].wifiMatchStr = @"kingwer...";
          [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = strOfName;
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfKw;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfKw;
        return 2;
    }else if ([strOfName isEqualToString:@"周工"]||[strOfName isEqualToString:@"倍徕恩"]){// 倍徕恩
        [DataManager shareDataManager].homeCellImgNameStr = @"扫地机测试图标3";
//        [DataManager shareDataManager].wifiMatchStr = @"bleamn...";
          [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = strOfName;
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfBleam;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfBleamn;
        return 3;
    }else{
       [DataManager shareDataManager].homeCellImgNameStr = @"扫地机图标";
      //   [DataManager shareDataManager].homeCellImgNameStr = @"扫地机测试图标";
//        [DataManager shareDataManager].wifiMatchStr = @"...robot...";
          [DataManager shareDataManager].wifiMatchStr = @"...sweep...";
        [DataManager shareDataManager].appNameStr = strOfName;
//        [DataManager shareDataManager].xmlOfMainCtrl = S_sweeperUpdateCtrlXmlOfQg;
//        [DataManager shareDataManager].xmlOfMainSlam = S_sweeperUpdateSlamXmlOfQg;
        return 0;
    }
    
    /**if ([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==1) {
     
     }else if ([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==2){
     }else if ([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==3){
     }else{
     }
     */
    
    /**
     wifi
     晶果：ginkgor
     冠唯（李工）：kingwer
     公模机：bleamn
     
     
     晶果：ginkgor = 01
     冠唯（李工）：kingwer = 02
     倍徕恩：bleamn = 03

    if ([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==1) {
        strOfWf = @"ginkgor...";
    }else if ([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==2){
        strOfWf = @"kingwer...";
    }else if([ToolOfBasic appIsJgReturnOneIsLgReturnTwoIsZgReturnThrOtherReturnZone]==3){
        strOfWf = @"bleamn...";
    }else{
        strOfWf = @"...robot...";//0
    }
     */
    
}
//存下的xml数据是否大于当前扫地机版本数据 是 升级  否 不升级 //两位比较
+ (BOOL)lastxmlVersionBigThanCurrentRobotVersionWithMsgArr:(NSMutableArray *)arrOfMessage
                                         saveXmlVersionStr:(NSString *)lastVersionStr{
    BOOL versionCanShengJiBool = false;
    if (![arrOfMessage.firstObject isEqualToString:@"Nav"]) {
        NSLog(@"%@ %@",arrOfMessage,lastVersionStr);
    }
    [arrOfMessage removeObjectAtIndex:0];//去除字符type
    if (arrOfMessage.count!=2) {
        return versionCanShengJiBool;
    }
    int curOne = [arrOfMessage.firstObject intValue];//第一位
    int curTwo = [arrOfMessage.lastObject intValue];//第二位
    
    //xml
    if ([lastVersionStr isEqualToString:@""]||[lastVersionStr isEqualToString:@"--"]||[lastVersionStr isEqualToString:@"(null)"]) {
        return versionCanShengJiBool;
    }
    NSMutableArray *arrOfLastV = [NSMutableArray arrayWithArray:[lastVersionStr componentsSeparatedByString:@" "]];//去除字符type
    [arrOfLastV removeObjectAtIndex:0];
    NSString *strofArrFirst = [NSString stringWithFormat:@"%@", arrOfLastV.firstObject];
    NSArray *arrOfLastVerionNum = [strofArrFirst componentsSeparatedByString:@"."];
    if (arrOfLastVerionNum.count!=2) {
        return versionCanShengJiBool;
    }
    int xmlOne =  [arrOfLastVerionNum.firstObject intValue];//第一位
    int xmlTwo = [arrOfLastVerionNum.lastObject intValue];//第二位
    
    
    if (xmlOne>curOne) {//第一位
        versionCanShengJiBool=true;
        return versionCanShengJiBool;
    }else if(xmlOne == curOne){//第一位相同时
        if (xmlTwo>curTwo) {//第二位
            versionCanShengJiBool = true;
            return versionCanShengJiBool;
        }
        
    }
    
    return versionCanShengJiBool;
}

//控制板升级数据3位的判断
//存下的xml数据是否大于当前扫地机版本数据 是 升级  否 不升级 //两位比较
+ (BOOL)lastxmlKZVersionBigThanCurrentRobotKZVersionWithMsgArr:(NSMutableArray *)arrOfMessage
                                         saveXmlKZVersionStr:(NSString *)lastKZVersionStr{
    BOOL versionCanShengJiBool = false;
    
    
    
    if (![arrOfMessage.firstObject isEqualToString:@"Frie"]) {
        NSLog(@"%@ %@",arrOfMessage,lastKZVersionStr);
    }
    [arrOfMessage removeObjectAtIndex:0];//去除字符type
    if (arrOfMessage.count!=3) {//非3位
        return versionCanShengJiBool;
    }
    int curOne = [arrOfMessage.firstObject intValue];//第一位
    int curTwo = [[NSString stringWithFormat:@"%@", arrOfMessage[1]] intValue];//第二位
    int curThr = [arrOfMessage.lastObject intValue];//第三位
 

    if ([lastKZVersionStr isEqualToString:@""]||[lastKZVersionStr isEqualToString:@"--"]||[lastKZVersionStr isEqualToString:@"(null)"]) {
        return versionCanShengJiBool;
    }
    //xml
    NSMutableArray *arrOfLastV = [NSMutableArray arrayWithArray:[lastKZVersionStr componentsSeparatedByString:@" "]];//去除字符type
    if(arrOfLastV.count==0){
        return versionCanShengJiBool;//如果空则返回
    }
    //删除前判断是否为空数组
    [arrOfLastV removeObjectAtIndex:0];
    NSString *strofArrFirst = [NSString stringWithFormat:@"%@", arrOfLastV.firstObject];
    NSArray *arrOfLastVerionNum = [strofArrFirst componentsSeparatedByString:@"."];
    if (arrOfLastVerionNum.count!=3) {
        return versionCanShengJiBool;
    }
    int xmlOne =  [arrOfLastVerionNum.firstObject intValue];//第一位
    int xmlTwo = [[NSString stringWithFormat:@"%@", arrOfLastVerionNum[1]] intValue];//第二位
    int xmlThr = [arrOfLastVerionNum.lastObject intValue];//第三位
    
    //为yes true的重新附值，其他不变。
    if (xmlOne>curOne) {
        versionCanShengJiBool=true;//第一位
        return versionCanShengJiBool;
        
    }else if(xmlOne == curOne){//第一位相同时
        if (xmlTwo>curTwo) {//第二位
            versionCanShengJiBool = true;
             return versionCanShengJiBool;
            
        }else if(xmlTwo == curTwo){//第一第二位都同时
            if (xmlThr>curThr) {//第三位
                versionCanShengJiBool = true;
                return versionCanShengJiBool;
            }else{
            }
            
        }else{
            
        }
        
    }else{
        
    }
    
    return versionCanShengJiBool;
}

//btn 文字图片左右
+ (UIButton *)btnTextRightAndImgLeft:(UIButton *)btn{
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.bounds.size.width, 0, btn.imageView.bounds.size.width)];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    return btn;
}
//btn 图片文字上下
+ (UIButton *)btnTextBottomAndImgTop:(UIButton *)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    {top, left, bottom, right};
    //text
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+20 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    //img
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-5, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不
    return btn;
}

#pragma mark -- itunes 版本和本机版本比较
/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)itunesVersionAndAppVersionCompareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

#pragma mark -- 判断仅输入字母或数字：
+ (BOOL)inputShouldLetterOrNum:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
#pragma mark -- color获取rgb
+ (NSArray *)getRGBAArrByUIColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
//    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
    
        [originColor getRed:&r green:&g blue:&b alpha:&a];
//    }
//    else {
    
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        
        r = components[0];
        
        g = components[1];
        
        b = components[2];
        
        a = components[3];
//    }
//
//    return @{@"R":@(r),
//
//             @"G":@(g),
//
//             @"B":@(b),
//
//             @"A":@(a)};
    return @[@(r),@(g),@(b),@(a)];
    
}
#pragma mark -- UIImageView虚线
+ (void)drawLineByImageView:(UIImageView *)imageView {
    //该view需要有h才能设置
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
 
    
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
//    CGContextSetStrokeColorWithColor(line, [UIColor darkGrayColor].CGColor);
     CGContextSetStrokeColorWithColor(line, [DataManager    shareDataManager].colorOfMainType.CGColor);
    
    CGFloat lengths[] = {5,2};//先画4个点再画2个点
    CGContextSetLineDash(line,0, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line,imageView.frame.size.width,2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    UIImage *image =   UIGraphicsGetImageFromCurrentImageContext();
    imageView.image = image;
}
#pragma mark -- 将UIColor变换为UIImage
// 将UIColor变换为UIImage
+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}
#pragma mark --img圆角UIIamge 的方法
//生成圆角UIIamge 的方法
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius img:(UIImage*)img
{
    UIImage *original = img;
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

 
@end
