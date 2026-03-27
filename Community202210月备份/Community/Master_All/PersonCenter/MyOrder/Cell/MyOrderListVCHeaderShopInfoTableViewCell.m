//
//  MyOrderListVCHeaderShopInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVCHeaderShopInfoTableViewCell.h"

@implementation MyOrderListVCHeaderShopInfoTableViewCell


- (void)fillDataWithOrderModel:(MyOrderModel *)model{
 
 //    [cell.redTextBtn newAnBtnWithTextStr:@"10元领取|10元领取|10元领取"];
    if (model.shopLogo.length>0) {
        NSString *allShopLogoImgStr = URL_BuniessService_ImgAllURL([TextShowWithModelStr textShowWithModelStr:model.shopLogo]);
        [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:allShopLogoImgStr]];
    }
//    self.titLeL.text = [NSString stringWithFormat:@"%@(%@)",[TextShowWithModelStr textShowWithModelStr:model.shopName],[TextShowWithModelStr textShowWithModelStr:model.address]];
    self.titLeL.text = [TextShowWithModelStr textShowWithModelStr:model.shopName];
    self.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.appState];
    //优惠券字段没有 暂处理UI
    [self.redTextBtn newAnBtnWithTextStr:@"优惠券"];
    self.redTextBtn.hidden = YES;
    [self.titLeL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.centerY.equalTo(_titLeL.superview);
        make.height.offset(20);
        make.right.lessThanOrEqualTo(_titLeL.superview.mas_right).multipliedBy(0.7);
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titLeL];
        [self.backView addSubview:self.titleBtn];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.redTextBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.superview.mas_centerY);
        make.width.offset(30);
        make.height.offset(30);
        make.left.equalTo(_imgV.superview.mas_left).offset(10);
    }];
    [_titLeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.top.equalTo(_titLeL.superview.mas_top).offset(5);
        make.height.offset(20);
        make.right.lessThanOrEqualTo(_titLeL.superview.mas_right).multipliedBy(0.7);
    }];
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titLeL);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titLeL.mas_centerY);
        make.width.offset(60);
        make.right.equalTo(_typeL.superview.mas_right).offset(-10);
    }];
    [_redTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.top.equalTo(_titLeL.mas_bottom);
        make.height.offset(15);
    }];
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
//        _imgV.layer.cornerRadius = 15;
//        _imgV.layer.masksToBounds = YES;
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        [_imgV zy_cornerRadiusAdvance:15 rectCornerType:UIRectCornerAllCorners];

    }
    return _imgV;
}

- (UILabel *)titLeL{
    if (!_titLeL) {
        _titLeL  = [[UILabel alloc]init];
        _titLeL.textColor = [UIColor blackColor];
        _titLeL.font = FontSize_Orders_Bold(15);
    }
    return _titLeL;
}
- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _titleBtn;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = Color_153GrayColor;
        _typeL.font = FontSize_Orders_Nomail(12);
        _typeL.textAlignment = NSTextAlignmentRight;
    }
    return _typeL;
}
- (UIButton *)redTextBtn{
    if (!_redTextBtn) {
        _redTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redTextBtn.titleLabel.font = FontSize_Orders_Nomail(10);
        [_redTextBtn newAnBtnWithTextColor:COlor_Red255];
        [_redTextBtn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0.5 withLayerLineColor:COlor_Red255];
    }
    return _redTextBtn;
}

@end
