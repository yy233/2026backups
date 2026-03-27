//
//  ZYEventRemindDetailBottomView.m
//  Community
//
//  Created by ZY on 2021/11/29.
//

#import "ZYEventRemindDetailBottomView.h"

@interface ZYEventRemindDetailBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ZYEventRemindDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)editButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonEvent)]) {
        [self.delegate editButtonEvent];
    }
}

- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonEvent)]) {
        [self.delegate deleteButtonEvent];
    }
}

@end
