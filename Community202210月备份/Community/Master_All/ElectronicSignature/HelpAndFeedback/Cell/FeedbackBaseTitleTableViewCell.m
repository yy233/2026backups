//
//  FeedbackBaseTitleTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "FeedbackBaseTitleTableViewCell.h"

@implementation FeedbackBaseTitleTableViewCell

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
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleLabel.superview);
        make.height.offset(30);//
    }];
}
#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleLabel.font = FontSize_ElectronicSignature_Bold(14);
    }
    return _titleLabel;
}


@end
