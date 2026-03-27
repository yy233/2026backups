//
//  ZYAnnotation.h
//  Community
//
//  Created by ZY on 2021/12/9.
//

#import <MapKit/MapKit.h>
#import "ZYPensionMainActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) ZYPensionMainActivityDataModel *activityModel;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
