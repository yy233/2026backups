//
//  MapBottomViewChangeTool.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/20.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapBottomViewChangeTool : NSObject

+ (void)hidenOtherAndMoveOneBtnLableWithBtnTag:(int)btntag
                                       bottomV:(MapBottommView*)bottomV;
+ (void)showAllBottomV:(MapBottommView*)bottomV;
@end

NS_ASSUME_NONNULL_END
