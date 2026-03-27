//
//  DirectionBtn.h
//  RobotSweeper
//
//  Created by Joey on 2018/9/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionBtn : UIButton
@property (nonatomic,assign)CGFloat radius;
@property (nonatomic,assign)CGPoint centerP;
@property (nonatomic,assign)CGFloat begA;
@property (nonatomic,assign)CGFloat endA;
@property (nonatomic,assign)CGPathRef selfPath;

-(instancetype)initWithFrame:(CGRect)frame
                      radius:(CGFloat)radius
                     centerP:(CGPoint)centerP
                        begA:(CGFloat)begA
                        endA:(CGFloat)endA;
@end
