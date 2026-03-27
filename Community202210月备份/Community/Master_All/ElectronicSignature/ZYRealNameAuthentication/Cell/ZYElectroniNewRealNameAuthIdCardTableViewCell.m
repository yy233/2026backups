//
//  ElectroniNewRealNameAuthIdCardTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ZYElectroniNewRealNameAuthIdCardTableViewCell.h"

@interface ZYElectroniNewRealNameAuthIdCardTableViewCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIImageView *rightImg;
@end

@implementation ZYElectroniNewRealNameAuthIdCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextAndImgWithZhengMianWithImg:(UIImage*)faceImg{
    self.titleL.text = @"头像面";
    self.detailL.text = @"身份证正面";
    if (isNotNil(faceImg)) {
        self.rightImg.image = faceImg;
    }else{
        self.rightImg.image = [UIImage imageNamed:@"zmd"];
    }

}
- (void)setTextAndImgWithFanMianWithImg:(UIImage*)backImg{
    self.titleL.text = @"国徽面";
    self.detailL.text = @"身份证反面";
    if (isNotNil(backImg)) {
        self.rightImg.image = backImg;
    }else{
        self.rightImg.image = [UIImage imageNamed:@"fmd"];
    }

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self.contentView addSubview:self.rightImg];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImg.superview.mas_top).offset(10);
        make.bottom.equalTo(_rightImg.superview.mas_bottom).offset(-10);
        make.right.equalTo(_rightImg.superview.mas_right).offset(-50);
        make.width.offset(135);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview.mas_left).offset(10);
        make.right.equalTo(_rightImg.mas_left).offset(-10);
        make.height.offset(20);
        make.bottom.equalTo(_rightImg.mas_centerY).offset(-2);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailL.superview.mas_left).offset(10);
        make.right.equalTo(_rightImg.mas_left).offset(-10);
        make.height.offset(20);
        make.top.equalTo(_rightImg.mas_centerY).offset(2);
    }];
}
- (UIImageView *)rightImg{
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]init];
        _rightImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImg;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = FontSize_ElectronicSignature_Bold(18);
         
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.textColor =  Y_RGBA(136, 136, 136, 1);
        _detailL.font = FontSize_ElectronicSignature_Nomail(12);
    }
 
    return _detailL;
}
@end
