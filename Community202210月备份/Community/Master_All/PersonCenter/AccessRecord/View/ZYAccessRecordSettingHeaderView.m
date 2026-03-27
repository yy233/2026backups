//
//  ZYAccessRecordSettingHeaderView.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordSettingHeaderView.h"

@interface ZYAccessRecordSettingHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYAccessRecordSettingHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW - 32, 40) radius:5 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

@end
