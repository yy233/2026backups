//
//  ChatBaseMapView.h
//  Community
//
//  Created by 余莹 on 2021/10/22.
// 基础地图展示 一个已知经纬度的大头针 展示位置的功能

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChatBaseMapView : UIView <MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
- (void)setlocateToLatitude:(CGFloat)lati longitude:(CGFloat)longi;

@end

NS_ASSUME_NONNULL_END
