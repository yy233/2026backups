//
//  ZYCommunityFairBottomView.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYCommunityFairBottomView.h"

@interface ZYCommunityFairBottomView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYCommunityFairBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_L2672f9;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
}

@end
