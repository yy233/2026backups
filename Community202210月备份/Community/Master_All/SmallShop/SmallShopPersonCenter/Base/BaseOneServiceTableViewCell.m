//
//  BaseOneServiceTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "BaseOneServiceTableViewCell.h"

@implementation BaseOneServiceTableViewCell

- (void)fillOrderDetailModel:(SmallShopOrderDetailModel *)model{
    SmallShopOrderDetailModelSubGoodsModel *subOneGoodsModel = model.value0.firstObject;
    if (isNil(subOneGoodsModel)) {
        return;
    }
    [self.imgV sd_setImageWithURL:[NSURL URLWithString: subOneGoodsModel.serveHeadImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];
    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@",[TextShowWithModelStr textShowWithModelStr:subOneGoodsModel.serveSellPrice] ];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr: [TextShowWithModelStr textShowWithModelStr:model.value1.orderPayMoney] ];//self.moneyL.text = [NSString stringWithFormat:@"¥%@",@"86666"];
    
    self.titleL.text =  [TextShowWithModelStr textShowWithModelStr:subOneGoodsModel.serveName];
 
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
        //self.boxMonthTitleL.hidden = YES;
        self.boxMonthTitleL.text = @"";
    }
    return self;
}
@end
