//
//  ZYSOSAddressBookBottomView.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookBottomView.h"

@interface ZYSOSAddressBookBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addContactButton;

@end

@implementation ZYSOSAddressBookBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addContactButton addTarget:self action:@selector(addContactButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addContactButton newAnBtnWithImg:[UIImage imageNamed:@"yl_jiahao"]];
    [self.addContactButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5.5];
}

#pragma mark - 处理点击事件
- (void)addContactButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addContactButtonEvent)]) {
        [self.delegate addContactButtonEvent];
    }
}

@end
