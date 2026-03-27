//
//  TextShowWithModelStr.h
//  Community
//
//  Created by 余莹 on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextShowWithModelStr : NSObject
+ (NSString *)textShowWithModelStr:(id)modeStr;
+ (NSString *)textShowWithNotNullStr:(id)modeStr;
//常用来id 转idstr
+ (NSString *)textShowWithModelIntType:(NSInteger)modeIntV;
@end

NS_ASSUME_NONNULL_END
