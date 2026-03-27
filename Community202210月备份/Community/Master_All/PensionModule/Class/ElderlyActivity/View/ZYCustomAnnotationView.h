//
//  ZYCustomAnnotationView.h
//  Community
//
//  Created by ZY on 2021/12/9.
//

#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCustomAnnotationView : MKAnnotationView

+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView withAnnotation:(id <MKAnnotation>)annotation;

@end

NS_ASSUME_NONNULL_END
