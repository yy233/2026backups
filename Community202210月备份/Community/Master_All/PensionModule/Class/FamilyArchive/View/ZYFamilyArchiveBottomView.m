//
//  ZYFamilyArchiveBottomView.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveBottomView.h"

@interface ZYFamilyArchiveBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *medicalCustomButton;

@end

@implementation ZYFamilyArchiveBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.medicalCustomButton addTarget:self action:@selector(medicalCustomButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)medicalCustomButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(medicalCustomButtonEvent)]) {
        [self.delegate medicalCustomButtonEvent];
    }
}

@end
