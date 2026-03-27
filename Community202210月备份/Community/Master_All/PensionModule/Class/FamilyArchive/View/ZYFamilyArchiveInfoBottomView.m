//
//  ZYFamilyArchiveInfoBottomView.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveInfoBottomView.h"

@interface ZYFamilyArchiveInfoBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ZYFamilyArchiveInfoBottomView

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
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)saveButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveButtonEvent)]) {
        [self.delegate saveButtonEvent];
    }
}

- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonEvent)]) {
        [self.delegate deleteButtonEvent];
    }
}

@end
