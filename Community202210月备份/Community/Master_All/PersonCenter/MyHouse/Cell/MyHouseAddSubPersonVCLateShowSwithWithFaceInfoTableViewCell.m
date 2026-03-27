//
//  MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell.h"

@implementation MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell

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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.faceImgV];
        [self.contentView addSubview:self.imgTopBtn];
        [self.contentView addSubview:self.onceAgainBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.height.offset(20);
        make.centerY.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(32);
    }];
    
    [_faceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_faceImgV.superview);
        make.width.height.offset(76);
        make.left.equalTo(_titleL.mas_right).offset(5);
    }];
    [_imgTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_faceImgV);
    }];
    [_onceAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(30);
        make.bottom.equalTo(_faceImgV.mas_bottom);
        make.left.equalTo(_faceImgV.mas_right).offset(15);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"人脸照片";//是否开启手机号
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleL;
}
- (UIImageView *)faceImgV{
    if (!_faceImgV) {
        _faceImgV = [[UIImageView alloc]init];
        _faceImgV.image = [UIImage imageNamed:@"sczp_icon"];//占位图
        _faceImgV.contentMode = UIViewContentModeScaleAspectFill;
        _faceImgV.layer.cornerRadius = 5.0;
        _faceImgV.clipsToBounds = YES;
        
    }
    return _faceImgV;
}
- (UIButton *)imgTopBtn{
    if (!_imgTopBtn) {
        _imgTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgTopBtn addTarget:self action:@selector(imgTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgTopBtn;
}
- (UIButton *)onceAgainBtn{
    if (!_onceAgainBtn) {
        _onceAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onceAgainBtn newAnBtnWithTextStr:@"重传"];
        [_onceAgainBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_onceAgainBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0x2672F9)];
        [_onceAgainBtn addTarget:self action:@selector(onceAgainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onceAgainBtn;
}

#pragma mark ===
- (void)imgTopBtnAction{
    if (isNil(self.touchChooseImgBlcok)) {
        return;
    }
    self.touchChooseImgBlcok();
}

- (void)onceAgainBtnAction{
    if (isNil(self.touchChooseOnceAgainBtnBlock)) {
        return;
    }
    self.touchChooseOnceAgainBtnBlock();
}

@end
