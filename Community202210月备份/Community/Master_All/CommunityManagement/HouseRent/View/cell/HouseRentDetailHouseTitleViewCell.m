//
//  HouseRentHouseTitleViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailHouseTitleViewCell.h"
#define  BlueColor_Label    Y_RGBA(38, 114, 249, 1)
@interface HouseRentDetailHouseTitleViewCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIView *titelLabelTopBackView;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *houseTypeLabel;
@property (nonatomic,strong) UILabel *modeLabel;
@end

@implementation HouseRentDetailHouseTitleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _model = model;
    self.titleL.text = model.houseTitle;
//    CGFloat h = [_model getHouseCellTitleHeight];
//    [_titleL mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(h);
//    }];
    //
    self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f/%@", model.housePrice,[TextShowWithModelStr textShowWithModelStr:model.houseUnit]];
    self.houseTypeLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseDeposit];
    self.modeLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseMode];
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.titelLabelTopBackView];
        [self.titelLabelTopBackView addSubview:self.moneyLabel];
        [self.titelLabelTopBackView addSubview:self.houseTypeLabel];
        [self.titelLabelTopBackView addSubview:self.modeLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titelLabelTopBackView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titelLabelTopBackView.superview.mas_top).offset(15);
        make.left.equalTo(_titelLabelTopBackView.superview.mas_left).offset(16);
        make.right.equalTo(_titelLabelTopBackView.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titelLabelTopBackView.mas_bottom).offset(0);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.bottom.equalTo(_titleL.superview.mas_bottom).offset(-5);
    }];
    //
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLabel.superview.mas_top);
        make.left.equalTo(_moneyLabel.superview.mas_left);
        make.bottom.equalTo(_moneyLabel.superview.mas_bottom);
    }];//w 灵活
    [_houseTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_houseTypeLabel.superview.mas_top);
        make.left.equalTo(_moneyLabel.mas_right).offset(5);
        make.bottom.equalTo(_houseTypeLabel.superview.mas_bottom);
    }];
    [_modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_modeLabel.superview.mas_top);
        make.right.equalTo(_modeLabel.superview.mas_right);
        make.bottom.equalTo(_modeLabel.superview.mas_bottom);
    }];//w灵活
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:18];
        _titleL.numberOfLines = 2;
    }
    return _titleL;
}
- (UIView *)titelLabelTopBackView{
    if (!_titelLabelTopBackView) {
        _titelLabelTopBackView = [[UIView alloc]init];
    }
    return _titelLabelTopBackView;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _moneyLabel;
}
- (UILabel *)houseTypeLabel{
    if (!_houseTypeLabel) {
        _houseTypeLabel = [[UILabel alloc]init];
        _houseTypeLabel.textAlignment = NSTextAlignmentLeft;
        _houseTypeLabel.font = [UIFont systemFontOfSize:12];
        _houseTypeLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _houseTypeLabel;
}
- (UILabel *)modeLabel{
    if (!_modeLabel) {
        _modeLabel = [[UILabel alloc]init];
        _modeLabel.textAlignment = NSTextAlignmentLeft;
        _modeLabel.font = [UIFont systemFontOfSize:12];
        _modeLabel.textColor = BlueColor_Label;
    }
    return _modeLabel;
}
@end
