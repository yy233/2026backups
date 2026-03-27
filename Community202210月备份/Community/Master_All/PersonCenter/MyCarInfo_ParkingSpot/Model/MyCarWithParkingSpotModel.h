//
//  MyCarWithParkingSpotModel.h
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCarWithParkingSpotModel : NSObject

@property (nonatomic,copy) NSString *ID;//车位id
@property (nonatomic,assign) NSInteger dockNumber;//该车位运行停靠车数
@property (nonatomic,assign) NSInteger carPosStatus;  //1产权，2租赁
@property (nonatomic,copy) NSString *carPositionNumber;//产权车位号
@property (nonatomic,copy) NSString *classificationName;//车位分类名称
@property (nonatomic,copy) NSString *siteClassificationName;//车场名称
@property (nonatomic,strong) NSMutableArray *carNumbers;
@property (nonatomic,assign) NSInteger whetherMoreCar;//是否开启一位多车 0没有开启1开启（决定展示下面的车牌信息）(1开启状态只展示基础信息 不可编辑)

@end

NS_ASSUME_NONNULL_END
