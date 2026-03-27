//
//  ZYOwnersVoteCompleteView.m
//  Community
//
//  Created by ZY on 2021/8/4.
//

#import "ZYOwnersVoteCompleteView.h"

@interface ZYOwnersVoteCompleteView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ZYOwnersVoteCompleteView

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
    self.subTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
}

@end
