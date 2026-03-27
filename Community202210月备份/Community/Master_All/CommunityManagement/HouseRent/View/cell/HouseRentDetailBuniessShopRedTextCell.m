//
//  HouseRentDetailRedTextCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailBuniessShopRedTextCell.h"

@interface HouseRentDetailBuniessShopRedTextCell ()
@property (nonatomic,strong)  UILabel *moneyLabel;
@property (nonatomic,strong)  UILabel *twoLabel;
@property (nonatomic,strong)  UILabel *areaSeacpLabel;
//
@property (nonatomic,strong)  UILabel *depositLabel;
@property (nonatomic,strong)  UILabel *twoBottomLabel;
@property (nonatomic,strong)  UILabel *areaSeacpBottomLabel;

@end
@implementation HouseRentDetailBuniessShopRedTextCell

 
- (void)setModel:(HouseRentDetailVcBuniessShopModelShopModel *)model{
    _model = model;
    _depositLabel.text = [TextShowWithModelStr textShowWithModelStr:model.defrayType];
    NSString *strMoney = [TextShowWithModelStr textShowWithModelStr:model.monthMoneyString];
    //
    if (strMoney.length == 0 && model.monthMoney == 0) {
        _moneyLabel.text =@"面议";
    }else{//str
        if (strMoney.length==0) {
            _moneyLabel.text = [NSString stringWithFormat:@"%0.2f/月",model.monthMoney];
        }
        //str
        if ([strMoney isEqualToString:@"面议"]) {
            _moneyLabel.text = @"面议";
        }else{
            _moneyLabel.text = [NSString stringWithFormat:@"%@/月",strMoney];
        }
        //
        if ([_moneyLabel.text isEqualToString: @"/月"] ) {
            _moneyLabel.text = @"面议";
        }
    }
    //
    _areaSeacpLabel.text = [NSString stringWithFormat:@"%0.2f ㎡",model.shopAcreage];
    if ([TextShowWithModelStr textShowWithModelStr:model.transferMoneyString].length==0) {
        _twoBottomLabel.text = @"";//@"转让费"
    }else{
        _twoLabel.text = [TextShowWithModelStr textShowWithModelStr:model.transferMoneyString] ;//[NSString stringWithFormat:@"%0.2f元",model.transaferMoney];
        _twoBottomLabel.text = @"转让费";
    }
    
}

#pragma mark ===
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
        self.contentView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.twoLabel];
        [self.contentView addSubview:self.areaSeacpLabel];
        [self.contentView addSubview:self.depositLabel];
        [self.contentView addSubview:self.twoBottomLabel];
        [self.contentView addSubview:self.areaSeacpBottomLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoLabel.superview.mas_top).offset(15);
        make.centerX.equalTo(_twoLabel.superview.mas_centerX);
        make.height.offset(20);
        make.width.offset(Screen_W/3);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLabel.superview.mas_top).offset(15);
        make.height.offset(20);
        make.width.offset(Screen_W/3);
        make.right.equalTo(_twoLabel.mas_left);
    }];
    [_areaSeacpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_areaSeacpLabel.superview.mas_top).offset(15);
        make.height.offset(20);
        make.width.offset(Screen_W/3);
        make.left.equalTo(_twoLabel.mas_right);
    }];
    
    [_twoBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_twoLabel.mas_centerX);
        make.width.equalTo(_twoLabel.mas_width);
        make.top.equalTo(_twoLabel.mas_bottom).offset(5);
    }];
    [_depositLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_moneyLabel.mas_centerX);
        make.width.equalTo(_moneyLabel.mas_width);
        make.top.equalTo(_moneyLabel.mas_bottom).offset(5);
    }];
    [_areaSeacpBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_areaSeacpLabel.mas_centerX);
        make.width.equalTo(_areaSeacpLabel.mas_width);
        make.top.equalTo(_areaSeacpLabel.mas_bottom).offset(5);
    }];
    
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _moneyLabel;
}
- (UILabel *)twoLabel{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc]init];
        _twoLabel.textAlignment = NSTextAlignmentCenter;
        _twoLabel.textColor = [UIColor redColor];
        _twoLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _twoLabel;
}
- (UILabel *)areaSeacpLabel{
    if (!_areaSeacpLabel) {
        _areaSeacpLabel  = [[UILabel alloc]init];
        _areaSeacpLabel.textAlignment = NSTextAlignmentCenter;
        _areaSeacpLabel.textColor = [UIColor redColor];
        _areaSeacpLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _areaSeacpLabel;
}

- (UILabel *)depositLabel{
    if (!_depositLabel) {
        _depositLabel = [[UILabel alloc]init];
        _depositLabel.textAlignment = NSTextAlignmentCenter;
        _depositLabel.font = [UIFont systemFontOfSize:12];
        _depositLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _depositLabel;
}
- (UILabel *)twoBottomLabel{
    if (!_twoBottomLabel) {
        _twoBottomLabel = [[UILabel alloc]init];
        _twoBottomLabel.textAlignment = NSTextAlignmentCenter;
        _twoBottomLabel.font = [UIFont systemFontOfSize:12];
        _twoBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _twoBottomLabel.text = @"转让费";
    }
    return _twoBottomLabel;
}
- (UILabel *)areaSeacpBottomLabel{
    if (!_areaSeacpBottomLabel) {
        _areaSeacpBottomLabel = [[UILabel alloc]init];
        _areaSeacpBottomLabel.text = @"面积";
        _areaSeacpBottomLabel.textAlignment = NSTextAlignmentCenter;
        _areaSeacpBottomLabel.font = [UIFont systemFontOfSize:12];
        _areaSeacpBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _areaSeacpBottomLabel;
}

@end
