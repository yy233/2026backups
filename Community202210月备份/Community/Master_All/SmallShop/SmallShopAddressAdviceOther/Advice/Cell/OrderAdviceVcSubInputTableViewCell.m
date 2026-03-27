//
//  OrderAdviceVcSubInputTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import "OrderAdviceVcSubInputTableViewCell.h"
#import "UITextView+YLTextView.h"


@interface OrderAdviceVcSubInputTableViewCell () <UITextViewDelegate>

@property (nonatomic,strong) UILabel *pLabel;
@property (nonatomic,strong) UITextView *textView;


@end

@implementation OrderAdviceVcSubInputTableViewCell

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
        [self.contentView addSubview:self.textView];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textView.superview).insets(UIEdgeInsetsMake(10, 26, 10, 26));
    }];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _textView.font = [UIFont systemFontOfSize:15.0];
        _textView.placeholder = @"请输入您的建议";
        _textView.placeholdColor = Y_ColorWith16FromRGB(0x6E727D);
        _textView.placeholdFont = [UIFont systemFontOfSize:15.0];
//        _textView.wordCountLabel.textColor =  [UIColor redColor];
        _textView.limitLength = @300;
    }
    return _textView;
}


- (void)textViewDidChange:(UITextView *)textView{
    if (isNotNil(self.saveSelfTextViewStrBlock)) {
        self.saveSelfTextViewStrBlock( [TextShowWithModelStr textShowWithModelStr:textView.text] );
    }
}
@end
