//
//  NSObject+Utils.h
//  AppStore
//
//  Created by JIAQUAN ZHU on 2020/8/29.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Utils)

+ (BOOL)isNil:(id)obj;
+ (BOOL)isNotNil:(id)obj;

- (id)performString:(NSString *)string;
- (id)performString:(NSString *)string withObject:(id)obj;

+ (BOOL)isNullOrNilWithObject:(id)object;
@end

#define isNil(obj) [NSObject isNil:obj]
#define isNotNil(obj) [NSObject isNotNil:obj]

NS_ASSUME_NONNULL_END
