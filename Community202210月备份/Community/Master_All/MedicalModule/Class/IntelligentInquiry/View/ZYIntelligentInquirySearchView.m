//
//  ZYIntelligentInquirySearchView.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYIntelligentInquirySearchView.h"

@interface ZYIntelligentInquirySearchView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ZYIntelligentInquirySearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.voiceButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
     [self.voiceButton addTarget:self action:@selector(voiceBtnActionDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceButton addTarget:self action:@selector(voiceBtnActionUpInside) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件


- (void)backButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonEvent)]) {
        [self.delegate backButtonEvent];
    }
}

- (void)searchButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonEvent)]) {
        [self.delegate searchButtonEvent];
    }
}

 
//点击抬起
- (void)voiceBtnActionDown  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonEventBegin)]) {
        [self.delegate voiceButtonEventBegin];
    }
}

//点击落下
- (void)voiceBtnActionUpInside {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonEventEnd)]) {
        [self.delegate voiceButtonEventEnd];
    }
}


@end
