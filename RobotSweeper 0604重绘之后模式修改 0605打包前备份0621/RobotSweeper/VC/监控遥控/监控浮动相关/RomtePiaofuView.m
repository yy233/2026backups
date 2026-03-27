//
//  RomtePiaofuView.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/5/17.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "RomtePiaofuView.h"
#import "LXFloaintButton.h"
@implementation RomtePiaofuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
       [self initJiankong];
    }
    return self;
}

- (void)initJiankong{
    [self setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_jiankong"] forState:UIControlStateNormal];
//    [self setTitle:NSLocalizedString(@"监控" , nil) forState:UIControlStateNormal];
//    self.backgroundColor = [DataManager shareDataManager].colorOfMainType;
//    [button setLXCornerdious:50];
//    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    
    
    self.safeInsets = UIEdgeInsetsMake(NAVH, 0, ELSareArea , 0);
   
    self.parentView = self.superview;//mapvc.view为其父图属性
    
}

@end
