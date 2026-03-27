//
//  HouseRepairDetailInfoCellSubTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairDetailInfoCellSubTextTableViewCell.h"

@implementation HouseRepairDetailInfoCellSubTextTableViewCell

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
        [self.contentView addSubview:self.titleLalel];
        [self.contentView addSubview:self.detailLalel];
        [self setSubCellTextUI];
    }
    return self;
}
- (void)setSubCellTextUI{
    [_titleLalel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLalel.superview.mas_top);
        make.bottom.equalTo(_titleLalel.superview.mas_bottom);
        make.left.equalTo(_titleLalel.superview.mas_left);
        make.width.offset(80);
    }];
    [_detailLalel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailLalel.superview.mas_top);
        make.bottom.equalTo(_detailLalel.superview.mas_bottom);
        make.right.equalTo(_detailLalel.superview.mas_right);
        make.left.equalTo(_titleLalel.mas_right).offset(10);
    }];
}

- (UILabel *)titleLalel{
    if (!_titleLalel) {
        _titleLalel = [[UILabel alloc]init];
        _titleLalel.font = [UIFont systemFontOfSize:13];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _titleLalel.textColor = Y_RGBA(158, 158, 158, 1);
        }else{
            _titleLalel.textColor = Y_RGBA(197, 201, 212, 1);
        }
    }
    return _titleLalel;
}

- (UILabel *)detailLalel{
    if (!_detailLalel) {
        _detailLalel = [[UILabel alloc]init];
        _detailLalel.font = [UIFont systemFontOfSize:13];
        _detailLalel.textColor = [ThemeManager shareManager].mainTextColor;
        _detailLalel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLalel;
}
@end


#pragma mark ===========================

@implementation HouseRepairDetailInfoCellSubTextAndRightBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.copyBtn];
        [self setSubCellTextAndRightBtnUI];
    }
    return self;
}
- (void)setSubCellTextAndRightBtnUI{
    [self.titleLalel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLalel.superview.mas_top);
        make.bottom.equalTo(self.titleLalel.superview.mas_bottom);
        make.left.equalTo(self.titleLalel.superview.mas_left);
        make.width.offset(60);
    }];
    [_copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_copyBtn.superview.mas_centerY);
        make.right.equalTo(_copyBtn.superview.mas_right);
        make.width.offset(40);
        make.height.offset(22);
    }];
    [self.detailLalel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLalel.superview.mas_top);
        make.bottom.equalTo(self.detailLalel.superview.mas_bottom);
        make.left.equalTo(self.titleLalel.mas_right).offset(5);
        make.right.equalTo(_copyBtn.mas_left).offset(-10);
    }];
    self.detailLalel.numberOfLines = 2;//订单号可2行
}
- (UIButton *)copyBtn{
    if (!_copyBtn) {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyBtn.layer.cornerRadius = 3;
        _copyBtn.layer.borderWidth = 0.5;
        _copyBtn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.6].CGColor;
        _copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    }
    return _copyBtn;
}
@end
