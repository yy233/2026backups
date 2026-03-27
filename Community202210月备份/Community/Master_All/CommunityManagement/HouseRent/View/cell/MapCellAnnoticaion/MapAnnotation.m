//
//  MapAnnotation.m
//  Community
//
//  Created by 余莹 on 2021/1/7.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

- (id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate2d{
    self.title = title;
    self.coordinate = coordinate2d;
    return self;
}
@end
