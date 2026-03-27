//
//  MapCGTool.h
//  RobotSweeper
//
//  Created by Joey on 2019/1/24.
//  Copyright © 2019年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapCGTool : NSObject
+ (UIImage *)mosaicImage:(UIImage *)image withLevel:(int)level;
+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;
@end
