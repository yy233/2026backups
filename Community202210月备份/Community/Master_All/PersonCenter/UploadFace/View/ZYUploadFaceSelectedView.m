//
//  ZYUploadFaceSelectedView.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceSelectedView.h"

@interface ZYUploadFaceSelectedView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@end

@implementation ZYUploadFaceSelectedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.contentView.backgroundColor = [UIColor zy_colorWithHexString:@"#F7F7F7"];
    }else {
        self.contentView.backgroundColor = [UIColor zy_colorWithHexString:@"#062351"];
    }
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.cameraLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.albumLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

@end
