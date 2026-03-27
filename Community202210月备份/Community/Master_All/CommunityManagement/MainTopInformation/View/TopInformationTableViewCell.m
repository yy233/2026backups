//
//  TopInformationTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/14.
//

#import "TopInformationTableViewCell.h"

@interface TopInformationTableViewCell ()
@property (nonatomic,strong) UIView *backGroundV;

@end
@implementation TopInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)prepareForReuse{
    [super prepareForReuse];
    _headImgv.image = nil;
}

- (void)setModel:(TopInformationModel *)model{
    _model = model;
    _titleLabel.text = model.name;
    _detailtitleLabel.text = model.unreadInformTitle;
    [self timeText];
    [self redCountLabelShow];
    [_headImgv sd_setImageWithURL:[UrlWithString getURLWithStr:_model.avatarUrl]];
}
- (void)timeText{
    
    NSString *timeStr = [ToolOfTimeChangeFormat urgentListTimeFormatWithStr:_model.unreadInformCreateTime];
    _timeLabel.text = timeStr;
 }
 
- (void)redCountLabelShow{
    if (_model.unread == 0) {
        _redCountLabel.hidden = YES;
    }else{
        _redCountLabel.hidden = NO;
    }
    _redCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.unread];
    
}
//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor  = [UIColor clearColor];
//        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor  = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgv];//42 42 21
        [self.backGroundV addSubview:self.redCountLabel];
        [self.backGroundV addSubview:self.timeLabel];
         [self.backGroundV addSubview:self.titleLabel];
         [self.backGroundV addSubview:self.detailtitleLabel];
         [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backGroundV.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    
    [_headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.mas_top).offset(10);
        make.height.offset(42);
        make.width.offset(42);
        make.left.equalTo(_backGroundV.mas_left).offset(0);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.mas_top).offset(10);
        make.height.offset(20);
        make.width.offset(80);
        make.right.equalTo(_backGroundV.mas_right).offset(-10);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgv.mas_top).offset(0);
        make.left.equalTo(_headImgv.mas_right).offset(15);//
        make.height.offset(20);
        make.right.equalTo(_timeLabel.mas_left).offset(-5);
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(0);
        make.left.equalTo(_titleLabel.mas_left).offset(0);//
        make.right.equalTo(_backGroundV.mas_right).offset(-10);
        make.bottom.equalTo(_headImgv.mas_bottom).offset(0);//
    }];
    [_redCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgv.mas_top);
        make.height.offset(12);
        make.right.equalTo(_headImgv.mas_right).offset(0);
        make.width.greaterThanOrEqualTo(_redCountLabel.mas_height);
    }];
}

#pragma mark ==
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.backgroundColor = [UIColor clearColor];
        _backGroundV.layer.cornerRadius = 10;
        _backGroundV.layer.masksToBounds = YES;
    }
    return _backGroundV;
}
- (UIImageView *)headImgv{
    if (!_headImgv) {
        _headImgv = [[UIImageView alloc]init];
//        _headImgv.layer.cornerRadius = 21;
//        _headImgv.layer.masksToBounds = YES;
        [_headImgv zy_cornerRadiusAdvance:21 rectCornerType:UIRectCornerAllCorners];
//        _headImgv.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        _headImgv.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headImgv;
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
        _timeLabel.textColor = Y_RGBA(197, 201, 212, 1);//[ThemeManager shareManager].mainTexDetailLightBluetColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont systemFontOfSize:13];
        _detailtitleLabel.textColor = Y_RGBA(197, 201, 212, 1);//[ThemeManager shareManager].mainTexDetailLightBluetColor;
        _detailtitleLabel.numberOfLines = 1;
    }
    return _detailtitleLabel;
}
- (UILabel *)redCountLabel{
    if (!_redCountLabel) {
        _redCountLabel = [[UILabel alloc]init];
        _redCountLabel.font = [UIFont systemFontOfSize:8];
        _redCountLabel.textColor = [UIColor whiteColor];
        _redCountLabel.backgroundColor = Y_RGBA(255, 0, 51, 1);
        _redCountLabel.numberOfLines = 1;
        _redCountLabel.layer.cornerRadius = 6;//12_h
        _redCountLabel.layer.masksToBounds = YES;
        _redCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redCountLabel;
}
@end
