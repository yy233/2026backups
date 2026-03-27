//
//  creatDbTool.h
//  Socialize
//
//  Created by 余莹 on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface creatDbTool : NSObject
singleton_interface(share);

- (void)create;
- (void)search1;
- (void)search2;
- (void)encrydb;
@end

NS_ASSUME_NONNULL_END
