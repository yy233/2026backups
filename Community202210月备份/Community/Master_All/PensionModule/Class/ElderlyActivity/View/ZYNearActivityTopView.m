//
//  ZYNearActivityTopView.m
//  Community
//
//  Created by ZY on 2021/11/13.
//

#import "ZYNearActivityTopView.h"
#import <MapKit/MapKit.h>

@interface ZYNearActivityTopView () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContentView;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;

@end

@implementation ZYNearActivityTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.mapContentView addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapView.superview);
    }];
}

#pragma mark - 懒加载
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        // 设置地图显示样式(必须注意,设置时 注意对应的版本)
        _mapView.mapType = MKMapTypeStandard;
        // 设置地图是否可以缩放
        _mapView.zoomEnabled = YES;
        //是否可以滚动
        _mapView.scrollEnabled = YES;
        //旋转
        _mapView.rotateEnabled = NO;
        //设置显示用户当前位置
        _mapView.showsUserLocation = YES;
        // 为MKMapView设置delegate
        _mapView.delegate = self;
    }
    
    return _mapView;
}

#pragma mark - MKMapViewDelegate
// 选中大头针
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 500, 500);
    [mapView setRegion:region animated:NO];
}

//// MKMapViewDelegate协议中的方法，当MKMapView显示区域将要发生改变时激发该方法
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//    NSLog(@"地图控件的显示区域将要发生改变！");
//}
//// MKMapViewDelegate协议中的方法，当MKMapView显示区域改变完成时激发该方法
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"地图控件的显示区域完成了改变！");
//}
//// MKMapViewDelegate协议中的方法，当MKMapView开始加载数据时激发该方法
//- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
//{
//    NSLog(@"地图控件开始加载地图数据！");
//}
//// MKMapViewDelegate协议中的方法，当MKMapView加载数据完成时激发该方法
//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
//{
//    NSLog(@"地图控件加载地图数据完成！");
//}
//// MKMapViewDelegate协议中的方法，当MKMapView加载数据失败时激发该方法
//- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView
//                        withError:(NSError *)error
//{
//    NSLog(@"地图控件加载地图数据发生错误，错误信息 %@！" , error);
//}
//// MKMapViewDelegate协议中的方法，当MKMapView开始渲染地图时激发该方法
//- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
//{
//    NSLog(@"地图控件开始渲染地图！");
//}
//// MKMapViewDelegate协议中的方法，当MKMapView渲染地图完成时激发该方法
//- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView
//                        fullyRendered:(BOOL)fullyRendered
//{
//    NSLog(@"地图控件渲染地图完成！");
//}

@end
