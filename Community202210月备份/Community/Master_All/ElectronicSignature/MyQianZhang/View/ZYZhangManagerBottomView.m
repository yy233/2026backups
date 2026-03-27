//
//  ZYZhangManagerBottomView.m
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import "ZYZhangManagerBottomView.h"

@interface ZYZhangManagerBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation ZYZhangManagerBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = CGSizeMake(kScreenW - 72, 50);
    self.uploadButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    [self.uploadButton addTarget:self action:@selector(uploadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
- (void)uploadButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadButtonEvent)]) {
        [self.delegate uploadButtonEvent];
    }
}

@end
