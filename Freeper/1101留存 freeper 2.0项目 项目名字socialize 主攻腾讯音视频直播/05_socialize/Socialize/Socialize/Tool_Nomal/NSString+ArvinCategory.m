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

//文件接口半截数据替换
#define  URL_FileSource_Use              @"un93kdk-v1source.freeper.cc"
#define  URL_FileSource_Cant_Use          @"source.freeper.io"

- (NSString *)changeFailSourceUrlOfImgUrl{
    NSLog(@"changeFailSourceUrlOfImgUrl self = %@",self);
    if([self containsString:URL_FileSource_Cant_Use]){
        NSLog(@"changeFailSourceUrlOfImgUrl 替换动作1");
        return [self stringByReplacingOccurrencesOfString:URL_FileSource_Cant_Use withString:URL_FileSource_Use]; 
    }else{
        NSLog(@"changeFailSourceUrlOfImgUrl 返回原本str");
        return self;
    }
}

 

//-(NSString*)ObjectToJsonString:(id)object{
//    NSString *jsonString = @"";
//    
//    NSError *error;
//    
//    NSData *jsonData = [NSJSONSerialization
//                        
//                        dataWithJSONObject:object
//                        
//                        options:NSJSONWritingPrettyPrinted
//                        
//                        error:&error];
//    
//    if (! jsonData) {
//        
//        NSLog(@"error: %@", error);
//        
//    } else {
//        
//        jsonString = [[NSString
//                       
//                       alloc] initWithData:jsonData
//                      
//                      encoding:NSUTF8StringEncoding];
//        
//    }
//    NSLog(@"jsonString --- : %@", jsonString);
//    return jsonString;
//}
 


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
//替换*号
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation length:(NSInteger)length {
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}
 
@end
