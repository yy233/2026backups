//
//  IssueBaseTextViewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssueBaseTextViewTableViewCell.h"

@interface IssueBaseTextViewTableViewCell () <UITextViewDelegate>

@end

@implementation IssueBaseTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.titelL];
        [self.contentView addSubview:self.textView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titelL.superview.mas_left).offset(16);
        make.top.equalTo(_titelL.superview.mas_top).offset(5);
        make.right.equalTo(_titelL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titelL.mas_bottom).offset(5);
        make.left.equalTo(_titelL.mas_left);
        make.right.equalTo(_titelL.mas_right);
        make.bottom.equalTo(_textView.superview.mas_bottom).offset(-5);
    }];
    self.placeHolderLabel.frame = CGRectMake(10, 0, 300, 30);//展示长度缩短问题
}
#pragma mark ==
- (UILabel *)titelL{
    if (!_titelL) {
        _titelL = [[UILabel alloc]init];
        _titelL.font = [UIFont systemFontOfSize:15.f];
        _titelL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titelL;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        _textView.textColor = [ThemeManager shareManager].mainTextColor;
        // _placeholderLabel
        [_textView addSubview:self.placeHolderLabel];
        _textView.font = [UIFont systemFontOfSize:15.f];
        [_textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
        _textView.delegate = self;
    }
    return _textView;
}
- (UILabel *)placeHolderLabel{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _placeHolderLabel.text = @"请输入";
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];
        [_placeHolderLabel sizeToFit];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _placeHolderLabel;
}

#pragma mark == 文本数据
- (void)textViewDidChange:(UITextView *)textView{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTextViewTag:withTextViewStr:)]) {
        [_delegate cellTextViewTag:self.textView.tag withTextViewStr:textView.text];
    }
}
 
@end
