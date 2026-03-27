//
//  ZYPensionSOSTopView.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYPensionSOSTopView.h"

@implementation ZYPensionSOSTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.iconImageView zy_cornerRadiusRoundingRect];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
