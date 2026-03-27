//
//  HouseRentDetailHouseTextCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailHouseTextCell.h"

@interface HouseRentDetailHouseTextCell ()
@property (nonatomic,strong)  UILabel *oneLabel;
@property (nonatomic,strong)  UILabel *twoLabel;
@property (nonatomic,strong)  UILabel *thrLabel;
@property (nonatomic,strong)  UILabel *fourLabel;
//
@property (nonatomic,strong)  UILabel *oneBottomLabel;
@property (nonatomic,strong)  UILabel *twoBottomLabel;
@property (nonatomic,strong)  UILabel *thrBottomLabel;
@property (nonatomic,strong)  UILabel *fourBottomLabel;
@end

@implementation HouseRentDetailHouseTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _model = model;
    _oneLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseType];
    _twoLabel.text = [NSString stringWithFormat:@"%0.2f ㎡",model.houseSquareMeter];
    _thrLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseFloor];
    _fourLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseDirection];
}
#pragma mark == 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.oneLabel];
        [self.contentView addSubview:self.twoLabel];
        [self.contentView addSubview:self.thrLabel];
        [self.contentView addSubview:self.fourLabel];
        [self.contentView addSubview:self.oneBottomLabel];
        [self.contentView addSubview:self.twoBottomLabel];
        [self.contentView addSubview:self.thrBottomLabel];
        [self.contentView addSubview:self.fourBottomLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneLabel.superview.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(Screen_W/4);
        make.left.equalTo(_oneLabel.superview.mas_left);
    }];
    [_twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoLabel.superview.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(Screen_W/4);
        make.left.equalTo(_oneLabel.mas_right);
    }];
    
    [_thrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrLabel.superview.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(Screen_W/4);
        make.left.equalTo(_twoLabel.mas_right);
    }];
    [_fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrLabel.superview.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(Screen_W/4);
        make.left.equalTo(_thrLabel.mas_right);
    }];
    //
    [_twoBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_twoLabel.mas_centerX);
        make.width.equalTo(_twoLabel.mas_width);
        make.top.equalTo(_twoLabel.mas_bottom);
    }];
    [_oneBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_oneLabel.mas_centerX);
        make.width.equalTo(_oneLabel.mas_width);
        make.top.equalTo(_oneLabel.mas_bottom);
    }];
    [_thrBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_thrLabel.mas_centerX);
        make.width.equalTo(_thrLabel.mas_width);
        make.top.equalTo(_thrLabel.mas_bottom);
    }];
    [_fourBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerX.equalTo(_fourLabel.mas_centerX);
        make.width.equalTo(_thrLabel.mas_width);
        make.top.equalTo(_thrLabel.mas_bottom);
    }];
    
}
- (UILabel *)oneLabel{
    if (!_oneLabel) {
        _oneLabel = [[UILabel alloc]init];
        _oneLabel.textAlignment = NSTextAlignmentCenter;
        _oneLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _oneLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _oneLabel;
}
- (UILabel *)twoLabel{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc]init];
        _twoLabel.textAlignment = NSTextAlignmentCenter;
        _twoLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _twoLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _twoLabel;
}
- (UILabel *)thrLabel{
    if (!_thrLabel) {
        _thrLabel  = [[UILabel alloc]init];
        _thrLabel.textAlignment = NSTextAlignmentCenter;
        _thrLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _thrLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _thrLabel;
}
- (UILabel *)fourLabel{
    if (!_fourLabel) {
        _fourLabel  = [[UILabel alloc]init];
        _fourLabel.textAlignment = NSTextAlignmentCenter;
        _fourLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _fourLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _fourLabel;
}
//
- (UILabel *)oneBottomLabel{
    if (!_oneBottomLabel) {
        _oneBottomLabel = [[UILabel alloc]init];
        _oneBottomLabel.text = @"房型";
        _oneBottomLabel.textAlignment = NSTextAlignmentCenter;
        _oneBottomLabel.font = [UIFont systemFontOfSize:12];
        _oneBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _oneBottomLabel;
}
- (UILabel *)twoBottomLabel{
    if (!_twoBottomLabel) {
        _twoBottomLabel = [[UILabel alloc]init];
        _twoBottomLabel.text = @"面积";
        _twoBottomLabel.textAlignment = NSTextAlignmentCenter;
        _twoBottomLabel.font = [UIFont systemFontOfSize:12];
        _twoBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _twoBottomLabel;
}
- (UILabel *)thrBottomLabel{
    if (!_thrBottomLabel) {
        _thrBottomLabel = [[UILabel alloc]init];
        _thrBottomLabel.text = @"楼层";
        _thrBottomLabel.textAlignment = NSTextAlignmentCenter;
        _thrBottomLabel.font = [UIFont systemFontOfSize:12];
        _thrBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _thrBottomLabel;
}
- (UILabel *)fourBottomLabel{
    if (!_fourBottomLabel) {
        _fourBottomLabel = [[UILabel alloc]init];
        _fourBottomLabel.text = @"朝向";
        _fourBottomLabel.textAlignment = NSTextAlignmentCenter;
        _fourBottomLabel.font = [UIFont systemFontOfSize:12];
        _fourBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _fourBottomLabel;
}
@end
