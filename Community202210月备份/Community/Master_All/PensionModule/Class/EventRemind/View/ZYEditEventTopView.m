//
//  ZYEditEventTopView.m
//  Community
//
//  Created by ZY on 2021/12/10.
//

#import "ZYEditEventTopView.h"

@interface ZYEditEventTopView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ZYEditEventTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

@end
