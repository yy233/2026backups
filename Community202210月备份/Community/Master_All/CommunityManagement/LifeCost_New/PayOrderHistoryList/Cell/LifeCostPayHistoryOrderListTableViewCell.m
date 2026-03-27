//
//  LifeCostPayHistoryOrderListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayHistoryOrderListTableViewCell.h"

@interface LifeCostPayHistoryOrderListTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UILabel *timeL;
@end

@implementation LifeCostPayHistoryOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithModel:(LifeCostPayHistoryOrderSubOrderEntityModel *)model{
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.typePicUrl] placeholderImage:[UIImage imageNamed:kLifeCost_Placeholder_ImgName]];
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.typeName];
    self.detailL.text = [NSString stringWithFormat:@"%@ | %@",[TextShowWithModelStr textShowWithModelStr:model.account], [TextShowWithModelStr textShowWithModelStr:model.householder] ];
    self.timeL.text = [TextShowWithModelStr textShowWithModelStr:model.updateTime];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
        [self.backView addSubview:self.timeL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_imgV.superview);
        make.left.equalTo(_imgV.superview.mas_left).offset(15);
        make.width.offset(25);
     }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_imgV.superview);
        make.right.equalTo(_imgV.superview.mas_right).offset(-26);
        make.width.lessThanOrEqualTo(_moneyL.superview).multipliedBy(0.5);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.right.equalTo(_moneyL.mas_left).offset(-5);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(2);
        make.left.right.equalTo(_titleL);
        make.height.lessThanOrEqualTo(_titleL);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailL.mas_bottom).offset(1);
        make.left.right.equalTo(_titleL);
        make.height.lessThanOrEqualTo(_titleL);
        make.bottom.equalTo(_timeL.superview);
    }];
}
#pragma mark ===
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.font = [UIFont systemFontOfSize:12.0];
    }
    return _detailL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _timeL.font = [UIFont systemFontOfSize:11.0];
    }
    return _timeL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL =[[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:17.0];
        _moneyL.textAlignment = NSTextAlignmentRight;
    }
    return _moneyL;
}

@end


@implementation LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.backView addSubview:self.monthTitleL];
        [self setMonthCellUI];
    }
    return self;
}
- (void)setMonthCellUI{
    [_monthTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_monthTitleL.superview).offset(15);
        make.width.equalTo(_monthTitleL.superview).multipliedBy(0.5);
        make.top.bottom.equalTo(_monthTitleL.superview);
    }];
}
- (UILabel *)monthTitleL{
    if (!_monthTitleL) {
        _monthTitleL = [[UILabel alloc]init];
        _monthTitleL.font = [UIFont boldSystemFontOfSize:15.0];
        _monthTitleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _monthTitleL;
}
@end
