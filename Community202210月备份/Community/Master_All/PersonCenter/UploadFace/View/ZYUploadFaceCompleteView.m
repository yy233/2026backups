//
//  ZYUploadFaceCompleteView.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceCompleteView.h"

@interface ZYUploadFaceCompleteView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYUploadFaceCompleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

@end
