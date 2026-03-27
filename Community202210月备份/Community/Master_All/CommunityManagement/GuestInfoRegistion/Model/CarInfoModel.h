//
//  CarInfoModel.h
//  Community
// 车牌号 车类型code+name 访客随行车辆
//  Created by 余莹 on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarInfoModel : NSObject
//@property (nonatomic,strong) NSString *carIdname;//车牌号
//@property (nonatomic,strong) CarTypeModel *type;//车类型 //此用于sub btn的处理， 不做info数据的增删改 

@property (nonatomic,strong) NSString *carPlate;//车牌号
@property (nonatomic,assign) NSInteger carType;//类型code
@property (nonatomic,strong) NSString *carTypeStr;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *updateTim;
@end

/**
 carPlate = "赣XXAE87";
 carType = 2;
 carTypeStr = "<null>";
 createTime = "2020-12-15 15:57:48";
 deleted = 0;
 id = 2157326949814272;
 uid = test123;
 updateTime = "<null>";
 */
NS_ASSUME_NONNULL_END
