//
//  HouseRentDetailHousesDetailLocationTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^CellGoToBtnBlcok)(void);

@interface HouseRentDetailHousesDetailLocationTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) MKMapView *mapView;//地图
@property (nonatomic,strong) HouseRentDetailVcHouseModel *model;
- (void)addMapViewEndShowWithCenterLat:(double)lat lon:(double)lon;
@property (nonatomic,copy) CellGoToBtnBlcok gotoBtnblock;
@end

NS_ASSUME_NONNULL_END
