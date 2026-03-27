//
//  ZYSOSSalvageServiceTopView.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSSalvageServiceTopView.h"

@interface ZYSOSSalvageServiceTopView ()

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation ZYSOSSalvageServiceTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.voiceButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    //[self.voiceButton addTarget:self action:@selector(voiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton addTarget:self action:@selector(voiceBtnActionDown) forControlEvents:UIControlEventTouchDown];
    [self.voiceButton addTarget:self action:@selector(voiceBtnActionUpInside) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
//- (void)voiceButtonClicked {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonEvent)]) {
//        [self.delegate voiceButtonEvent];
//    }
//}
 


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
