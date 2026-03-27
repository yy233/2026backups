//
//  ZYAccessRecordHeaderView.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordHeaderView.h"

@implementation ZYAccessRecordHeaderView

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
