//
//  HealthGetTempOneDayData.h
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import <Foundation/Foundation.h>
#import "healthGetTempOrHeartListObjModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthGetTempOrHeartOneDayModel : NSObject

@property (nonatomic,strong) NSString *tempStatus;
@property (nonatomic,strong) NSString *temptAvg;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSString *heartRateStatus;
@property (nonatomic,strong) NSString *silentHeartAvg;
/**
 list =     (
             {
         healthData = "0.0";
         timeTitle = "11\U670823\U65e5 00:00";
         timeValue = "00:00";
     },
             {
         healthData = "0.0";
         timeTitle = "11\U670823\U65e5 06:00";
         timeValue = "06:00";
     },
             {
         healthData = "0.0";
         timeTitle = "11\U670823\U65e5 10:05";
         timeValue = "10:05";
     }
 );
 tempStatus = "<null>";
 temptAvg = "<null>";
 
 heartRateStatus = "<null>";
 list =     (
 {
 healthData = 0;
 timeTitle = "2021\U5e7410\U670826\U65e5";
 timeValue = "10/26";
 },
 {
 healthData = 0;
 timeTitle = "2021\U5e7411\U670824\U65e5";
 timeValue = "11/24";
 }
 );
 silentHeartAvg = "<null>";
 */
@end

NS_ASSUME_NONNULL_END
