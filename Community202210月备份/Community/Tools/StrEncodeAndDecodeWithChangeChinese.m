//
//  StrEncodeAndDecodeWithChangeChinese.m
//  Community
//
//  Created by 余莹 on 2020/12/11.
//

#import "StrEncodeAndDecodeWithChangeChinese.h"

@implementation StrEncodeAndDecodeWithChangeChinese

//编码 URLEncodedString
-(NSString *)URLEncodedString:(NSString *)str{
 
    NSString *dataUTF8 = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return dataUTF8;
}
//解码 URLDecodedString
-(NSString *) URLDecodedString:(NSString *) str{
 
    return [str stringByRemovingPercentEncoding];
}



/**
 //    NSString *videourl = [dataUTF8 stringByReplacingOccurrencesOfString:@"%5C" withString:@"/"];
 //    连接中有 \ 时，这两种编码都会把 \ 编码成 %5C，而js中 \ 是编译成%2f,所以要记得替换字符
 //    return videourl;
 */
@end
