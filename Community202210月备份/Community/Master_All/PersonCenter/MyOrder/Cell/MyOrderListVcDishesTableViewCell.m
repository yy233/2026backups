//
//  MyOrderListVcDishesTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVcDishesTableViewCell.h"


@implementation MyOrderListVcDishesTableViewCell

- (void)fillDataWithCommModel:(MyOrderModelSubCommodityModel *)model{
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr: model.name];
    self.numberL.text = [NSString stringWithFormat:@"x%ld",model.num];
    self.oldMoneyL.text = [NSString stringWithFormat:@"%0.2f",model.price];
    self.nowMoneyL.text = [NSString stringWithFormat:@"%0.2f",model.price];
    NSString *allDishesImgStr = URL_BuniessService_ImgAllURL([TextShowWithModelStr textShowWithModelStr:model.image]);
    [self.dishesImgV sd_setImageWithURL:[UrlWithString getURLWithStr:allDishesImgStr]];
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
        [self.backView addSubview:self.dishesImgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.numberL];
        [self.backView addSubview:self.oldMoneyL];
        [self.backView addSubview:self.nowMoneyL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_dishesImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dishesImgV.superview.mas_left).offset(10);
        make.centerY.equalTo(_dishesImgV.superview.mas_centerY);
        make.width.offset(45);
        make.height.offset(45);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dishesImgV.mas_right).offset(10);
        make.top.equalTo(_dishesImgV);
        make.right.equalTo(_titleL.superview).offset(-70);
    }];
    [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.bottom.equalTo(_dishesImgV);
        make.right.equalTo(_titleL.superview).offset(-70);
        make.height.offset(20);
    }];
    //
    [_nowMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nowMoneyL.superview.mas_right).offset(-10);
        make.top.equalTo(_titleL);
        make.height.offset(20);
    }];
    [_oldMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nowMoneyL.mas_left).offset(-10);
        make.height.top.equalTo(_titleL);
    }];
}
#pragma mark ==
- (UIImageView *)dishesImgV{
    if (!_dishesImgV) {
        _dishesImgV = [[UIImageView alloc]init];
//        _dishesImgV.layer.cornerRadius = 5;
//        _dishesImgV.layer.masksToBounds = YES;
        [_dishesImgV zy_cornerRadiusAdvance:5 rectCornerType:UIRectCornerAllCorners];

    }
    return _dishesImgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = Color_51BlackColor;
        _titleL.font = FontSize_Orders_Bold(13);
    }
    return _titleL;
}
- (UILabel *)numberL{
    if (!_numberL) {
        _numberL = [[UILabel alloc]init];
        _numberL.textColor = Color_153GrayColor;
        _numberL.font = FontSize_Orders_Nomail(12);
    }
    return _numberL;
}
- (UILabel *)nowMoneyL{
    if (!_nowMoneyL) {
        _nowMoneyL = [[UILabel alloc]init];
        _nowMoneyL.textColor = [UIColor blackColor];
        _nowMoneyL.font = FontSize_Orders_Bold(15);
    }
    return _nowMoneyL;
}
- (UILabel *)oldMoneyL{
    if (_oldMoneyL) {
        _oldMoneyL = [[UILabel alloc]init];
        _oldMoneyL.textColor = Color_153GrayColor;
        _oldMoneyL.font = FontSize_Orders_Nomail(12);
    }
    return _oldMoneyL;
}
@end
