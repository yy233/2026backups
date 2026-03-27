//
//  TextShowWithModelStr.m
//  Community
//
//  Created by 余莹 on 2020/12/16.
//

#import "TextShowWithModelStr.h"

@implementation TextShowWithModelStr
+ (NSString *)textShowWithModelStr:(id)modeStr{
    if (modeStr==nil || isNil(modeStr) || modeStr==NULL || modeStr==[NSNull null] || [modeStr isEqualToString:@"(null)"] || [modeStr isEqualToString:@"<null>"]  ||  [NSString stringWithFormat:@"%@",modeStr].length==0)  {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",modeStr];
    }
}
+ (NSString *)textShowWithNotNullStr:(id)modeStr{
    if (modeStr==nil || isNil(modeStr) || modeStr==NULL || modeStr==[NSNull null] || [modeStr isEqualToString:@"(null)"] || [modeStr isEqualToString:@"<null>"]  ||  [NSString stringWithFormat:@"%@",modeStr].length==0) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",modeStr];
    }
}

//常用来id 转idstr
+ (NSString *)textShowWithModelIntType:(NSInteger)modeIntV{
    return [NSString stringWithFormat:@"%ld",(long)modeIntV];
}
@end
