//
//  LdleGoodDetailHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodDetailHeaderView.h"

@implementation LdleGoodDetailHeaderView

- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model{
    
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.goodsName];
    self.moneyL.text = [NSString  stringWithFormat:@"¥%0.2f",model.price];
    [self.goodsStuasBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.labelName]];
    CGFloat goodsStuasBtn_H = [Tool getTextWidthWhenOneLineWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.labelName] withFont:[UIFont systemFontOfSize:14.0]];
    if (goodsStuasBtn_H > 0) {//有状态数据
        [_goodsStuasBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(goodsStuasBtn_H+10);
        }];
    }
    self.readCountL.text = [NSString stringWithFormat:@"%ld次浏览",model.clickNumberSum];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 120);//title过长 得增加
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.centerMainBackView];
        [self.centerMainBackView addSubview:self.titleL];
        [self.centerMainBackView addSubview:self.moneyL];
        [self.centerMainBackView addSubview:self.goodsStuasBtn];
        [self.centerMainBackView addSubview:self.forwardingBtn];
        [self.centerMainBackView addSubview:self.readCountL];
        [self setUI];
        self.goodsStuasBtn.userInteractionEnabled = YES;
    }
    return self;
}
- (void)setUI{
    [_centerMainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerMainBackView.superview);
        make.left.equalTo(_centerMainBackView.superview).offset(16);
        make.right.equalTo(_centerMainBackView.superview).offset(-16);
        make.height.offset(120);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(5);
        make.left.equalTo(_titleL.superview);
        make.right.equalTo(_titleL.superview).offset(-36);

    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(0);
        make.left.equalTo(_moneyL.superview);
        make.height.offset(30);
    }];
    [_goodsStuasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.mas_bottom).offset(5);
        make.left.equalTo(_goodsStuasBtn.superview);
        make.width.offset(0);
    }];
    [_forwardingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(_forwardingBtn.superview).offset(-10);
        make.bottom.equalTo(_titleL.mas_bottom);
    }];
    [_readCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyL);
        make.right.equalTo(_readCountL.superview).offset(0);
        make.height.offset(20);
    }];
}


#pragma mark ===
- (UIView *)centerMainBackView{
    if (!_centerMainBackView) {
        _centerMainBackView = [[UIView alloc]init];
        _centerMainBackView.clipsToBounds = YES;
    }
    return _centerMainBackView;
}

- (UIButton *)goodsStuasBtn{
    if (!_goodsStuasBtn) {
        _goodsStuasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodsStuasBtn newAnBtnWithFont: [UIFont systemFontOfSize:11]];
        [_goodsStuasBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xFF8319)];
        [_goodsStuasBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_goodsStuasBtn newAnBtnWithBackColor: [Y_ColorWith16FromRGB(0xFF8319) colorWithAlphaComponent:0.2]];
    }
    return _goodsStuasBtn;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.numberOfLines = 3;
        _titleL.font = [UIFont boldSystemFontOfSize:14.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = [UIFont boldSystemFontOfSize:14.0];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);
    }
    return _moneyL;
}

- (UIButton *)forwardingBtn{
    if (!_forwardingBtn) {
        _forwardingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_forwardingBtn newAnBtnWithImg:[UIImage imageNamed:@"js_fenx_icon"]];
        }else{
            [_forwardingBtn newAnBtnWithImg:[UIImage imageNamed:@"js_fenxz_icon"]];
        }
    }
    return _forwardingBtn;
}

- (UILabel *)readCountL{
    if (!_readCountL) {
        _readCountL = [[UILabel alloc]init];
        _readCountL.text = @"0次浏览";
        _readCountL.font = [UIFont systemFontOfSize:14.0];
        _readCountL.textColor = [ThemeManager shareManager].detailTextColor;
    }
    return _readCountL;
}
 
@end
