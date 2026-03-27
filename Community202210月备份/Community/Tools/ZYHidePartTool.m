//
//  ZYHidePartTool.m
//  Community
//
//  Created by ZY on 2021/12/20.
//

#import "ZYHidePartTool.h"

@implementation ZYHidePartTool

+ (NSString *)hidePartWithStr:(NSString *)Str holderSingleStr:(NSString *)holderSingleStr location:(NSInteger)location length:(NSInteger)length
{
    NSString *hideNumStr = Str;
    NSString *placeHolderStr=[NSString string];
    if (isNotNil(Str))//判断非空
    {
        for (int i=0; i<length; i++)
        {
            placeHolderStr = [placeHolderStr stringByAppendingString:holderSingleStr];
        }
        hideNumStr =[Str stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:placeHolderStr];
    }
    return hideNumStr;
}

@end
