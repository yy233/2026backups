//
//  ImageGetWithString.m
//  Community
//
//  Created by 余莹 on 2020/12/18.
//

#import "ImageGetWithString.h"

@implementation ImageGetWithString

+ (UIImage *)getImageFromURLStr:(NSString *)urlStr{
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    });
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    result = [UIImage imageWithData:data];
    return result;
}

@end
