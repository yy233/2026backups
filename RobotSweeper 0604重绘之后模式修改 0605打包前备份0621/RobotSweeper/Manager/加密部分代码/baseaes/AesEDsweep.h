//
//  AesEDsweep.h
//  xmpp加密demo
//
//  Created by Joey on 2018/9/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AesEDsweep : NSObject
+(NSString *)aesEorDwithType:(int)isEncryp
isStrOFSourceStr:(NSString *)dataSource;

//
+(NSString *)aesEorDwithTypeIsE:(int)isEncryp
               isStrOFSourceStr:(NSString *)dataSource;
+(NSString *)aesEorDwithTypeNotE:(int)isEncryp
                isStrOFSourceStr:(NSString *)dataSource;

+ (void)freeAllBuf:(char *)buf
              buf1:(char *)buf1
              buf2:(char *)buf2
              buf3:(char *)buf3
              buf4:(char *)buf4
          base64em:(char *)base64em
          base64dm:(char *)base64dm
            dedata:(char *)dedata;
@end
