//
//  HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import "HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell.h"

@implementation HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell

- (void)fillDataIsShowStatusBool:(BOOL)isShowStatusInfo withListModel:(MyRepairPageListUseModel *)listModel{
    if (isShowStatusInfo) {
        self.titleL.text = @"类  别：";
        [self.statusBtn newAnBtnWithTextStr:listModel.statusStr];
        self.detailL.text = [TextShowWithModelStr textShowWithNotNullStr:listModel.typeName];
    }else{
        self.titleL.text = @"事  项：";
        [self.statusBtn newAnBtnWithTextStr:@""];
        self.detailL.text = [TextShowWithModelStr textShowWithNotNullStr:listModel.problem];
    }
}
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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self.contentView addSubview:self.statusBtn];
        [self setUI];
    }
    return  self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(26);
        make.width.lessThanOrEqualTo(_titleL.mas_height).offset(10);
    }];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_statusBtn.superview);
        make.right.equalTo(_statusBtn.superview).offset(-26);
        make.width.offset(40);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_detailL.superview);
        make.left.equalTo(_titleL.mas_right).offset(5);
        make.right.equalTo(_statusBtn.mas_left).offset(-5);
    }];
    
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:14];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont boldSystemFontOfSize:14];
        _detailL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _detailL;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_statusBtn setTitleColor:Color_Blue forState:UIControlStateNormal];//蓝色 
    }
    return _statusBtn;
}
@end
