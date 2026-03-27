//
//  ElectronicSigbatureTextAndRightBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicSigbatureTextAndRightBtnTableViewCell.h"

@interface ElectronicSigbatureTextAndRightBtnTableViewCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation ElectronicSigbatureTextAndRightBtnTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.rightBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleLabel.superview);
        make.width.offset(120);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_rightBtn.superview);
        make.width.offset(60);
        make.right.equalTo(_rightBtn.superview.mas_right).offset(-16);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_detailLabel.superview);
        make.left.equalTo(_titleLabel.mas_right);
        make.right.equalTo(_rightBtn.mas_left);
    }];
}
#pragma mark ==
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:24];
        _titleLabel.text = @"待签合同:";
    }
    return _titleLabel  ;
}
- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = Y_RGBA(38, 114, 249, 1);
        _detailLabel.font = [UIFont systemFontOfSize:30];
        _detailLabel.text = @"--";
    } 
    return _detailLabel;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [_rightBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        [_rightBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
        _rightBtn.userInteractionEnabled = NO;
    }
    return _rightBtn;
}
@end
