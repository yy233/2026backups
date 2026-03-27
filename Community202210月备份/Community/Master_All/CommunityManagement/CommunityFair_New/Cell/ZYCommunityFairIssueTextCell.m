//
//  ZYCommunityFairIssueTextCell.m
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import "ZYCommunityFairIssueTextCell.h"
#import "UITextView+YLTextView.h"

@interface ZYCommunityFairIssueTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ZYCommunityFairIssueTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.limitLength = @200;
    self.textView.placeholder = @"至少描述20字...";
    self.textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
}

// 设置数据model
- (void)setModel:(ZYCommunityFairIssueModel *)model {
    _model = model;
    
    self.textView.text = _model.goodsExplain;
    self.textView.placeholder = @"至少描述20字...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
