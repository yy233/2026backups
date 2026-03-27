//
//  MainRecommendedServiceHourseEstateModel.h
//  Community
//
//  Created by 余莹 on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainRecommendedServiceHourseEstateModel : NSObject
/**
 houseTitle = "观音桥111";
 id = 21695975911460864;
 leaseHouse = 0;*/
@property (nonatomic,strong) NSString *houseTitle;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) BOOL leaseHouse; //true 表示 是租赁房屋的数据 false 代表 为商铺的数据

@end

NS_ASSUME_NONNULL_END
