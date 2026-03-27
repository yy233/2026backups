//
//  CartVcSubBaseFooterView.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
// jiesuan

#import "CartVcSubBaseFooterView.h"

#define  Color_GreenOfPayBtn     Y_ColorWith16FromRGB(0x22D1AD)

@implementation CartVcSubBaseFooterView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W+2, 60+2);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = Y_ColorWith16FromRGB(0xD8DCE6).CGColor;
        //
        [self addSubview:self.allChooseBtn];
        [self addSubview:self.payBtn];
        [self addSubview:self.moneyTitleL];
        [self addSubview:self.payDtoInfoL];
        [self addSubview:self.moneyL];
    
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(106);
        make.height.offset(40);
        make.centerY.equalTo(_payBtn.superview);
        make.right.equalTo(_payBtn.superview).offset(-16);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_payBtn);
        make.top.bottom.equalTo(_moneyL.superview);
        make.right.equalTo(_payBtn.mas_left).offset(-10);
    }];
    [_moneyTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_payBtn);
        make.height.offset(20);
        make.right.equalTo(_moneyL.mas_left).offset(1);
    }];
    [_allChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_payBtn);
        make.width.offset(55);
        make.height.offset(25);
        make.left.equalTo(_allChooseBtn.superview).offset(16);
    }];
    [_allChooseBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6.0];
    //优惠文本
    [_payDtoInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payDtoInfoL.superview).offset(2);
        make.left.equalTo(_payDtoInfoL.superview);
        make.right.equalTo(_moneyL);
    }];
    
}

#pragma mark ==
- (UIButton *)allChooseBtn{
    if (!_allChooseBtn) {
        _allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allChooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"cc_gouwucheyuan_icon"] selectedImg:[UIImage imageNamed:@"cc_gouwuchegouxuan_icon"]];
        [_allChooseBtn newAnBtnWithTextStr:@"全选"];
        [_allChooseBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_allChooseBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xAAAEB9)];
    }
    return _allChooseBtn;
}
- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn newAnBtnWithTextStr:@"结算"];
        [_payBtn newAnBtnWithTextColor: [UIColor whiteColor]  withBackColor:Color_GreenOfPayBtn withFont: [UIFont boldSystemFontOfSize:15.0] withLayerCorNerNum:19.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _payBtn;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = [UIFont boldSystemFontOfSize:28.0];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF0033);
        _moneyL.text = @"0";
    }
    return _moneyL;
}
- (UILabel *)moneyTitleL{
    if (!_moneyTitleL) {
        _moneyTitleL = [[UILabel alloc]init];
        _moneyTitleL.font = [UIFont boldSystemFontOfSize:15.0];
        _moneyTitleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _moneyTitleL.text = @"合计：";
    }
    return _moneyTitleL;
}
- (UILabel *)payDtoInfoL{
    if (!_payDtoInfoL) {
        _payDtoInfoL = [[UILabel alloc]init];
        _payDtoInfoL.font = [UIFont systemFontOfSize:11.0];
        _payDtoInfoL.textColor = Y_ColorWith16FromRGB(0xFF0033);
        _payDtoInfoL.text = @"";
        _payDtoInfoL.textAlignment = NSTextAlignmentRight;
    }
    return _payDtoInfoL;
}

- (void)fillPayDtoInfoLWithPayDto:(SmallShopCartSubPayDtoModel *)payDtoModel{
    
    switch (payDtoModel.activityType) {  //  活动类型 0无1打折2满减3满送4拼团
        case 1://打折
        {
            _payDtoInfoL.text = [NSString stringWithFormat: @"(商品有打折优惠%@折)",payDtoModel.activityGive];
        }
            break;
        case 2://满减
        {
            _payDtoInfoL.text = [NSString stringWithFormat:@"(商品满%@减%@)",payDtoModel.activityFull,payDtoModel.activityGive];
        }
            break;
        case 3://满送
        {
            _payDtoInfoL.text = [NSString stringWithFormat:@"(商品满%@送%@)",payDtoModel.activityFull,payDtoModel.activityGive];
        }
            break;
        case 4://拼团
        {
            _payDtoInfoL.text = [NSString stringWithFormat:@"(商品参加了拼团活动)"];
        }
            break;
          
        default:
            _payDtoInfoL.text = @"";//置空
            break;
    }
   
  
}

- (void)footerViewIsRedOrangeBackColor{
    DLog(@"底部颜色待改");
}
/**
 
 
     
 
 
 activityType    number
 非必须
     
     活动类型 0无1打折2满减3满送4拼团
 activityFull    null
 非必须
     
     满x
 activityGive    null
 非必须
     
     送y(折扣/份数/金额)
 */
@end
