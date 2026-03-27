//
//  ZYSigningDetailBottomHintCell.m
//  Community
//
//  Created by ZY on 2021/8/20.
//

#import "ZYSigningDetailBottomHintCell.h"

@interface ZYSigningDetailBottomHintCell ()

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIButton *rentButton;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end

@implementation ZYSigningDetailBottomHintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rightLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.leftLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    
    [self.rentButton setTitleColor:Y_RGBA(38, 114, 249, 1) forState:UIControlStateNormal];
    [self.rentButton addTarget:self action:@selector(rentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 我的租赁
- (void)rentButtonClicked {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rentButtonClickedEvent)]) {
        [self.delegate rentButtonClickedEvent];
    }
}

@end
