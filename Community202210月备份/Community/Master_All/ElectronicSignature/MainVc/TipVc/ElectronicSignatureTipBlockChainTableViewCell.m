//
//  ElectronicSignatureTipBlockChainTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureTipBlockChainTableViewCell.h"

@implementation ElectronicSignatureTipBlockChainTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)showLeftTextAndRightImgCell{
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImg.superview.mas_centerY);
        make.width.equalTo(_rightImg.superview.mas_width).multipliedBy(0.3);
        make.height.equalTo(_rightImg.superview.mas_width).multipliedBy(0.3);
        make.right.equalTo(_rightImg.superview.mas_right);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.height.offset(40);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_rightImg.mas_left).offset(-20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _detailL.textAlignment = NSTextAlignmentLeft;
}
- (void)showRightTextAndLeftImgCell{
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImg.superview.mas_centerY);
        make.width.equalTo(_rightImg.superview.mas_width).multipliedBy(0.3);
        make.height.equalTo(_rightImg.superview.mas_width).multipliedBy(0.3);
        make.left.equalTo(_rightImg.superview.mas_left).offset(10);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.height.offset(40);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.left.equalTo(_rightImg.mas_right).offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    _titleL.textAlignment = NSTextAlignmentRight;
    _detailL.textAlignment = NSTextAlignmentRight;
}

- (void)setUI{
}

- (UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]init];
        _rightImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _rightImg;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = FontSize_ElectronicSignature_Bold(21);
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentLeft;
        _detailL.textColor =  [ZYThemeManager shareManager].subTitleThemeColor;
        _detailL.font = FontSize_ElectronicSignature_Nomail(14);
        _detailL.numberOfLines = 0;
    }
 
    return _detailL;
}
@end
