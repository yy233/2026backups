//
//  Tool.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "Tool.h"
#import <stdlib.h>
@implementation Tool

+ (NSString *)softwareVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];// app版本
    NSString *app_build = [infoDic objectForKey:@"CFBundleVersion"];// app build版本
    NSString *currentVersion = [NSString stringWithFormat:@"%@ (build %@)",app_Version,app_build];
    return currentVersion;
}

//复制文本动作
+ (void)copyTextWithStr:(NSString *)str{
 
    NSLog(@"复制动作");
    if (![str isKindOfClass:[NSString class]]) {
        return;
    }
    if (str.length > 0) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        pb.string = str;
        Y_SVP_SHOW_SUCCESS_MES(@"复制成功");
    }
}

//随机颜色
+ (UIColor *)getAnRandomColor{
    NSInteger red = [self getRandomNumber:0 to:255];
    NSInteger gree = [self getRandomNumber:0 to:255];
    NSInteger blue = [self getRandomNumber:0 to:255];
    NSLog(@"Random Color %ld %ld  %ld",(long)red,(long)gree,(long)blue);
    UIColor *colorA = [UIColor colorWithRed:red/255.0 green:gree/255.0 blue:blue/255.0 alpha:1];
    return colorA;
}
/**
 获取一个随机整数，范围在[from,to]，包括from，包括to
 */

//+  (NSInteger)getRandomNumberFrom:(NSInteger)fromIntV withTo:(NSInteger)toIntV
//{
//    return  ( fromIntV + ( arc4random() % ( toIntV - fromIntV + 1) ));
//}
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)( from + (arc4random() % ( to - from + 1) ));
}
 

/**
 生成32为无序标示
 */
//随机串
+ (NSString *)toolCreateRandomUuid
{
    char data[32];

    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));

    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
/**
 生成32为无序标示
 */
//随机串
+ (NSString *)toolCreateRandomUuidSmall
{
    char data[32];

    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));

    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
/*!
 *@brief        根据十六进制串生成颜色值
 *@function     getColorWithHexString:
 *@param        hex         -- 十六进制颜色串(aabb11, 0xaabb11, 0xaabb11cc)
 *@return       (UIColor)   -- 生成的颜色值
 */
+ (UIColor *)getColorWithHexString:(NSString *)hex
{
    // String should be 6 or 8 characters
    if ([hex length] < 6) return [UIColor whiteColor];
    
    NSString *hex0 = [NSString stringWithFormat:@"%@", hex];
    if ([hex0 hasPrefix:@"0x"] || [hex0 hasPrefix:@"0X"]) {
        hex0 = [NSString stringWithFormat:@"%@", [hex substringFromIndex:2]];
    } else if ([hex0 hasPrefix:@"#"] ) {
        hex0 = [NSString stringWithFormat:@"%@", [hex substringFromIndex:1]];
    }
    if ([hex0 length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [hex0 substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [hex0 substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [hex0 substringWithRange:range];
    
    float alpha = 1.0f;
    if ([hex0 length] > 6) {
        uint al;
        [[NSScanner scannerWithString:bString] scanHexInt:&al];
        alpha = (float)al / 255.f;
    }
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
    
}


/**
 单行
 输入：文本 文本font
 得到：文字宽度 */
+ (float)getTextWidthWhenOneLineWithTextStr:(NSString *)string withFont:(UIFont*)font{
    CGSize labSize = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    return labSize.width;
}
/**
 多行
 输入：最大宽度 文本 font
 得到： 文字高度

 NSStringDrawingUsesLineFragmentOrigin = 1 << 0,
 // 整个文本将以每行组成的矩形为单位计算整个文本的尺寸
 NSStringDrawingUsesFontLeading = 1 << 1,
 // 使用字体的行间距来计算文本占用的范围，即每一行的底部到下一行的底部的距离计算
 
 NSStringDrawingUsesDeviceMetrics = 1 << 3,
 // 将文字以图像符号计算文本占用范围，而不是以字符计算。也即是以每一个字体所占用的空间来计算文本范围
 
 NSStringDrawingTruncatesLastVisibleLine
 // 当文本不能适合的放进指定的边界之内，则自动在最后一行添加省略符号。如果NSStringDrawingUsesLineFragmentOrigin没有设置，则该选项不生效 --  （ps：此可让 换行符号@"\n"会自动计高度）
 

 */
+ (float)getTextHeightWhenHaveWidthFloatNum:(float)width withTextStr:(NSString *)string withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    return size.height;
}

+ (NSInteger)getIndexWithObj:(id)obj withArr:(NSMutableArray *)sourceArr{
    if (isNil(obj)) {
        return 99999;//@"不存在"
    }
    NSInteger inde = [sourceArr indexOfObject:obj];
    if (inde != NSNotFound) {
        return inde;
    }else{
        return 99999;
    }
}

//
+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData

{

    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {

        return nil;

    }

    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObj isKindOfClass:[NSDictionary class]]) {

        return nil;

    }

    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];

}
/** 将字典转换成json格式字符串,不含\n这些符号*/

