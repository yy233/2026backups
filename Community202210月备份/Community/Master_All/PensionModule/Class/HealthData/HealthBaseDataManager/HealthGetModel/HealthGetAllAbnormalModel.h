//
//  HealGetTempAbnormalModel.h
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import <Foundation/Foundation.h>
#import "HealthGetOneAbnormalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthGetAllAbnormalModel : NSObject

@property (nonatomic,strong) NSString *timeTitle;
@property (nonatomic,strong) NSMutableArray <HealthGetOneAbnormalModel *>*list;
/**
 list =         ...
 timeTitle = "2021/11/16";*/
@end

NS_ASSUME_NONNULL_END 
