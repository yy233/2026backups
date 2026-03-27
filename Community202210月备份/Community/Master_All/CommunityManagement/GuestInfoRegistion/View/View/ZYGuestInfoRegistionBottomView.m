//
//  ZYGuestInfoRegistionBottomView.m
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import "ZYGuestInfoRegistionBottomView.h"

@interface ZYGuestInfoRegistionBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;

@property (weak, nonatomic) IBOutlet UIButton *temporaryQRCodeButton;

@end

@implementation ZYGuestInfoRegistionBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addGuestButton.layer.cornerRadius = 3.5;
    self.addGuestButton.layer.masksToBounds = YES;
    self.temporaryQRCodeButton.layer.borderWidth = 0.5;
    self.temporaryQRCodeButton.layer.borderColor = [UIColor zy_colorWithHexString:@"#2672F9"].CGColor;
    self.temporaryQRCodeButton.layer.cornerRadius = 3.5;
    self.temporaryQRCodeButton.layer.masksToBounds = YES;
    
    [self.addGuestButton addTarget:self action:@selector(addGuestButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.temporaryQRCodeButton addTarget:self action:@selector(temporaryQRCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击事件
- (void)addGuestButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addGuestButtonEvent)]) {
        [self.delegate addGuestButtonEvent];
    }
}

- (void)temporaryQRCodeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(temporaryQRCodeButtonEvent)]) {
        [self.delegate temporaryQRCodeButtonEvent];
    }
}

@end
