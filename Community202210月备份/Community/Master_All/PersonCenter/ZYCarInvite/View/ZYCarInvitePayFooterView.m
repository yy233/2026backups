//
//  ZYCarInvitePayFooterView.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInvitePayFooterView.h"

@interface ZYCarInvitePayFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYCarInvitePayFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
}

@end
