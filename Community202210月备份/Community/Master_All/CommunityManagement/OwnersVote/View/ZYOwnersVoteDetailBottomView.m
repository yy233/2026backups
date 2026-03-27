//
//  ZYOwnersVoteDetailBottomView.m
//  Community
//
//  Created by ZY on 2021/8/4.
//

#import "ZYOwnersVoteDetailBottomView.h"

@interface ZYOwnersVoteDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYOwnersVoteDetailBottomView

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
