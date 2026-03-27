//
//  SmallShppOrderTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShppOrderTableViewCell.h"

@interface SmallShppOrderTableViewCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *orderNumL;
@property (nonatomic,strong) UILabel *timeL;
@end

@implementation SmallShppOrderTableViewCell


- (void)fillDataWithOrderModel:(SmallShppOrderModel *)orderModel{
    
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:orderModel.name];
    self.orderNumL.text =  [NSString stringWithFormat:@"订单号码：%@",[TextShowWithModelStr textShowWithModelStr:orderModel.orderNumber]];
    self.timeL.text =   [NSString stringWithFormat:@"创建时间：%@",[TextShowWithModelStr textShowWithModelStr:orderModel.orderTime]];
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr: orderModel.headImg ] placeholderImage:[UIImage imageNamed:@"morentup_icon"]];

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 10;
        self.backView.clipsToBounds = YES;
        [self addView];
        [self setUI];
    }
    return self;
}
- (void)addView{
    [self.backView addSubview:self.imgV];
    [self.backView addSubview:self.titleL];
    [self.backView addSubview:self.orderNumL];
    [self.backView addSubview:self.timeL];
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(80);
        make.left.equalTo(_imgV.superview).offset(10);
        make.centerY.equalTo(_imgV.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.right.equalTo(_titleL.superview).offset(-10);
        make.top.equalTo(_imgV).offset(5);
        make.height.offset(20);
    }];
    [_orderNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_titleL);
        make.top.equalTo(_orderNumL.mas_bottom).offset(1);
    }];
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.layer.cornerRadius = 2;
        _imgV.clipsToBounds = YES;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font =  [UIFont boldSystemFontOfSize:13.0];
        _titleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    return _titleL;
}
- (UILabel *)orderNumL{
    if (!_orderNumL) {
        _orderNumL = [[UILabel alloc]init];
        _orderNumL.font =  [UIFont systemFontOfSize:11.0];
        _orderNumL.textColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    return _orderNumL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font =  [UIFont systemFontOfSize:11.0];
        _timeL.textColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    return _timeL;
}

@end
