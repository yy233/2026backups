//
//  ZYLeadFamilyArchiveBottomView.m
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import "ZYLeadFamilyArchiveBottomView.h"

@interface ZYLeadFamilyArchiveBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ZYLeadFamilyArchiveBottomView

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

#pragma mark - 处理点击事件
- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

@end
