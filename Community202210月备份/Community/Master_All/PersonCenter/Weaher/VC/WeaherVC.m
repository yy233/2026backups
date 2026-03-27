//
//  WeaherVC.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
// 天气

#import "WeaherVC.h"
#import "WeatherCityChooseVC.h"
#import "YMCitySelect.h"
#import "WeaherView.h"
#import "ZYWeatherModel.h"

@interface WeaherVC () <WeaherViewDelegate, YMCitySelectDelegate>

@property(nonatomic, strong) WeaherView *weaherView;

@property (nonatomic, strong) ZYWeatherDataModel *dataModel;

// 城市名
@property (nonatomic, copy) NSString *cityName;

@end

@implementation WeaherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天气";
//    [self initRightBar];
    
    [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
    self.cityName = [ShareUserInfo sharedUserInfo].positioningModel.locality;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initWeatherDetailsData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[Tool getColorWithHexString:@"#617690"]];
}

- (void)initView{
    
    [self.view addSubview:self.weaherView];
    [self.weaherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initRightBar{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"Weather_share"] forState:UIControlStateNormal];
    rightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}

#pragma mark - 懒加载
- (WeaherView *)weaherView{
    if (!_weaherView) {
        _weaherView = [[WeaherView alloc] init];
        _weaherView.delegate = self;
    }
    
    return _weaherView;
}

- (ZYWeatherDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[ZYWeatherDataModel alloc] init];
    }
    
    return _dataModel;
}

#pragma mark - 加载数据
// 天气详情数据
- (void)initWeatherDetailsData {
    NSDictionary *params = @{@"cityName" : self.cityName};
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_Get_Weather_Details withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYWeatherModel *model = [ZYWeatherModel yy_modelWithJSON:responsObject];
                self.dataModel = model.data;
                self.weaherView.dataModel = self.dataModel;
                [self initView];
                [self reloadInputViews];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}


#pragma mark - WeaherViewDelegate
- (void)addressClicked{
    
//    WeatherCityChooseVC *vc = [[WeatherCityChooseVC alloc] init];
//    [self pushVc:vc];
    
    YMCitySelect *citySelect = [[YMCitySelect alloc] initWithDelegate:self];
    citySelect.type = City_Select_Type_Weather;
    [self pushVc:citySelect];
}

#pragma mark - YMCitySelectDelegate
- (void)ym_ymCitySelectCityName:(NSString *)cityName {
    
    NSLog(@"%@", cityName);
    self.cityName = cityName;
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initWeatherDetailsData];
}

#pragma mark - other
- (void)rightBtnClicked {
    
    NSLog(@"分享天气");
}
 
@end
