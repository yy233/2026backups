//
//  ZYHealthDataContentHeaderView.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataContentHeaderView.h"

@interface ZYHealthDataContentHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation ZYHealthDataContentHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.refreshButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)refreshButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshButtonEvent)]) {
        [self.delegate refreshButtonEvent];
    }
}

@end
