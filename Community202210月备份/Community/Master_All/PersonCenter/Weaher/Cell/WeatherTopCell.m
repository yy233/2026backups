//
//  WeatherTopCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "WeatherTopCell.h"
#import "WeatherTopSubCell.h"

@interface WeatherTopCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UIView *bgView;
//例如：渝北区 青松路
@property(nonatomic, strong) UILabel *addressL;

@property(nonatomic, strong) UIImageView *addressImageV;

@property(nonatomic, strong) UIImageView *addressSubImageV;
//例如：12°
@property(nonatomic, strong) UILabel *temperatureL;

//例如：°
@property(nonatomic, strong) UILabel *temperatureSubL;

@property(nonatomic, strong) UIView *airV;
//例如：阴
@property(nonatomic, strong) UILabel *airL;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIImageView *airImageV;
//例如：91 良
@property(nonatomic, strong) UILabel *airSubL;
//例如：今天6~13°  阴转小雨
@property(nonatomic, strong) UILabel *weatherL;
//例如：空气不太好，在室内休息休息吧
@property(nonatomic, strong) UILabel *remarkL;

@property(nonatomic, strong) UICollectionView *collectionV;

@property(nonatomic, strong) UIView *bottomV;

@property(nonatomic, strong) UIButton *addressBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *const cellID = @"WeatherTopSubCell";
@implementation WeatherTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

// 设置数据model
- (void)setConditionModel:(ZYWeatherDataConditionModel *)conditionModel {
    _conditionModel = conditionModel;
    
    self.temperatureL.text = _conditionModel.temp;
    self.airL.text = _conditionModel.condition;
    self.remarkL.text = _conditionModel.tips;
}

- (void)setCityModel:(ZYWeatherDataCityModel *)cityModel {
    _cityModel = cityModel;
    
    self.addressL.text = [NSString stringWithFormat:@"%@", _cityModel.secondaryname];
}

- (void)setAqiModel:(ZYWeatherDataAqiModel *)aqiModel {
    _aqiModel = aqiModel;
    
    self.airSubL.text = [NSString stringWithFormat:@"%@ %@", _aqiModel.value, _aqiModel.aqiName];
}

- (void)setHourlyArray:(NSArray<ZYWeatherDataHourlyModel *> *)hourlyArray {
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:hourlyArray];
    [self.collectionV reloadData];
}

- (void)initView{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.offset(367);
    }];
    
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(7);
    }];
    
    [self.addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.addressL);
        make.right.mas_equalTo(self.addressL.mas_left).offset(-5);
        make.width.offset(10);
        make.height.offset(13);
    }];
    
    [self.addressSubImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.addressL);
        make.left.mas_equalTo(self.addressL.mas_right).offset(5);
        make.width.offset(10);
        make.height.offset(5.5);
    }];
    
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressImageV);
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.addressL);
        make.height.mas_equalTo(self.addressL);
    }];
    
    [self.temperatureL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.addressL.mas_bottom).offset(20);
    }];
    
    [self.temperatureSubL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temperatureL).offset(10);
        make.left.mas_equalTo(self.temperatureL.mas_right).offset(0);
    }];
    
    [self.airV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.temperatureL.mas_bottom).offset(0);
        make.width.offset(140);
        make.height.offset(30);
    }];
    
    [self.airImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.airV);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.airImageV);
        make.width.offset(0.5);
        make.height.offset(15);
        make.right.mas_equalTo(self.airImageV.mas_left).offset(-10);
    }];
    
    [self.airL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.airImageV);
        make.right.mas_equalTo(self.lineV.mas_left).offset(-3);
        make.left.equalTo(self.airV).offset(3);
    }];
    
    [self.airSubL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.airImageV);
        make.left.mas_equalTo(self.airImageV.mas_right).offset(0);
        make.right.offset(0);
    }];
    
    [self.weatherL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.airV.mas_bottom).offset(15);
    }];
    
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.width.offset(self.contentView.frame.size.width - 32);
        make.top.mas_equalTo(self.weatherL.mas_bottom).offset(15);
    }];
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.offset(110);
    }];
    
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomV);
    }];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:CGSizeMake(Screen_W, 367) direction:IHGradientChangeDirectionVertical startColor:[Tool getColorWithHexString:@"#617690"] endColor:[Tool getColorWithHexString:@"#C0C9D3"]];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.text = @"渝北区 青松路";
        _addressL.font = FontSize_Vip_Nomail(16);
        _addressL.textColor = [Tool getColorWithHexString:@"#FFFFFF"];
        _addressL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_addressL];
    }
    return _addressL;
}

