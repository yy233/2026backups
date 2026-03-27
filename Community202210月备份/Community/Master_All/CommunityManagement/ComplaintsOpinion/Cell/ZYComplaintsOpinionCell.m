//
//  ZYComplaintsOpinionCell.m
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import "ZYComplaintsOpinionCell.h"
#import "UITextView+YLTextView.h"

@interface ZYComplaintsOpinionCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *decTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *subTelView;

@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;

@end

@implementation ZYComplaintsOpinionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.decTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.subContentV.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    self.subTelView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.telTitleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.nameLabel.text = [ShareUserInfo sharedUserInfo].commuityInfo.name;
    
    [self.subContentV addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textView.superview);
    }];
    
    self.telTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarT = class_getInstanceVariable([self.telTF class], "_placeholderLabel");
    id placeholderLabelT = object_getIvar(self.telTF, ivarT);
    [placeholderLabelT performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _textView.limitLength = @300;
        _textView.placeholder = @"请输入您的评价内容...";
        _textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
        _textView.placeholdFont = [UIFont systemFontOfSize:14];
        _textView.wordCountLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    }
    
    return _textView;
}

@end
