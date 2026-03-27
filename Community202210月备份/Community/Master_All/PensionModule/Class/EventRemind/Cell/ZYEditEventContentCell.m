//
//  ZYEditEventContentCell.m
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import "ZYEditEventContentCell.h"
#import "UITextView+YLTextView.h"

@interface ZYEditEventContentCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYEditEventContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.borderColor = Y_RGBA(221, 221, 221, 1).CGColor;
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.masksToBounds = YES;
    
//    self.textView.limitLength = @300;
    self.textView.placeholdColor = [UIColor zy_colorWithHexString:@"#999999"];
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor zy_colorWithHexString:@"#999999"];
}

// 设置数据model
- (void)setModel:(ZYEventRemindModel *)model {
    _model = model;
    
    self.textView.text = _model.content;
    self.textView.placeholder = @"请输入您需要提醒的内容...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
