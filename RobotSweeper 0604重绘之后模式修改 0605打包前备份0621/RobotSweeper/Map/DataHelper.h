//
//  DataHelper.h
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/24.
//  Copyright © 2017年 美超刘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject


+ (NSData *)changeStringToData:(NSString *)msg;

+ (NSData *)appendLength:(NSData *)data length:(uint32_t)length;
    
+ (NSString *)changeDataToString:(NSData *)data;

+ (int)getDataLenght:(NSData *)data;

+(NSString*)getFileMD5WithPath:(NSString*)path;

+ (NSData *)changeSsidAndPwdToData:( NSArray *)array;

@end
