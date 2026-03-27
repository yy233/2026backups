//
//  ZYAnnotation.m
//  Community
//
//  Created by ZY on 2021/12/9.
//

#import "ZYAnnotation.h"

@implementation ZYAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if(self = [super init])
        self.coordinate = coordinate;
    return self;
}

@end
