//
//  NSData+LGJExtension.h
//  Socialize
//
//  Created by 余莹 on 2023/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LGJExtension)
/**
 NSData转化成string

 @return 返回nil的解决方案
 */
-(NSString *)convertedToUtf8String;
@end

NS_ASSUME_NONNULL_END
