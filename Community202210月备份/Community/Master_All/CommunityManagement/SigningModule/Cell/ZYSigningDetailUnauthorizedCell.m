//
//  ZYSigningDetailUnauthorizedCell.m
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import "ZYSigningDetailUnauthorizedCell.h"

@interface ZYSigningDetailUnauthorizedCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowsImageView;

@end

@implementation ZYSigningDetailUnauthorizedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.titleLabel.textColor = [UIColor zy_colorWithHexString:@"#2B2C2F"];
    }else {
        self.titleLabel.textColor = [UIColor zy_colorWithHexString:@"#C5C9D4"];
    }
    self.contentLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    self.arrowsImageView.image = [[ZYThemeManager shareManager] themeImageNamed:@"ic_weirenz"];
    
    CGRect bounds = CGRectMake(0, 0, kScreenW - 32, self.contentV.bounds.size.height);
    [self.contentV cornerRadiusWithBounds:bounds radius:7.5 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 未认证
- (void)contentViewTap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewTapEvent)]) {
        [self.delegate contentViewTapEvent];
    }
}

@end
