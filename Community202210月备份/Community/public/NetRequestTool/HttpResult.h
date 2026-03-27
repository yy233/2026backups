//
//  HttpResult.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpResult : NSObject

/// 状态代码
@property (nonatomic,assign) NSInteger status;

/// 状态代码对应得描述
@property (nonatomic,strong) NSString *msg;

/// 结果数据
@property (nonatomic,strong) id result;

@property (nonatomic, strong) NSNumber *code;

/// 请求成功状态
@property (nonatomic,assign,readonly) BOOL isSuccess;

@property (nonatomic,strong) id data;

@property (nonatomic,strong) id datas;

@end

NS_ASSUME_NONNULL_END
