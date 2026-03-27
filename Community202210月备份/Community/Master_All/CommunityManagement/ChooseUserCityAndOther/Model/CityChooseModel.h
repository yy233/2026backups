//
//  CityChooseModel.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
//    QueryType_City = 1,
    QueryType_City = 2,
    QueryType_HotCity = 3,
    QueryType_CitySearchText = 4,//搜索框有数值时使用 ，和其他数据不一样的请求参数结果参数。
} QueryType;//热门城市3  城市接口2

@interface CityChooseModel : NSObject

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,strong) NSString *initials;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger pid;

@end

NS_ASSUME_NONNULL_END
