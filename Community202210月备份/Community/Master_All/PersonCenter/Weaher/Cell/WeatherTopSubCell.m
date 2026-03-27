//
//  WeatherTopSubCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/25.
//

#import "WeatherTopSubCell.h"

@interface WeatherTopSubCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *subL;

@end

@implementation WeatherTopSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.offset(45);
        make.height.offset(45);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageV.mas_top).offset(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self);
    }];
    
}

// 设置数据model
- (void)setHourlyModel:(ZYWeatherDataHourlyModel *)hourlyModel {
    _hourlyModel = hourlyModel;
    
    self.titleL.text = [NSString stringWithFormat:@"%@:00", _hourlyModel.hour];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_hourlyModel.iconUrl] placeholderImage:[UIImage imageNamed:@"Weather_Now"]];
    self.subL.text = [NSString stringWithFormat:@"%@°", _hourlyModel.temp];
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"17:00";
        _titleL.font = FontSize_Vip_Nomail(14);
        _titleL.textColor = [Tool getColorWithHexString:@"#666666"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"12°";
        _subL.font = FontSize_Vip_Nomail(14);
        _subL.textColor = [Tool getColorWithHexString:@"#000000"];
        _subL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subL];
    }
    return _subL;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"Weather_Now"];
        [self addSubview:_imageV];
    }
    return _imageV;
}

@end
