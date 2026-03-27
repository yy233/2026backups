//
//  SystemMapNavigatioManger.h
//  
//
//  Created by 余莹 on 2021/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemMapNavigatioManger : NSObject
+ (void)goToSystemMapNavigatioWithLat:(CLLocationDegrees)mLat lon:(CLLocationDegrees)mLon title:(NSString *)showTitleName;
@end

NS_ASSUME_NONNULL_END
