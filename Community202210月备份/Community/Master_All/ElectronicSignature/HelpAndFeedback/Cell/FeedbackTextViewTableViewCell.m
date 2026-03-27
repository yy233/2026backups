//
//  FeedbackTextViewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "FeedbackTextViewTableViewCell.h"
#import "UITextView+YLTextView.h"

@interface FeedbackTextViewTableViewCell ()

@end

@implementation FeedbackTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.text = @"描述问题:";
        [self.backView addSubview:self.textView];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_textView.superview);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _textView.font = FontSize_ElectronicSignature_Nomail(14);
        _textView.limitLength = @200;
        _textView.placeholder = @"请仔细描述你的问题方便我们解决和回馈";
        _textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
        _textView.wordCountLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
        _textView.placeholdFont = FontSize_ElectronicSignature_Nomail(14);
        _textView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

@end
