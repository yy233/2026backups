//
//  DataHelper.m
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/24.
//  Copyright © 2017年 美超刘. All rights reserved.
//

#import "DataHelper.h"
#import <CommonCrypto/CommonDigest.h>  

@implementation DataHelper

+ ( NSData *)changeStringToData:(NSString *)msg{ 
    NSLog(@"msg=%@",msg);
    NSData *dataOfStr=[NSMutableData dataWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]];//0107二进制流的长度 匹配中文
    long  lenght = dataOfStr.length;
    NSData *lengthDataS = [NSData dataWithBytes:&lenght length:sizeof(lenght)];
    uint32_t valueS = CFSwapInt32HostToBig(*(uint32_t *)[lengthDataS bytes]);
    
    NSData *msgDataS = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *dataFinS = [NSMutableData data];
    [dataFinS appendBytes:&valueS length:sizeof(uint32_t)];
    [dataFinS appendData:msgDataS];
    NSLog(@"changeStringToDataSSSSS   %@",dataFinS);
    
//    //这种中文无法生成正确的数据
//    uint32_t count = (uint32_t)msg.length;
//
//    NSData *lengthData = [NSData dataWithBytes:&count length:sizeof(count)];
//    uint32_t value = CFSwapInt32HostToBig(*(uint32_t *)[lengthData bytes]);
//
//    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSMutableData *dataFin = [NSMutableData data];
//    [dataFin appendBytes:&value length:sizeof(uint32_t)];
//    [dataFin appendData:msgData];
//    NSLog(@"changeStringToData   %@",dataFin);
    
    return dataFinS;
//    return dataFin;
}




//+ (NSData *)changeSsidAndPwdToData:( NSArray *)array{
//    
//    NSString *ssid = [NSString stringWithFormat:@"wifi%@",[DataHelper dealStrigLength:[array objectAtIndex:0]]];
//    NSString *pwd = [DataHelper dealStrigLength:[array objectAtIndex:1]];
//    
//    NSLog(@"%@",ssid);
//    NSLog(@"%@",pwd);
//    
//    uint32_t count = (uint32_t)ssid.length + (uint32_t)pwd.length + 8;
//    NSData *lengthData = [NSData dataWithBytes:&count length:sizeof(count)];
//    uint32_t value = CFSwapInt32HostToBig(*(uint32_t *)[lengthData bytes]);
//    
//    NSData *ssidData = [ssid dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *pwdData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSMutableData *dataFin = [NSMutableData data];
//    [dataFin appendBytes:&value length:sizeof(uint32_t)];
//    [dataFin appendData:ssidData];
//    [dataFin appendData:pwdData];
//    
//    NSLog(@"%@",dataFin);
//    return dataFin;
//}

+ (NSData *)changeSsidAndPwdToData:( NSArray *)array{
    
    NSString *ssid = [NSString stringWithFormat:@"wifi%@",[DataHelper dealStrigLength:[array objectAtIndex:0]]];
    NSString *pwd = [DataHelper dealStrigLength:[array objectAtIndex:1]];
    
    NSLog(@"changeSsidAndPwdToData ssid %@",ssid);
    NSLog(@"changeSsidAndPwdToData pwd %@",pwd);
    
    NSString*allStr = [NSString stringWithFormat:@"%@%@",ssid,pwd];
//    [allStr dataUsingEncoding:NSUTF8StringEncoding];
   
    
    NSData *dataFin = [DataHelper changeStringToData:allStr];// DataHelper.changeString

    NSLog(@"%@",dataFin);
    return dataFin;
}

+ (NSData *)appendLength:(NSData *)data length:(uint32_t)length{
    
    NSData *lengthData = [NSData dataWithBytes:&length length:sizeof(length)];
    uint32_t value = CFSwapInt32HostToBig(*(uint32_t *)[lengthData bytes]);
    
    NSMutableData *dataFin = [NSMutableData data];
    [dataFin appendBytes:&value length:sizeof(uint32_t)];
    [dataFin appendData:data];
    
    
    return dataFin;
    
}

+ (NSString *)changeDataToString:(NSData *)data{
    
    //解析
//    NSData *dataStr = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
    NSString *msgStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return msgStr;
}

+ (int)getDataLenght:(NSData *)data{
    
    NSData *tmpData = [data subdataWithRange:NSMakeRange(0, 4)];
    
    int datalength;
    
    [tmpData getBytes: &datalength length: sizeof(datalength)];
    
    int length = CFSwapInt32BigToHost(datalength);
    
    
    return length;
}

- (int) subDataWithData:(NSData *)data range:(NSInteger)loca length:(NSInteger)length{
    
    NSData *convertData = [data subdataWithRange:NSMakeRange(loca, length)];
    int value = CFSwapInt32HostToBig(*(int *)[convertData bytes]);
    
    return value;
        
}

+(NSString*)getFileMD5WithPath:(NSString*)path

{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    
    return [s uppercaseString];
    
}


+(NSString *) dealStrigLength:(NSString *)contentStr{
    
    NSString *lenghtStr = @"";
    
    long lenght = contentStr.length;
    NSData *dataOfStr=[NSMutableData dataWithData:[contentStr dataUsingEncoding:NSUTF8StringEncoding]];//0107二进制流的长度
    lenght = dataOfStr.length;
    NSLog(@"contentStr data length = %ld",lenght);
    if (lenght < 10){
        
        lenghtStr = [NSString stringWithFormat:@"000%ld",lenght];
    }else if (lenght < 100 && lenght > 9){
        
        lenghtStr = [NSString stringWithFormat:@"00%ld",lenght];
    }else if (lenght < 1000 && lenght > 99){
        lenghtStr = [NSString stringWithFormat:@"0%ld",lenght];
    }else{
        lenghtStr = [NSString stringWithFormat:@"%ld",lenght];
    }
    
    return [NSString stringWithFormat:@"%@%@",lenghtStr,contentStr];
}




@end
