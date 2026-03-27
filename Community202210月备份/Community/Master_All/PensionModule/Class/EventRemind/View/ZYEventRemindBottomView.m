//
//  ZYEventRemindBottomView.m
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import "ZYEventRemindBottomView.h"

@interface ZYEventRemindBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@end

@implementation ZYEventRemindBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(kScreenW, 45 + button_bottom_height) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(44, 231, 189, 1) endColor:Y_RGBA(54, 200, 193, 1)];
    [self.addEventButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [self.addEventButton addTarget:self action:@selector(addEventButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)addEventButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addEventButtonEvent)]) {
        [self.delegate addEventButtonEvent];
    }
}

@end
