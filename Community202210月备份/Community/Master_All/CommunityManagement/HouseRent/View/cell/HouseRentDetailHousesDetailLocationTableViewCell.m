//
//  HouseRentDetailHousesDetailLocationTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailHousesDetailLocationTableViewCell.h"


@interface HouseRentDetailHousesDetailLocationTableViewCell ()<MKMapViewDelegate>
@property (nonatomic,strong) UIView *showTextBackView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *gotoBtn;
@property (nonatomic,strong) UIView *locationBackView;
@end
@implementation HouseRentDetailHousesDetailLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)gotoBtnAction{
    self.gotoBtnblock();
}

- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _detailL.text = [TextShowWithModelStr textShowWithModelStr:model.houseAddress];
    
    _model = model;
    double lat = model.houseLat;
    double lon = model.houseLon;
    NSLog(@"HouseRentDetailHousesDetailLocationTableViewCell setModel");
    self.mapView.frame = CGRectMake(0, 0, 400, 400);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMapViewEndShowWithCenterLat:lat lon:lon];
    });
    
    
}
- (void)addMapViewEndShowWithCenterLat:(double)lat lon:(double)lon{
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(lat, lon);
    MKCoordinateSpan span;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    MKCoordinateRegion region = {centerCoord,span};
    if (lat==0 && lon==0) {
        return;
    }
    NSLog(@"HouseRentDetailHousesDetailLocationTableViewCell addMapViewEndShowWithCenterLat");
    /**
     东经正数，西经为负数-180~180。北纬为正数，南纬为负数-90～90。
     数据越界纬度的范围 -90 <= latitude <= 90   经度的范围是 -180 <= longitude <= 180
     经度0°——180°（东行,标注E）0°——180°（西行,标注W）
     纬度0°——90°N、0°——90°S
     */
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            //处理UI
    //
    //     });
    if ((centerCoord.latitude >= -90) && (centerCoord.latitude <= 90) && (centerCoord.longitude >= -180) && (centerCoord.longitude <= 180)){    // 数据越界纬度的范围 -90 <= latitude <= 90   经度的范围是 -180 <= longitude <= 180

        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lon);
        
        //        MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:[TextShowWithModelStr textShowWithModelStr:_model.houseTitle] andCoordinate:location];
        //        [self.mapView addAnnotation:newAnnotation];
        MapAnnotation *newAnnotation = [[MapAnnotation alloc] init];
        newAnnotation.title = [TextShowWithModelStr textShowWithModelStr:_model.houseTitle] ;
        newAnnotation.coordinate= location;
        [_mapView addAnnotation:newAnnotation];
        //
        _mapView.region = region;
        //        _mapView.centerCoordinate = CLLocationCoordinate2DMake(lat, lon);
        [self.locationBackView addSubview:self.mapView];
        
    }else{
        if (isNil(self.mapView)) {
            DLog(@"self.mapView 空")
        }
        if (isNil(self.locationBackView)) {
            DLog(@"self.locationBackView 空")
        }
        CLLocationCoordinate2D location;
        location.latitude = 29.723927;
        location.longitude = 106.637559;
        MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:[TextShowWithModelStr textShowWithModelStr:_model.houseTitle] andCoordinate:location];
        [self.mapView addAnnotation:newAnnotation];
        
        
        //        _mapView.region = region;
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(29.723927,106.637559);
        [self.locationBackView addSubview:self.mapView];
        NSLog(@"经纬度越界 赋值重庆的数据");
    }
    
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.showTextBackView];
        //
        [self.showTextBackView addSubview:self.titleL];
        [self.showTextBackView addSubview:self.detailL];
        [self.showTextBackView addSubview:self.gotoBtn];
        //
        [self.contentView addSubview:self.locationBackView];
        [self.locationBackView addSubview:self.mapView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_showTextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_showTextBackView.superview);
        make.top.equalTo(_showTextBackView.superview).offset(10);
        make.height.offset(80);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-100);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.bottom.equalTo(_detailL.mas_bottom).offset(-10);
    }];
    [_gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(75);
        make.height.offset(25);
        make.centerY.equalTo(_gotoBtn.superview);
        make.right.equalTo(_gotoBtn.superview).offset(-16);
    }];
    //
    [_locationBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showTextBackView.mas_bottom).offset(1);
        make.left.equalTo(_locationBackView.superview.mas_left).offset(0);
        make.right.equalTo(_locationBackView.superview.mas_right).offset(0);
        make.bottom.equalTo(_locationBackView.superview.mas_bottom).offset(0);
    }];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapView.superview);
    }];
    
}
#pragma mark ==
- (UIView *)showTextBackView{
    if (!_showTextBackView) {
        _showTextBackView = [[UIView alloc]init];
    }
    return _showTextBackView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:17];
        _titleL.text = @"所在位置";
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.font = [UIFont systemFontOfSize:14];
        _detailL.numberOfLines = 3;
    }
    return _detailL;
}
- (UIButton *)gotoBtn{
    if (!_gotoBtn) {
        _gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoBtn newAnBtnWithTextStr:@"导航到这"];
        [_gotoBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        [_gotoBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x3699FF)];
        [_gotoBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:1.0 withLayerLineColor:Y_ColorWith16FromRGB(0x3699FF)];
        [_gotoBtn addTarget:self action:@selector(gotoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        /**
         //暂时隐藏暂时不做导航
         */
//        _gotoBtn.hidden = YES;
    }
    return _gotoBtn;
}
- (UIView *)locationBackView{
    if (!_locationBackView) {
        _locationBackView = [[UIView alloc]init];
        _locationBackView.backgroundColor  = Color_153GrayColor;
    }
    return _locationBackView;
}
- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.frame];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;//MKMapTypeStandard MKMapTypeSatellite,卫星地图
        _mapView.showsUserLocation = NO;
    }
    return _mapView;
}
#pragma mark ==
// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([mp coordinate], 1500, 1500);
    [mv setRegion:region animated:YES];
    [mv selectAnnotation:mp animated:YES];
