//
//  ChatBaseMapView.m
//  Community
//
//  Created by 余莹 on 2021/10/22.
//

#import "ChatBaseMapView.h"

@implementation ChatBaseMapView

/*
 if ((centerCoord.latitude >= -90) && (centerCoord.latitude <= 90) && (centerCoord.longitude >= -180) && (centerCoord.longitude <= 180)){

*/
- (void)setlocateToLatitude:(CGFloat)lati longitude:(CGFloat)longi
{
    // 数据越界纬度的范围 -90 <= latitude <= 90   经度的范围是 -180 <= longitude <= 180
    if ((lati >= -90) && (lati<= 90) && (longi >= -180) && (longi <= 180)) {//合法
        DLog(@"经纬度符合");
        // 设置地图中心的经、纬度
        CLLocationCoordinate2D center = {lati , longi};
        // 设置地图显示的范围
        MKCoordinateSpan span;
        // 地图显示范围越小，细节越清楚
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        // 创建MKCoordinateRegion对象，该对象代表了地图的显示中心和显示范围。
        MKCoordinateRegion region = {center,span};
        // 设置当前地图的显示中心和显示范围
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark ===
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_mapView.superview);
        }];
    }
    return self;
}
- (MKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]init];
        //    MKMapTypeStandard = 0, // 标准地图
        //    MKMapTypeSatellite, // 卫星云图
        //    MKMapTypeHybrid, // 混合(在卫星云图上加了标准地图的覆盖层)
        //    MKMapTypeSatelliteFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D立体
        //    MKMapTypeHybridFlyover NS_ENUM_AVAILABLE(10_11, 9_0), // 3D混合
        // 设置地图显示样式(必须注意,设置时 注意对应的版本)
        _mapView.mapType = MKMapTypeStandard;
        
        // 设置地图是否可以缩放
        _mapView.zoomEnabled = YES;
        //是否可以滚动
        _mapView.scrollEnabled = YES;
        //旋转
        _mapView.rotateEnabled = YES;
        //设置显示用户当前位置
        _mapView.showsUserLocation = YES;
        // 显示用户位置, 但是地图并不会自动放大到合适比例
       _mapView.showsUserLocation = YES;
        // 为MKMapView设置delegate
        _mapView.delegate = self;
        //设置经纬度(北京的经度 39.9,纬度:116.3)
      
    }
    return _mapView;
}

#pragma mark == 放大地图
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


// MKMapViewDelegate协议中的方法，当MKMapView显示区域将要发生改变时激发该方法
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域将要发生改变！");
}
// MKMapViewDelegate协议中的方法，当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域完成了改变！");
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

@end
