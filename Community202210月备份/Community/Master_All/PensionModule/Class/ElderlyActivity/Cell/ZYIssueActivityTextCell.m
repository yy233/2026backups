//
//  ZYIssueActivityTextCell.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityTextCell.h"
#import "UITextView+YLTextView.h"

@implementation ZYIssueActivityTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.placeholder = @"请输入您想发起的活动内容...";
    self.textView.placeholdColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
