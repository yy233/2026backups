//
//  BaseOneBoxTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "BaseOneBoxTableViewCell.h"

@interface BaseOneBoxTableViewCell ()
@end

@implementation BaseOneBoxTableViewCell
- (void)fillOrderDetailModel:(SmallShopOrderDetailModel *)model{
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.cabinetImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];
    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@",[TextShowWithModelStr textShowWithModelStr:model.cabinetPriceOriginal]];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr: [TextShowWithModelStr textShowWithModelStr:model.orderPayMoney] ];//self.moneyL.text = [NSString stringWithFormat:@"¥%@",@"86666"];
    
    self.titleL.text =  [TextShowWithModelStr textShowWithModelStr:model.title];
 
}
- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{//添加中划线，文字颜色

    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    
    NSRange range1 = NSMakeRange(0, first.length);
    NSRange range2 = NSMakeRange(first.length, (first.length + second.length)-1);
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0]  };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]  };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];//
    return astring;
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
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.moneyL];
        [self.contentView addSubview:self.oldMoneyL];//原价
        [self.contentView addSubview:self.boxMonthTitleL];//货柜月租 str
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(80);
        make.left.equalTo(_imgV.superview).offset(26);
        make.centerY.equalTo(_imgV.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleL.superview).offset(-26);
        make.top.equalTo(_imgV).offset(0);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.height.lessThanOrEqualTo(_imgV).offset(-30);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.height.offset(30);
        make.bottom.equalTo(_imgV);
    }];
    [_boxMonthTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_moneyL);
        make.left.equalTo(_moneyL.mas_right);
    }];
    [_oldMoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_moneyL);
        make.left.equalTo(_boxMonthTitleL.mas_right).offset(5);
    }];
    _imgV.image = [UIImage imageNamed:@"morentup_icon"];
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
        _titleL.numberOfLines = 3;
    }
    return _titleL;
}
- (UILabel *)boxMonthTitleL{
    if (!_boxMonthTitleL) {
        _boxMonthTitleL = [[UILabel alloc]init];
        _boxMonthTitleL.font =  [UIFont systemFontOfSize:12.0];
        _boxMonthTitleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _boxMonthTitleL.text = @"货柜月租";
    }
    return _boxMonthTitleL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font =  [UIFont boldSystemFontOfSize:18.0];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF0033);
        _moneyL.text = @"¥0";
    }
    return _moneyL;
}
- (UILabel *)oldMoneyL{
    if (!_oldMoneyL) {
        _oldMoneyL = [[UILabel alloc]init];
        _oldMoneyL.textColor = Y_ColorWith16FromRGB(0xAAAEB9);
        _oldMoneyL.font = [UIFont systemFontOfSize:11.0];
    }
    return _oldMoneyL;

}
 
@end

    
