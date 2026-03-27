//
//  NSString+ArvinCategory.m
//  GouGou
//
//  Created by cq on 15/1/17.
//  Copyright (c) 2015年 gougou. All rights reserved.
//

#import "NSString+ArvinCategory.h"

@implementation NSString (ArvinCategory)


- (NSString *)kdtk_stringByReplaceingUnicode {
    NSString *tempString1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempString2 = [tempString1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempString3 = [[@"\"" stringByAppendingString:tempString2] stringByAppendingString:@"\""];
    NSData *tempData = [tempString3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnString = [NSPropertyListSerialization propertyListFromData:tempData
                                                              mutabilityOption:NSPropertyListImmutable
                                                                        format:NULL
                                                              errorDescription:NULL];
    
    return [returnString stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


+ (BOOL)isEmpty:(NSString*)text{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}
 
@end
