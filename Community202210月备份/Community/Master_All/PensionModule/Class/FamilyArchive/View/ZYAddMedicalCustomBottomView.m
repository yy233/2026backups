//
//  ZYAddMedicalCustomBottomView.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYAddMedicalCustomBottomView.h"

@interface ZYAddMedicalCustomBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZYAddMedicalCustomBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)saveButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveButtonEvent)]) {
        [self.delegate saveButtonEvent];
    }
}

@end
