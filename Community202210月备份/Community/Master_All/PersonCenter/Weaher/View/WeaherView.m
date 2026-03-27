//
//  WeaherView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "WeaherView.h"
#import "WeatherTopCell.h"
#import "WeatherCenterCell.h"
#import "WeatherBottomCell.h"

@interface WeaherView ()<UITableViewDelegate,UITableViewDataSource,WeatherTopCellDelegate>

@property(nonatomic, strong) UITableView *tableV;

@property (nonatomic, strong) ZYWeatherDataConditionModel *conditionModel;

@property (nonatomic, strong) ZYWeatherDataCityModel *cityModel;

@property (nonatomic, strong) ZYWeatherDataAqiModel *aqiModel;

@property (nonatomic, strong) NSArray<ZYWeatherDataForecastModel *> *forecastArray;

@property (nonatomic, strong) NSArray<ZYWeatherDataHourlyModel *> *hourlyArray;

@property (nonatomic, strong) NSArray<ZYWeatherDataLiveIndexModel *> *liveIndexArray;

@end

static NSString *const topCellID = @"WeatherTopCell";
static NSString *const centerCellID = @"WeatherCenterCell";
static NSString *const bottomCellID = @"WeatherBottomCell";

@implementation WeaherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.offset(-1);
    }];
}

// 设置数据model
- (void)setDataModel:(ZYWeatherDataModel *)dataModel {
    _dataModel = dataModel;
    
    self.conditionModel = _dataModel.condition;
    self.cityModel = _dataModel.city;
    self.aqiModel = _dataModel.aqi;
    
    self.forecastArray = _dataModel.forecast;
    self.hourlyArray = _dataModel.hourly;
    self.liveIndexArray = _dataModel.liveIndex;
    
    [self.tableV reloadData];
}

#pragma mark - 懒加载
- (NSArray<ZYWeatherDataForecastModel *> *)forecastArray {
    if (!_forecastArray) {
        _forecastArray = [NSArray array];
    }
    
    return _forecastArray;
}

- (NSArray<ZYWeatherDataHourlyModel *> *)hourlyArray {
    if (!_hourlyArray) {
        _hourlyArray = [NSArray array];
    }
    
    return _hourlyArray;
}

- (NSArray<ZYWeatherDataLiveIndexModel *> *)liveIndexArray {
    if (!_liveIndexArray) {
        _liveIndexArray = [NSArray array];
    }
    
    return _liveIndexArray;
}

- (UITableView *)tableV{
    if (!_tableV ){
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableV];
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.showsVerticalScrollIndicator = NO;
        _tableV.bounces = NO;
        if (@available(ios 11.0,*)) {
            // 针对 11.0 以上的iOS系统进行处理
            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 0;
            _tableV.estimatedSectionFooterHeight = 0;
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableV registerClass:[WeatherTopCell class] forCellReuseIdentifier:topCellID];
        [_tableV registerClass:[WeatherCenterCell class] forCellReuseIdentifier:centerCellID];
        [_tableV registerClass:[WeatherBottomCell class] forCellReuseIdentifier:bottomCellID];
    }
    return _tableV;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WeatherTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.conditionModel = self.conditionModel;
        cell.cityModel = self.cityModel;
        cell.aqiModel = self.aqiModel;
        cell.hourlyArray = self.hourlyArray;
        
        return cell;
    }else if (indexPath.section == 1){
        WeatherCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.forecastArray = self.forecastArray;
        
        return cell;
    }else{
        WeatherBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.liveIndexArray = self.liveIndexArray;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 465;
    }else if (indexPath.section == 1){
        return 449;
    }else{
        return 234;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 20 + bottom_height;
    }
    
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.backgroundColor = Y_RGBA(245, 245, 245, 1);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = Y_RGBA(245, 245, 245, 1);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(cellCliced)]) {
//        [self.delegate cellCliced];
//    }
}

#pragma mark - WeatherTopCellDelegate
- (void)addressClicked{
    if ([self.delegate respondsToSelector:@selector(addressClicked)]) {
        [self.delegate addressClicked];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
