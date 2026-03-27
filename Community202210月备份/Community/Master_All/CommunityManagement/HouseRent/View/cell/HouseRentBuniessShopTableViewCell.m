//
//  HouseRentBuniessShopTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import "HouseRentBuniessShopTableViewCell.h"

@implementation HouseRentBuniessShopTableViewCell
//重写 滞空
- (void)reSetUI{
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.image = nil;
    [self.typeBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setShopCellmodel:(HouseRentListVcBuniessShopCellModel *)shopCellmodel{
    _shopCellmodel = shopCellmodel;
    [self allNomailShowLabel];
    [self typeAddSubLabel];
    [self imgShow];
}

//重写赋值
- (void)imgShow{
    if (_shopCellmodel.imgPath.length>0) {
        NSURL *imgUrl = [UrlWithString getURLWithStr:[TextShowWithModelStr textShowWithModelStr:_shopCellmodel.imgPath]];
        [self.headImgv sd_setImageWithURL:imgUrl];
    }
}
- (void)allNomailShowLabel{
    self.titleLabel.text = [TextShowWithModelStr textShowWithModelStr: _shopCellmodel.title];
    self.detailtitleLabel.text = [NSString stringWithFormat:@"%@",_shopCellmodel.summarize];
    NSString *coseStr = @"";// [NSString stringWithFormat:@"%0.2f元/月",_shopCellmodel.monthMoney];
    if ([[TextShowWithModelStr textShowWithModelStr:_shopCellmodel.monthMoneyString] isEqualToString:@"面议"]) {
        coseStr = @"面议";
    }else{
        coseStr = [NSString stringWithFormat:@"%@/月",[TextShowWithModelStr textShowWithModelStr:_shopCellmodel.monthMoneyString]];
    }
    NSString *acrStr = [NSString stringWithFormat:@"%0.2f㎡",_shopCellmodel.shopAcreage];
    NSString *coseAllStr = [NSString stringWithFormat:@"%@ %@",coseStr,acrStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: coseAllStr];
    //左对齐
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, coseAllStr.length)];
    //cose部分
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont  boldSystemFontOfSize:15] range:NSMakeRange(0, coseStr.length)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: Y_RGBA(255, 0, 51, 1) range:NSMakeRange(0, coseStr.length)];
    //面积部分
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont  systemFontOfSize:13] range:NSMakeRange(coseStr.length+1, acrStr.length)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: Y_RGBA(197, 201, 212, 1) range:NSMakeRange(coseStr.length+1, acrStr.length)];
    self.coseL.attributedText = attributedStr;

}
- (void)typeAddSubLabel{
    [self setTypeBackViewSubViews:_shopCellmodel.tags];
}

- (void)setTypeBackViewSubViews:(NSArray *)tage{
    NSInteger count = 0;
   
    if (tage.count==0) {
        return;//空数据 不做小标签图
    }
    if (tage.count>3) {
        count = 3;//列表限制最多显示3个
    }else{
        count = tage.count;
    }
    //add labe
    float  subLabY = 0;//
    for (int i=0; i<count; i++) {
        NSString *textStr = [NSString stringWithFormat:@"%@",tage[i]];
        //基础
        UILabel *lab = [self subBaseLab];
        //文本+fram
        lab.text = [NSString stringWithFormat:@"%@",textStr];
        CGSize labSize = [[NSString stringWithFormat:@"%@",textStr] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}]; //文本尺寸
        CGRect fram = CGRectMake(subLabY,2, labSize.width+4, 20);//+2y +4w
        lab.frame = fram;
        //下次的fram 用到的y 更新
        subLabY = subLabY + labSize.width + 5+4;//5间隔 4w
        [self.typeBackView addSubview:lab];
    }
}
- (UILabel *)subBaseLab{//基础
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.layer.cornerRadius = 2;
    lab.textColor = Y_RGBA(38, 114, 249, 1);
    lab.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    lab.layer.borderWidth = 1;
    return lab;
}

@end
 
