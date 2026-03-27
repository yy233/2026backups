//
//  MainTableViewRecommendedServiceCell.m
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import "MainTableViewRecommendedServiceWeatherCell.h"
#import "MainTableViewSubCellWeatherCell.h"
//#define Color_Before_BlueColor  Y_RGB(67, 144, 234)
#define Color_Before_BlueColor  Y_RGB(87, 138, 224)
#define Color_End_BlueColor Y_RGB(46, 87, 205)

@interface MainTableViewRecommendedServiceWeatherCell () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *leftWearherDetailView;
@property (nonatomic,strong) UIImageView *leftWearherDetailImgV;
@property (nonatomic,strong) UITableView *wearherTableView;
@property (nonatomic,strong) UILabel *temperatureNumLabel;
@property (nonatomic,strong) UILabel *temperatureDetailLabel;
@property (nonatomic,strong) UILabel *cityAndDetailLabel;
@property (nonatomic,strong) UILabel *bottomTipDetailLabel;
//
@property (nonatomic,strong) NSMutableArray *weathOtherDaysDataSourceArr;
@property (nonatomic,strong) NSMutableDictionary *nowDayDic;
@property (nonatomic,strong) MainWeatherModel* mainWeatherModel;

@end
@implementation MainTableViewRecommendedServiceWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ===
//- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
//    _dataSourceArr = dataSourceArr;
//}
- (void)showCellDataSourceWithWeathOtherNowDayDic:(NSMutableDictionary *)nowDayDic
                  withWeathOtherDaysDataSourceArr:(NSMutableArray *)weathOtherDaysDataSourceArr{
    _nowDayDic = nowDayDic;
    _weathOtherDaysDataSourceArr = weathOtherDaysDataSourceArr;
    [self setData];
}
- (void)setData{
    self.mainWeatherModel = [MainWeatherModel mj_objectWithKeyValues:_nowDayDic];
   
    _temperatureNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.mainWeatherModel.temp];
    _temperatureDetailLabel.text = [TextShowWithModelStr textShowWithModelStr:self.mainWeatherModel.condition];
    NSString *cityStr = [TextShowWithModelStr textShowWithModelStr: self.mainWeatherModel.pname];
    NSString *cityQuYuStr = [TextShowWithModelStr textShowWithModelStr: self.mainWeatherModel.name];
    NSString *moneyAndDayStr = [TextShowWithModelStr textShowWithModelStr: self.mainWeatherModel.updateDay];
    NSString *weekStr = [TextShowWithModelStr textShowWithModelStr: self.mainWeatherModel.dayOfWeek];
    _cityAndDetailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                cityStr,
                                cityQuYuStr,
                                moneyAndDayStr,
                                weekStr];
    _bottomTipDetailLabel.text = [TextShowWithModelStr textShowWithModelStr:self.mainWeatherModel.tips];
    [self.wearherTableView reloadData];
}
#pragma mark ===
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSourceArr.count;
//    return 2;
    return self.weathOtherDaysDataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewSubCellWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewSubCellWeatherCell"];
    if (!cell) {
        cell = [[MainTableViewSubCellWeatherCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MainTableViewSubCellWeatherCell"];
    }
    cell.dataSourceDic = self.weathOtherDaysDataSourceArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@" indexPath %ld",(long)indexPath.row);
}
#pragma mark ===
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nowDayDic = [[NSMutableDictionary alloc]init];
        self.weathOtherDaysDataSourceArr = [[NSMutableArray alloc]init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftWearherDetailView];
        [self.contentView addSubview:self.wearherTableView];
        [self.leftWearherDetailView addSubview:self.leftWearherDetailImgV];
        [self.leftWearherDetailView addSubview:self.temperatureNumLabel];
        [self.leftWearherDetailView addSubview:self.temperatureDetailLabel];
        [self.leftWearherDetailView addSubview:self.cityAndDetailLabel];
        [self.leftWearherDetailView addSubview:self.bottomTipDetailLabel];
        [self setUI];
    }
    return self;
}
- (void)setUI{
 
    _leftWearherDetailImgV.image = [UIImage imageNamed:@"Weather_background"];
    _temperatureNumLabel.text = @"";
    _temperatureDetailLabel.text = @"";
    _cityAndDetailLabel.text = @"";
    _bottomTipDetailLabel.text = @"";
//    _leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackImg_1.png"]];
//    _leftWearherDetailView.layer.contents = CFBridgingRelease([UIImage imageNamed:@"mainBackImg_0.png"].CGImage);
    
    [_leftWearherDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftWearherDetailView.superview.mas_left);
        make.width.equalTo(_leftWearherDetailView.superview.mas_width).multipliedBy(0.75);
        make.height.equalTo(_leftWearherDetailView.superview.mas_height).offset(-10);
        make.centerY.equalTo(_leftWearherDetailView.superview.mas_centerY);
    }];
    [_wearherTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftWearherDetailView.mas_right).offset(5);
        make.right.equalTo(_wearherTableView.superview.mas_right);
        make.height.equalTo(_wearherTableView.superview.mas_height).offset(-10);
        make.centerY.equalTo(_wearherTableView.superview.mas_centerY);
    }];
    [self leftViewUI];
}
- (void)leftViewUI{
    [_leftWearherDetailImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_leftWearherDetailImgV.superview);
    }];
    [_temperatureNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_temperatureNumLabel.superview.mas_left).offset(20);
        make.top.equalTo(_temperatureNumLabel.superview.mas_top).offset(10);
        make.height.equalTo(_temperatureNumLabel.superview.mas_height).multipliedBy(0.33);
        make.width.offset(50);
    }];
    [_temperatureDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_temperatureNumLabel.mas_right).offset(10);
        make.centerY.equalTo(_temperatureNumLabel.mas_centerY);
    }];
    [_cityAndDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityAndDetailLabel.superview.mas_left).offset(20);
        make.top.equalTo(_temperatureNumLabel.mas_bottom).offset(10);
        make.right.equalTo(_cityAndDetailLabel.superview.mas_right).offset(-10);
    }];
    [_bottomTipDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomTipDetailLabel.superview.mas_bottom).offset(-10);
        make.left.equalTo(_bottomTipDetailLabel.superview.mas_left).offset(20);
        make.right.equalTo(_bottomTipDetailLabel.superview.mas_right).offset(-10);
    }];
}
#pragma mark == get
- (UIView *)leftWearherDetailView{
    if (!_leftWearherDetailView) {
        _leftWearherDetailView = [[UIView alloc]init];
        _leftWearherDetailView.layer.cornerRadius = 10;
        _leftWearherDetailView.layer.masksToBounds = YES;
        _leftWearherDetailView.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:0.3];
    }
    return _leftWearherDetailView;
}
- (UITableView *)wearherTableView{
    if (!_wearherTableView) {
        _wearherTableView = [[UITableView alloc]init];
        _wearherTableView.dataSource = self;
        _wearherTableView.delegate = self;
        _wearherTableView.tableFooterView = [UIView new];
        _wearherTableView.layer.cornerRadius = 10;
        _wearherTableView.layer.masksToBounds = YES;
        _wearherTableView.separatorInset =  UIEdgeInsetsMake(0, 20, 0, 20);
        _wearherTableView.separatorColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _wearherTableView.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(Screen_W*0.25, 200) direction:IHGradientChangeDirectionVertical startColor:Color_Before_BlueColor endColor:Color_End_BlueColor];
    }
    return _wearherTableView;
}
#pragma mark == sub
- (UIImageView *)leftWearherDetailImgV{
    if (!_leftWearherDetailImgV) {
        _leftWearherDetailImgV = [[UIImageView alloc]init];
        _leftWearherDetailImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftWearherDetailImgV;
}
- (UILabel *)temperatureNumLabel{
    if (!_temperatureNumLabel) {
        _temperatureNumLabel = [[UILabel alloc]init];
        _temperatureNumLabel.textColor = [UIColor whiteColor];
        _temperatureNumLabel.numberOfLines = 1;
        _temperatureNumLabel.font = [UIFont boldSystemFontOfSize:36];
    }
    return _temperatureNumLabel;
}
- (UILabel *)temperatureDetailLabel{
    if (!_temperatureDetailLabel) {
        _temperatureDetailLabel = [[UILabel alloc]init];
        _temperatureDetailLabel.textColor = [UIColor whiteColor];
        _temperatureDetailLabel.numberOfLines = 1;
        _temperatureDetailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _temperatureDetailLabel;
}

- (UILabel *)cityAndDetailLabel{
    if (!_cityAndDetailLabel) {
        _cityAndDetailLabel = [[UILabel alloc]init];
        _cityAndDetailLabel.textColor = [UIColor whiteColor];
        _cityAndDetailLabel.numberOfLines = 1;
        _cityAndDetailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cityAndDetailLabel;
}
- (UILabel *)bottomTipDetailLabel{
    if (!_bottomTipDetailLabel) {
        _bottomTipDetailLabel = [[UILabel alloc]init];
        _bottomTipDetailLabel.textColor = [UIColor whiteColor];
        _bottomTipDetailLabel.numberOfLines = 1;
        _bottomTipDetailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _bottomTipDetailLabel;
}
//
- (MainWeatherModel *)mainWeatherModel{
    if (!_mainWeatherModel) {
        _mainWeatherModel = [[MainWeatherModel alloc]init];
    }
    return _mainWeatherModel;
}
@end
