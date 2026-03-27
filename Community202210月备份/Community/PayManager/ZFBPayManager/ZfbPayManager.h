//
//  ZfbPayManager.h
//  Community
//
//  Created by 余莹 on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

NS_ASSUME_NONNULL_BEGIN
 
@interface ZfbPayManager : NSObject
singleton_interface(shareManager)

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)hangleZFPayOrderStr:(NSString *)orderStr;
@end

NS_ASSUME_NONNULL_END
