//
//  ZYCarInvitePayHeaderView.m
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import "ZYCarInvitePayHeaderView.h"

@interface ZYCarInvitePayHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ZYCarInvitePayHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ci_smjf_icon"];
}

@end
