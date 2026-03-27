//
//  ErrorPopView.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/24.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ErrorPopView.h"

@implementation ErrorPopView
- (IBAction)OkBtnAction:(UIButton *)sender {
    
//    self.hidden = YES;
//    [self removeFromSuperview];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.okBtn setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
    self.errBackView.layer.cornerRadius = 10;
    [self.okBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
                                                        
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.hidden = YES;
//    [self removeFromSuperview];
//    self = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
