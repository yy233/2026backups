//
//  AllMapNavigatioManger.h
//  Community
//
//  Created by 余莹 on 2021/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllMapNavigatioManger : NSObject
+ (void)gotoAddressWithLat:(CLLocationDegrees)mLat lon:(CLLocationDegrees)mLon title:(NSString *)showTitleName andPresntVC:(UIViewController *)pVc;
@end

NS_ASSUME_NONNULL_END