+ (NSData *)compactFormatDataForDictionary:(NSDictionary *)dicJson

{

    if (![dicJson isKindOfClass:[NSDictionary class]]) {

        return nil;

    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];

    if (![jsonData isKindOfClass:[NSData class]]) {

        return nil;

    }

    return jsonData;

}
#pragma mark ========== json arr
+ (NSString*)jsonWithArr:(NSArray *)arr
{
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:arr])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}

+ (NSArray *)arrWithJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

#pragma mark ========== json dic
/** json 转dic*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
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
/**  dic 转 json */
+ (NSString *)jsonStrWithDic:(NSDictionary *)dict{

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}

//
/**
 *  URLEncode
 */
+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *newString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (__bridge CFStringRef)str,
                                                                                                NULL,
                                                                                                CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    if (newString)
    {
        return newString;
    }

    return @"";
}
 
 
//
/**
 *  URLEncode
 */
//+ (NSString *)URLEncodedString:(NSString *)str
//{
//    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
//    // CharactersToLeaveUnescaped = @"[].";
//
//    NSString *unencodedString = str;
//    NSString *encodedString = (NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)unencodedString,
//                                                              NULL,
//                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                              kCFStringEncodingUTF8));
//
//    return encodedString;
//}



/**
 *  URLDecode
 */
+(NSString *)URLDecodedString:(NSString *)str
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];

    NSString *encodedString = str;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (UIWindow *)toolGetKeyWindow{
    UIWindow *foundWindow = nil;
        NSArray  *windows = [[UIApplication sharedApplication]windows];
        for (UIWindow  *window in windows) {
            if (window.isKeyWindow) {
                foundWindow = window;
                break;
            }
        }
        return foundWindow;
}

#pragma mark ==
#pragma mark ----两个数相加-----------

+(NSString *)calculateByadding:(NSString *)number1 secondNumber:(NSString *)number2
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *addingNum = [num1 decimalNumberByAdding:num2];
    return [addingNum stringValue];
}

#pragma mark ----两个数相减------------ number1 - number2
+(NSString *)calculateBySubtractingMinuend:(NSString *)number1 subtractorNumber:(NSString *)number2
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *addingNum = [num1 decimalNumberBySubtracting:num2];
    return [addingNum stringValue];
    
}

#pragma mark ----两个数相乘------------
+(NSString *)calculateByMultiplying:(NSString *)number1 secondNumber:(NSString *)number2
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *multiplyingNum = [num1 decimalNumberByMultiplyingBy:num2];
    return [multiplyingNum stringValue];
    
}

#pragma mark ----两个数相除------------
+ (NSString *)calculateByDividingNumber:(NSString *)number1 secondNumber:(NSString *)number2
{
    NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:number1];
    NSDecimalNumber *num2 = [NSDecimalNumber decimalNumberWithString:number2];
    NSDecimalNumber *dividingNum = [num1 decimalNumberByDividingBy:num2];
    return [dividingNum stringValue];
    
}

// webView 因URL中含有中文加载网页白屏显示的解决方法
#pragma mark == 中文转符号
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       NULL, /* allocator */
                                                                                       (__bridge CFStringRef)input,
                                                                                       NULL, /* charactersToLeaveUnescaped */
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return
    outputStr;
}

 

#pragma mark == url dic  之间的转换
 
//字典转链接（参数）
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict{
    if (dict == nil) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];


    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }


    return string;
}


//链接转字典  （参数）
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

/**特殊链接解析不了 。  'https://wwww.baidu.com/#/sdffff?name=sdfff&pass=dddff'/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+ (NSDictionary *) parameterWithURL:(NSURL *) url {
 
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
 
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
 
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
 
    return parm;
}
@end
