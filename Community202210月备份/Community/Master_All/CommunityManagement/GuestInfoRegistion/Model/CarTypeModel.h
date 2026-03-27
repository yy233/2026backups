//
//  CarTypeModel.h
//  Community
// 车辆类型 model
//  Created by 余莹 on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarTypeModel : NSObject
@property (nonatomic,strong) NSString *name;//类型名称
@property (nonatomic,assign) NSInteger code;//类型号
@end
/**
 {
     code = 1;
     name = "\U5fae\U578b\U8f66";
 },*/
NS_ASSUME_NONNULL_END
