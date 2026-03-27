//
//  EIntergralMallOrderVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallOrderVcTableViewCell.h"

@implementation EIntergralMallOrderVcTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.lineViewOne];
        [self.backView addSubview:self.lineViewTwo];
        [self.backView addSubview:self.rightImgV];
        //
        [self.backView addSubview:self.orderNumL];
        [self.backView addSubview:self.imgV];
        //
        [self.backView addSubview:self.goodsNameL];
        [self.backView addSubview:self.goodsNumL];
        //
        [self.backView addSubview:self.outLineL];
        [self.backView addSubview:self.eNumL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
  
    [_orderNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderNumL.superview.mas_top).offset(10);
        make.left.equalTo(_orderNumL.superview.mas_left).offset(10);
        make.right.equalTo(_orderNumL.superview.mas_right).offset(-10);
        make.height.offset(40);
    }];
    [_lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_lineViewOne.superview);
        make.height.offset(1);
        make.top.equalTo(_orderNumL.mas_bottom);
    }];
    //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderNumL.mas_left);
        make.width.height.offset(66);
        make.top.equalTo(_lineViewOne.mas_bottom).offset(10);
    }];
    [_rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(5);
        make.height.offset(10);
        make.centerY.equalTo(_imgV.superview);
        make.right.equalTo(_rightImgV.superview).offset(-16);
    }];
    [_goodsNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.top.equalTo(_imgV.mas_top);
        make.height.offset(20);
        make.right.equalTo(_goodsNameL.superview);
    }];
    [_goodsNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.bottom.equalTo(_imgV.mas_bottom);
        make.height.offset(20);
        make.right.equalTo(_goodsNumL.superview).offset(-10);
    }];
    //
    [_lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(10);
        make.left.right.height.equalTo(_lineViewOne);
    }];
    [_outLineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewTwo.mas_bottom);
        make.bottom.equalTo(_outLineL.superview.mas_bottom);
        make.left.equalTo(_imgV.mas_left);
        make.width.equalTo(_outLineL.superview.mas_width).multipliedBy(0.5);
    }];
    [_eNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineViewTwo.mas_bottom);
        make.bottom.equalTo(_eNumL.superview.mas_bottom);
        make.right.equalTo(_eNumL.superview.mas_right).offset(-10);
        make.width.equalTo(_eNumL.superview.mas_width).multipliedBy(0.5);
    }];
}
#pragma mark ==
- (UILabel *)orderNumL{
    if (!_orderNumL) {
        _orderNumL = [[UILabel alloc]init];
        _orderNumL.textColor = [UIColor blackColor];
        _orderNumL.font = FontSize_MoneyWallet_Nomail(14);
    }
    return _orderNumL;
}
-  (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
//        _imgV.layer.cornerRadius = 2;
//        _imgV.layer.borderWidth = 0.5;
//        _imgV.layer.borderColor = Color_245Gray.CGColor;// Color_153GrayColor.CGColor;
        [_imgV zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
        [_imgV zy_attachBorderWidth:0.5 color:Color_245Gray];

    }
    return _imgV;
}
//---
- (UILabel *)goodsNameL{
    if (!_goodsNameL) {
        _goodsNameL = [[UILabel alloc]init];
        _goodsNameL.textColor = [UIColor blackColor];
        _goodsNameL.font = FontSize_MoneyWallet_Nomail(14);
    }
    return _goodsNameL;
}
- (UILabel *)goodsNumL{
    if (!_goodsNumL) {
        _goodsNumL = [[UILabel alloc]init];
        _goodsNumL.textColor = Color_153GrayColor;
        _goodsNumL.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _goodsNumL;
}

//---
- (UILabel *)outLineL{
    if (!_outLineL) {
        _outLineL = [[UILabel alloc]init];
        _outLineL.font = FontSize_MoneyWallet_Nomail(12);
        _outLineL.textColor = Y_ColorWith16FromRGB(0xFF7B05);
    }
    return _outLineL;
}
- (UILabel *)eNumL{
    if (!_eNumL) {
        _eNumL = [[UILabel alloc]init];
        _eNumL.textAlignment = NSTextAlignmentRight;
    }
    return _eNumL;
}
//---
- (UIView *)lineViewOne{
    if (!_lineViewOne) {
        _lineViewOne = [[UIView alloc]init];
        _lineViewOne.backgroundColor = Color_245Gray;
    }
    return _lineViewOne;
}
- (UIView *)lineViewTwo{
    if (!_lineViewTwo) {
        _lineViewTwo = [[UIView alloc]init];
        _lineViewTwo.backgroundColor = Color_245Gray;
    }
    return _lineViewTwo;
}
- (UIImageView *)rightImgV{
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc]init];
        _rightImgV.image = [UIImage imageNamed:@"skip"];
    }
    return _rightImgV;
}
@end
