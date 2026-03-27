//
//  ZYChatBarView.m
//  Community
//
//  Created by ZY on 2021/4/21.
//

#import "ZYChatBarView.h"

@implementation ZYChatBarView

 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.grayBackView.layer.cornerRadius = 5;
    self.grayBackView.layer.masksToBounds = YES;
}
 

@end
