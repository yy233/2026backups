//
//  ZYHelpAndFeedbackCell.m
//  Community
//
//  Created by ZY on 2021/9/7.
//

#import "ZYHelpAndFeedbackCell.h"

@interface ZYHelpAndFeedbackCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *updownImageView;

@end

@implementation ZYHelpAndFeedbackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabelWidthConstraint.constant = kScreenW - 48;
}

// 设置数据model
- (void)setModel:(ZYHelpAndFeedbackDataListModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    self.contentLabel.text = _model.content;
    if (_model.isSelected) {
        self.contentV.hidden = NO;
        self.updownImageView.image = [UIImage imageNamed:@"up"];
    }else {
        self.contentV.hidden = YES;
        self.updownImageView.image = [UIImage imageNamed:@"down"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
