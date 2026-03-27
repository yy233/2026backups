//
//  BaseGoodsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "BaseOneGoodsTableViewCell.h"

@implementation BaseOneGoodsTableViewCell
- (void)fillOrderDetailModelSubOneGoodsModel:(SmallShopOrderDetailModelSubGoodsModel *)goodsModel{
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString: goodsModel.commodityHeadImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];

    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@",[TextShowWithModelStr textShowWithModelStr:goodsModel.commoditySellPrice] ];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.text = [NSString stringWithFormat:@"¥%@", [TextShowWithModelStr textShowWithModelStr: goodsModel.commoditySellPrice]];
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:goodsModel.commodityName];

    self.rightCountL.text = ( [TextShowWithModelStr textShowWithModelStr: goodsModel.commodityNumber].length>0 ?  [NSString stringWithFormat:@"x%@", [TextShowWithModelStr textShowWithModelStr: goodsModel.commodityNumber]] : @"x0" );

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
        [self.contentView addSubview:self.rightCountL];
        WEAKSELF
        [_rightCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_rightCountL.superview).offset(-26);
            make.top.bottom.equalTo(weakSelf.moneyL);
        }];
        [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {//-40 r
            make.right.equalTo(weakSelf.titleL.superview).offset(-26-40);
            make.top.equalTo(weakSelf.imgV).offset(0);
            make.left.equalTo(weakSelf.imgV.mas_right).offset(10);
            make.height.lessThanOrEqualTo(weakSelf.imgV).offset(-30);
        }];
    }
    return self;
}

- (UILabel *)rightCountL{
    if (!_rightCountL) {
        _rightCountL = [[UILabel alloc]init];
        _rightCountL.textColor = Y_ColorWith16FromRGB(0xAAAEB9);
        _rightCountL.font = [UIFont systemFontOfSize:11.0];
        _rightCountL.text = @"x1";//默认一个
    }
    return _rightCountL;
}
@end
