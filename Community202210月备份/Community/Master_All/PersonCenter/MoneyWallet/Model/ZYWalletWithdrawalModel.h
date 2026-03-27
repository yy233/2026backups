//
//  ZYWalletWithdrawalModel.h
//  Community
//
//  Created by ZY on 2021/10/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYWalletWithdrawalModel : NSObject

// 操作状态码
@property (nonatomic, assign) NSInteger code;

// 返回详情
@property (nonatomic, copy) NSString *msg;

// 操作状态，判断是否成功提现唯一标识
@property (nonatomic, assign) BOOL success;

// 错误详情码，当success为true时，该属性必定为空。
@property (nonatomic, copy) NSString *subCode;

@end

NS_ASSUME_NONNULL_END
