//
//  ZYWalletBalanceModel.h
//  Community
//
//  Created by ZY on 2021/10/15.
//

#import <Foundation/Foundation.h>

@class ZYWalletBalanceDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYWalletBalanceModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYWalletBalanceDataModel *data;

@end


@interface ZYWalletBalanceDataModel : NSObject

@property (nonatomic, copy) NSString *balance;

@end

NS_ASSUME_NONNULL_END
