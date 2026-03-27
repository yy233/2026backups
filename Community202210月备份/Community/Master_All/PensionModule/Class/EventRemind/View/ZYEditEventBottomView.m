//
//  ZYEditEventBottomView.m
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import "ZYEditEventBottomView.h"

@interface ZYEditEventBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ZYEditEventBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

@end
