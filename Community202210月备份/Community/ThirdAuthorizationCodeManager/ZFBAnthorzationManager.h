//
//  ZFBAnthorzationManager.h
//  Community
//
//  Created by 余莹 on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ZFBAnthorzationWithGetCodeStrBlock)(NSString *codeStr,BOOL success);

@interface ZFBAnthorzationManager : NSObject
- (void)getZFBAnthorzationCodeWithBLock:(ZFBAnthorzationWithGetCodeStrBlock)block;


singleton_interface(shareManager)


//- (void)ZfbAuthorzationBtnIsTap;
- (BOOL)handleOpenURL:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
