//
//  ZYMedicalMainSearchView.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainSearchView.h"
#import <objc/runtime.h>

@interface ZYMedicalMainSearchView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *searchContentView;

@end

@implementation ZYMedicalMainSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    Ivar ivarS = class_getInstanceVariable([self.searchTF class], "_placeholderLabel");
    id placeholderLabelS = object_getIvar(self.searchTF, ivarS);
    [placeholderLabelS performSelector:@selector(setTextColor:) withObject:[UIColor whiteColor]];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchContentViewTap)]];
}

#pragma mark - 处理点击事件
- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)searchContentViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchContentViewEvent)]) {
        [self.delegate searchContentViewEvent];
    }
}

@end
