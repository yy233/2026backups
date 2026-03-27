//
//  EIntergralMallMingXiListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import "EIntergralMallMingXiListVcTableViewCell.h"
#define Color_Orange_Text      Y_ColorWith16FromRGB(0xFF6600)
#define Color_Green_Text       Y_ColorWith16FromRGB(0x38C218)
@implementation EIntergralMallMingXiListVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillCellWithTypeIsZhiChu:(BOOL)isZhiChu
                   withTittleStr:(NSString*)titleStr
                     withTimeStr:(NSString*)timeStr
                      withNumStr:(NSString*)numStr{
    if (isZhiChu) {
        self.numL.textColor = Color_Green_Text;//支出
    }else{
        self.numL.textColor = Color_Orange_Text;//收入
    }
    self.titleL.text = titleStr;
    self.timeL.text = timeStr;
    self.numL.text = numStr;
}
 
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.numL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview.mas_left).offset(10);
        make.right.equalTo(_titleL.superview.mas_right).offset(100);
        make.top.equalTo(_titleL.superview.mas_top);
        make.height.offset(20);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_titleL);
        make.bottom.equalTo(_timeL.superview.mas_bottom);
    }];
    [_numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_numL.superview);
        make.right.equalTo(_numL.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
}
    
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_MoneyWallet_Nomail(16);
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font = FontSize_MoneyWallet_Nomail(12);
        _timeL.textColor = Color_153GrayColor;
    }
    return _timeL;
}
- (UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]init];
        _numL.font = FontSize_MoneyWallet_Nomail(16);
        _numL.textAlignment = NSTextAlignmentRight;
    }
    return _numL;
}
@end
