//
//  IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell.h"

@implementation IssueBaseTextFieldAndOnlyShowWithClearnBtnTableViewCell

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
        [self.contentView addSubview:self.textFieldTopBtn];
        [self setTopBtnUI];
        //
        self.textFieldTopBtn.userInteractionEnabled = NO;
        self.textField.userInteractionEnabled = NO;
    }
    return self;
}
- (void)setTopBtnUI{
    [_textFieldTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textField);
    }];
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请选择" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
    self.textField.attributedPlaceholder = placeholderString;
}
#pragma mark ==
- (UIButton *)textFieldTopBtn{
    if (!_textFieldTopBtn) {
        _textFieldTopBtn = [[UIButton alloc]init];
    }
    return _textFieldTopBtn;
}
@end
