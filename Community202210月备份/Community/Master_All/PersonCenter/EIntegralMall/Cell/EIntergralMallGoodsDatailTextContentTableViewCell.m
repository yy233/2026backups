//
//  EIntergralMallGoodsDatailTextContentTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallGoodsDatailTextContentTableViewCell.h"

@implementation EIntergralMallGoodsDatailTextContentTableViewCell

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
        [self.backView addSubview:self.textView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textView.superview);
    }];
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = [UIColor blackColor];
        _textView.scrollEnabled = YES;
        _textView.editable = NO;
    }
    return _textView;
}
@end
