//
//  MyOrderListVcMaxDishesTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVcMaxDishesTableViewCell.h"

@implementation MyOrderListVcMaxDishesTableViewCell
- (void)fillDataWithOrderModel:(MyOrderModel *)model{
    MyOrderModelSubCommodityModel *subCommodityModel =   model.orderCommodityDtos.firstObject;//取一个菜品做显示
    if (subCommodityModel.image.length>0) {
        NSString *allDishesImgStr = URL_BuniessService_ImgAllURL([TextShowWithModelStr textShowWithModelStr:subCommodityModel.image]);
        [self.dishesImgV sd_setImageWithURL:[UrlWithString getURLWithStr:allDishesImgStr]];
    }
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:subCommodityModel.name];
    //商品数量总数
    __block  NSInteger subCommodityNum = 0;
    for ( MyOrderModelSubCommodityModel *subCommMode in model.orderCommodityDtos) {
        subCommodityNum +=  subCommMode.num;
    }
    self.numberL.text = [NSString stringWithFormat:@"共%ld件",(long)subCommodityNum];
    //
    self.timeL.text = [NSString stringWithFormat:@"下单时间：%@",[TextShowWithModelStr textShowWithModelStr:model.createTime]];
    self.nowMoneyL.text = [NSString stringWithFormat:@"%0.2f",model.orderPrice];
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
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.nowMoneyL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_dishesImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dishesImgV.superview.mas_left).offset(10);
        make.centerY.equalTo(_dishesImgV.superview.mas_centerY);
        make.width.offset(70);
        make.height.offset(55);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dishesImgV.mas_right).offset(10);
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.right.equalTo(_titleL.superview).offset(-70);
    }];
    [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {//自动的whitd
        make.centerY.equalTo(_titleL.mas_centerY);
        make.right.equalTo(_numberL.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    //
    [_nowMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nowMoneyL.superview.mas_right).offset(-10);
        make.top.equalTo(_dishesImgV.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dishesImgV.mas_left);
        make.height.offset(20);
        make.top.bottom.equalTo(_nowMoneyL);
        
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
        _titleL.textColor = Color_153GrayColor;
        _titleL.font = FontSize_Orders_Nomail(12);
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
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = Color_153GrayColor;
        _timeL.font = FontSize_Orders_Nomail(12);
    }
    return _timeL;
}
@end
