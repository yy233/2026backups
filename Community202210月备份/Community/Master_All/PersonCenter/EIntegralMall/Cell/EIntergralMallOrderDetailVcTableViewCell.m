//
//  EIntergralMallOrderDetailVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "EIntergralMallOrderDetailVcTableViewCell.h"

@implementation EIntergralMallOrderDetailVcTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.topRightL];
        [self.backView addSubview:self.centerENumL];
        [self setDetailCellUI];
    }
    return self;
}
- (void)setDetailCellUI{
    self.outLineL.text = @"实付总额";
    self.outLineL.textColor = [UIColor blackColor];
    [self.orderNumL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderNumL.superview.mas_right).offset(-100);
    }];
    [self.goodsNumL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgV.mas_right).offset(100);
    }];
    self.goodsNumL.textAlignment = NSTextAlignmentRight;
    self.rightImgV.hidden = YES;
    //
    [_topRightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.orderNumL);
        make.right.equalTo(_topRightL.superview.mas_right).offset(-10);
    }];
    [_centerENumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodsNumL.mas_centerY);
        make.left.equalTo(self.imgV.mas_right).offset(10);
        make.height.equalTo(self.goodsNumL.mas_height);
    }];
}
#pragma mark ==
- (UILabel *)topRightL{
    if (!_topRightL) {
        _topRightL = [[UILabel alloc]init];
        _topRightL.textColor = Y_ColorWith16FromRGB(0xFF7B05);
        _topRightL.font = FontSize_MoneyWallet_Nomail(12);
        _topRightL.textAlignment = NSTextAlignmentRight;
    }
    return _topRightL;
}
- (UILabel *)centerENumL{
    if (!_centerENumL) {
        _centerENumL = [[UILabel alloc]init];
        _centerENumL.textColor = [UIColor blackColor];
        _centerENumL.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _centerENumL;
}
@end
