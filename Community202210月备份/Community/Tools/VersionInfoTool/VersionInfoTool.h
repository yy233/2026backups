//
//  VersionInfoTool.h
//  Community
//
//  Created by 余莹 on 2021/5/26.
// 没使用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ShowViewBoolBlock)(BOOL);
@interface VersionInfoTool : NSObject
singleton_interface(share)
- (void)showViewBoolBlock:( ShowViewBoolBlock )showBlock;
@end

NS_ASSUME_NONNULL_END
