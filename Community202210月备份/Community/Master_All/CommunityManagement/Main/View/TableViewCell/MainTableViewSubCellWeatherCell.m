//
//  MainTableViewSubCellWeatherCell.m
//  Community
//
//  Created by 余莹 on 2020/11/25.
//

#import "MainTableViewSubCellWeatherCell.h"
@interface MainTableViewSubCellWeatherCell ()
@property (nonatomic,strong) UILabel *weakLabel;
@property (nonatomic,strong) UILabel *monthAndDayLabel;
@property (nonatomic,strong) UIImageView *weatherImgV;


@end
@implementation MainTableViewSubCellWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataSourceDic:(NSMutableDictionary *)dataSourceDic{
    _dataSourceDic = dataSourceDic;
    MainWeatherModel *weatherModel = [MainWeatherModel mj_objectWithKeyValues:dataSourceDic];
    [self setDataWithModel:weatherModel];
}
- (void)setDataWithModel:(MainWeatherModel *)model{
    _weakLabel.text = [TextShowWithModelStr textShowWithModelStr:model.dayOfWeek];
    _monthAndDayLabel.text = [TextShowWithModelStr textShowWithModelStr:model.updateDay];
    [self setImgWithConditionId:model.conditionIdDay];
}
- (void)setImgWithConditionId:(NSInteger)conditionId{
    switch (conditionId) {
        case 0:
            _weatherImgV.image = [UIImage imageNamed:@"Convenientservice_Weather_Rain_night"];
            break;
            //图片待约定
        default:
            _weatherImgV.image = [UIImage imageNamed:@"Convenientservice_Weather_Rain_night"];
            break;
    }
 
 }
#pragma mark ===
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.weakLabel];
        [self.contentView addSubview:self.weatherImgV];
        [self.contentView addSubview:self.monthAndDayLabel];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = [UIColor clearColor];
    _weakLabel.text = @"周";
    _monthAndDayLabel.text = @"月";
//    _weatherImgV.backgroundColor = [UIColor grayColor];
    
    [_weakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakLabel.superview.mas_top).offset(5);
        make.left.equalTo(_weakLabel.superview.mas_left).offset(5);
        make.right.equalTo(_weakLabel.superview.mas_right).offset(-5);
        make.height.offset(15);
    }];
    [_monthAndDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weakLabel.mas_left);
        make.right.equalTo(_weakLabel.mas_right);
        make.bottom.equalTo(_monthAndDayLabel.superview.mas_bottom).offset(-5);
        make.height.offset(15);
    }];
    [_weatherImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weatherImgV.superview.mas_left).offset(5);
        make.right.equalTo(_weatherImgV.superview.mas_right).offset(-5);
        make.top.equalTo(_weakLabel.mas_bottom);
        make.bottom.equalTo(_monthAndDayLabel.mas_top);
    }];
}
#pragma mark ==
- (UILabel *)weakLabel{
    if (!_weakLabel) {
        _weakLabel = [[UILabel alloc]init];
        _weakLabel.textColor = [UIColor whiteColor];
        _weakLabel.numberOfLines = 1;
        _weakLabel.font = [UIFont systemFontOfSize:13];
        _weakLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weakLabel;
}
- (UILabel *)monthAndDayLabel{
    if (!_monthAndDayLabel) {
        _monthAndDayLabel = [[UILabel alloc]init];
        _monthAndDayLabel.textColor = [UIColor whiteColor];
        _monthAndDayLabel.numberOfLines = 1;
        _monthAndDayLabel.font = [UIFont systemFontOfSize:13];
        _monthAndDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthAndDayLabel;
}
- (UIImageView *)weatherImgV{
    if (!_weatherImgV) {
        _weatherImgV = [[UIImageView alloc]init];
        _weatherImgV.contentMode = UIViewContentModeCenter;
    }
    return _weatherImgV;
}
@end
