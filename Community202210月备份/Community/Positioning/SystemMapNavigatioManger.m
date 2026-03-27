//
//  SystemMapNavigatioManger.m
//  
//
//  Created by 余莹 on 2021/9/18.
//

#import "SystemMapNavigatioManger.h"
//地图框架
#import <MapKit/MapKit.h>
//定位，经纬度框架
#import <CoreLocation/CoreLocation.h>

@implementation SystemMapNavigatioManger
+ (void)goToSystemMapNavigatioWithLat:(CLLocationDegrees)mLat lon:(CLLocationDegrees)mLon title:(NSString *)showTitleName{
    //目的地

    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(mLat,mLon);

    //目的地的位置

    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];


    toLocation.name = showTitleName;


    NSArray *items = [NSArray arrayWithObjects:toLocation, nil];


    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item

    [MKMapItem openMapsWithItems:items launchOptions:options];
}
 
@end
