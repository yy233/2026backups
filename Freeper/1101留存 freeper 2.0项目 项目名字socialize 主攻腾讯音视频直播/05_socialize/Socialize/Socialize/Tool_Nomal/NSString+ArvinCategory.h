//
//  NSString+ArvinCategory.h
//  GouGou
//
//  Created by cq on 15/1/17.
//  Copyright (c) 2015年 x. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ArvinCategory)

- (NSString *)kdtk_stringByReplaceingUnicode;
- (NSString *)changeFailSourceUrlOfImgUrl;
+ (BOOL)isEmpty:(NSString*)text;
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation length:(NSInteger)length;
@end
