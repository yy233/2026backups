//
//  Y_ToolOfOthers.m
//  Socialize
//
//  Created by 余莹 on 2023/5/18.
//

#import "Y_ToolOfOthers.h"
#import <stdlib.h>

@implementation Y_ToolOfOthers


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
// 生成随机整数
+ (int)getRandomInt:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

// 生成随机浮点数
+ (float)getRandomFloat:(float)from to:(float)to {
    float diff = to - from;
    return (((float) arc4random() / UINT_MAX) * diff) + from;
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
        
        return @{};
        
    }
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];
    
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        
        return @{};
        
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
    NSString *jsonString = @"";
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
        return @[];
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];

    if(err) {
        NSLog(@"json解析失败：%@",err);
        return @[];
    }
    return arr;
}

#pragma mark ========== json dic
/** json 转dic*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if([jsonString  isKindOfClass: [NSDictionary class]] ){
        return (NSDictionary *)jsonString;
    }
    
    if (jsonString == nil || [jsonString isEqualToString:@""]) {
        return @{};
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableLeaves //不仅返回的最外层是可变的, 内部的子数值或字典也是可变对象 ,NSJSONReadingMutableContainers 返回可变容器
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败 jsonString：%@",jsonString);
        NSLog(@"json解析失败 1err：%@",err);
        return @{};
    }
    return dic;
}
/** json 转dic*/
+ (NSDictionary *)dictionaryWithString:(NSString *)jsonString{
    
    
    if([jsonString  isKindOfClass: [NSDictionary class]] ){
        return (NSDictionary *)jsonString;
    }
    
    if (jsonString == nil || [jsonString isEqualToString:@""]) {
        return @{};
    }
    
    
   NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
   NSError *err;
   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];

    {
        NSLog(@"json解析失败 String：%@",jsonString);
        NSLog(@"json解析失败 2err：%@",err);
        return @{};
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
    
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];//0808 不去空格子
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
//    NSRange range3 = {0, mutStr.length};
//    NSString * str = @"\\";
//    [mutStr replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch range:range3];//去掉反斜线 这个加了 会转不回来
    
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



/**
 复制链接
 */
+ (void)copyStrClickWithStr:(NSString *)copyStr {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyStr;
    Y_SVP_SHOW_SUCCESS_MES(@"复制成功");
    
}

/**
 系统分享
 */
+ (void)shareLinkUrlWithStr:(NSString *)linkStr withNowVc:(UIViewController *)vc{
    
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:linkStr]] applicationActivities:nil];
    [vc presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"分享成功");
        }else{
            NSLog(@"分享取消");
        }
    };
}
/**
 系统分享
 */
+ (void)shareActionWithArr:(NSArray *)arrs withNowVc:(UIViewController *)vc{
    
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:arrs applicationActivities:nil];
    [vc presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"分享成功");
        }else{
            NSLog(@"分享取消");
        }
    };
}

/**
 用地址打开浏览器
 */
+ (void)openLiuLanQiWithLinkStr:(NSString *)linkStr{
    if (@available(iOS 8.0, *)) {
        NSURL * url = [NSURL URLWithString:linkStr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            if (@available(iOS 10.0, *)) {
                
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    } else {
        // Fallback on earlier versions
    }
    
}


#pragma mark === //截图保存功能
+ (void)saveImgToPhone:(UIView *)saveview{
    DLog(@"保存到手机");

    UIImage *willSaveImg =  [self captureImageFromView:saveview];
    UIImageWriteToSavedPhotosAlbum(willSaveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

+(UIImage *)captureImageFromView:(UIView *)saveview

{
    
    CGRect screenRect = [saveview bounds];
    
    //UIGraphicsBeginImageContext(screenRect.size);
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, [UIScreen mainScreen].scale);//清晰度 /【UIScreen mainScreen].scale本参数==指定当前设备的缩放因子，而0.0的意思就是自动调整缩放因子以适配显示屏
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [saveview.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

 

//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//#pragma mark -- <保存到相册>
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = @"" ;
//    if(error){
//        msg = @"保存图片失败" ;
//        Y_SVP_SHOW_ERR_MES(msg);
//    }else{
//        msg = @"保存图片成功" ;
//        Y_SVP_SHOW_SUCCESS_MES(msg);
//    }
    if(isNil(error)){
        msg = @"保存图片成功" ;
        Y_SVP_SHOW_SUCCESS_MES(msg);
    }else if (error.code==-1 || [error.localizedDescription containsString:@"未知错误"]){
        //未知错误 服务连接被中断
        msg = @"保存图片状态未获得，可去相册查看图片是否已经被保存";
        Y_SVP_SHOW_INFO_MES(msg);
      
    }else{
        msg = @"保存图片失败" ;
        Y_SVP_SHOW_ERR_MES(msg);
    }
 
}


#pragma mark === //截图保存功能 end



+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (int)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return[da length];
}
 
@end
