//
//  ZYAddMedicalCustomCell.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYAddMedicalCustomCell.h"
#import "UITextView+YLTextView.h"

@interface ZYAddMedicalCustomCell ()

@property (weak, nonatomic) IBOutlet UIView *medicalView;

@end

@implementation ZYAddMedicalCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.medicalView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(medicalViewTap)]];
    
//    self.textView.limitLength = @300;
    self.textView.placeholder = @"请输入您的详情叙述...";
    self.textView.placeholdColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor zy_colorWithHexString:@"#AAAEB9"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)medicalViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(medicalViewEvent)]) {
        [self.delegate medicalViewEvent];
    }
}

@end
