//
//  ZYSmallShopMainTitleHeaderView.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainTitleHeaderView.h"

@interface ZYSmallShopMainTitleHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation ZYSmallShopMainTitleHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.moreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:0];
    self.moreButton.hitTestEdgeInsets = UIEdgeInsetsMake(0, -16, 0, -16);
    [self.moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 更多
- (void)moreButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreButtonEvent)]) {
        [self.delegate moreButtonEvent];
    }
}

@end
