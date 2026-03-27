//
//  ZYElectronicSignatureModelData.h
//  Community
//
//  Created by ZY on 2021/10/21.
//

#import <Foundation/Foundation.h>

typedef void(^ZYCompletionBlock)(id _Nullable responsObject, BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicSignatureModelData : NSObject

// 签署密码是否存在
+ (void)isSignPasswordCompletion:(ZYCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
