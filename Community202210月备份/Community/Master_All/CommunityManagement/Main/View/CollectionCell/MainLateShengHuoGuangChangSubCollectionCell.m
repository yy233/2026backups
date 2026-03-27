//
//  MainLateShengHuoGuangChangSubCollectionCell.m
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import "MainLateShengHuoGuangChangSubCollectionCell.h"
#define Color_Black     Y_ColorWith16FromRGB(0x2B2C2F)

@implementation MainLateShengHuoGuangChangSubCollectionCell
 

#pragma mark ===
//二手市集数据
- (void)fillErShouShopCellDataModel:(MainShengHuoGuangChangListErShouUseModel *)model{
   NSArray *imgArr = [model.images componentsSeparatedByString:@","];
    [self.imgView sd_setImageWithURL:[UrlWithString getURLWithStr:imgArr.firstObject]];
    self.titleLabel.text = model.goodsName;
    self.typeL.text = model.labelName;//新旧程度 长度不一定

    self.addressL.text = model.categoryName;
    self.moneyL.text = [NSString stringWithFormat:@"¥%0.2f",model.price];
    if (model.negotiable >0 ) {//"negotiable": 0,//是否面议  没有价格 默认面议
        self.moneyL.text = @"面议";
    }
}

//租房数据
- (void)fillZuFangCellDataModel:(HouseRentListVcHouseCellModel *)model{
    [self.imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.houseImage.firstObject]];
    self.titleLabel.text = model.houseTitle;
    self.typeL.text = model.houseLeaseMode;
    self.addressL.text = model.houseAddress;
    self.moneyL.text = [NSString stringWithFormat:@"¥%0.2f/%@",model.housePrice,model.houseUnit];
    if (model.houseAdvantageCode.count>0) {
        //tips
        [self setTypeBackViewSubViews:model.houseAdvantageCode];
    }
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.imgView.image = nil;
    [self.tipBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//
    //
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    _typeL.textColor = [ThemeManager shareManager].mainTextColor;
    _lineV.backgroundColor = Y_ColorWith16FromRGB(0xDDDDDD);
 
}

- (void)setTypeBackViewSubViews:(NSDictionary *)houseAdvantage{
    NSInteger count = 0;
    NSArray *typeKeysArr = [houseAdvantage allKeys];
    if (typeKeysArr.count==0) {
        return;//空数据 不做小标签图
    }
    if (typeKeysArr.count>3) {
        count = 3;//列表限制最多显示3个
    }else{
        count = typeKeysArr.count;
    }
    //add labe
//    float  subLabY = 35;//整租合租有30w 初5间隔
    float  subLabX = 5;//广场的tips此行没有合租整租属性位置30   x 非 y
    float  subLabTopY = 8;//y---应该走centery 但是tipBackView heightV的高低灵活不定 当前固定一个偏中心的
    for (int i=0; i<count; i++) {
        NSString *textStr = [NSString stringWithFormat:@"%@",typeKeysArr[i]];
        //基础
        UILabel *lab = [self subBaseLab];
        //文本+fram
        lab.text = [NSString stringWithFormat:@"%@",textStr];
        CGSize labSize = [[NSString stringWithFormat:@"%@",textStr] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}]; //文本尺寸
        CGRect fram = CGRectMake(subLabX,subLabTopY, labSize.width+4, 20);//+2y +4w
        lab.frame = fram;
        //下次的fram 用到的y 更新
        subLabX = subLabX + labSize.width + 5+4;//5间隔 4w
        [self.tipBackView addSubview:lab];
    }
}
- (UILabel *)subBaseLab{//基础
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 2.5;
    lab.textColor =  Y_ColorWith16FromRGB(0xF35D45);//Y_RGBA(38, 114, 249, 1);
    lab.backgroundColor = [Y_ColorWith16FromRGB(0xF35D45) colorWithAlphaComponent:0.2];
    return lab;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.lineV];
        [self.backView addSubview:self.addressL];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.tipBackView];
        [self setUI];
        
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.superview.mas_top);
        make.left.right.equalTo(_imgView.superview);
        make.height.offset(135);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.superview.mas_top).offset(140);
        make.bottom.equalTo(_titleLabel);
        make.left.equalTo(_typeL.superview).offset(0);
        make.width.offset(36);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeL.mas_right);
        make.width.offset(1);
        make.centerY.equalTo(_typeL);
        make.height.offset(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.superview.mas_top).offset(140);
        make.left.equalTo(_lineV.mas_right).offset(5);
        make.right.equalTo(_titleLabel.superview).offset(-10);
     }];
    //
    
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_moneyL.superview).offset(-10);
        make.left.equalTo(_moneyL.superview).offset(10);
        make.bottom.equalTo(_moneyL.superview).offset(-10);
        make.height.offset(20);
    }];
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addressL.superview).offset(-10);
        make.left.equalTo(_addressL.superview).offset(10);
        make.bottom.equalTo(_moneyL.mas_top).offset(-5);
    }];
    //
    [_tipBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.right.equalTo(_tipBackView.superview);
        make.bottom.equalTo(_addressL.mas_top);
    }];
}


- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
    }
    _backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    return _backView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        //    [self.typeL sizeThatFits:CGSizeMake(36, 20)];//字体大小处理
        _typeL.adjustsFontSizeToFitWidth = YES;
        [_typeL sizeToFit];
        _typeL.numberOfLines = 2;//
        _typeL.font = [UIFont boldSystemFontOfSize:14];
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    _typeL.textColor = [ThemeManager shareManager].mainTextColor;
    return _typeL;
    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleLabel;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_ColorWith16FromRGB(0xDDDDDD);
    }
    return _lineV;
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.numberOfLines = 0;
        _addressL.font = [UIFont boldSystemFontOfSize:11];
        _addressL.textColor = Y_ColorWith16FromRGB(0xAAAEB9);
    }
    return _addressL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.numberOfLines = 0;
        _moneyL.font = [UIFont boldSystemFontOfSize:13];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xF63D33);
    }
    return _moneyL;
}
- (UIView *)tipBackView{
    if (!_tipBackView) {
        _tipBackView = [[UIView alloc]init];
    }
    return _tipBackView;
}
@end
