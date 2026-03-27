//
//  WeatherCenterCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "WeatherCenterCell.h"

#import "XQQWeatherModel.h"

#import "XQQDayView.h"

@interface WeatherCenterCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIView *lineV;

/** 天气View */
@property (nonatomic, strong)  XQQDayView *dayView;

/** 数据源 */
@property (nonatomic, strong)  NSMutableArray<XQQWeatherModel*>  *dataArr;

@end

@implementation WeatherCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(44);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.height.offset(0.5);
        make.top.mas_equalTo(self.titleL.mas_bottom);
    }];
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"15日天气";
        _titleL.font = FontSize_Vip_Bold(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - 设置数据
- (void)setForecastArray:(NSArray<ZYWeatherDataForecastModel *> *)forecastArray {
    
    if (self.dayView) {
        [self.dayView removeFromSuperview];
    }
    self.dayView = [[XQQDayView alloc]initWithFrame:CGRectMake(0, 44.5, Screen_W, 404)];
    [self.contentView addSubview:self.dayView];
    
    if (self.dataArr.count > 0) {
        [self.dataArr removeAllObjects];
    }
    
    ZYWeatherDataForecastModel *tempModel = [forecastArray firstObject];
    NSInteger maxTemp = [tempModel.tempDay integerValue];
    NSInteger minTemp = [tempModel.tempNight integerValue];
    for (int i = 0; i < forecastArray.count; i++) {
        ZYWeatherDataForecastModel *tModel = forecastArray[i];
        if ([tModel.tempDay integerValue] > maxTemp) {
            maxTemp = [tModel.tempDay integerValue];
        }
        if ([tModel.tempNight integerValue] < minTemp) {
            minTemp = [tModel.tempNight integerValue];
        }
    }
    for (int i = 0; i < forecastArray.count; i++) {
        ZYWeatherDataForecastModel *forecastModel = forecastArray[i];
        XQQWeatherModel *model = [[XQQWeatherModel alloc] init];
        model.max = [NSString stringWithFormat:@"%ld", maxTemp + 2];
        model.min = [NSString stringWithFormat:@"%ld", minTemp - 2];
        model.index = i;
        model.weekStr = forecastModel.dayOfWeek;
        model.dateStr = forecastModel.updateDay;
        model.weatherStr = forecastModel.conditionDay;
        model.weatherNightStr = forecastModel.conditionNight;
        model.currentMax = forecastModel.tempDay;
        model.currentMin = forecastModel.tempNight;
        model.iconUrlDay = forecastModel.iconUrlDay;
        model.iconUrlNight = forecastModel.iconUrlNight;
        model.windDirection = forecastModel.windDirDay;
        model.windPower = forecastModel.windLevelDay;
        [self.dataArr addObject:model];
    }
    self.dayView.dataArr = self.dataArr;
    [self.dayView reloadInputViews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