- (UIImageView *)addressImageV{
    if (!_addressImageV) {
        _addressImageV = [[UIImageView alloc] init];
        _addressImageV.image = [UIImage imageNamed:@"Weather_address"];
        [self.contentView addSubview:_addressImageV];
    }
    return _addressImageV;
}

- (UIImageView *)addressSubImageV{
    if (!_addressSubImageV) {
        _addressSubImageV = [[UIImageView alloc] init];
        _addressSubImageV.image = [UIImage imageNamed:@"Weather_switch"];
        [self.contentView addSubview:_addressSubImageV];
    }
    return _addressSubImageV;
}

- (UILabel *)temperatureL{
    if (!_temperatureL) {
        _temperatureL = [[UILabel alloc] init];
        _temperatureL.text = @"12";
        _temperatureL.font = [UIFont fontWithName:@"PingFangSC-Light"size:120];
        _temperatureL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _temperatureL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_temperatureL];
    }
    return _temperatureL;
}

- (UILabel *)temperatureSubL{
    if (!_temperatureSubL) {
        _temperatureSubL = [[UILabel alloc] init];
        _temperatureSubL.text = @"°";
        _temperatureSubL.font = [UIFont fontWithName:@"PingFangSC-Light"size:60];
        _temperatureSubL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _temperatureSubL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_temperatureSubL];
    }
    return _temperatureSubL;
}

- (UIView *)airV{
    if (!_airV) {
        _airV = [[UIView alloc] init];
        _airV.backgroundColor = [Tool getColorWithHexString:@"#F2C425"];
        _airV.layer.cornerRadius = 15;
        _airV.clipsToBounds = YES;
        [self.contentView addSubview:_airV];
    }
    return _airV;
}

- (UILabel *)airL{
    if (!_airL) {
        _airL = [[UILabel alloc] init];
        _airL.text = @"阴";
        _airL.font = FontSize_Vip_Nomail(16);
        _airL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _airL.textAlignment = NSTextAlignmentCenter;
        [self.airV addSubview:_airL];
    }
    return _airL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#FFFFFF"];
        [self.airV addSubview:_lineV];
    }
    return _lineV;
}

- (UILabel *)airSubL{
    if (!_airSubL) {
        _airSubL = [[UILabel alloc] init];
        _airSubL.text = @"91 良";
        _airSubL.font = FontSize_Vip_Nomail(16);
        _airSubL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _airSubL.textAlignment = NSTextAlignmentCenter;
        [self.airV addSubview:_airSubL];
    }
    return _airSubL;
}

- (UIImageView *)airImageV{
    if (!_airImageV) {
        _airImageV = [[UIImageView alloc] init];
        _airImageV.image = [UIImage imageNamed:@"Weather_atmosphere"];
        [self.airV addSubview:_airImageV];
    }
    return _airImageV;
}

- (UILabel *)weatherL{
    if (!_weatherL) {
        _weatherL = [[UILabel alloc] init];
//        _weatherL.text = @"今天6~13°  阴转小雨";
        _weatherL.text = @"";
        _weatherL.font = FontSize_Vip_Nomail(15);
        _weatherL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _weatherL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_weatherL];
    }
    return _weatherL;
}

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        _remarkL.text = @"空气不太好，在室内休息休息吧";
        _remarkL.numberOfLines = 2;
        _remarkL.font = FontSize_Vip_Nomail(15);
        _remarkL.textColor = [Tool getColorWithHexString:@"#ffffff"];
        _remarkL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_remarkL];
    }
    return _remarkL;
}

- (UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 110)];
        _bottomV.backgroundColor = [Tool getColorWithHexString:@"#ffffff"];
        [_bottomV dlj_addRounderCornerWithRadius:17 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        [self.contentView addSubview:_bottomV];
    }
    return _bottomV;
}

- (UICollectionView *)collectionV{
    if (!_collectionV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W)/6, 90);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//top0
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 110) collectionViewLayout:flowLayout];
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.bounces = NO;
        _collectionV.backgroundColor = [UIColor whiteColor];
        
        [_collectionV registerClass:[WeatherTopSubCell class] forCellWithReuseIdentifier: cellID];
        [self.bottomV addSubview:_collectionV];
    }
    return _collectionV;
}

- (UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _addressBtn.tag = 0;
        [self.contentView addSubview:_addressBtn];
    }
    return _addressBtn;
}

#pragma mark - 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeatherTopSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ZYWeatherDataHourlyModel *model = self.dataArray[indexPath.row];
    cell.hourlyModel = model;
    
    return cell;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(addressClicked)]) {
        [self.delegate addressClicked];
    }
}

#pragma mark - other

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
