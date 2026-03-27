//
//  ZYCityCell.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYCityCell.h"

@interface ZYCityCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZYCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleLabel.superview);
        make.left.equalTo(_titleLabel.superview).offset(16);
        make.right.equalTo(_titleLabel.superview).offset(-16);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView.superview).offset(16);
        make.right.equalTo(_lineView.superview).offset(-16);
        make.bottom.equalTo(_lineView.superview);
        make.height.offset(0.5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    }
    
    return _lineView;
}

@end
