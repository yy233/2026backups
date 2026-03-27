//
//  ZYMedicalCustomBottomView.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYMedicalCustomBottomView.h"

@interface ZYMedicalCustomBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ZYMedicalCustomBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)addButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonEvent)]) {
        [self.delegate addButtonEvent];
    }
}

@end
