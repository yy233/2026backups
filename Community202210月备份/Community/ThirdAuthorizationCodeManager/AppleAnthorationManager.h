//
//  AppleAnthorationManager.h
//  Community
//
//  Created by 余莹 on 2021/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IOSAnthorzationWithGetCodeStrBlock)(NSString *codeStr,BOOL success);

@interface AppleAnthorationManager : NSObject
singleton_interface(shareManager)

- (void)getIOSAppleAnthorzationCodeWithBLock:(IOSAnthorzationWithGetCodeStrBlock)block;

@end

NS_ASSUME_NONNULL_END
