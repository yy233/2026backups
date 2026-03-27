//
//  IssueBaseThreeGroupTextInfoShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "IssueBaseThreeGroupTextInfoShowTableViewCell.h"
#define Color_TopText            ([ThemeManager shareManager].type == ThemeType_White ? Y_RGBA(153, 153, 153, 1) : Y_RGBA(172, 172, 172, 1))
#define Width_Label              (Screen_W/3)
@interface IssueBaseThreeGroupTextInfoShowTableViewCell ()

@property (nonatomic,strong) UIView *centerRightLineView;
@property (nonatomic,strong) UIView *centerLeftLineView;
@end

@implementation IssueBaseThreeGroupTextInfoShowTableViewCell

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
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.oneTopLabel];
        [self.backV addSubview:self.twoTopLabel];
        [self.backV addSubview:self.thrTopLabel];
        [self.backV addSubview:self.oneBottomLabel];
        [self.backV addSubview:self.twoBottomLabel];
        [self.backV addSubview:self.thrBottomLabel];
        [self.backV addSubview:self.centerLeftLineView];
        [self.backV addSubview:self.centerRightLineView];
        [self setUI];
        [self setUIOfNewTitles];//用于子类重写
    }
    return self;
}
- (void)setUIOfNewTitles{
    
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview);
    }];
    //
    [_oneTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneTopLabel.superview.mas_top);
        make.left.equalTo(_oneTopLabel.superview.mas_left);
        make.height.equalTo(_oneTopLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    [_twoTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoTopLabel.superview.mas_top);
        make.left.equalTo(_oneTopLabel.mas_right);
        make.height.equalTo(_twoTopLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    [_thrTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrTopLabel.superview.mas_top);
        make.left.equalTo(_twoTopLabel.mas_right);
        make.height.equalTo(_twoTopLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    //
    [_oneBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneTopLabel.mas_bottom);
        make.left.equalTo(_oneTopLabel.mas_left);
        make.height.equalTo(_oneBottomLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    [_twoBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoTopLabel.mas_bottom);
        make.left.equalTo(_twoTopLabel.mas_left);
        make.height.equalTo(_twoBottomLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    [_thrBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrTopLabel.mas_bottom);
        make.left.equalTo(_thrTopLabel.mas_left);
        make.height.equalTo(_thrBottomLabel.superview.mas_height).multipliedBy(0.5);
        make.width.offset(Width_Label);
    }];
    //
    [_centerLeftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerLeftLineView.superview.mas_centerY);
        make.width.offset(1);
        make.height.equalTo(_centerLeftLineView.superview.mas_height).multipliedBy(0.5);
        make.left.equalTo(_oneTopLabel.mas_right);
    }];
    [_centerRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerRightLineView.superview.mas_centerY);
        make.width.offset(1);
        make.height.equalTo(_centerRightLineView.superview.mas_height).multipliedBy(0.5);
        make.left.equalTo(_twoTopLabel.mas_right);
    }];
    
}
#pragma mark ==
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
    }
    return _backV;
}
//
- (UILabel *)oneTopLabel{
    if (!_oneTopLabel) {
        _oneTopLabel = [[UILabel alloc]init];
        _oneTopLabel.font = [UIFont systemFontOfSize:12];
        _oneTopLabel.textColor = Color_TopText;
        _oneTopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _oneTopLabel;
}
- (UILabel *)twoTopLabel{
    if (!_twoTopLabel) {
        _twoTopLabel = [[UILabel alloc]init];
        _twoTopLabel.font = [UIFont systemFontOfSize:12];
        _twoTopLabel.textColor = Color_TopText;
        _twoTopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _twoTopLabel;
}
- (UILabel *)thrTopLabel{
    if (!_thrTopLabel) {
        _thrTopLabel = [[UILabel alloc]init];
        _thrTopLabel.font = [UIFont systemFontOfSize:12];
        _thrTopLabel.textColor = Color_TopText;
        _thrTopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thrTopLabel;
}
//
- (UILabel *)oneBottomLabel{
    if (!_oneBottomLabel) {
        _oneBottomLabel = [[UILabel alloc]init];
        _oneBottomLabel.font = [UIFont boldSystemFontOfSize:18];
        _oneBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _oneBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _oneBottomLabel;
}
-(UILabel *)twoBottomLabel{
    if (!_twoBottomLabel) {
        _twoBottomLabel = [[UILabel alloc]init];
        _twoBottomLabel.font = [UIFont boldSystemFontOfSize:18];
        _twoBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _twoBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _twoBottomLabel;
}
- (UILabel *)thrBottomLabel{
    if (!_thrBottomLabel) {
        _thrBottomLabel = [[UILabel alloc]init];
        _thrBottomLabel.font = [UIFont boldSystemFontOfSize:18];
        _thrBottomLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _thrBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thrBottomLabel;
}
//
- (UIView *)centerRightLineView{
    if (!_centerRightLineView) {
        _centerRightLineView = [[UIView alloc]init];
        _centerRightLineView.backgroundColor = [Color_TopText colorWithAlphaComponent:0.3];
    }
    return _centerRightLineView;
}
- (UIView *)centerLeftLineView{
    if (!_centerLeftLineView) {
        _centerLeftLineView = [[UIView alloc]init];
        _centerLeftLineView.backgroundColor = [Color_TopText colorWithAlphaComponent:0.3];
    }
    return _centerLeftLineView;
}

@end
