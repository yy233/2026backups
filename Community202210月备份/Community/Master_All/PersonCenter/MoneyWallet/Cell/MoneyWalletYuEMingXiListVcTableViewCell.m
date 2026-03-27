//
//  MoneyWalletYuEMingXiListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletYuEMingXiListVcTableViewCell.h"

@implementation MoneyWalletYuEMingXiListVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)fillCellData:(NSDictionary *)dic withType:(YuEMingXi_Type)type{
//    if(type==YuEMingXi_Type_ShouRu){
//        _mongyL.textColor = Y_RGBA(255, 102, 0, 1);
//    }else if (type==YuEMingXi_Type_ZhiChu){
//        _mongyL.textColor = Y_RGBA(56, 194, 24, 1);
//    }else{
//        return;
//    }
//    //test
//    _timeL.text = @"2021-01-17 14:36:15";
//    if(type==YuEMingXi_Type_ShouRu){
//        _titleL.text = @"充值";
//        _mongyL.text = @"+200";
//    }else if (type==YuEMingXi_Type_ZhiChu){
//        _titleL.text  = @"支付";
//        _mongyL.text = @"-10";
//    }
//}

// 设置数据model
- (void)setModel:(ZYBalanceDetailDataRecordsModel *)model {
    _model = model;
    
    self.titleL.text = _model.tradeFromStr;
    self.timeL.text = _model.createTime;
    if (_model.tradeType == 2) {
        self.mongyL.textColor = Y_RGBA(255, 102, 0, 1);
        self.mongyL.text = [NSString stringWithFormat:@"+%@", _model.tradeAmountStr];
    }else {
        self.mongyL.textColor = Y_RGBA(56, 194, 24, 1);
        self.mongyL.text = [NSString stringWithFormat:@"-%@", _model.tradeAmountStr];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.mongyL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.left.equalTo(_titleL.superview).offset(10);
        make.right.equalTo(_titleL.superview).offset(-50);
        make.height.offset(20);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_timeL.superview).offset(-10);
        make.left.equalTo(_timeL.superview).offset(10);
        make.right.equalTo(_timeL.superview).offset(-50);
        make.height.offset(20);
    }];
    [_mongyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mongyL.superview).offset(10);//用了组圆角 内容视图会减少右边且在箭头左边 -10改0 即可
        make.centerY.equalTo(_mongyL.superview);
        make.height.offset(20);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_MoneyWallet_Nomail(16);
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font = FontSize_MoneyWallet_Nomail(12);
     }
    _timeL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _timeL;
}
- (UILabel *)mongyL{
    if (!_mongyL) {
        _mongyL = [[UILabel alloc]init];
        _mongyL.font = FontSize_MoneyWallet_Bold(16);
        _mongyL.textAlignment = NSTextAlignmentRight;
    }
    return _mongyL;
}

@end
