//
//  CarInfoBaseModel.h
//  Community
//
//  Created by 余莹 on 2022/5/7.
// 车模块各个界面都有用到的基础model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarInfoBaseModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *carNumberId;//车牌id
@property (nonatomic,copy) NSString *carNumber;//车牌号码
@property (nonatomic,assign) BOOL carPlateIsOnEditing;//当前行 是否为编辑状态BOOL 本地属性
@property (nonatomic,copy) NSString *positionId;//车位id
@property (nonatomic,copy) NSString *communityId;//社区id

@end

NS_ASSUME_NONNULL_END
