//
//  WeatherBottomSubCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/25.
//

#import "WeatherBottomSubCell.h"

@interface WeatherBottomSubCell ()
@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *subL;


@end

@implementation WeatherBottomSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

// 设置数据model
- (void)setLiveIndexModel:(ZYWeatherDataLiveIndexModel *)liveIndexModel {
    _liveIndexModel = liveIndexModel;
    
    self.titleL.text = _liveIndexModel.status;
    self.subL.text = _liveIndexModel.name;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_liveIndexModel.iconUrl] placeholderImage:[UIImage imageNamed:@"Weather_calendar"]];
}

- (void)initView{
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.offset(14);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.imageV.mas_bottom);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titleL.mas_bottom);
    }];
}

#pragma mark - 懒加载

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        [self addSubview:_imageV];
    }
    return _imageV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"十二月廿三";
        _titleL.font = FontSize_Vip_Nomail(14);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"万年历";
        _subL.font = FontSize_Vip_Nomail(12);
        _subL.textColor = [Tool getColorWithHexString:@"#999999"];
        _subL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subL];
    }
    return _subL;
}

@end
