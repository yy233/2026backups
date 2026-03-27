//
//  PensionMapAllViewSubMapV.m
//  Community
//
//  Created by 余莹 on 2021/12/1.
//  文本搜索获取firstobj选中 + 拖动后中心位置获取选中

#import "PensionMapAllViewSubChooseOneAddressMapV.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface PensionMapAllViewSubChooseOneAddressMapV () <MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLGeocoder *geocoder;
@property (nonatomic,strong) UIImageView *showCenterInfoView;

@end
 

@implementation PensionMapAllViewSubChooseOneAddressMapV
//展示当前选中的点
- (UIImageView *)showCenterInfoView{
    if (!_showCenterInfoView) {
        _showCenterInfoView = [[UIImageView alloc]init];
        _showCenterInfoView.image = [UIImage imageNamed:@"yl_dingwshuax"];
    }
    return _showCenterInfoView;
}
- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
        // 设置地图显示样式(必须注意,设置时 注意对应的版本)
        _mapView.mapType = MKMapTypeStandard;
        
        // 设置地图是否可以缩放
        _mapView.zoomEnabled = YES;
        //是否可以滚动
        _mapView.scrollEnabled = YES;
        //旋转
        _mapView.rotateEnabled = YES;
        //设置显示用户当前位置
        _mapView.showsUserLocation = NO;//不显示当前位置 ｜YES 显示用户位置, 但是地图并不会自动放大到合适比例
        _mapView.delegate = self;

    }
    return _mapView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.mapView];
        [self addSubview:self.showCenterInfoView];
        [self setUI];
   
    }
    return self;
}
- (void)setUI{
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapView.superview);
    }];
    [_showCenterInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_mapView);
        make.height.offset(50);
        make.width.offset(50);
    }];
}

//初始状态的展示位置
- (void)setlocateToLatitude:(CGFloat)lati longitude:(CGFloat)longi
{
    
    if ((lati >= -90) && (lati<= 90) && (longi >= -180) && (longi <= 180)) {//合法初始经纬度
        [self initShowLatitude:lati longitude:longi]; //保存的数据
    }else{
        [self initShowLatitude:self.mapView.userLocation.location.coordinate.latitude longitude:self.mapView.userLocation.location.coordinate.longitude];//当前的位置
    }
}
- (void)initShowLatitude:(CGFloat)lati longitude:(CGFloat)longi{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    CLLocationCoordinate2D initCenterLocation = CLLocationCoordinate2DMake(lati, longi);
    [self.mapView setRegion:MKCoordinateRegionMake( initCenterLocation, span) animated:YES];
}
//#pragma mark == 地图
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//}

#pragma mark == 地图
 

// MKMapViewDelegate协议中的方法，当MKMapView显示区域将要发生改变时激发该方法
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域将要发生改变！");
}
// MKMapViewDelegate协议中的方法，当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域完成了改变！");
    NSLog(@"改变数据 == mapView %@",mapView);
   // CLLocationCoordinate2D moveMaoCoordinate = [self convertPoint:self.showCenterInfoView.center toCoordinateSpace: self.mapView];
    CLLocationCoordinate2D moveMaoCoordinate = [self.mapView convertPoint:self.showCenterInfoView.center toCoordinateFromView:self];
    NSLog(@"改变数据 == moveMaoCoordinate %f %f", moveMaoCoordinate.latitude,moveMaoCoordinate.longitude);
    //反编码拿到 文本
    self.saveShooseAddressLatStr = [NSString stringWithFormat:@"%f",moveMaoCoordinate.latitude];
    self.saveShooseAddressLongStr = [NSString stringWithFormat:@"%f",moveMaoCoordinate.longitude];
    self.saveShooseAddressTextStr = @"暂无终点地址的文本信息";// @"暂待反编码后的地址文本";
    [self mapMoveDidInfoOfAddressTextWithLat:moveMaoCoordinate.latitude andLong:moveMaoCoordinate.longitude];//更新text + 通知更新展示信息
    if (isNotNil(self.mapMoveChangedBlock)) {
        self.mapMoveChangedBlock();
    }
    
}
// MKMapViewDelegate协议中的方法，当MKMapView开始加载数据时激发该方法
- (void) mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始加载地图数据！");
}
// MKMapViewDelegate协议中的方法，当MKMapView加载数据完成时激发该方法
- (void) mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件加载地图数据完成！");
}
// MKMapViewDelegate协议中的方法，当MKMapView加载数据失败时激发该方法
- (void) mapViewDidFailLoadingMap:(MKMapView *)mapView
                        withError:(NSError *)error
{
    NSLog(@"地图控件加载地图数据发生错误，错误信息 %@！" , error);
}
// MKMapViewDelegate协议中的方法，当MKMapView开始渲染地图时激发该方法
- (void) mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始渲染地图！");
}
// MKMapViewDelegate协议中的方法，当MKMapView渲染地图完成时激发该方法
- (void) mapViewDidFinishRenderingMap:(MKMapView *)mapView
                        fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"地图控件渲染地图完成！");
}
#pragma mark ====
#pragma mark ====

 
#pragma mark ===  反编码
- (void)mapMoveDidInfoOfAddressTextWithLat:(double)lati andLong:(double )longi{
    //创建地理编码对象
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        //创建位置
        CLLocation *location=[[CLLocation alloc]initWithLatitude:lati  longitude:longi];
        
        //反地理编码
       //[self.geocoder
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //判断是否有错误或者placemarks是否为空
            if (error !=nil || placemarks.count==0) {
                NSLog(@"判断是否有错误或者placemarks是否为空 %@",error);
                return ;
            }
            for (CLPlacemark *placemark in placemarks) {
                //赋值详细地址
                NSLog(@"赋值详细地址 %@ ",placemark.name);
                /**
                 (lldb) po placemark.country
                 中国
                 (lldb) po placemark.locality
                 重庆市
                 (lldb) po placemark.subLocality
                 綦江区
                 (lldb) po placemark.name
                 永城镇
                 */
                self.saveShooseAddressTextStr =  [NSString stringWithFormat:@"%@ %@ %@",placemark.locality,placemark.subLocality,placemark.name];//@"暂待反编码后的地址文本";
                if (isNotNil(self.mapMoveChangedBlock)) {
                    self.mapMoveChangedBlock();
                }
            }
            
        }];
}
#pragma mark ===  编码
//文本搜地址位置列表 得其某个位置
- (void)searchAddressWithSearchText:(NSString *)addressText{
    
    NSLog(@"searchAddressWithSearchText  ==  %@",addressText);
    //创建编码对象
       CLGeocoder *geocoder=[[CLGeocoder alloc]init];
       //判断是否为空
       if (addressText.length ==0) {
           return;
       }
       [geocoder geocodeAddressString:addressText completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
           if (error!=nil || placemarks.count==0) {
               Y_SVP_SHOW_INFO_MES(@"未搜到具体位置信息，可输入更详细的文本，以供搜索。");
               return ;
           }
           //创建placemark对象
           CLPlacemark *placemark = [placemarks firstObject];
           self.mapView.centerCoordinate = placemark.location.coordinate;
           
           /**
            //赋值经度
            self.longitudeTextField.text =[NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
            //赋值纬度
            self.latitudeTextField.text=[NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
            //赋值详细地址
            self.textView.text=placemark.name;
            */
        
       }];
}
@end
