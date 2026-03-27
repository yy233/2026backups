//
//  ZYXianjingJuanCell.m
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import "ZYXianjingJuanCell.h"

@interface ZYXianjingJuanCell ()

@property (nonatomic,strong) UILabel *bttomL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *deadLineTimeL;
@property (nonatomic,strong) UIImageView *backImgV;

@end

@implementation ZYXianjingJuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYXianjingJuanListDataRecordsModel *)model {
    _model = model;
    
    self.moneyL.textColor = Color_38BlueColor;
    self.moneyL.text = [NSString stringWithFormat:@"¥%@", _model.moneyStr];
    self.typeL.text = @"现金抵扣券";
    self.titleL.text = _model.title;
    self.deadLineTimeL.text = _model.remark;
    self.bttomL.textColor = COlor_Red255;
    self.bttomL.text = [NSString stringWithFormat:@"%@到期", _model.expireTime];
    self.bottomBtn.backgroundColor = [UIColor clearColor];
    self.bottomBtn.userInteractionEnabled = NO;
    if (_model.expired == 0) {
        if (_model.status == 0) {
            [self.bottomBtn newAnBtnWithTextStr:@"去使用"];
            [self.bottomBtn newAnBtnWithTextColor:Color_38BlueColor];
        }else {
            [self.bottomBtn newAnBtnWithTextStr:@"已使用"];
            [self.bottomBtn newAnBtnWithTextColor:Y_RGBA(200, 200, 200, 1)];
        }
    }else {
        [self.bottomBtn newAnBtnWithTextStr:@"已过期"];
        [self.bottomBtn newAnBtnWithTextColor:Y_RGBA(200, 200, 200, 1)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =  [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor clearColor];
       //
//        self.backView.layer.cornerRadius = 7.5;
//        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.backImgV];
        [self.backView addSubview:self.bttomL];
        [self.backView addSubview:self.bottomBtn];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.deadLineTimeL];
        
        
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgV.superview);
    }];
    [_bttomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bttomL.superview).offset(10);
        make.right.equalTo(_bttomL.superview).offset(-90);
        make.bottom.equalTo(_bttomL.superview);
        make.height.offset(35);
    }];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.right.equalTo(_bottomBtn.superview).offset(-10);
        make.top.equalTo(_bttomL.mas_top);
        make.height.offset(25);//
    }];
    //
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.superview.mas_top).offset(20);
        make.width.offset(100);
        make.height.offset(25);
        make.left.equalTo(_moneyL.superview.mas_left).offset(6);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeL.superview.mas_left).offset(6);
        make.height.offset(25);
        make.width.offset(100);
        make.top.equalTo(_moneyL.mas_bottom);
    }];
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyL.mas_right).offset(6);
        make.right.equalTo(_titleL.superview.mas_right).offset(-10);
        make.top.equalTo(_moneyL.mas_top);
    }];
    [_deadLineTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.left.right.equalTo(_titleL);
    }];
    
}
- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]init];
        _backImgV.image = [UIImage imageNamed:@"Coupons_bottom"];
        _backImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImgV;
}
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn newAnBtnWithTextStr:@"去使用"];
        [_bottomBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_bottomBtn newAnBtnWithFont:FontSize_Vip_Bold(12)];
        [_bottomBtn newAnBtnWithLayerCorNerNum:12.5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        _bottomBtn.backgroundColor = COlor_Red255;
    }
    return _bottomBtn;
}
- (UILabel *)bttomL{
    if (!_bttomL) {
        _bttomL = [[UILabel alloc]init];
        _bttomL.font = FontSize_Vip_Nomail(12);
        _bttomL.textColor = Y_RGBA(153, 153, 153, 1);
        _bttomL.numberOfLines = 0;
    }
    return _bttomL;
}
//
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = FontSize_Vip_Bold(27);
        _moneyL.textColor = COlor_Red255;
        _moneyL.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyL;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.font = FontSize_Vip_Nomail(12);
        _typeL.textColor = Y_RGBA(153, 153, 153, 1);
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeL;
}
//
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_Vip_Bold(17);
        _titleL.textColor = [UIColor blackColor];
        _titleL.numberOfLines = 0;
    }
    return _titleL;
}
- (UILabel *)deadLineTimeL{
    if (!_deadLineTimeL) {
        _deadLineTimeL = [[UILabel alloc]init];
        _deadLineTimeL.font = FontSize_Vip_Nomail(12);
        _deadLineTimeL.textColor = Y_RGBA(255, 96, 0, 1);
        _deadLineTimeL.numberOfLines = 0;
    }
    return _deadLineTimeL;
}

@end
