//
//  CommunityFunMoreVCTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/22.
//

#import "CommunityFunMoreVCTableViewCell.h"
@interface CommunityFunMoreVCTableViewCell ()
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIImageView*imgv;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *rightTipBtn;
@end

@implementation CommunityFunMoreVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CommunityFunModel *)model{
    _model = model;
    _titleLabel.text = model.titleName;
    NSString *timeStr = [ToolOfTimeChangeFormat funNewsListTimeFormatWithStr:_model.createTime];
    _timeLabel.text = timeStr;
    [_imgv sd_setImageWithURL:[UrlWithString getURLWithStr:model.coverImageUrl]];
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.rightTipBtn];
        [self.backGroundV addSubview:self.timeLabel];
        [self.backGroundV addSubview:self.imgv];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backGroundV.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.mas_top).offset(15);
        make.left.equalTo(_backGroundV.mas_left).offset(10);
        make.right.equalTo(_backGroundV.mas_right).offset(-20);
        make.height.offset(20);
    }];
    [_rightTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(5);
        make.right.equalTo(_backGroundV.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.height.offset(20);
        make.width.offset(80);
        make.left.equalTo(_titleLabel.mas_left).offset(0);
    }];
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
        make.bottom.equalTo(_backGroundV.mas_bottom).offset(-15);
        make.left.equalTo(_timeLabel.mas_left);
        make.right.equalTo(_rightTipBtn.mas_right);
    }];
}

#pragma mark ==
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.backgroundColor = [ThemeManager shareManager].mainContentBackgroundColor;
        _backGroundV.layer.cornerRadius = 10;
        _backGroundV.layer.masksToBounds = YES;
    }
    return _backGroundV;
}
- (UIImageView *)imgv{
    if (!_imgv) {
        _imgv = [[UIImageView alloc]init];
//        _imgv.layer.cornerRadius = 3;
//        _imgv.layer.masksToBounds = YES;
        [_imgv zy_cornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];
        _imgv.contentMode = UIViewContentModeScaleAspectFill;
//        _imgv.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    }
    return _imgv;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIButton *)rightTipBtn{
    if (!_rightTipBtn) {
        _rightTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            [_rightTipBtn setImage:[UIImage imageNamed:@"rightSkip"] forState:UIControlStateNormal];
        }else{
            [_rightTipBtn setImage:[UIImage imageNamed:@"rightSkip_white"] forState:UIControlStateNormal];
        }
    }
    return _rightTipBtn;
}
 
@end
