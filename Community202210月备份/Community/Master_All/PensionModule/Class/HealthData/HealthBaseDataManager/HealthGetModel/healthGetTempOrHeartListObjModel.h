//
//  healthGetTempData.h
//  Community
//
//  Created by 余莹 on 2021/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface healthGetTempOrHeartListObjModel : NSObject

@property (nonatomic,strong) NSString *timeTitle;
@property (nonatomic,strong) NSString *healthData;
@property (nonatomic,strong) NSString *timeValue;
/** 体温
 {
healthData = "0.0";
timeTitle = "11\U670823\U65e5 10:05";
timeValue = "10:05";
}
 
 //心率
 */
@end

NS_ASSUME_NONNULL_END
