//
//  CaschesTool.h
//  Community
//
//  Created by 余莹 on 2021/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaschesTool : NSObject
singleton_interface(share)
// 显示缓存大小
- ( float )getCashSizeWithDefinefilePath;
// 清理缓存
- ( void )clearFileWithSuccessOrFairBlcok:(void(^)(BOOL success,NSError *err))clearnSuccessOfFail;
 
 @end

NS_ASSUME_NONNULL_END
