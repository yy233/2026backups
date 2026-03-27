//
//  NSObject+Utils.m
//  AppStore
//
//  Created by JIAQUAN ZHU on 2020/8/29.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performString:(NSString *)string
{
    SEL selector = NSSelectorFromString(string);
    if ([self respondsToSelector:selector])
    {
        return [self performSelector:selector];
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performString:(NSString *)string withObject:(id)obj
{
    SEL selector = NSSelectorFromString(string);
    if ([self respondsToSelector:selector])
    {
        return [self performSelector:selector withObject:obj];
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isNil:(id)obj
{
    return (obj == nil || [obj isEqual:[NSNull null]] || [obj isEqual:nil]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isNotNil:(id)obj
{
    return (obj != nil && ![obj isEqual:[NSNull null]] && ![obj isEqual:nil]);
}

#pragma mark ==
+ (BOOL)isNullOrNilWithObject:(id)object
{//NULL c; nil oc对象;Nil oc类；NSNull oc对象空值
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

@end
