//
//  ZYPensionMainTopSearchView.m
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import "ZYPensionMainTopSearchView.h"

@interface ZYPensionMainTopSearchView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation ZYPensionMainTopSearchView

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
    [self.searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTap)]];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)searchViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewEvent)]) {
        [self.delegate searchViewEvent];
    }
}

@end
