//
//  NSString+ReplceStr.h
//  Community
//
//  Created by 余莹 on 2021/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ReplceStr)
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation length:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
