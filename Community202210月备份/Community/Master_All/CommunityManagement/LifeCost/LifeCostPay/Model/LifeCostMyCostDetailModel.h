//
//  LifeCostMyCostDetailModel.h
//  Community
//
//  Created by 余莹 on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMyCostDetailModel : NSObject
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *familyId;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *familyName;
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,assign) double accountBalance;



/**

 data =     {
     accountBalance = "-349.33";
     address = "天王星b座1810";
     companyId = 1;
     companyName = "重庆江南水务公司";
     familyId = 1056134646;
     familyName = "纵横世纪";
     typeId = 1;
 };
 message = "<null>";
}
 */
@end

NS_ASSUME_NONNULL_END
