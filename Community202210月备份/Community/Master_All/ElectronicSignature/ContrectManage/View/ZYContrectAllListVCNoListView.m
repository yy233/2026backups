//
//  ZYContrectAllListVCNoListView.m
//  Community
//
//  Created by ZY on 2021/9/6.
//

#import "ZYContrectAllListVCNoListView.h"

@interface ZYContrectAllListVCNoListView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYContrectAllListVCNoListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    self.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

@end
