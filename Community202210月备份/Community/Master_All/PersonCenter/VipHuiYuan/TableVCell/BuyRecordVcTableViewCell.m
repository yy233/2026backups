//
//  BuyRecordVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "BuyRecordVcTableViewCell.h"

@implementation BuyRecordVcTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 7.5;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
        [self.backView addSubview:self.rightL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(10);
        make.right.equalTo(_titleL.superview).offset(-70);
        make.bottom.equalTo(_titleL.superview.mas_centerY).offset(-2);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.right.left.height.equalTo(_titleL);
    }];
    [_rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightL.superview.mas_centerY);
        make.right.equalTo(_rightL.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_Vip_Bold(17);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = FontSize_Vip_Nomail(12);
        _detailL.textColor = Y_RGBA(153, 153, 153, 1);
    }
    return _detailL;
}
- (UILabel *)rightL{
    if (!_rightL) {
        _rightL = [[UILabel alloc]init];
        _rightL.font = FontSize_Vip_Bold(17);
        _rightL.textColor = COlor_Red255;
        _rightL.textAlignment = NSTextAlignmentRight;
    }
    return _rightL;
}
@end
