//
//  ZYCustomAnnotationView.m
//  Community
//
//  Created by ZY on 2021/12/9.
//

#import "ZYCustomAnnotationView.h"
#import "ZYLocationView.h"
#import "ZYAnnotation.h"

@interface ZYCustomAnnotationView ()

@property (nonatomic, strong) ZYLocationView *locationView;

@end

@implementation ZYCustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)annotationViewWithMapView:(MKMapView *)mapView withAnnotation:(id <MKAnnotation>)annotation{
    static NSString *ID = @"ZYCustomAnnotationView";
    ZYCustomAnnotationView *annotationView = (ZYCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annotationView) {
        annotationView = [[ZYCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
    }
    annotationView.locationView = [[NSBundle mainBundle] loadNibNamed:@"ZYLocationView" owner:nil options:nil].lastObject;
    ZYAnnotation *annot = (ZYAnnotation *)annotation;;
    if (annot.activityModel.isAnnotation) {
        annotationView.locationView.frame = CGRectMake(0, 0, 40, 48);
    }else {
        annotationView.locationView.frame = CGRectMake(0, 0, 30, 36);
    }
    annotationView.bounds = annotationView.locationView.bounds;
    [annotationView addSubview:annotationView.locationView];
    [annotationView getlocationView:annotationView.locationView];
    
    return annotationView;
}

- (void)getlocationView:(ZYLocationView *)locationView {
    self.locationView = locationView;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    ZYAnnotation *annotat = (ZYAnnotation *)annotation;
    self.locationView.activityModel = annotat.activityModel;
}

@end
