//
//  HouseRentMoreShaixuanModel.h
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentMoreShaixuanModel : NSObject
@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,strong) NSString *houseConstName;
@property (nonatomic,assign) NSInteger houseConstCode;
@property (nonatomic,assign) NSInteger houseConstType;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

/**
 annotation = "\U623f\U5c4b\U6765\U6e90";
 houseConstCode = 1;
 houseConstName = "\U4e0d\U9650";
 houseConstType = 9;
 id = 62;
 */
@end

NS_ASSUME_NONNULL_END
