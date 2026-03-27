//
//  MoreMenuTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/11.
//

#import "MoreUrgentTableViewCell.h"
@interface MoreUrgentTableViewCell ()
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *detailtitleLabel;
@end
@implementation MoreUrgentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(TableViewTopAndCenterBannerCellModel *)model{
    _model = model;
    _titleLabel.text = model.pushTitle;
    _detailtitleLabel.text = model.pushSubTitle;//model.content;
    [self timeText];
}
- (void)timeText{
    NSString *timeStr = [ToolOfTimeChangeFormat urgentListTimeFormatWithStr:_model.createTime];
    _timeLabel.text = timeStr;
}


//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.timeLabel];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    //cell70 self80
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backGroundV.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(80);
        make.right.equalTo(_backGroundV.mas_right).offset(-10);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.mas_top).offset(10);
        make.left.equalTo(_backGroundV.mas_left).offset(10);
        make.height.offset(20);
        make.right.equalTo(_timeLabel.mas_left).offset(-5);
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(_backGroundV.mas_bottom).offset(-10);
        make.left.equalTo(_backGroundV.mas_left).offset(10);
        make.right.equalTo(_backGroundV.mas_right).offset(-10);
    }];
}

#pragma mark ==
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
//        _backGroundV.backgroundColor = [ThemeManager shareManager].mainContentBackgroundColor;
        _backGroundV.layer.cornerRadius = 10;
        _backGroundV.layer.masksToBounds = YES;
    }
    _backGroundV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    return _backGroundV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
//        _timeLabel.textColor = Y_RGBA(197, 201, 212, 1);//[ThemeManager shareManager].mainTexDetailLightBluetColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    _timeLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
    return _timeLabel;
}
- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont systemFontOfSize:13];
//        _detailtitleLabel.textColor = Y_RGBA(197, 201, 212, 1);//[ThemeManager shareManager].mainTexDetailLightBluetColor;
        _detailtitleLabel.numberOfLines = 2;
    }
    _detailtitleLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;

    return _detailtitleLabel;
}

@end