//    NSLog(@"annotationView 对象的内存地址-->%p 指向对象的指针的地址-->%p",  annotationView,&annotationView);
//    NSLog(@"mv 对象的内存地址-->%p 指向对象的指针的地址-->%p",  mv,&mv);
//    NSLog(@"views 对象的内存地址-->%p 指向对象的指针的地址-->%p",  views,&views);
}

#pragma mark - MKMapViewDelegate
///*
// 所有的点标注视图的父类 MKAnnotationView
// MKPinAnnotationView 是 MKAnnotationView 的子类
// */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //test
    //
    //    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    //       if ([annotation isKindOfClass:[MapAnnotation class]]) {
    //           static NSString  * key1 = @"Annotation";
    //           MKAnnotationView * annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:key1];
    //           if (!annotationView) {
    //               annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:key1];
    //               annotationView.canShowCallout = true;              //允许交互点击
    //               annotationView.calloutOffset = CGPointMake(0, 0);  //定义详情视图偏移量
    ////               annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    //           }
    //           annotationView.annotation = annotation;
    ////           annotationView.image = [UIImage imageNamed:@"勾选"];    //设置大头针视图的图片
    //           return annotationView;
    //       }else{
    //           return nil;
    //       }
    if (isNil(annotation)) {
        DLog(@"annotation 空");
        
    }
    //判断是哪一类大头针数据
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationView"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationView"];
        }
        pinView.animatesDrop = YES;//是否有掉落的效果
        //设置颜色
        //        pinView.pinColor = MKPinAnnotationColorRed;
        NSLog(@"大头针 1 %f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
        return pinView;
    } else if ([annotation isKindOfClass:[MapAnnotation class]]){
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationView"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationView"];
        }
        pinView.animatesDrop = YES;//是否有掉落的效果
        //设置颜色
        //        pinView.pinColor = MKPinAnnotationColorRed;
        NSLog(@"大头针 aaaa %f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
        return pinView;
    }
    
    NSLog(@"大头针 2 %f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
    MKAnnotationView *v = [[MKAnnotationView alloc]init];
    return v;
    
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
//    NSLog(@"view 对象的内存地址-->%p 指向对象的指针的地址-->%p",  view,&view);
//    NSLog(@"mapv 对象的内存地址-->%p 指向对象的指针的地址-->%p",  _mapView,&_mapView);
//    NSLog(@"_locationBackView 对象的内存地址-->%p 指向对象的指针的地址-->%p", _locationBackView,&_locationBackView);
    NSLog(@"大头针被选中");//
}


@end
